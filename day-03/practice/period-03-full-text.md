# 3교시 실습 — 전문 검색 확장

## (공통) 문제 1 — 제공 코드로 여러 field 검색

```http
GET /products/_search
{
  "size": 5,
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name", "description"]
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 505
- 상위 3개 ID·name: `P-00241`(SoundLab 프리미엄 무선 이어폰), `P-00305`(Auralis 실속형 무선 이어폰), `P-00529`(NeoTech 스마트 무선 이어폰)
- 각 문서가 name·description 중 어디에서 의도와 연결되는가: 세 문서 모두 `name`에 "무선"과 "이어폰"이 그대로 포함되어 있어 검색 의도와 직접 연결된다. `description`은 "전자기기 상품입니다..."류의 공통 문구만 있어 실제 매칭 기여가 거의 없다.
- 상위 3개 관련/보류/무관 판정: 관련, 관련, 관련 — 세 문서 모두 "무선 이어폰" 그 자체를 판매하는 상품이다.



## (공통) 문제 2 — field boost 직접 구현

문제 1과 같은 조건을 유지하되 `name` 일치를 `description`보다 3배 중요하게 보는 Search API를 작성하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "query": {
    "multi_match": {
      "query": "무선 이어폰",
      "fields": ["name^3", "description"]
    }
  }
}
```

### 비교 결과

- 변경 전 상위 3개 ID: `P-00241`, `P-00305`, `P-00529` (`_score` 6.7587247)
- 변경 후 상위 3개 ID: `P-00241`, `P-00305`, `P-00529` (`_score` 20.276176, 정확히 3배)
- 순위가 달라진 문서와 이유: 없음. 상위 문서들이 모두 `name`에서만 "무선"·"이어폰" 토큰과 매칭되고 `description`에는 해당 단어가 없어 boost 전후 모두 `_score`만 3배로 커졌을 뿐 문서 간 상대 순위는 그대로였다.
- boost가 사용자 의도에 유리했는가: 이번 상위 5건에는 순위 변화가 없었지만, `description`에서만 우연히 "무선"·"이어폰"이 등장하는 문서(제목은 다른 상품)가 있었다면 boost로 인해 순위가 밀려났을 것이므로, 제목 매칭을 우선하려는 의도에는 여전히 유효한 설정이다.

## (공통) 문제 3 — 구문 검색 직접 구현

`products` index의 `name`에서 `무선 이어폰`이라는 단어 순서와 인접성을 중요하게 검색하세요. `slop`은 0, 최대 5건으로 구현하세요.

### API 전체 입력

```http
GET /products/_search
{
  "size": 5,
  "query": {
    "match_phrase": {
      "name": { "query": "무선 이어폰", "slop": 0 }
    }
  }
}
```

### 결과 입력

- `hits.total.value`: 249
- 상위 문서 ID·name: `P-00241`(SoundLab 프리미엄 무선 이어폰), `P-00305`(Auralis 실속형 무선 이어폰), `P-00529`(NeoTech 스마트 무선 이어폰)
- 문제 1보다 결과가 같거나 줄어든 이유: 505건 → 249건으로 줄었다. 문제 1의 `multi_match`는 "무선"과 "이어폰"이 `name` 또는 `description` 어디에 어떤 순서로 있든 매칭됐지만, `match_phrase`는 `name` 안에서 "무선" 바로 다음에 "이어폰"이 붙어 있는 문서만 통과시키기 때문에 조건이 훨씬 엄격해졌다.
- 구문 의도에 맞지 않는 문서가 있는가: 상위 5건을 확인한 결과 모두 "무선 이어폰"이 이름에 그대로 붙어 있어 구문 의도에 어긋나는 문서는 없었다.

## (개인) 문제 4 — 여러 text field 검색

자기 프로젝트에서 같은 사용자 검색어가 적용될 수 있는 text field 2개 이상을 선택해 전문 검색을 구현하세요.

### 역할·검증 기준

- 각 field의 서비스 역할을 설명합니다.
- 상위 3개 문서를 사람이 평가합니다.
- 한 field만 필요한 도메인이라면 `match`를 선택하고 그 이유를 적어도 됩니다.

### API와 결과 입력

```http
GET /audio-devices-search/_search
{
  "size": 5,
  "query": {
    "multi_match": {
      "query": "노이즈 캔슬링",
      "fields": ["product_name", "review_summary"]
    }
  }
}
```

- 사용자 질문·검색어: "노이즈 캔슬링 잘 되는 제품 찾고 싶어" / 검색어 "노이즈 캔슬링"
- 선택 field와 역할: `product_name`(제품명에 기능명이 직접 들어가는 경우를 잡음), `review_summary`(실사용 후기에서 기능 평가를 언급하는 경우를 잡음)
- 상위 3개 판정: `AD-00017`, `AD-00023`, `AD-00052` 모두 `review_summary`가 "노이즈 캔슬링이 완벽해서 작업할 때 좋아요."로 검색 의도와 정확히 일치 — 3건 모두 관련.
- query 선택 근거: 검색어가 들어갈 수 있는 text field가 `product_name`, `review_summary` 두 개이므로 `multi_match`로 동시에 검색했다. 두 field 모두 사용자가 같은 키워드로 찾을 수 있는 위치라 하나만 검색하면 후기에만 있는 문서를 놓칠 수 있다.

## (개인) 문제 5 — boost 또는 phrase 가설 검증

자기 검색에서 field boost 또는 phrase 중 하나를 선택해 기본 요청과 비교하세요.

### 역할·검증 기준

- 같은 index·데이터·검색어·size를 유지합니다.
- 한 요소만 변경합니다.
- 결과가 바뀌지 않아도 실제 결과대로 기록합니다.

### API와 결과 입력

```http
# 변경 전 — boost 없음
GET /audio-devices-search/_search
{
  "size": 3,
  "query": {
    "multi_match": {
      "query": "노이즈 캔슬링",
      "fields": ["product_name", "review_summary"]
    }
  }
}

# 변경 후 — product_name에 3배 boost
GET /audio-devices-search/_search
{
  "size": 3,
  "query": {
    "multi_match": {
      "query": "노이즈 캔슬링",
      "fields": ["product_name^3", "review_summary"]
    }
  }
}
```

- 선택한 가설: `product_name`에 boost를 주면 제품명 자체에 기능이 들어간 문서가 리뷰에서만 언급된 문서보다 위로 올라올 것이다.
- 변경 전·후 상위 3개: 변경 전 `AD-00017`, `AD-00023`, `AD-00052`(`_score` 1.8751523) / 변경 후 동일하게 `AD-00017`, `AD-00023`, `AD-00052`(`_score` 1.8751523, 동일)
- 개선/보류/악화 판정: 보류. 순위와 점수 모두 변하지 않았다.
- 판정 근거: 상위 결과의 `product_name`(예: "Bose 스탠다드 오버이어 헤드폰")에는 애초에 "노이즈"나 "캔슬링" 토큰이 없어 `product_name` field 자체가 이 질의에 전혀 매칭되지 않았다. 매칭되지 않는 field에 boost를 줘도 점수에 영향이 없으므로, 이번 데이터에서는 boost보다 `product_name`에 기능 키워드가 없다는 데이터 특성이 원인이었다.
