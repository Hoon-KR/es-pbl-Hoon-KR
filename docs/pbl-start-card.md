# PBL 시작 카드

## 프로젝트

- 프로젝트 주제: 음향기기(이어폰, 헤드셋) 스펙 및 리뷰 통합 검색
- 사용자: 예산, 용도, 선호하는 기능에 맞춰 최적의 기기를 찾으려는 소비자 및 오디오 애호가
- 해결하려는 문제: 수많은 음향기기 중에서 가격, 폼팩터, 특정 기능(노이즈 캔슬링 등) 및 평점을 한 번에 조합하여 원하는 제품을 비교하고 찾기 어렵다.
- ES로 찾게 할 문서 한 건: 검색 결과 목록에 표시되는 특정 음향기기 모델 한 건 (상세 스펙 및 리뷰 요약 포함)
- index 이름: `audio-devices-search`
- 업무 ID field: `product_id`
- 업무 ID와 ES `_id` 사용 계획: 같은 값을 사용하되 두 값이 자동으로 동기화되지는 않음을 확인한다.

## 사용자 질문

1. 기능에 '노이즈 캔슬링'이 포함된 10만 원 이하의 무선 이어폰을 낮은 가격순으로 보여줘.
2. 리뷰에 '저음'이나 '운동용'이 포함되고 배터리가 30시간 이상 가는 무선 헤드셋을 배터리가 긴 순으로 보여줘.
3. 소니나 보스 제품 중 사용자 평점이 4.5 이상인 헤드폰을 평점이 높은 순서로 보여줘.

## 검색에 사용할 field

- 전문 검색: `product_name`, `review_summary`
- 정확 조건: `brand`, `category`, `connection`, `features`
- 범위 조건: `price`, `battery_hours`, `rating`
- 정렬: `price`, `battery_hours`, `rating`
- 결과 표시: `product_id`, `product_name`, `brand`, `category`, `price`, `connection`, `features`, `battery_hours`, `rating`, `review_summary`

## 성공 기준

- 제품명이나 리뷰 요약에서 "저음", "운동용" 등의 키워드를 전문 검색할 수 있다.
- `category`, `connection`, `price`, `features` 조건을 함께 적용하고 가격순이나 배터리순으로 정렬할 수 있다.
- `brand` 다중 선택과 `rating` 4.5 이상을 조건으로 적용하고 높은 평점순으로 정렬할 수 있다.
- 최소 1,000건의 합성 음향기기 데이터를 적재하고 count와 주요 분포를 실제 응답으로 검증한다.
- 브랜드별 및 폼팩터(카테고리)별 평균 평점과 인기 기능(features) 분포를 Dashboard에서 확인한다.

## 현재 상태

- [x] 문서 단위와 index 이름 결정
- [x] 사용자 질문 3개 결정
- [x] field 10개와 type 후보 결정
- [x] 대표 JSON 3건 작성
- [ ] mapping 최종 검토
- [ ] index 생성과 mapping·shard 검증
- [ ] analyzer·CRUD·Bulk 적재
- [ ] 검색·집계·Dashboard 구현

## 범위

- 웹사이트 전체가 아니라 ES index, 검색 요청, 분석과 Dashboard를 완성한다.
- 실제 고객 개인정보와 주문 정보는 사용하지 않는다.
- 합성 상품 데이터만 사용한다.