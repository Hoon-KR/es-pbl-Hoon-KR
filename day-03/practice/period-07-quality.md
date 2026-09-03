# 7교시 실습 — 검색 품질 점검

## (공통) 문제 1 — 제공 코드로 상위 결과 평가

```http
GET /products/_search
{
  "size": 10,
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name^3", "description"]
    }
  }
}
```

### 결과 입력

| 순위 | 문서 ID | name | 관련/보류/무관 | 근거 |
|---:|---|---|---|---|
| 1 | P-00241 | SoundLab 프리미엄 무선 이어폰 | 관련 | 이름에 "무선"·"이어폰"이 그대로 포함, 검색 의도와 완전히 일치 |
| 2 | P-00305 | Auralis 실속형 무선 이어폰 | 관련 | 동일하게 "무선 이어폰"을 이름에 그대로 포함 |
| 3 | P-00529 | NeoTech 스마트 무선 이어폰 | 관련 | 동일하게 "무선 이어폰"을 이름에 그대로 포함 |

- `hits.total.value`: 505
- 결과 수가 많다는 사실만으로 품질이 좋다고 말할 수 있는가: 아니오. 505건이라는 숫자 자체는 "무선"이나 "이어폰" 토큰이 `name` 또는 `description` 어딘가에 있는 문서 수일 뿐이다. 실제로 상위 3건이 사용자 의도와 맞는지는 `_source`를 직접 읽어 판정해야 하며, 결과 수만으로는 청소기·다른 무선기기가 섞여 있는지 알 수 없다.

## (공통) 문제 2 — 정확 조건 품질 직접 구현

category가 `전자기기`이고 `in_stock=true`인 상품만 검색하는 API를 작성하세요. 최대 10건을 반환하고 모든 결과가 두 조건을 만족하는지 확인하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "category", "in_stock"],
  "query": {
    "bool": {
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } }
      ]
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 1065
- 기대 문서 ID·이유: `P-00009`(category="전자기기", in_stock=true — 두 조건 모두 정확히 만족)
- 제외 문서 ID·이유: `P-00003`(category="패션"이라 category 조건 불일치, 문제 1 결과에서 확인된 문서) — category가 다르므로 이번 결과에는 나타나지 않아야 한다.
- 확인한 모든 문서가 조건을 통과했는가: 예. 상위 10건을 코드로 검증(`category=="전자기기" and in_stock==true`)한 결과 전부 `true`였다.

## (공통) 문제 3 — 의도한 0건 직접 구현

실제 `products` index와 실제 `product_id` field를 사용하되, 데이터에 존재하지 않는 값 `__DAY03_INTENTIONAL_ZERO__`를 검색해 정상적인 0건 요청을 구현하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "query": { "term": { "product_id": "__DAY03_INTENTIONAL_ZERO__" } }
}
```

### 결과 입력

- HTTP 성공 여부: 200 OK, 성공(오류 없음)
- `hits.total.value`: 0
- index·field가 실제 존재한다는 근거: `GET /products/_mapping`으로 `product_id` field가 `type: keyword`로 정의돼 있음을 확인했고, 같은 index에서 `match_all`은 10000건을 정상 반환한다.
- 값만 존재하지 않는다는 근거: `product_id`는 실제 데이터가 `P-00001`~`P-10000` 형식이라 `__DAY03_INTENTIONAL_ZERO__`라는 값 자체가 애초에 생성되지 않았다. mapping·field는 유효하고 검색 값만 데이터에 없는 경우다.
- 오류 0건과 정상 0건의 차이: 오류 0건은 응답에 `error`/`status`가 포함되거나(예: 존재하지 않는 index·field 조회 시 `index_not_found_exception`) HTTP 4xx/5xx가 반환되는 경우이고, 정상 0건은 이번처럼 요청이 200 OK로 성공하고 `error` 없이 `hits.total.value`만 0으로 나오는 경우다.

## (개인) 문제 4 — 자기 질문 3개 품질 점검

자기 PBL의 전문 검색, 정확 조건, bool/filter 질문을 각각 실행하고 기대 문서와 제외 문서를 판정하세요.

### 역할·검증 기준

- 질문마다 독립된 요청 ID를 사용합니다.
- 실행 전에 기대·제외 기준을 적습니다.
- 상위 3개를 실제 `_source`로 평가합니다.

### 결과 입력

| 질문 | 요청 ID | 기대 ID | 제외 ID | 상위 3개 | 판정·근거 |
|---|---|---|---|---|---|
| 전문 검색 | AD-Q-FULLTEXT | `review_summary`에 "저음"·"운동용" 리뷰가 있는 문서(예: `AD-00003`) | — | 없음 | 실패(0건). 기대와 달리 `hits.total.value`=0. 문제 5에서 원인 진단. |
| 정확 조건 | AD-Q-EXACT | `brand`="Sony"인 문서(예: `AD-00005`) | `brand`="Bose"·"Apple" 등 다른 브랜드 문서 | `AD-00005`, `AD-00007`, `AD-00014` | 통과. 1314건 모두 `brand`="Sony"였고 상위 3건도 실제 값으로 확인됨. |
| bool/filter | AD-Q-BOOLFILTER | category="이어폰", connection="무선", price≤100000, 리뷰에 "노이즈" 포함 문서(예: `AD-00370`) | `AD-00001`(connection=유선, price 초과, 리뷰에 노이즈 언급 없음) | `AD-00370`, `AD-00475`, `AD-01036` | 통과. 42건 모두 세 filter와 must 조건을 만족했고, 기대했던 `AD-00001` 제외도 확인됨. |

## (개인) 문제 5 — 실패 원인 진단

개인 문제 4에서 실패·보류 또는 개선 여지가 있는 결과 하나를 선택해 원인을 진단하세요.

### 역할·검증 기준

- mapping / analyzer / query / filter / sort / data 중 1차 원인을 선택합니다.
- 실제 mapping·문서·응답 근거를 하나 이상 첨부합니다.
- 아직 요청을 고치지 말고 원인과 다음 실험을 분리합니다.

### 진단 입력

- 문제: `GET /audio-devices-search/_search {"query":{"match":{"review_summary":"저음 운동용"}}}`이 실제로는 "저음이 강조되고 운동용으로 딱입니다."라는 리뷰 문서가 존재하는데도 `hits.total.value`=0으로 실패했다.
- 1차 원인: analyzer. `review_summary`는 mapping에서 별도 analyzer를 지정하지 않아 기본 `standard` analyzer를 사용하는데, 이 analyzer는 한국어 조사를 분리하지 못하고 공백 단위로만 토큰을 나눈다.
- 확인한 실제 근거: `POST /audio-devices-search/_analyze {"field":"review_summary","text":"저음이 강조되고 운동용으로 딱입니다."}` 결과 토큰이 `["저음이","강조되고","운동용으로","딱입니다"]`로 나왔다. 반면 검색어 "저음 운동용"을 분석하면 `["저음","운동용"]`이 되어, 저장된 토큰("저음이", "운동용으로")과 글자 단위로 전혀 일치하지 않았다.
- 다음에 바꿀 한 요소: `review_summary`에 형태소 분석이 가능한 analyzer(예: Nori)를 적용하거나, 검색어를 실제 저장 형태("저음이", "운동용으로")에 맞춰 조정하는 실험을 다음 교시에서 진행한다.
- 새 Console 재현 여부: 예. 새 Console에서 `_analyze` 요청과 원래 `match` 요청을 다시 실행해 동일한 결과(0건, 불일치 토큰)를 재현했다.
