# 8교시 실습 — 통합·개선·제출

## (공통) 문제 1 — 제공 코드로 통합 검색 검증

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "description", "category", "price", "rating", "in_stock"],
  "query": {
    "bool": {
      "must": [{
        "multi_match": {
          "query": "무선 이어폰",
          "fields": ["name^3", "description"]
        }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }],
  "highlight": { "fields": { "name": {}, "description": {} } }
}
```

### 결과 입력

- `hits.total.value`: 74
- 상위 3개 ID: `P-08761`, `P-06457`, `P-09025`
- 세 filter 통과 여부: 통과. 세 문서 모두 category="전자기기", in_stock=true, price가 51300~184900원(50000~200000 범위 안)이었다.
- 1·2차 정렬 통과 여부: 통과. rating이 5, 5, 4.9로 내림차순이었고, rating이 5로 동률인 `P-08761`(107200원)과 `P-06457`(184900원)은 price 오름차순으로 정렬돼 2차 정렬도 확인됐다.
- highlight 확인 결과: 세 문서 모두 `name`에 `<em>무선</em> <em>이어폰</em>` highlight가 생성됐다(`description` highlight는 없음 — description에 해당 단어가 없기 때문).
- 관련/보류/무관 판정: 관련. 세 문서 모두 "전자기기 카테고리의 재고 있는 무선 이어폰, 5만~20만원, 평점 높은 순"이라는 통합 조건과 사용자 의도에 정확히 부합했다.

## (공통) 문제 2 — boost 개선 전후 직접 구현

`name`, `description`에서 `무선 이어폰`을 검색하는 boost 없는 요청과 `name^3` 요청을 각각 작성하세요. 다른 조건은 동일하게 유지하세요.

### 개선 전 API

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name"],
  "query": {
    "bool": {
      "must": [{
        "multi_match": { "query": "무선 이어폰", "fields": ["name", "description"] }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }]
}
```

### 개선 후 API

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name"],
  "query": {
    "bool": {
      "must": [{
        "multi_match": { "query": "무선 이어폰", "fields": ["name^3", "description"] }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }]
}
```

### 비교 결과

- 전/후 상위 3개 ID: 전 `P-08761`, `P-06457`, `P-09025` / 후 `P-08761`, `P-06457`, `P-09025` (동일)
- 순위가 달라진 문서: 없음.
- 개선/보류/악화: 보류(순위 기준으로는 변화 없음).
- 사용자 의도 근거: 이 요청에는 `sort`(rating desc, price asc)가 명시돼 있어 최종 노출 순서가 `_score`가 아니라 `sort` 조건으로 결정된다. `name^3` boost는 `_score`만 바꿀 뿐 정렬 기준이 아니므로 실제 노출 순서에는 영향을 주지 못했다. boost가 의미를 가지려면 이 요청처럼 `sort`가 있는 화면이 아니라 관련도(`_score`) 순으로 정렬하는 화면에 적용해야 한다는 것을 확인했다.

## (공통) 문제 3 — 요구사항으로 최종 API 직접 구현

다음 요구사항만 보고 실행 가능한 Search API 전체를 작성하세요.

- index: `products`
- 검색어: `무선 이어폰`
- 검색 field: `name`, `description`; name을 더 중요하게 처리
- category: `전자기기`
- 재고 있는 상품만 포함
- 가격: 50,000원 이상 200,000원 이하
- 평점 높은 순, 가격 낮은 순
- 최대 10건
- 결과 카드 field와 검색어 highlight 포함

### API 전체 입력

```http
GET /products/_search
{
  "size": 10,
  "_source": ["product_id", "name", "description", "category", "price", "rating", "in_stock"],
  "query": {
    "bool": {
      "must": [{
        "multi_match": {
          "query": "무선 이어폰",
          "fields": ["name^3", "description"]
        }
      }],
      "filter": [
        { "term": { "category": "전자기기" } },
        { "term": { "in_stock": true } },
        { "range": { "price": { "gte": 50000, "lte": 200000 } } }
      ]
    }
  },
  "sort": [{ "rating": "desc" }, { "price": "asc" }],
  "highlight": { "fields": { "name": {}, "description": {} } }
}
```

### 검증 결과

- 문제 1과 기능적으로 같은 조건인가: 예.
- 다른 부분이 있다면 이유: 없음. 요구사항을 그대로 구현한 결과 문제 1의 API와 완전히 동일한 구조가 됐다.
- 실제 실행 성공 여부: 성공. `hits.total.value`=74로 문제 1과 동일했다.
- 상위 결과 검증: 상위 3개 ID가 `P-08761`, `P-06457`, `P-09025`로 문제 1과 정확히 일치해 요구사항 기반 API가 올바르게 작성됐음을 확인했다.

## (개인) 문제 4 — 자기 검색 한 요소 개선

7교시에서 진단한 개인 검색 문제 하나를 선택해 query, field, boost, filter, sort, 검색어 중 한 요소만 변경하고 다시 실행하세요.

### 역할·검증 기준

- 같은 index·데이터·검색어·size를 유지합니다. 검색어를 바꾸는 실험이라면 나머지 요소를 유지합니다.
- 변경 전후 요청을 모두 보존합니다.
- hit 수가 아니라 사용자 의도와 조건 통과로 개선을 판정합니다.

### API와 결과 입력

```http
# 개선 전 (7교시 개인 문제 4 전문 검색, 0건 실패)
GET /audio-devices-search/_search
{
  "size": 3,
  "query": { "match": { "review_summary": "저음 운동용" } }
}

# 개선 후 — 검색어를 실제 저장된 토큰 형태(조사 포함)에 맞춰 변경
GET /audio-devices-search/_search
{
  "size": 3,
  "query": { "match": { "review_summary": "저음이 강조되고 운동용으로" } }
}
```

- 문제 / 추정 원인: 7교시에서 진단한 `AD-Q-FULLTEXT` 요청이 0건이었던 문제. 1차 원인은 analyzer — `review_summary`가 기본 `standard` analyzer를 사용해 "저음이", "운동용으로"처럼 조사가 붙은 채로 토큰화되므로, 조사를 뗀 검색어 "저음 운동용"과 글자 단위로 일치하지 않았다.
- 변경한 한 요소: 검색어 — "저음 운동용" → "저음이 강조되고 운동용으로" (index·field·query 종류·filter·sort는 그대로 유지)
- 전/후 상위 3개: 전 없음(0건) / 후 `AD-00003`, `AD-00004`, `AD-00005`
- 개선/보류/악화와 근거: 개선. `hits.total.value`가 0 → 1480으로 바뀌어 실제로 검색이 됐다. 다만 이는 근본적인 analyzer 문제를 검색어를 저장 형태에 맞춰 우회한 것이라, 사용자가 자유롭게 입력하는 검색어까지 대응하려면 다음 단계에서 한국어 형태소 analyzer(Nori) 적용을 검토해야 한다.

## (개인) 문제 5 — 최종 재현·산출물 완성

자기 전문 검색·정확 조건·bool/filter 요청을 새 Console에서 다시 실행하고 다른 사람이 commit만으로 재현할 수 있게 정리하세요.

### 역할·검증 기준

- 루트 `requests.http`에 `V1-T17-P`~`V1-T21-P`를 정리합니다.
- `docs/quality-test.md`에 질문별 기대·실제·개선 근거를 작성합니다.
- `evidence/day-03-search.md`에 핵심 결과와 commit SHA를 기록합니다.

### 최종 입력

- 새 Console 재현 성공 여부: 예. 세 요청을 다시 실행해 동일한 결과(1480건 / 1314건 / 42건)를 확인했다.
- 전문 검색 요청 ID: `V1-T18-2-P` (`AD-Q-FULLTEXT`, 개선 후 검색어 "저음이 강조되고 운동용으로" 사용)
- 정확 조건 요청 ID: `V1-T18-1-P` (`AD-Q-EXACT`, `brand="Sony"` term 검색)
- bool/filter 요청 ID: `V1-T19-2-P` (`AD-Q-BOOLFILTER`, category+connection+price+review_summary 조합)
- 품질표 경로: `docs/quality-test.md` (개인 저장소에 복사 후 이번 결과로 작성 예정)
- evidence 경로: `evidence/day-03-search.md`
- 최종 commit SHA: 미완료 — 이번 실습 결과는 아직 개인 PBL 저장소에 commit되지 않았다. commit 후 SHA를 여기에 채운다.
- 미완료 또는 재현 실패 항목: `docs/quality-test.md`·`evidence/day-03-search.md`·루트 `requests.http`에 위 요청 ID로 옮겨 적는 작업과 최종 commit이 남아 있다. 전문 검색은 근본 원인(analyzer)을 아직 해결하지 못하고 검색어를 저장 형태에 맞춰 우회한 상태이므로, Day 4 이전에 analyzer 개선 여부를 결정해야 한다.
