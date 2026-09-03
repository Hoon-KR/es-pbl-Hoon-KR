# 5교시 실습 — bool 검색

## (공통) 문제 1 — 제공 코드로 must·filter 확인

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [{ "match": { "name": "무선" } }],
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

- `hits.total.value`: 74
- 상위 3개 ID·name: `P-00025`(MobiCore 컴팩트 무선 이어폰), `P-00129`(Auralis 스마트 무선 이어폰), `P-00369`(SoundLab 데일리 무선 이어폰)
- 세 filter의 실제 값: category="전자기기", in_stock=true, price는 59400~162800원 사이(50000~200000 범위 안)
- must와 filter의 역할 차이: `must`(`match: name:"무선"`)는 관련도 점수(`_score`) 계산에 참여해 상위 문서를 정렬하는 데 쓰이고, `filter`(category/in_stock/price)는 점수 계산 없이 조건을 만족하는지 여부만으로 결과 집합을 좁힌다.

## (공통) 문제 2 — 조건 제거 실험 직접 구현

문제 1의 요청에서 `in_stock` filter만 제거한 API를 작성하세요. 다른 조건은 바꾸지 마세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "must": [{ "match": { "name": "무선" } }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  }
}
```

### 비교 결과

- 변경 전 total / 변경 후 total: 74 / 83
- 새로 포함된 문서 ID·in_stock: `P-00457`(in_stock=false), `P-00521`(in_stock=false) 등 상위 10건 중 2건이 새로 확인됐고, total 차이(9건) 전체가 in_stock=false 문서다.
- 변화가 없다면 데이터 근거: 해당 없음(변화 있음, 74→83건으로 9건 증가).
- 제거한 조건의 역할: `in_stock` filter는 품절 상품을 결과에서 걸러내는 조건이었다. 제거하자 재고가 없는(in_stock=false) 상품까지 결과에 포함됐다.

## (공통) 문제 3 — should 조건 직접 구현

category가 `전자기기`인 문서 중 `name`에 `무선`이 있거나 `in_stock=true`인 조건을 최소 하나 만족하도록 bool API를 작성하세요. `minimum_should_match`를 명시하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "bool": {
      "filter": [{ "term": { "category": "전자기기" } }],
      "should": [
        { "match": { "name": "무선" } },
        { "term": { "in_stock": true } }
      ],
      "minimum_should_match": 1
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 1097
- 무선이지만 품절인 문서 존재 여부: 예. `name`에 "무선"이 있으면서 `in_stock=false`인 문서가 32건 있었다(예: `P-00457`). `should`이므로 이런 문서도 (should 두 조건 중 하나만 만족해도) 결과에 포함된다.
- 무선이 아니지만 재고가 있는 문서 존재 여부: 예. `name`에 "무선"이 없으면서 `in_stock=true`인 문서가 848건 있었다(예: `P-00009` NeoTech 데일리 기계식 키보드).
- should 조건 판정: 통과. 두 조건 중 하나만 만족해도 포함되는 `should` + `minimum_should_match: 1`의 동작이 실제 데이터로 확인됐다.

## (개인) 문제 4 — 자기 bool 검색

자기 사용자 질문 하나를 검색 의도와 정확 조건으로 분해해 bool 요청을 구현하세요.

### 역할·검증 기준

- must 0~1개, filter 2개 이상을 사용합니다.
- 각 field와 query 선택 이유를 mapping type으로 설명합니다.
- 반환 문서 3개 이상을 실제 값으로 검증합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": {
    "bool": {
      "must": [{ "match": { "review_summary": "노이즈" } }],
      "filter": [
        { "term": { "category": "이어폰" } },
        { "term": { "connection": "무선" } },
        { "range": { "price": { "lte": 100000 } } }
      ]
    }
  }
}
```

- 사용자 질문: `docs/data-model.md` Q1 — "노이즈 캔슬링이 지원되는 10만 원 이하 무선 이어폰"
- must와 이유: `match: {review_summary: "노이즈"}` — 리뷰 문장 속 "노이즈 캔슬링" 언급 여부는 정확한 값 비교가 아니라 문장을 분석해 찾아야 하는 검색 의도이므로 관련도 계산이 필요한 `must`로 넣었다.
- filter 2개와 이유: `category="이어폰"`(keyword, 정확한 폼팩터 조건), `connection="무선"`(keyword, 정확한 연결방식 조건). 두 field 모두 값 전체 일치가 필요해 점수 계산 없이 결과만 좁히는 `filter`에 적합했다. (가격 조건 `price<=100000`도 filter로 추가했다.)
- 실제 검증 결과: `hits.total.value`=42. 상위 결과 `AD-00370`(이어폰/무선/56100원), `AD-00475`(이어폰/무선/66300원), `AD-01036`(이어폰/무선/26300원) 모두 `_source`에서 category="이어폰", connection="무선", price≤100000, review_summary에 "노이즈 캔슬링" 포함을 직접 확인했다.

## (개인) 문제 5 — 조건 역할 검증

개인 문제 4에서 filter 하나를 제거하고 전후 결과를 비교하세요. 추가로 원래 조건에서 제외되어야 하는 문서 1개를 독립 요청으로 확인하세요.

### 역할·검증 기준

- 한 번에 filter 하나만 제거합니다.
- 새로 포함된 문서의 실제 값을 확인합니다.
- 제외 문서는 원래 bool 결과에 포함되지 않아야 합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 10,
  "_source": ["product_id", "category", "connection", "price"],
  "query": {
    "bool": {
      "must": [{ "match": { "review_summary": "노이즈" } }],
      "filter": [
        { "term": { "category": "이어폰" } },
        { "range": { "price": { "lte": 100000 } } }
      ]
    }
  }
}
```

- 제거한 filter: `connection: "무선"`
- 전/후 total: 42 / 126
- 새로 포함된 ID와 값: `AD-00058`(connection=완전무선, 95400원), `AD-00190`(connection=유선, 90400원), `AD-00232`(connection=유선, 47900원) 등 84건이 새로 포함됐고, 모두 connection이 "무선"이 아닌 "완전무선" 또는 "유선"이었다.
- 제외 확인 ID와 근거: `AD-00001`을 독립 조회한 결과 category="이어폰"이지만 connection="유선", price=324400원(10만원 초과), review_summary="배터리가 오래가서 충전 스트레스가 없어요."(노이즈 언급 없음)였다. 세 조건 중 하나도 만족하지 않아 원래 42건 결과에도, 필터를 하나 뺀 126건 결과에도 포함되지 않았다.
