# 검색 품질 점검표

각 행에 자신의 PBL 검색 질문과 실제 결과를 기록합니다. 결과 수만 적지 말고, 상위 결과가 질문 의도에 맞는지 확인합니다.

- 대상 index: `audio-devices-search` (10,000건)
- 요청 파일: `elasticsearch/requests.http`의 `V1-T17-P`~`V1-T21-P` 구간

| 번호 | 검색 질문 | 요청 파일/조건 | 기대 결과 | 실제 결과 요약 | 개선 여부·근거 |
|---|---|---|---|---|---|
| 1 | 저음이 강조되고 배터리가 오래가는 운동용 제품 리뷰를 찾고 싶다 | `V1-T18-2-P`(`AD-Q-FULLTEXT`) — `match: {review_summary: "..."}`  | `review_summary`에 "저음"·"운동용" 취지가 담긴 문서(예: `AD-00003`)가 상위에 나온다 | 원 검색어 "저음 운동용"은 0건. `standard` analyzer가 한국어 조사를 분리하지 못해 저장 토큰("저음이","운동용으로")과 검색어 토큰("저음","운동용")이 글자 단위로 불일치했기 때문(`_analyze`로 확인). 검색어를 "저음이 강조되고 운동용으로"로 조정하자 1,480건, 상위 3건(`AD-00003`~`AD-00005`) 모두 highlight로 일치 확인 | 개선함(임시). 근본 원인은 analyzer이므로 한국어 형태소 분석기(Nori) 적용을 다음 과제로 남김 |
| 2 | 소니 제품만 모아 보고 싶다 | `V1-T18-1-P`(`AD-Q-EXACT`) — `term: {brand: "Sony"}` | `brand`="Sony"인 문서만, 다른 브랜드는 0건 | 1,314건, 상위 3건(`AD-00005`,`AD-00007`,`AD-00014`) 모두 `brand`="Sony" 확인. `brand`="Bose" 등 다른 값은 결과에 없음 | 개선 불필요 — 통과 |
| 3 | 노이즈 캔슬링이 지원되는 10만 원 이하 무선 이어폰을 찾고 싶다(`docs/data-model.md` Q1) | `V1-T19-2-P`(`AD-Q-BOOLFILTER`) — `must: match(review_summary:"노이즈")` + `filter: category=이어폰, connection=무선, price<=100000` | category=이어폰, connection=무선, price 10만 원 이하, 리뷰에 "노이즈" 언급이 있는 문서만(예: `AD-00370`) | 42건. 상위 3건(`AD-00370`,`AD-00475`,`AD-01036`) 모두 세 filter와 리뷰 언급 조건 충족. `connection` filter를 제거(`V1-T19-1-P`)하면 126건으로 늘어나 filter가 실제로 결과를 좁히는 역할을 함을 확인 | 개선 불필요 — 통과 |

## 최소 기준 확인

- [x] 전문 검색 1개(`V1-T18-2-P`), 정확 조건 검색 1개(`V1-T18-1-P`), bool/filter 검색 1개(`V1-T19-2-P`)
- [x] filter 최소 2개 — `V1-T19-2-P`에 `category`, `connection`, `price` 총 3개 적용
- [x] sort 최소 2개 — `V1-T20-P`에 `battery_hours desc` + `price asc` 2단 정렬 적용, 동률 구간(80h)에서 2차 정렬 작동 확인
- [x] 결과가 0건이어야 하는 조건 1개 — `V1-T21-P`에서 존재하지 않는 `product_id` 값으로 정상 0건(HTTP 200, error 없음) 확인
- [x] 예상과 다른 결과 기록 — 질문 1의 전문 검색이 기대와 달리 0건이 나온 원인을 `analyzer`(standard analyzer의 한국어 조사 미분리)로 진단하고, 검색어 조정으로 우회했음을 기록. 근본 해결(Nori analyzer 적용)은 다음 개선 과제로 남김
