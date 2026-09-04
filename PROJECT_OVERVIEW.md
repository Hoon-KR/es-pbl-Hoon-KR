햣# es-pbl-Hoon-KR 프로젝트 설명자료

> 강사님 발표용 — 저장소 전체 구조와 진행 내용을 한 문서로 정리합니다.

## 1. 이 저장소는 무엇인가

`es-pbl-Hoon-KR`은 **개인 PBL(Project-Based Learning) 저장소**입니다.

- 강사 배포 저장소 `djkorea/es-5days-pbl-course`를 기반(merge)으로 시작해, 매일 공개되는 교재·공통 예제·템플릿을 받습니다.
- 그 위에 **내 개인 프로젝트인 "오디오 기기 검색 서비스"**를 설계·구현하며 산출물(mapping, 데이터, 요청, evidence 문서, 대시보드)을 쌓아 왔습니다.
- 즉 이 저장소 안에는 (1) 수업이 제공한 공통 자료와 (2) 제가 직접 만든 개인 산출물이 함께 들어 있습니다.

## 2. 전체 폴더 구조

```
es-pbl-Hoon-KR/
├── day-01/        Docker(ES 3노드+Kibana) 환경, PBL 주제 정하기, 첫 REST 요청
├── day-02/        mapping 설계, 데이터 생성기, Bulk 색인 (공통 교재 + 개인 실습 안내)
├── day-03/        Search API 구현 — term/match/bool/filter/sort/highlight, 품질 진단
│   ├── practice/      교시별(1~8교시) 문제지 — 내가 실제로 푼 답이 여기 들어 있음
│   └── evidence/      최종 요약 문서(현재 작성 중)
├── day-04/        Kibana 집계·Discover·Lens·Dashboard
│   ├── practice/      교시별 문제지 + 캡처 근거(assets)
│   └── evidence/day-04/  개인 Dashboard 설계서·검증 기록(완료)
├── docs/          내 프로젝트 설계 문서 (data-model.md 등)
├── evidence/      Day별 결과 보고 문서 (day-02-data.md 등)
├── elasticsearch/ 내 index mapping(index-create.json)과 실행 요청(requests.http)
├── data/          대표 문서 샘플(sample-documents.json)
└── search-app-template/  FE·BE 검색 데모 앱 템플릿 (아직 내 index로 미적용, 공통 값 그대로)
```

Day 5(ES|QL, AI Search, 제출·발표)는 강사 공개 전이라 아직 폴더가 없습니다.

## 3. 나의 PBL 프로젝트 주제

**주제: 오디오 기기(이어폰·헤드폰·헤드셋) 쇼핑 검색 서비스**

| 항목 | 내용 |
|---|---|
| Index 이름 | `audio-devices-search` |
| 문서 1건의 의미 | 오디오 기기 1개 모델의 스펙 + 리뷰 요약 |
| 문서 수 | 10,000건 (Bulk 색인, `errors: false` 확인) |
| mapping `dynamic` | `strict` |

### Field 설계 (`elasticsearch/index-create.json`)

| Field | Type | 용도 |
|---|---|---|
| `product_id` | keyword | 고유 식별 |
| `product_name` | text | 제품명 전문 검색 |
| `brand` | keyword | 브랜드 필터·집계 |
| `category` | keyword | 이어폰/헤드폰/헤드셋 필터·집계 |
| `connection` | keyword | 무선/유선/완전무선 필터 |
| `price` | integer | 가격 범위·정렬 |
| `features` | keyword | 기능(노이즈 캔슬링 등) 필터 |
| `battery_hours` | integer | 배터리 시간 범위·정렬 |
| `rating` | float | 평점 범위·정렬 |
| `review_summary` | text | 리뷰 키워드 전문 검색 |

### 설계한 사용자 검색 질문 3개 (`docs/data-model.md`)

1. 노이즈 캔슬링 지원, 10만 원 이하 무선 이어폰 → 가격 낮은 순
2. 저음 강조, 배터리 오래가는 운동용 무선 헤드셋 → 배터리 긴 순
3. 소니·보스 중 평점 4.5 이상 오버이어 헤드폰 → 평점 높은 순

## 4. Day별 진행 내용

### Day 1 — 환경 구성
Docker로 ES 3노드 + Kibana 9.5.0 클러스터를 띄우고, PBL 주제(오디오 기기 검색)와 사용자 질문 초안을 정했습니다.

### Day 2 — 데이터 모델링·적재 (`evidence/day-02-data.md`, `docs/data-model.md`)
- mapping 10개 field 확정, `dynamic: strict` 적용
- PowerShell 생성기(`day-02/data/generator/generate-products.ps1`)로 10,000건 생성
- Bulk API로 전량 색인, `_count`=10,000 확인, 카테고리/가격/평점 분포 검증
- Ingest Pipeline은 생성 단계에서 이미 데이터가 정제되어 **미적용 결정**

### Day 3 — 검색 기능 구현 (`day-03/practice/period-*.md`) — 완료
공통 `products` index로 8교시 문제(전문 검색, term/match, filter/range, bool, sort/highlight)를 실습한 뒤, 같은 절차를 내 `audio-devices-search`에 적용했습니다.

- 실제로 발견한 문제: `review_summary`가 기본 `standard` analyzer라 조사가 붙은 검색어("저음 운동용")와 저장된 토큰이 일치하지 않아 0건 발생
- 임시 개선: 검색어를 저장 형태에 맞춰 변경 → 0건에서 1,480건으로 정상화
- **남은 과제로 확인한 근본 원인**: 한국어 형태소 분석기(Nori) 적용 검토 필요
- 최종 정리 완료: `elasticsearch/requests.http`(`V1-T17-P`~`V1-T21-P`), `docs/quality-test.md`, `evidence/day-03-search.md` 작성 완료 — **commit만 남음**

### Day 4 — Kibana 집계·Dashboard (`day-04/evidence/day-04/`) — 완료
- Data View `audio-devices-search` 생성
- Lens 4종 제작: Metric(전체 수), Bar(카테고리별 수), Table(브랜드별 수·평균가), Donut(연결 방식 비율)
- 4패널 Dashboard + category Options list Control 조립, 화면 캡처 저장
- 핵심값 3개를 ES 집계(`_count`, `term` query)로 교차 검증 → 모두 일치
- 데이터 부족 진단: `in_stock`(재고), `created_at`(등록일) field가 없어 해당 질문은 "말할 수 없는 것"으로 명시하고, 향후 데이터 보강 규칙(확률 배정 방식)까지 설계
- 개선 사례 기록: 원래 계획했던 재고 Donut을 만들 수 없어 연결 방식 Donut으로 대체한 과정과 이유

## 5. 핵심 산출물 위치 한눈에 보기

| 산출물 | 경로 |
|---|---|
| index mapping | `elasticsearch/index-create.json` |
| 실행 요청(Console) | `elasticsearch/requests.http` |
| 데이터 모델·질문 설계 | `docs/data-model.md` |
| Day2 결과 보고 | `evidence/day-02-data.md` |
| Day3 실습 답안(실질 내용) | `day-03/practice/period-01~08*.md` |
| Day3 검색 품질 점검표 | `docs/quality-test.md` |
| Day3 최종 요약 | `evidence/day-03-search.md` |
| Day4 Dashboard 설계 | `day-04/evidence/day-04/dashboard-plan.md` |
| Day4 Dashboard 검증 | `day-04/evidence/day-04/dashboard-review.md` |
| Day4 교시별 답안·캡처 | `day-04/practice/*.md`, `day-04/assets/day-04-practice/*.png` |

## 6. 다음 계획

1. Day 3 마무리 산출물(`elasticsearch/requests.http`, `docs/quality-test.md`, `evidence/day-03-search.md`) commit
2. `review_summary` 전문 검색 품질 개선을 위한 Nori 형태소 분석기 적용 검토
3. `in_stock`, `created_at` field 보강(설계는 완료, 실제 재색인 예정) 후 Day4에서 보류했던 질문 완성
4. `search-app-template`을 `audio-devices-search` 기준으로 개인화(설정 2개 파일 수정)
5. Day 5(ES\|QL, AI Search) 공개 후 진행
