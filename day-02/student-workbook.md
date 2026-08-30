# ES 5일 PBL — Day 2 학생교재

- 주제: 데이터 모델링과 적재
- 공통 실습: 쇼핑몰 검색 / ES·Kibana 9.5.0 / 공통 index: `products`
- 이 교재는 PPT와 같은 토픽 ID·실습 흐름을 사용합니다. 교시별 시간과 강사용 발화는 포함하지 않습니다.
- **중요:** 강사는 쇼핑몰 예제로 시연하지만, 여러분은 선택한 도메인의 PBL을 완성합니다. 공통 예제를 그대로 제출하지 마세요.

## 검색 요구와 오늘의 데이터 설계

어제 정한 검색 질문과 조건은 오늘 document·field·mapping이 됩니다. ES는 검색 요구를 구현하는 도구이므로, 어떤 결과를 찾아야 하는지 먼저 정하지 않으면 어떤 field와 type이 필요한지도 결정할 수 없습니다.

## 오늘의 완료 기준

- 학생이 cluster는 함께 동작하는 node 집합이며, index는 같은 목적 문서의 논리적 묶음입니다.
- 학생이 데이터 모델링은 검색 결과에 보여 줄 대상 하나를 document로 정하고, 그 속성을 field로 분해하는 일입니다.
- 학생이 mapping은 field 이름과 type을 미리 정해 검색·filter·sort·aggregation의 규칙을 고정합니다.
- 학생이 settings는 index 동작 기준, mappings는 field schema입니다.
- 학생이 analyzer는 text를 검색 가능한 token으로 바꾸며 character filter, tokenizer, token filter 흐름으로 봅니다.
- 학생이 CRUD는 document 한 건을 PUT으로 생성, GET으로 조회, POST /products/_update로 일부 수정, DELETE로 삭제하는 작업입니다.
- 학생이 더미 데이터는 검색·filter·sort·aggregation을 모두 검증할 분포를 먼저 정한 뒤 seed 기반으로 생성합니다.
- 학생이 ingest pipeline은 색인 전에 문서를 변환하는 서버 측 처리 체인입니다.

## 오늘 사용할 파일

- `data/requests/01-create-products.http`
- `data/requests/02-verify-products.http`
- `requests/03-analyze-and-crud.http`
- `data/load-products.ps1`
- `DAY_02_PRACTICE_AND_EVIDENCE_GUIDE.md` — PPT 기준 Day 2 실습 중단 지점·개인 저장소 기록 파일·확인 기준

## 목차

- T09 심화 ES 구조·Console
- T10 데이터 모델링
- T11 mapping과 field 유형
- T12 index 생성과 settings
- T13 텍스트 분석과 analyzer
- T14 문서 CRUD
- T15 더미 데이터와 Bulk 적재
- T16 ingest pipeline 기초

## T09 심화 ES 구조·Console

- 학생교재 위치: §9 ES 구조·Console

### 학습 목표

- 학생이 cluster는 함께 동작하는 node 집합이며, index는 같은 목적 문서의 논리적 묶음입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

products는 상품 한 건이 아니라 상품 document를 담는 index입니다.

**주의:** CAT API는 사람의 상태 점검용 표이고 애플리케이션 연동은 JSON API가 기본이라는 점을 구분합니다.

### PPT와 연결되는 학습 포인트

1. **어제 접속한 3 node는 하나의 cluster로 동작합니다.** — 어제 접속한 3 node는 하나의 cluster로 동작합니다. · cluster-node-index-document 계층도
2. **index는 같은 목적 문서의 논리적 묶음입니다.** — index는 같은 목적 문서의 논리적 묶음입니다. · products 상자
3. **document는 JSON 한 건, field는 그 안의 속성입니다.** — document는 JSON 한 건, field는 그 안의 속성입니다. · P-0001 JSON
4. **CAT API는 사람이 빠르게 상태를 읽는 표입니다.** — CAT API는 사람이 빠르게 상태를 읽는 표입니다. · Console 표
5. **노드 확인** — 노드 확인
6. **index 목록 확인** — index 목록 확인
7. **내 PBL 이름 정하기** — 내 PBL 이름 정하기
8. **GET** — GET · {index} · _mapping은 schema를 확인한다.
9. **Day 2 데이터 흐름** — Day 2 데이터 흐름

#### PPT 원문 확인

- S01: `어제 접속한 3 node는 하나의 cluster로 동작합니다. / cluster-node-index-document 계층도`
- S02: `index는 같은 목적 문서의 논리적 묶음입니다. / products 상자`
- S03: `document는 JSON 한 건, field는 그 안의 속성입니다. / P-0001 JSON`
- S04: `CAT API는 사람이 빠르게 상태를 읽는 표입니다. / Console 표`
- S08: `GET /{index}/_mapping은 schema를 확인한다.`

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 cluster는 함께 동작하는 node 집합이며, index는 같은 목적 문서의 논리적 묶음입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/elasticsearch/rest-apis)

---

## T10 데이터 모델링

- 학생교재 위치: §10 데이터 모델링

### 학습 목표

- 학생이 데이터 모델링은 검색 결과에 보여 줄 대상 하나를 document로 정하고, 그 속성을 field로 분해하는 일입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

대표 document 3건을 먼저 쓰면 field 이름과 값의 형태를 과하게 추상화하는 실수를 줄일 수 있습니다.

**주의:** 한 field에 여러 의미를 섞거나 화면 요구와 무관한 내부 정보를 먼저 넣지 않게 합니다.

### PPT와 연결되는 학습 포인트

1. **문서 하나는 검색 결과 목록의 대상 하나입니다.** — 문서 하나는 검색 결과 목록의 대상 하나입니다.
2. **검색 질문에서 field를 찾는다** — 검색 질문에서 field를 찾는다
3. **표시용 field와 검색용 field를 구분한다** — 표시용 field와 검색용 field를 구분한다
4. **배열과 객체** — 배열과 객체
5. **개인정보 제외** — 개인정보 제외
6. **대표 문서 3건 작성** — 대표 문서 3건 작성
7. **field 목적 표** — field 목적 표
8. **짝 검토** — 짝 검토

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

이 토픽은 명령 실행보다 내 PBL의 설계 문장을 구체화하는 활동입니다.

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 데이터 모델링은 검색 결과에 보여 줄 대상 하나를 document로 정하고, 그 속성을 field로 분해하는 일입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/manage-data/data-store/mapping)

---

## T11 mapping과 field 유형

- 학생교재 위치: §11 mapping과 field

### 학습 목표

- 학생이 mapping은 field 이름과 type을 미리 정해 검색·filter·sort·aggregation의 규칙을 고정합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

text는 분석된 문장 검색, keyword는 정확 비교·집계·정렬, integer·float·boolean·date는 값 성격에 맞게 씁니다.

**주의:** text와 keyword를 둘 중 하나만 고르는 절대 규칙으로 말하지 않고 field 목적에 따라 판단합니다.

### PPT와 연결되는 학습 포인트

1. **mapping은 field 이름과 type을 미리 정하는 schema입니다.** — mapping은 field 이름과 type을 미리 정하는 schema입니다.
2. **text: 분석 후 전문 검색** — text: 분석 후 전문 검색
3. **keyword: 원값 비교·집계·정렬** — keyword: 원값 비교·집계·정렬
4. **숫자·boolean·date** — 숫자·boolean·date
5. **다중 field** — 다중 field
6. **공통 mapping 읽기** — 공통 mapping 읽기
7. **내 mapping 초안** — 내 mapping 초안
8. **설계 점검** — 설계 점검

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 mapping은 field 이름과 type을 미리 정해 검색·filter·sort·aggregation의 규칙을 고정합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/manage-data/data-store/mapping)

---

## T12 index 생성과 settings

- 학생교재 위치: §12 index 생성

### 학습 목표

- 학생이 settings는 index 동작 기준, mappings는 field schema입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

공통 products는 3 primary shard, 1 replica와 명시적 mapping으로 생성하고 GET으로 확인합니다.

**주의:** 생성한 index 이름과 이후 CRUD·Search API에서 쓸 이름을 반드시 products로 통일합니다.

### PPT와 연결되는 학습 포인트

1. **settings는 index 동작, mappings는 field schema입니다.** — settings는 index 동작, mappings는 field schema입니다.
2. **공통 products의 설정** — 공통 products의 설정
3. **생성 요청 읽기** — 생성 요청 읽기
4. **공통 생성 시연** — 공통 생성 시연
5. **개인 index 생성** — 개인 index 생성
6. **GET으로 검증** — GET으로 검증
7. **shard 관찰** — shard 관찰
8. **오류 처리** — 오류 처리

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
PUT /products
{ "settings": { "number_of_shards": 3, "number_of_replicas": 1 }, "mappings": { "properties": { "product_id": { "type": "keyword" }, "name": { "type": "text" }, "category": { "type": "keyword" }, "price": { "type": "integer" }, "in_stock": { "type": "boolean" } } } }

GET /products/_mapping
GET /_cat/shards/products?v
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

`resource_already_exists_exception`은 같은 index가 이미 존재한다는 뜻입니다. 먼저 GET으로 상태를 확인하고 개인 PBL index와 공통 `products`를 혼동하지 않습니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 settings는 index 동작 기준, mappings는 field schema입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create)

---

## T13 텍스트 분석과 analyzer

- 학생교재 위치: §13 analyzer

### 학습 목표

- 학생이 analyzer는 text를 검색 가능한 token으로 바꾸며 character filter, tokenizer, token filter 흐름으로 봅니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

_analyze 응답의 tokens 배열에서 token과 position을 확인하고, mapping type 설명과 analyzer 결과를 섞지 않습니다.

**주의:** 분석 결과 하나만 보고 검색 품질 전체를 단정하지 않습니다.

### PPT와 연결되는 학습 포인트

1. **analyzer는 text를 비교 가능한 token으로 바꿉니다.** — analyzer는 text를 비교 가능한 token으로 바꿉니다.
2. **character filter → tokenizer → token filter** — character filter → tokenizer → token filter
3. **공통 analyzer** — 공통 analyzer
4. **_analyze 요청** — _analyze 요청
5. **공통 실행** — 공통 실행
6. **내 검색어 실행** — 내 검색어 실행
7. **text** — text · keyword 대비
8. **T17 연결** — T17 연결

#### PPT 원문 확인

- S07: `text/keyword 대비`

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습

```http
POST /products/_analyze
{ "field": "name", "text": "무선 노이즈 캔슬링 이어폰" }
```

#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 analyzer는 text를 검색 가능한 token으로 바꾸며 character filter, tokenizer, token filter 흐름으로 봅니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/text-analysis)

---

## T14 문서 CRUD

- 학생교재 위치: §14 CRUD

### 학습 목표

- 학생이 CRUD는 document 한 건을 PUT으로 생성, GET으로 조회, POST /products/_update로 일부 수정, DELETE로 삭제하는 작업입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

각 요청 뒤 result와 found 또는 _source를 확인해야 요청 성공과 데이터 상태를 분리할 수 있습니다.

**주의:** PUT 전체 교체와 POST _update 부분 수정의 차이를 명확히 말합니다.

### PPT와 연결되는 학습 포인트

1. **CRUD는 문서의 생성·조회·수정·삭제입니다.** — CRUD는 문서의 생성·조회·수정·삭제입니다.
2. **PUT** — PUT · index · _doc · id
3. **POST** — POST · index · _update · id
4. **C·R 시연** — C·R 시연
5. **U 시연** — U 시연
6. **D 시연** — D 시연
7. **학생 실행** — 학생 실행
8. **정리 검증** — 정리 검증

#### PPT 원문 확인

- S02: `PUT /index/_doc/id`
- S03: `POST /index/_update/id`

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 CRUD는 document 한 건을 PUT으로 생성, GET으로 조회, POST /products/_update로 일부 수정, DELETE로 삭제하는 작업입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/reference/elasticsearch/rest-apis)

---

## T15 더미 데이터와 Bulk 적재

- 학생교재 위치: §15 Bulk와 더미 데이터

### 학습 목표

- 학생이 더미 데이터는 검색·filter·sort·aggregation을 모두 검증할 분포를 먼저 정한 뒤 seed 기반으로 생성합니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

Bulk NDJSON은 action 줄과 source 줄을 한 쌍으로 두며 마지막 줄바꿈을 유지합니다.

**주의:** 적재 수만 맞추지 말고 errors false, count, category 분포를 함께 확인합니다.

### PPT와 연결되는 학습 포인트

1. **대량 더미 데이터는 질문을 검증할 분포를 먼저 설계합니다.** — 대량 더미 데이터는 질문을 검증할 분포를 먼저 설계합니다.
2. **생성 규칙과 seed** — 생성 규칙과 seed
3. **Bulk NDJSON** — Bulk NDJSON
4. **공통 파일 구조** — 공통 파일 구조
5. **생성·적재 시연** — 생성·적재 시연
6. **count·분포 검증** — count·분포 검증
7. **내 PBL 계획** — 내 PBL 계획
8. **실패 읽기** — 실패 읽기

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 강사 배포 저장소의 `day-02/pbl-data-template/` 전체를 내 개인 PBL 저장소의 `data/pbl-data-template/`로 복사합니다. 예: `Copy-Item -Recurse "강사 저장소\day-02\pbl-data-template" "내 PBL 저장소\data\"`. 이후에는 개인 저장소의 복사본에서만 작업합니다.
3. PowerShell에서 `내 PBL 저장소/data/pbl-data-template/`로 이동한 뒤, 메모장으로 `my-data-settings.ps1`의 값 목록·범위·seed·field 규칙을 내 주제에 맞게 바꿉니다. NDJSON을 직접 작성하지 않습니다.
4. `generator/generate-data.ps1 -SettingsFile .\my-data-settings.ps1`로 NDJSON을 생성하고, Kibana Dev Tools에서 내 mapping을 먼저 만듭니다.
5. `load-data.ps1 -SettingsFile .\my-data-settings.ps1 -DockerDirectory "강사 배포 저장소/day-01/docker 폴더 경로"`로 Bulk 적재한 뒤 `requests/verify-data-template.http`의 count·분포 요청을 내 field로 바꾸어 실행합니다.
6. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- Bulk 응답의 `errors`가 `false`이고 적재 건수와 분포가 계획과 맞습니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.
- 전체 NDJSON 대신 생성 설정, 생성기, 30건 표본, 생성 요약과 검증 evidence를 제출합니다.

### 오류 해결 팁

NDJSON은 action 줄과 source 줄이 한 쌍입니다. `errors: true`이면 실패 item의 error를 먼저 확인하며, 마지막 줄바꿈도 유지합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 더미 데이터는 검색·filter·sort·aggregation을 모두 검증할 분포를 먼저 정한 뒤 seed 기반으로 생성합니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)

---

## T16 ingest pipeline 기초

- 학생교재 위치: §16 ingest pipeline

### 학습 목표

- 학생이 ingest pipeline은 색인 전에 문서를 변환하는 서버 측 처리 체인입니다.
- 쇼핑몰 예제를 내 도메인의 문서·field·검색 질문으로 바꾼다.

### 핵심 개념

_simulate로 processor 결과를 먼저 보고, pipeline 적용은 선택 기능이며 원본 field 의미를 훼손하지 않습니다.

**주의:** pipeline을 mapping이나 analyzer의 대체물로 설명하지 않습니다.

### PPT와 연결되는 학습 포인트

1. **pipeline은 색인 전 문서를 변환하는 서버 측 처리입니다.** — pipeline은 색인 전 문서를 변환하는 서버 측 처리입니다.
2. **processor 예** — processor 예
3. **pipeline 정의** — pipeline 정의
4. **_simulate** — _simulate
5. **공통 simulate** — 공통 simulate
6. **적용 판단** — 적용 판단
7. **선택 구현** — 선택 구현
8. **Day 2 commit** — Day 2 commit

### 쇼핑몰 데이터 예제

공통 index는 `products`입니다. 상품 문서의 `name`, `description`, `category`, `price`, `rating`, `in_stock`는 역할을 보여 주는 예시입니다. 내 PBL에서는 같은 이름을 복사하지 말고, 예를 들어 도서 검색의 `title`·`genre`·`available`처럼 같은 역할의 field로 대응합니다.

### 개념 실습



#### 진행 순서

1. 공통 쇼핑몰 예제를 먼저 실행하거나 화면에서 확인합니다.
2. 예상 결과를 확인한 뒤, 내 PBL에서 같은 역할을 할 field·값·질문을 정합니다.
3. 내 저장소의 README, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 중 알맞은 파일에 결과를 남깁니다.

#### 예상 결과·확인 기준

- 요청 또는 화면에서 핵심 field·문서·차트가 질문에 맞는지 한 문장으로 설명합니다.
- 결과 수만 보지 말고, 왜 그 결과가 나왔는지 field와 조건을 근거로 설명합니다.

### 오류 해결 팁

결과가 다르면 화면을 닫지 말고 method, path, field 이름, 값의 type, 응답의 error/message를 순서대로 확인합니다.

### 내 PBL 반영

- 내 주제에서 이 토픽과 같은 역할을 하는 문서·field·질문:
- 공통 예제를 내 데이터로 바꿀 때 변경할 값 또는 명령:
- 예상 결과와 실패했을 때 점검할 항목:
- 저장할 파일 경로:

### 복습 체크

- [ ] 학생이 ingest pipeline은 색인 전에 문서를 변환하는 서버 측 처리 체인입니다.
- [ ] 쇼핑몰 예제를 내 도메인에 맞게 한 항목 이상 바꾸었다.
- [ ] 결과 또는 설계 근거를 저장소에 남겼다.
- [ ] 다음 토픽에서 사용할 질문 또는 field를 정리했다.

### 공식 문서

- [Elastic 공식 문서](https://www.elastic.co/docs/manage-data/ingest/transform-enrich/ingest-pipelines)
