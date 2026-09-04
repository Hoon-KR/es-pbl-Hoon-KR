# Day 3 검색 구현·품질 검증 산출물

## 1. 실행 기준

- 개인 index: `audio-devices-search`
- 수업 시작 시 실제 `_count`: 10,000
- 개인 요청 파일: `elasticsearch/requests.http` (`V1-T17-P`~`V1-T21-P` 구간)
- 검색 품질 주 문서: `docs/quality-test.md`
- 실행 환경·시각: Docker ES 9.5.0 3노드 + Kibana 9.5.0, 2026-09-03 Day 3 실습

## 2. 검색 질문과 요구사항

| 요청 ID | 사용자 질문 | 검색 field·검색어 | 정확 조건·범위 | 정렬 | 표시·highlight |
|---|---|---|---|---|---|
| `V1-T18-2-P` 전문 검색 | 저음이 강조되고 배터리가 오래가는 운동용 제품 리뷰를 찾고 싶다 | `review_summary` · "저음이 강조되고 운동용으로" | 없음 | 없음(관련도순) | `product_id`, `product_name`, `review_summary` highlight |
| `V1-T18-1-P` 정확 조건 | 소니 제품만 모아 보고 싶다 | `brand` · "Sony" (term) | `brand`="Sony" 완전 일치 | 없음 | 없음 |
| `V1-T19-2-P` bool/filter | 노이즈 캔슬링 지원, 10만 원 이하 무선 이어폰(`docs/data-model.md` Q1) | `review_summary` · "노이즈" (must) | `category`="이어폰", `connection`="무선", `price`≤100000 | 없음 | `product_id`, `category`, `connection`, `price` |

## 3. 실행 전 기대 기준

| 요청 ID | 기대 문서 ID·이유 | 제외 문서 ID·이유 | 의도한 0건 조건 | 경계 포함·제외 기준 |
|---|---|---|---|---|
| `V1-T18-2-P` | `review_summary`에 "저음"·"운동용" 취지가 담긴 문서(예: `AD-00003`) | — | 원 검색어 "저음 운동용"으로는 0건 예상(조사 미포함) | 해당 없음 |
| `V1-T18-1-P` | `brand`="Sony"인 문서(예: `AD-00005`) | `brand`="Bose","Apple" 등 다른 브랜드 | — | 해당 없음(keyword 완전 일치) |
| `V1-T19-2-P` | `AD-00370`(이어폰/무선/56100원, 리뷰에 노이즈 언급) | `AD-00001`(category 일치하나 connection=유선, price>100000, 리뷰에 노이즈 언급 없음) | 세 조건을 모두 어긋나게 하면 0건 | `price`=100000 경계는 `lte`로 포함 |

## 4. 실제 결과와 판정

| 요청 ID | `hits.total.value` | 상위 3개 ID | 조건·경계 통과 | 관련/보류/무관과 근거 | 판정 |
|---|---:|---|---|---|---|
| `V1-T18-2-P`(개선 전) | 0 | 없음 | 해당 없음 | 무관(결과 없음) — 기대와 다름, §6에서 원인 진단 | 실패 |
| `V1-T18-2-P`(개선 후) | 1,480 | `AD-00003`, `AD-00004`, `AD-00005` | 해당 없음 | 관련. 세 문서 모두 `review_summary` highlight로 "저음이"·"강조되고" 매칭 확인 | 통과 |
| `V1-T18-1-P` | 1,314 | `AD-00005`, `AD-00007`, `AD-00014` | 통과 — 상위 3건 모두 `brand`="Sony" | 관련. 브랜드 조건 그대로 충족 | 통과 |
| `V1-T19-2-P` | 42 | `AD-00370`, `AD-00475`, `AD-01036` | 통과 — 세 filter(`category`,`connection`,`price`) 모두 만족, 기대 제외 문서(`AD-00001`) 미포함 확인 | 관련. 세 문서 모두 사용자 의도(노이즈 캔슬링/10만원 이하/무선 이어폰)에 부합 | 통과 |

## 5. 조건 제거·변형 실험

| 기준 요청 | 바꾼 한 요소 | 변경 전 total·대표 ID | 변경 후 total·새로 들어온/빠진 ID | 관찰한 역할 |
|---|---|---|---|---|
| `V1-T19-2-P` | `connection`="무선" filter 제거(`V1-T19-1-P`) | 42건 · `AD-00370` | 126건 · `AD-00058`(완전무선), `AD-00190`(유선) 등 84건 신규 포함 | `connection` filter가 "무선"이 아닌 연결 방식(완전무선·유선) 상품을 걸러내는 역할을 함을 확인 |

## 6. 실패 원인 진단

- 문제: `V1-T18-2-P` 원 검색어("저음 운동용")가 실제로 해당 리뷰 문서가 존재하는데도 0건을 반환함
- 1차 원인 분류: analyzer
- 확인한 실제 근거: `POST /audio-devices-search/_analyze {"field":"review_summary","text":"저음이 강조되고 운동용으로 딱입니다."}` 결과 토큰이 `["저음이","강조되고","운동용으로","딱입니다"]`로 나왔다. `review_summary`는 별도 analyzer 지정이 없어 기본 `standard` analyzer를 쓰는데, 이 analyzer는 한국어 조사를 분리하지 못해 검색어 토큰("저음","운동용")과 저장 토큰이 글자 단위로 불일치했다.
- 다음 확인 또는 변경: 한국어 형태소 분석기(Nori)를 `review_summary`에 적용하는 실험이 다음 과제로 남아 있다. 이번엔 검색어를 저장 형태에 맞춰 조정하는 우회로 해결했다.

## 7. 개선 전후

| 문제 | 추정 원인 | 변경한 한 요소 | 같은 조건으로 재실행한 결과 | 개선 판정과 근거 |
|---|---|---|---|---|
| 전문 검색 0건(`V1-T18-2-P`) | analyzer(조사 미분리) | 검색어를 "저음 운동용" → "저음이 강조되고 운동용으로"로 변경(field·query 종류·index는 유지) | 0건 → 1,480건, 상위 3건 모두 관련 문서로 확인 | 개선(임시). 사용자가 자유롭게 입력하는 검색어까지 대응하려면 analyzer 자체 개선(Nori)이 근본 해결책이며, 아직 미적용 상태임을 남김 |

## 8. 완료 체크

- [x] 전문 검색 요청 1개 (`V1-T18-2-P`)
- [x] 정확 조건 요청 1개 (`V1-T18-1-P`)
- [x] bool/filter 요청 1개 (`V1-T19-2-P`)
- [x] filter 2개 이상 (`category`, `connection`, `price` 3개)
- [x] sort 2개 (`V1-T20-P`: `battery_hours desc` + `price asc`)
- [x] highlight 1개 (`V1-T20-P`: `review_summary` highlight)
- [x] 의도한 0건 요청 1개 (`V1-T21-P`: 존재하지 않는 `product_id` 값)
- [x] 상위 3건 사람 평가 (§4)
- [x] 개선 1건과 전후 결과 (§7)
- [x] README의 기능 목록·실행 경로 동기화
- [ ] 최종 commit SHA: _(이 문서와 `elasticsearch/requests.http`, `docs/quality-test.md`를 commit한 뒤 SHA를 기록한다)_
