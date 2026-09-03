# 4교시 실습 — 정확 조건과 경계

## (공통) 문제 1 — 제공 코드로 세 filter 확인

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 380
- 확인한 문서 ID 3개: `P-00025`, `P-00129`, `P-00185`
- 각 문서의 category / in_stock / price: `P-00025`(전자기기 / true / 59400), `P-00129`(전자기기 / true / 53800), `P-00185`(전자기기 / true / 161600)
- 조건을 위반한 문서가 있는가: 아니오. 확인한 3건 모두 category="전자기기", in_stock=true, 50000≤price≤200000을 모두 만족했다.

## (공통) 문제 2 — 경계 포함 범위 직접 구현

`products`에서 category가 `전자기기`이고 가격이 50,000원 이상 200,000원 이하인 상품을 검색하세요. 최대 10건을 반환하고 `product_id`, `name`, `category`, `price`만 표시하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "category", "price"],
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "price": "asc" }]
}
```

### 결과 입력

- `hits.total.value`: 440
- 최소·최대 price: 최소 50700 (`P-03393`) / 최대 199500 (`P-04537`)
- 50,000 또는 200,000 경계 문서 존재 여부와 ID: 없음. `price=50000` term filter와 `price=200000` term filter를 각각 실행했을 때 두 경우 모두 `hits.total.value`가 0이었다. 이 데이터셋에는 정확히 50000원 또는 200000원인 "전자기기" 상품이 없다.

## (공통) 문제 3 — 경계 제외 범위 직접 구현

문제 2에서 다른 조건은 모두 그대로 유지하고 가격 조건만 50,000원 초과 200,000원 미만으로 바꾸세요. 한 요소만 변경해야 합니다.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "category", "price"],
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gt": 50000, "lt": 200000 } } }
      ]
    }
  },
  "sort": [{ "price": "asc" }]
}
```

### 비교 결과

- 문제 2 total / 문제 3 total: 440 / 440
- 빠진 경계 문서 ID: 없음
- 경계 문서가 없어 결과가 같다면 확인한 근거: 문제 2에서 `term: {price: 50000}`과 `term: {price: 200000}`을 각각 조회했을 때 두 요청 모두 0건이었다. 즉 이 category·가격대에는 정확히 경계값을 가진 문서가 원래 없었기 때문에 `gte/lte`를 `gt/lt`로 바꿔도 제외될 문서가 없어 total이 동일했다.

## (개인) 문제 4 — 자기 정확 조건 2개

자기 데이터에서 정확 조건으로 사용할 field 2개를 선택해 두 조건을 모두 만족하는 검색을 구현하세요.

### 역할·검증 기준

- keyword·boolean 등 실제 mapping type에 적합해야 합니다.
- 실행 전 포함 예상 문서 1개와 제외 예상 문서 1개를 정합니다.
- 실행 후 `_source`로 판정합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "헤드폰" } },
        { "term": { "connection": "무선" } }
      ]
    }
  }
}
```

- field·type·값 2개: `category`(keyword)="헤드폰", `connection`(keyword)="무선"
- 기대 ID / 제외 ID: 기대 `AD-00014`(category=헤드폰, connection=무선, 조건 그대로 만족) / 제외 `AD-00002`(category=헤드폰이지만 connection=유선이라 조건 불일치)
- 실제 결과와 판정: 통과. `hits.total.value`=1669, 확인한 상위 5건(`AD-00014`, `AD-00017`, `AD-00020`, `AD-00026`, `AD-00029`) 모두 category=헤드폰, connection=무선이었다. 예상대로 `AD-00002`는 결과 집합에 포함되지 않았다(connection이 유선이라 두 번째 filter에서 제외됨).

## (개인) 문제 5 — 자기 범위와 경계 실험

자기 데이터의 numeric 또는 date field를 선택해 포함 경계와 제외 경계 요청을 각각 구현하세요.

### 역할·검증 기준

- 실제 데이터의 최소·최대 또는 의미 있는 경계값을 먼저 확인합니다.
- `gte/lte`와 `gt/lt` 외 조건은 동일하게 유지합니다.
- 경계 문서가 없으면 fixture 설계 또는 부재 근거를 기록합니다.

### API와 결과 입력

```http
# 포함 경계
GET /audio-devices-search/_search
{
  "size": 10,
  "query": { "range": { "rating": { "gte": 4.5 } } }
}

# 제외 경계
GET /audio-devices-search/_search
{
  "size": 10,
  "query": { "range": { "rating": { "gt": 4.5 } } }
}
```

- field / type / 경계값: `rating` / `float` / 4.5 (`docs/data-model.md`의 Q3 기준 "평점 4.5 이상")
- 포함 요청 total / 제외 요청 total: 2755 / 2269
- 달라진 문서 ID: 두 요청의 차이는 486건이며, 이는 `rating`이 정확히 4.5인 문서 수(별도로 `term: {rating: 4.5}` 확인 시 486건, 예: `AD-00024`, `AD-00031`, `AD-00036`)와 정확히 일치한다.
- 경계 판정: 경계 존재. `gte`는 4.5를 포함해 2755건, `gt`는 4.5를 제외해 2269건으로 실제 차이(486건)가 발생했으므로 `gte/gt` 선택이 실제 결과에 영향을 준다는 것을 확인했다.
