# Day 2 데이터 모델

## V1-T09-P · 문서 단위

- 개인 index 이름: `my-products`
- 검색 결과 한 줄 / 문서 한 건의 의미: 검색 결과 목록에 표시되는 상품 한 건
- 업무 ID field / 예시 값: `prd_id` / `P-0001`
- ES `_id`와 업무 ID 관계: 같은 값을 사용할 계획이지만 역할은 다르며 ES가 자동으로 동기화하지 않는다.

## V1-T10-P · 질문 3개

| 번호 | 사용자 질문 | 검색어 | 조건 | 정렬 | 표시 field |
|---|---|---|---|---|---|
| Q1 | 무선 이어폰 상품을 찾아줘. | 무선 이어폰 | 없음 | 관련도순 | `prd_id`, `prd_nm`, `category`, `price`, `in_stock`, `qty_score` |
| Q2 | 재고가 있는 전자기기 중 가격이 5만 원 이상 20만 원 이하인 상품을 보여줘. | 없음 | `category=전자기기`, `in_stock=true`, `price=50000~200000` | `price` 오름차순 | `prd_id`, `prd_nm`, `price`, `in_stock` |
| Q3 | 평점이 4.5 이상인 상품을 보여줘. | 없음 | `qty_score>=4.5` | `qty_score` 내림차순 | `prd_id`, `prd_nm`, `qty_score` |

대표 3건은 [`../data/sample-documents.json`](../data/sample-documents.json)에 저장한다.

| 문서 | 포함/제외/경계 역할 | 연결 질문 | 예상과 field 근거 |
|---|---|---|---|
| `P-0001` | 정상 포함 | Q1, Q2, Q3 | `prd_nm`에 무선 이어폰, 재고 있음, 전자기기, 가격 89,000원, 평점 4.7 |
| `P-0002` | 포함 경계 | Q2, Q3 | 가격 200,000원과 평점 4.5로 두 조건의 포함 경계 |
| `P-0003` | 제외 | Q1, Q2, Q3 | 유선 상품, 재고 없음, 가격 49,900원, 평점 4.2 |

## V1-T11-P · field 계약

| field | 예시 값 | 역할 | type | 질문 번호 | 선택 이유 |
|---|---|---|---|---|---|
| `prd_id` | `P-0001` | 정확 비교·표시 | `keyword` | 공통 | 상품 업무 ID 전체를 하나의 값으로 보존 |
| `prd_nm` | `SoundLab 무선 이어폰` | 전문 검색·표시 | `text` | Q1 | 상품명을 분석한 token으로 검색 |
| `in_stock` | `true` | 정확 조건·표시 | `boolean` | Q2 | 재고 있음과 없음을 두 상태로 구분 |
| `category` | `전자기기` | 정확 조건·집계·표시 | `keyword` | Q2 | 카테고리 전체 값으로 필터하고 집계 |
| `price` | `89000` | 범위·정렬·표시·집계 | `integer` | Q2 | 정수 가격의 범위 계산과 숫자 정렬 |
| `qty_score` | `4.7` | 범위·정렬·표시·집계 | `float` | Q3 | 소수 평점의 범위 계산과 숫자 정렬 |

- 배열/객체 여부: 현재 6개 field에는 배열과 객체가 없다.
- 제외한 개인정보: 고객 이름, 전화번호, 이메일, 주소, 주문 내역
- 제외 이유: 세 검색 질문을 검증하는 데 필요하지 않으며 합성 상품 데이터만 사용한다.
- 자가 점검: 숫자는 JSON 문자열이 아닌 숫자, 재고는 문자열이 아닌 boolean으로 작성했다.
- 완전한 mapping: [`../elasticsearch/index-create.json`](../elasticsearch/index-create.json)

## 다음 작업

- mapping과 대표 JSON 3건의 field 이름·값 type을 최종 대조한다.
- index가 없는 것을 확인한 뒤 다음 교시에 생성한다.
- 생성 후 mapping, settings, shard 상태를 실제 응답으로 검증한다.
