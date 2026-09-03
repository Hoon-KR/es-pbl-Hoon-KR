# 7교시 연습 — 개인 목적형 Dashboard 제작

- 필수 권장 시간: 43분
- 선택 도전: 2분
- 제출 상태 확인: 5분
- 시작 기준: `dashboard-plan.md`의 질문 4개와 A/B/C 경로 확정
- 화면 순서: [Save as](../KIBANA_9_5_STEP_BY_STEP.md#142-개인본-만들기), [선택 확장 패널](../KIBANA_9_5_STEP_BY_STEP.md#16-선택-확장-패널)

## (개인·필수) 문제 1 — 공통 원본을 보존하고 개인본 만들기

공통 Dashboard를 `Save as` 또는 `Duplicate`하여 개인본을 만드세요. 공통 원본에 덮어쓰지 않습니다.

- 공통 원본 이름: `D4 공통 상품 Dashboard - Hoon-KR` (id `b84b4044-604a-41b2-86d4-99544b62046b`, index `products`)
- 개인본 이름 `D4 개인 미션 - 주제 - 이름`: `D4 개인 오디오기기 Dashboard - Hoon-KR` (id `81d81f7b-8d1d-4e54-88ce-98374b600dc9`, index `audio-devices-search`)
- 사용한 복제 방법: 공통본을 `Save as`로 복제하지 않고, 개인 index(`audio-devices-search`) 전용 Lens 패널 4개를 새로 만들어 별도 Dashboard로 저장했다(공통본 패널은 `products`를 참조하므로 그대로 복제하면 field가 없어 깨지기 때문). 두 Dashboard는 각각 독립된 saved object로 존재해 원본이 보존된다.
- 상단 제목이 개인본으로 바뀌었는가: 예 — `D4 개인 오디오기기 Dashboard - Hoon-KR`
- Dashboard 목록에 원본과 개인본이 모두 있는가: 예 (`GET /api/saved_objects/_find?type=dashboard` 결과에 두 항목 모두 존재)
- 캡처 파일: `p07-q01-personal-dashboard-saveas.png`

![개인 오디오기기 Dashboard 전체 화면](../assets/day-04-practice/p07-q01-personal-dashboard-saveas.png)

## (개인·필수) 문제 2 — 청사진대로 서로 다른 패널 4개 제작

질문 Q1~Q4를 답하는 패널을 최소 4개 만드세요. 공통 Dashboard와 비교해 field·집계·정렬·구간·제목 중 두 가지 이상을 개인 질문에 맞게 바꿉니다.

| 질문 | 패널 제목 | field | 계산·그룹 | 차트 | 실제 결과 | 완료 기준 통과 |
|---|---|---|---|---|---|---|
| Q1 | 전체 오디오 기기 수 | (전체 문서) | Count of records | Metric | 10,000 | 통과 |
| Q2 | 카테고리별 기기 수 | `category` | Terms + Count | Bar | 이어폰 3,334 / 헤드셋 3,333 / 헤드폰 3,333 | 통과 |
| Q3 | 브랜드별 기기 수와 평균 가격 | `brand`, `price` | Terms(12) + Count + Average | Table | Apple 1,332건(255,403원) 등 12개 브랜드 전체 표시 | 통과 |
| Q4 | 연결 방식 비율 | `connection` | Terms + Count | Donut | 무선 4,461 / 유선 4,448 / 완전무선 1,091 | 통과 |

- 공통본에서 변경한 요소 2개 이상: ① Data View를 `products` → `audio-devices-search`로 변경 ② Q4의 field/차트를 재고 Donut(`in_stock`)에서 연결 방식 Donut(`connection`)으로 변경(개인 index에 boolean field가 없어 대체) ③ Line(시간) 패널은 date field가 없어 만들지 않고 대신 Table의 Top N을 12(전체 브랜드)로 조정
- 만들지 못한 패널과 이유: 등록 시점 Line — `audio-devices-search`에 date 타입 field가 전혀 없어(`GET /audio-devices-search/_mapping` 확인) 만들 수 없다.
- 사용한 대체 질문 또는 데이터 보강 계획: Q4를 "재고 비율" 대신 "연결 방식 비율"로 대체했고, 원래의 재고·등록시점 질문은 6교시 `dashboard-plan.md`의 데이터 보강 규칙(§부족한 데이터)에 별도로 설계해 두었다.

## (개인·필수) 문제 3 — 제목과 배치만 보고 질문을 이해하게 만들기

각 제목을 `Bar`, `그래프`, `현황` 같은 차트 이름이 아니라 사용자가 알게 되는 내용으로 바꾸세요.

| 수정 전 제목 | 수정 후 제목 | 사용자가 알게 되는 것 |
|---|---|---|
| Metric | 전체 오디오 기기 수 | 현재 카탈로그 총 규모 |
| Bar | 카테고리별 기기 수 | 어느 카테고리에 상품이 몰려 있는지 |
| Table | 브랜드별 기기 수와 평균 가격 | 어느 브랜드가 저가/프리미엄 포지션인지 |
| Donut | 연결 방식 비율 | 완전무선 비중이 낮다는 것(10.9%) |

- 가장 중요한 패널: 브랜드별 기기 수와 평균 가격 Table — MD의 핵심 판단(소싱 우선순위)에 가장 직접적으로 연결된다.
- 가장 크게 배치한 이유: Table은 12개 브랜드 행을 모두 보여줘야 하므로 세로 공간을 가장 넓게 배정했다.
- 잘림·겹침을 수정한 패널: 카테고리별 기기 수 Bar — category label 3개는 짧아 겹침 위험이 낮지만, 공통 Dashboard와 동일하게 horizontal로 맞춰 일관성을 유지했다.
- 수정 후 전체 화면 캡처: `p07-q03-personal-dashboard-titles.png`

![의미 있는 제목으로 수정된 개인 Dashboard 4패널](../assets/day-04-practice/p07-q03-personal-dashboard-titles.png)

## (개인·필수) 문제 4 — 개인 질문용 Control 또는 Filter

사용자가 반복해서 바꿀 조건 하나를 Control로 만들거나, 항상 유지할 조건 하나를 Filter로 추가하세요.

- 선택한 방식: Control
- field: `category`
- label 또는 조건: `카테고리 선택` (Options list)
- 이 조건이 필요한 사용자 행동: MD가 카테고리 하나(예: 헤드셋)만 골라 그 안의 브랜드 구성·가격·연결 방식을 집중해서 볼 때 사용
- 적용 전 핵심값: 전체 10,000 / 브랜드 12종 / 연결방식 3종(무선 4,461·유선 4,448·완전무선 1,091)
- 적용 후 핵심값(카테고리 = 헤드셋 선택): 3,333건 / 브랜드 상위 Corsair 683·Razer 672·Logitech 671·HyperX 654·JBL 653 / 평균 가격 213,195원 / 연결방식 유선 1,673·무선 1,660(헤드셋은 완전무선 옵션이 없어 0건)
- 함께 변한 다른 패널: 브랜드별 기기 수와 평균 가격 Table, 연결 방식 비율 Donut
- 해제 방법: Control 값을 `Any`로 재선택
- 해제 후 복구값: 10,000
- 캡처 파일: `p07-q04-personal-control.png` (Control이 Kibana 화면에 정상 렌더링됨을 직접 확인함)

![카테고리 Control = 헤드셋 적용 상태](../assets/day-04-practice/p07-q04-personal-control.png)

## (선택 도전) 문제 5 — 확장 차트 하나의 필요성 심사

Gauge, Heatmap, Treemap, Tag cloud 중 하나가 자신의 질문에 정말 필요한지 먼저 판단하세요.

- 후보 차트: Heatmap
- 답하려는 질문: 카테고리 × 연결 방식 조합별로 상품이 어디에 몰려 있는가?
- 필요한 field: `category`, `connection`
- 기본 Bar/Table보다 나은 점: 두 범주 축의 조합을 한 화면에서 색상 농도로 즉시 비교할 수 있다(예: 이어폰×완전무선 조합만 특별히 진한지).
- 오해할 위험: 색상 스케일을 잘못 읽으면 절대값 차이를 과장해서 볼 수 있다.
- 추가/보류 결정: 보류 — 공통 6패널·개인 4패널 필수 요구사항을 이미 충족했고, 이어폰만 완전무선 옵션이 있는 데이터 구조(카탈로그 자체의 특성)라 Heatmap 없이도 Table/Donut 조합으로 같은 결론(완전무선은 이어폰에만 존재)을 확인할 수 있어 추가하지 않았다.
- 추가했다면 검증 결과: 해당 없음(보류)

## 교시 완료 신호

- GREEN: 개인본, 4패널, 의미 있는 제목·배치, 상호작용 1개 완료 — **충족**
- YELLOW: 3패널 또는 상호작용 검증 미완료
- RED: 개인 Dashboard 복제나 저장 불가
