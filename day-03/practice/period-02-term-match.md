# 2교시 실습 — term과 match

## (공통) 문제 1 — 제공 코드로 정확 조건 확인

```http
GET /products/_search
{
  "size": 5,
  "query": { "term": { "category": "전자기기" } }
}
```

### 결과 입력

- `hits.total.value`: 1250
- 상위 3개 문서 ID: `P-00009`, `P-00025`, `P-00081`
- 상위 3개 문서의 category: 전자기기, 전자기기, 전자기기
- 모든 확인 문서가 정확 조건을 만족하는가: 예. 상위 5건 모두 `category`가 정확히 "전자기기"였다.
- `term`을 선택한 mapping 근거: `category`는 `product-mapping.json`에서 `type: keyword`로 정의되어 있어 분석기를 거치지 않고 원본 문자열 그대로 저장된다. 따라서 `term`으로 값 전체를 정확히 비교해야 한다.

## (공통) 문제 2 — text 전문 검색 직접 구현

`products` index에서 상품명 `name`에 `무선`이라는 검색 의도가 있는 문서를 찾으세요. text 전문 검색에 적합한 query를 선택해 최대 5건을 반환하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "query": { "match": { "name": "무선" } }
}
```

### 결과 입력

- 선택한 query와 이유: `match`. `name`은 `type: text`이고 `korean_search` analyzer로 분석되므로, 검색어도 같은 analyzer로 분석해 토큰 단위로 비교하는 `match`가 적합하다.
- `hits.total.value`: 505
- 상위 3개 ID·name: `P-00025`(MobiCore 컴팩트 무선 이어폰), `P-00042`(CleanMate 실속형 무선 청소기), `P-00129`(Auralis 스마트 무선 이어폰)

## (공통) 문제 3 — 부적절한 조합 비교

같은 `name` field와 `무선` 검색어에 `term` query를 사용한 API를 직접 작성하세요. 문제 2와 결과를 비교하고, 차이를 mapping 또는 분석된 token 관점에서 설명하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "query": { "term": { "name": "무선" } }
}
```

### 비교 결과

- 문제 2 total / 문제 3 total: 505 / 505 (전체 ID 505건을 모두 비교해도 두 결과 집합이 완전히 동일했다)
- 공통으로 나온 문서 ID: 505건 전체가 공통이다 (예: `P-00025`, `P-00042`, `P-00129` 등 상위 3건도 동일).
- 달라진 이유: 이번 경우는 결과가 달라지지 않았다. `name`은 `korean_search`(standard tokenizer, 공백·구두점 기준 분리)로 분석되는데, "무선"이 원문에서 다른 단어와 공백으로 분리되어 있어 분석 후에도 정확히 "무선"이라는 토큰으로 저장된다. `term`은 검색어를 분석하지 않고 원본 문자열 그대로 역색인 토큰과 비교하는데, 마침 입력한 "무선"이 그 토큰과 글자 그대로 일치해 `match`와 같은 결과가 나왔다.
- `term`은 text에서 항상 0건인가? 실제 근거: 아니오. 이번 요청에서 `hits.total.value`가 505건으로 0건이 아니었다. `term`은 분석을 건너뛰고 원본 값을 그대로 비교할 뿐이므로, 검색어가 우연히 저장된 토큰과 완전히 같으면(대소문자·공백·형태가 모두 일치) 정상적으로 매칭될 수 있다. 다만 대소문자가 다르거나 띄어쓰기가 섞인 문장을 넣으면 토큰과 불일치해 0건이 될 가능성이 높으므로 text field에 `term`을 쓰는 것은 여전히 신뢰할 수 없는 방법이다.

## (개인) 문제 4 — 자기 정확 조건 검색

자기 mapping에서 값 전체가 정확히 일치해야 하는 `keyword` 또는 `boolean` field 하나를 선택해 정확 조건 검색을 구현하세요.

### 역할·검증 기준

- 실제 존재하는 field와 값을 사용합니다.
- 반환 문서의 `_source`에서 조건을 직접 확인합니다.
- 왜 전문 검색이 아니라 정확 비교인지 설명합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": { "term": { "connection": "완전무선" } }
}
```

- field / type / 값: `connection` / `keyword` / `"완전무선"`
- 사용자 질문: 케이블 없이 완전히 무선으로 쓸 수 있는 제품만 보고 싶다
- 상위 3개 ID와 실제 값: `AD-00010`(완전무선), `AD-00019`(완전무선), `AD-00025`(완전무선)
- 통과/실패와 근거: 통과. `hits.total.value`가 1091이고 확인한 상위 5건 모두 `connection` 값이 정확히 "완전무선"이었다. `connection`은 `keyword` type이라 "무선"·"유선"·"완전무선"처럼 값이 비슷해 보여도 부분 일치가 아닌 값 전체 일치가 필요하므로 전문 검색이 아닌 `term`이 맞는 선택이다.

## (개인) 문제 5 — 자기 전문 검색

자기 mapping의 `text` field 하나와 사용자가 입력할 검색어를 정해 전문 검색 API를 구현하세요.

### 역할·검증 기준

- field가 실제 `text`인지 mapping으로 확인합니다.
- 상위 3개 결과를 관련/보류/무관으로 판정합니다.
- 정확 조건 문제와 query 선택 이유가 달라야 합니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": { "match": { "review_summary": "노이즈 캔슬링" } }
}
```

- field / type / 검색어: `review_summary` / `text` / "노이즈 캔슬링"
- 상위 3개 ID: `AD-00017`, `AD-00023`, `AD-00052`
- 관련/보류/무관과 이유: 관련. 세 문서 모두 `review_summary`가 "노이즈 캔슬링이 완벽해서 작업할 때 좋아요."로, 검색 의도(노이즈 캔슬링 성능 후기)와 그대로 일치한다.
- 완료 판정: 통과. `hits.total.value` 1444건 중 상위 결과가 모두 검색 의도와 직접 연결되는 리뷰였고, 문제 4(정확 조건 `term`)와 달리 이번엔 문장 속 키워드를 분석해 찾는 전문 검색이라는 점에서 query 선택 이유가 달랐다.
