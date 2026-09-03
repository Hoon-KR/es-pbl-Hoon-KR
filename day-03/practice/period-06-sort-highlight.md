# 6교시 실습 — 정렬·highlight

## (공통) 문제 1 — 제공 코드로 1·2차 정렬 확인

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price", "rating", "in_stock"],
  "query": { "match": { "name": "무선" } },
  "sort": [
    { "rating": "desc" },
    { "price": "asc" }
  ]
}
```

### 결과 입력

- 상위 5개 ID / rating / price: `P-03842`(5 / 13900), `P-08761`(5 / 107200), `P-07634`(5 / 132300), `P-05962`(5 / 138300), `P-06457`(5 / 184900)
- 1차 정렬이 올바른가: 예. 상위 5개 모두 rating=5(최고 평점)로 내림차순 조건을 만족한다.
- rating 동률에서 2차 정렬이 적용된 사례: 있음. 상위 5개가 모두 rating=5로 동률인데, 그 안에서 price가 13900 → 107200 → 132300 → 138300 → 184900으로 오름차순 정렬돼 있어 2차 정렬(price asc)이 실제로 작동함을 확인했다.
- 동률이 없다면 2차 정렬을 확인할 수 있는 방법: 해당 없음(이번 데이터에서 이미 동률 사례로 확인됨).

## (공통) 문제 2 — 정렬 우선순위 교환

문제 1과 같은 검색 결과를 가격이 낮은 순서로 먼저 정렬하고, 가격이 같으면 평점이 높은 순서로 정렬하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "price", "rating", "in_stock"],
  "query": { "match": { "name": "무선" } },
  "sort": [
    { "price": "asc" },
    { "rating": "desc" }
  ]
}
```

### 비교 결과

- 변경 후 상위 5개 ID / price / rating: `P-01490`(10900 / 2.9), `P-05738`(12900 / 4.9), `P-05218`(13300 / 4.9), `P-08586`(13700 / 2.3), `P-03842`(13900 / 5)
- 순서가 달라진 문서: 완전히 달라졌다. 문제 1에서 1위였던 `P-03842`(rating 5)가 여기서는 5위로 밀려났고, 대신 가장 저렴한 `P-01490`(10900원, rating 2.9)이 1위가 됐다 — 정렬 기준을 rating 우선에서 price 우선으로 바꾸자 순위가 정렬 기준을 따라 완전히 재배치됐다.
- 검색 hit 집합도 달라졌는가: 아니오. `query`(match name:무선)는 그대로이므로 `hits.total.value`는 두 요청 모두 505건으로 동일하다. `sort`는 hit 집합이 아니라 같은 집합 안의 표시 순서만 바꾼다.

## (공통) 문제 3 — highlight와 표시 field 구현

`name`, `description`에서 `무선 이어폰`을 검색하되 `name`에 3배 boost를 적용하세요. 최대 5건을 반환하고 결과 카드용 field만 `_source`에 포함하며 `name`, `description`에 highlight를 적용하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "_source": ["product_id", "name", "price", "in_stock"],
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name^3", "description"]
    }
  },
  "highlight": {
    "fields": { "name": {}, "description": {} }
  }
}
```

### 결과 입력

- `_source` field 목록: `product_id`, `name`, `price`, `in_stock`
- highlight가 생성된 문서 ID와 field: `P-00241`, `P-00305`, `P-00529`, `P-00617`, `P-00777` — 5건 모두 `name` field에서 highlight가 생성됨(예: `P-00241` → "SoundLab 프리미엄 `<em>무선</em>` `<em>이어폰</em>`").
- `_source`와 highlight의 차이: `_source`는 원본 저장 값 그대로("SoundLab 프리미엄 무선 이어폰")를 보여주고, `highlight`는 같은 문자열에서 검색어와 일치한 부분만 `<em>` 태그로 감싼 조각을 별도로 제공한다.
- highlight가 없는 hit가 있다면 이유 추정: 5건 전부 `name` highlight는 있었지만 `description` highlight는 하나도 없었다. `description`에는 "OO 상품입니다..." 같은 공통 문구만 있고 "무선"·"이어폰" 토큰이 없어 해당 field는 애초에 매칭되지 않았기 때문이다.

## (개인) 문제 4 — 자기 결과 정렬·카드 설계

자기 서비스에서 중요한 1차·2차 정렬 기준과 결과 카드 field 3~5개를 선택해 Search API를 구현하세요.

### 역할·검증 기준

- 정렬 가능한 mapping type을 사용합니다.
- 1차·2차 정렬의 업무적 이유를 설명합니다.
- 실제 상위 5개 값으로 순서를 검증합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "_source": ["product_id", "product_name", "price", "battery_hours", "rating"],
  "query": { "term": { "category": "헤드셋" } },
  "sort": [
    { "battery_hours": "desc" },
    { "price": "asc" }
  ]
}
```

- 정렬 field·방향·이유: 1차 `battery_hours desc`(운동·이동 중 오래 쓰는 배터리가 헤드셋 구매의 핵심 기준), 2차 `price asc`(배터리 시간이 같으면 저렴한 상품을 먼저 보여줌)
- 카드 field와 이유: `product_id`(식별자), `product_name`(제목), `price`(가격 비교), `battery_hours`(정렬 기준 스펙 확인), `rating`(품질 참고)
- 상위 5개 정렬 검증: `AD-09183`(80h/34400원), `AD-07908`(80h/39000원), `AD-09861`(80h/64200원), `AD-02451`(80h/78100원), `AD-09744`(80h/79600원) — battery_hours가 모두 80으로 동률이고, 그 안에서 price가 34400 → 39000 → 64200 → 78100 → 79600으로 오름차순 정렬돼 2차 정렬까지 실제로 검증됐다.

## (개인) 문제 5 — 자기 highlight 또는 표시 최적화

자기 text 검색에 highlight를 적용하세요. text 검색이 없는 프로젝트라면 `_source` 최소화 전후를 비교하세요.

### 역할·검증 기준

- 검색 field와 highlight field의 관계가 타당해야 합니다.
- 원본 데이터와 강조 조각을 구분합니다.
- 사용자 판단에 실제로 도움이 되는지 평가합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 3,
  "_source": ["product_id", "product_name"],
  "query": { "match": { "review_summary": "저음이 강조되고 운동용" } },
  "highlight": { "fields": { "review_summary": {} } }
}
```

- 선택한 방식과 이유: `review_summary`(text) 검색에 highlight 적용. 리뷰 문장이 길기 때문에 사용자가 왜 이 상품이 검색됐는지 근거를 바로 보여주려면 강조 표시가 필요했다.
- 실제 결과: `AD-00003`(Corsair 플러스 방송용 헤드셋), `AD-00004`(QCY 프로 스포츠 이어폰), `AD-00005`(Sony 스탠다드 오버이어 헤드폰) 모두 `highlight.review_summary`에 "`<em>저음이</em> <em>강조되고</em> 운동용으로 딱입니다."`가 반환됐다.
- 사용자에게 유용한가: 예. 세 상품의 카테고리(헤드셋/이어폰/헤드폰)가 서로 다른데도 같은 리뷰 문장으로 매칭된 이유를 강조 표시로 바로 확인할 수 있어, 사용자가 "왜 이 상품이 나왔지?"에 대한 답을 리뷰 원문 안에서 즉시 찾을 수 있다.
- 개선할 점: 세 상품의 리뷰 문장이 완전히 동일해 문장만으로는 상품 간 차별점을 알기 어렵다. `product_name`이나 `features`처럼 상품별로 달라지는 field에도 검색어 관련 강조를 추가하면 카드의 변별력이 더 좋아질 것이다.
