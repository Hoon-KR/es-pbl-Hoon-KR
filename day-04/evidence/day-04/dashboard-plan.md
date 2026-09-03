# Day 4 개인 Dashboard 설계

## 1. 사용자와 목적

- 내 주제: 오디오 기기(이어폰·헤드폰·헤드셋) 쇼핑 검색 서비스 — index `audio-devices-search`
- 이 Dashboard를 볼 사람: 오디오 기기 카테고리를 담당하는 MD 1명
- Dashboard를 보고 결정하거나 행동할 것: 다음 시즌에 어떤 카테고리·브랜드·연결 방식의 상품을 더 소싱할지 우선순위를 정하고, 완전무선처럼 비중이 낮은 조합의 신규 상품 발주를 요청한다
- 사용할 index / Data View: `audio-devices-search` (Data View id `a8ed28f5-3d50-4941-ab45-79dfd3df293a`)

## 2. 데이터 준비 경로

- [x] A: 개인 데이터로 제작
- [ ] B: 공통 products로 제작하며 개인 데이터 보강 규칙 작성
- [ ] C: 공통 Dashboard를 완성하고 개인 청사진에 집중

선택 이유: `category`, `brand`, `price`, `connection` field가 모두 실제 존재하고(`GET /audio-devices-search/_mapping` 확인) 값 분포도 충분해(카테고리 3종, 브랜드 12종, 가격 15,100~600,000원) 공통 6패널과 동일한 절차를 개인 index에 바로 적용할 수 있다. 재고(boolean)·등록 시점(date) field만 없어 해당 두 질문은 데이터 보강 규칙으로 별도 설계했다(§4).

## 3. 질문-데이터-차트 청사진

| 번호 | 분석 질문 | 필요한 field | 현재 존재? | mapping type | 계산·그룹 방식 | 차트 | filter/control | 확인 기준 |
|---|---|---|---|---|---|---|---|---|
| Q1 전체 규모 | 전체 등록 오디오 기기는 몇 개인가? | (전체 문서) | 예 | — | Count of records | Metric | 없음 | `_count` = 10,000과 일치 |
| Q2 그룹 비교 | 카테고리별 등록 수는 어떤가? | `category` | 예 | keyword | Terms(size 5) + Count | Bar | category Options list | 3개 카테고리 합계 = 10,000 |
| Q3 분포/정확한 값 | 브랜드별 등록 수와 평균 가격은 어떻게 다른가? | `brand`, `price` | 예 | keyword, integer | Terms(size 20) + Count + Average | Table | category Options list와 연동 | 12개 브랜드 모두 표시, 합계 = 10,000 |
| Q4 상태/시간 | 연결 방식(무선/유선/완전무선) 비율은 어떤가? | `connection` | 예 | keyword | Terms(size 5) + Count | Donut | category Options list와 연동 | 3개 값 합계 = 10,000 |

## 4. 데이터 부족 분석

- 현재 데이터로 답할 수 없는 질문: 재고 있음/없음 비율은 어떤가? / 월별(또는 기간별) 등록 추이는 어떤가?
- 부족한 field: `in_stock`(boolean), `created_at`(date) — `audio-devices-search` mapping에 전혀 존재하지 않음
- 필요한 mapping type: `in_stock` boolean, `created_at` date
- 필요한 값의 범위·범주·비율: `in_stock`은 카테고리별로 다른 확률을 부여(이어폰 품절 20%, 헤드폰/헤드셋 품절 12%, products index 실측 전체 비율 15.3%를 참고해 카테고리별로 세분화). `created_at`은 products와 동일한 최근 1년 범위.
- 날짜가 필요하다면 기간과 단위: 2025-08-27 ~ 2026-08-26, 일 단위 균등 난수 배정
- 한 문서가 의미할 사건 또는 대상: 판매 중인 오디오 기기 상품 1개(등록 시점 = 카탈로그 등록일)
- 생성 또는 수집 방법: 기존 10,000건에 두 field를 추가 보강(신규 문서 생성 불필요). seed 고정 난수(기존 생성 seed 9502026 계열)로 카테고리별 확률에 따라 `in_stock`을 배정하고, `created_at`을 지정 범위에서 균등 난수로 배정한 뒤 `_update_by_query` 또는 재색인으로 반영.
- 데이터 수가 충분하다고 판단할 기준: 보강 후 `_count`가 여전히 10,000이고, `in_stock` terms 비율이 설계한 카테고리별 확률과 오차범위(±2%p) 내에서 일치하며, `created_at` 최소·최대값이 지정 범위를 벗어나지 않을 때

## 5. 제작 순서

1. Data View `audio-devices-search` 확인 (완료 — id `a8ed28f5-3d50-4941-ab45-79dfd3df293a`)
2. Q1 Metric `전체 오디오 기기 수` 제작 (완료 — Lens id `19299ba2-ef53-43bf-bda4-b124fde5592d`)
3. Q2 Bar `카테고리별 기기 수` 제작 (완료 — Lens id `a23406d6-cfc6-426e-af1e-2c2c9bb60266`)
4. Q3 Table `브랜드별 기기 수와 평균 가격` 제작 (완료 — Lens id `87c0dc56-a8c4-4518-8746-ce6e2a65f64b`)
5. Q4 Donut `연결 방식 비율` 제작 (완료 — Lens id `c218ec4e-f711-46de-aee8-17e438a7190b`)
6. 4패널을 Dashboard로 조립하고 category Options list Control 추가 (완료 — Dashboard id `81d81f7b-8d1d-4e54-88ce-98374b600dc9`)
7. Kibana를 열어 Control 렌더링과 패널 표시를 눈으로 확인하고 화면 캡처 3종 저장 (완료 — 아래 §6 참고)

## 6. 완료 화면

- Dashboard 제목: `D4 개인 오디오기기 Dashboard - Hoon-KR`
- 필수 패널 수: 4 (Metric, Bar, Table, Donut)
- 사용할 control/filter: category Options list (label `카테고리 선택`) — Kibana 9.5.0 화면에 정상 렌더링됨을 확인
- 저장한 캡처 파일: `personal-dashboard.png`, `personal-dashboard-filtered.png`

![개인 오디오기기 Dashboard 전체 화면](personal-dashboard.png)

![카테고리 Control 적용 상태](personal-dashboard-filtered.png)
