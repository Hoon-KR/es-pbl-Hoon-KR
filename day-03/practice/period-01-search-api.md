# 1교시 실습 — Search API 기본

## (공통) 문제 1 — 제공 코드 실행·응답 읽기

다음 요청을 실행하세요.

```http
GET /products/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

### 결과 입력

- HTTP 성공 여부: 200 OK, 성공
- `hits.total.value`: 10000
- `hits.hits`에 반환된 문서 수: 5
- 첫 번째 문서의 `_id`: `P-00003`
- 첫 번째 문서의 `_source` field 3개: `product_id`, `name`, `price`
- `hits.total.value`와 반환 문서 수가 다를 수 있는 이유: `size`는 이번 요청에서 실제로 반환할 문서 수(5)를 제한하는 값이고, `hits.total.value`는 `query` 조건(`match_all`)을 만족하는 전체 문서 수(10000)를 센 값이라 서로 역할이 다르기 때문이다.

## (공통) 문제 2 — 반환 개수와 field 직접 구현

`products` index의 전체 문서 중 최대 3건만 반환하고, `_source`에는 `product_id`, `name`, `price`, `in_stock`만 포함하는 Search API를 작성하고 실행하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 3,
  "_source": ["product_id", "name", "price", "in_stock"],
  "query": { "match_all": {} }
}
```

### 결과 입력

- 반환 문서 수: 3
- `_source`에 요구하지 않은 field가 포함됐는가: 아니오. `product_id`, `name`, `price`, `in_stock` 4개만 포함되었다.
- 검증한 문서 ID: `P-00003`, `P-00004`, `P-00008`

## (공통) 문제 3 — 정렬이 포함된 전체 조회 구현

`products` index의 전체 문서 중 최대 10건을 `price`가 낮은 순서로 반환하세요. `_source`에는 `product_id`, `name`, `price`만 포함하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price"],
  "query": { "match_all": {} },
  "sort": [{ "price": "asc" }]
}
```

### 결과 입력

- 첫 3개 문서의 ID와 price: `P-00431`(5900), `P-06599`(5900), `P-06479`(5900)
- 오름차순 여부: 예. 5900 → 5900 → 5900 → 5900 → 6100 → 6100 → 6100 → 6100 → 6200 → 6200 순으로 감소 없이 증가한다.
- 두 문서의 price가 같을 때 순서가 고정된다고 말할 수 있는가? 근거: 아니오. 같은 요청을 두 번 반복 실행했을 때는 동일한 순서(`P-00431` → `P-06599` → `P-06479` → `P-08895`)가 나왔지만, `sort`에 `price`만 지정하고 `_id` 같은 tie-breaker를 추가하지 않았기 때문에 이 순서는 현재 샤드·세그먼트 상태에서 우연히 일관된 것일 뿐 ES API가 공식적으로 보장하는 순서는 아니다. 문서가 추가·삭제되거나 샤드가 재배치되면 동일 price 문서 간 순서가 바뀔 수 있다.

## (개인) 문제 4 — 자기 index의 첫 Search API

자기 index의 전체 문서 중 최대 5건을 반환하는 Search API를 작성하세요.

### 역할·검증 기준

- 실제 자기 index 이름을 사용합니다.
- `_count`와 `hits.total.value`를 비교합니다.
- `size`와 전체 일치 문서 수를 구분해 설명합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

- 자기 index: `audio-devices-search`
- `_count`: 10000
- `hits.total.value`: 10000
- 반환 문서 수: 5
- 판정과 근거: 통과. `_count`(10000)와 `hits.total.value`(10000)가 일치해 색인된 전체 문서 수를 정확히 세고 있음을 확인했다. 다만 실제 화면에 나온 문서는 `size`로 제한한 5건뿐이므로, "조건을 만족하는 전체 문서 수"와 "이번 응답에서 눈에 보이는 문서 수"는 서로 다른 값이라는 점을 구분해야 한다.

## (개인) 문제 5 — 결과 카드 field 설계

자기 서비스에서 검색 결과 카드 한 개를 보여 준다고 가정하세요. 사용자가 클릭 여부를 결정하는 데 필요한 field 3~5개만 반환하는 Search API를 작성하세요.

### 역할·검증 기준

- 선택한 field가 자기 mapping과 실제 문서에 존재해야 합니다.
- 식별자, 제목 역할, 판단용 정보가 포함되어야 합니다.
- 불필요한 field를 하나 이상 제외하고 이유를 설명합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "_source": ["product_id", "product_name", "price", "rating", "battery_hours"],
  "query": { "match_all": {} }
}
```

- 포함한 field와 이유: `product_id`(식별자, 상세 페이지 연동), `product_name`(제목 역할, 어떤 제품인지 바로 인지), `price`(구매 판단의 핵심 기준), `rating`(신뢰도 판단), `battery_hours`(음향기기 사용자가 실제로 비교하는 스펙)
- 제외한 field와 이유: `review_summary`는 카드가 아니라 상세 화면에서 보여줄 긴 텍스트라서 카드에는 과도한 정보이고, `features`는 배열이라 카드 한 줄에 표시하기엔 길어질 수 있어 제외했다.
- 실제 반환 문서 ID: `AD-00001` ~ `AD-00005` (예: `AD-00001` `{price:324400, battery_hours:37, rating:3.9}`)
- 완료 판정: 통과. 5개 field만 `_source`에 포함되어 반환됐고, 식별자·제목·판단용 정보(가격/평점/배터리)가 모두 존재해 카드 요구사항을 만족한다.
