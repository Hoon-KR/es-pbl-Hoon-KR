# 개인 PBL 저장소 작성 위치 안내

이 문서는 수업 중 학생이 작성하는 모든 결과를 **개인 PBL 저장소**의 어디에 남길지 정한 안내서입니다. 강사 배포 저장소(`es-5days-pbl-course`)의 교재·쇼핑몰 예제·스크립트 원본에는 내용을 쓰거나 제출하지 않습니다.

## 1. Day 1에 만드는 개인 PBL 저장소 구조

개인 GitHub 저장소 `es-pbl-<github-id>`를 clone한 뒤 아래 구조를 만듭니다. 빈 폴더는 필요한 날에 만들어도 됩니다.

```text
es-pbl-<github-id>/
├─ README.md
├─ SUBMISSION.md
├─ docs/
│  ├─ pbl-start-card.md
│  ├─ data-model.md
│  ├─ quality-test.md
│  ├─ dashboard-plan.md
│  ├─ ai-search-decision.md
│  └─ retrospective.md
├─ elasticsearch/
│  ├─ index-create.json
│  └─ requests.http
├─ data/
│  ├─ pbl-data-template/
│  └─ generation-notes.md
├─ kibana/
│  └─ dashboard.ndjson           # 선택 제출
└─ evidence/
   ├─ day-01-environment.md
   ├─ day-02-data.md
   ├─ day-03-search.md
   └─ dashboard.png
```

## 2. 파일마다 무엇을 쓰는가

| 파일 | 기록할 내용 | 작성 시점 |
|---|---|---|
| `README.md` | 프로젝트·사용자·문서 단위·검색 질문 3개·핵심 field/type 이유·데이터 규모·Dashboard 질문·AI Search 판단의 요약 | Day 1부터 매일 갱신 |
| `docs/pbl-start-card.md` | 주제, 사용자, 문서 1건, 질문 3개, filter/sort 후보, Dashboard 질문 | Day 1 T01-2 |
| `docs/data-model.md` | 대표 문서 3건(JSON), field 목록, field 목적, type 선택 이유, 개인정보 제외 판단 | Day 1 초안 → Day 2 T10~T11 확정 |
| `elasticsearch/index-create.json` | 개인 index의 settings와 mappings을 포함한 실제 생성 요청 body | Day 2 T11~T12 |
| `elasticsearch/requests.http` | 개인 index를 대상으로 실행한 `_analyze`, CRUD, search, aggregation, ES\|QL 요청. 토픽 제목 주석으로 구분 | Day 2부터 Day 5까지 |
| `data/pbl-data-template/` | Day 2에 배포본에서 복사한 개인 데이터 생성기. `my-data-settings.ps1`만 자신의 데이터로 수정 | Day 2 T15 |
| `data/generation-notes.md` | 데이터 건수, seed, 값 분포, 생성·Bulk 실행일, count/분포 검증 결과 | Day 2 T15 |
| `docs/quality-test.md` | 질문 3개, 기대·제외·0건, 실제 결과, 개선 전후와 근거, 동료 재현 결과 | Day 1 품질 초안 → Day 3 T21 확정 |
| `docs/dashboard-plan.md` | Dashboard 사용자, 차트 4개가 답하는 질문, 사용할 field/집계, control 목적, 배치 계획 | Day 1 초안 → Day 4 T22~T25 확정 |
| `kibana/dashboard.ndjson` | Saved Objects에서 export한 개인 Dashboard와 참조 객체 | Day 4, 선택 |
| `evidence/day-01-environment.md` | `GET /`, cluster health, node 3개, Kibana 접속 확인 결과. 비밀번호·실제 `.env`는 제외 | Day 1 T07~T08 |
| `evidence/day-02-data.md` | index/mapping 생성, count, 분포, CRUD, pipeline 판단의 실행 결과 또는 캡처 경로 | Day 2 |
| `evidence/day-03-search.md` | 핵심 검색 요청의 응답 요약, 품질 테스트·개선의 증거 위치 | Day 3 |
| `evidence/dashboard.png` | 완성된 개인 Dashboard 전체 화면 캡처 | Day 4 |
| `docs/ai-search-decision.md` | AI Search 적용/보류/미적용 판단, 근거, 조건·제약 | Day 5 T28~T30 |
| `docs/retrospective.md` | 잘된 설계 결정 1개, 개선할 점 1개, 다음 학습 행동 1개, 동료 피드백 | Day 5 T32-2 |
| `SUBMISSION.md` | 이름/GitHub ID, 최종 commit SHA, 실행 환경, Dashboard 증거 경로, 제한 사항 | Day 5 T31-2 |

## 3. 수업 중 작성 활동 전체 배치표

| Day·토픽 | 학생이 하는 일 | 작성할 파일 |
|---|---|---|
| Day 1 T01-1 | ES 역할 한 문장, 내 문서 단위·핵심 field | `README.md` |
| Day 1 T01-2 | 주제, 사용자, 검색 질문 3개, filter/sort 후보, 데이터 규모 초안 | `docs/pbl-start-card.md`, `README.md` |
| Day 1 T02+T03 | 사례를 사용자·데이터·질문·행동으로 바꾸고 Dashboard 질문을 정함 | `README.md`, `docs/dashboard-plan.md` |
| Day 1 T04 | 검색어·filter·sort·기대 결과를 포함한 질문 3개 | `README.md`, `docs/quality-test.md`의 초안 |
| Day 1 T05 | text/keyword 등 field 역할 분류 | `docs/data-model.md` |
| Day 1 T06 | 기대 결과·제외 결과·0건 조건 | `docs/quality-test.md` |
| Day 1 T07~T09 | Docker·Kibana·Console 접속 성공 증거 | `evidence/day-01-environment.md` |
| Day 2 T09 | 개인 index 이름, 문서 예시 | `docs/data-model.md` |
| Day 2 T10 | 대표 문서 3건, field 목록·목적 | `docs/data-model.md` |
| Day 2 T11 | field type, multi-field, type 선택 이유 | `docs/data-model.md`, `elasticsearch/index-create.json` |
| Day 2 T12 | index/settings/mapping 생성 요청과 GET 검증 | `elasticsearch/index-create.json`, `evidence/day-02-data.md` |
| Day 2 T13 | `_analyze` 요청·token 관찰 | `elasticsearch/requests.http`, `evidence/day-02-data.md` |
| Day 2 T14 | CRUD 요청과 결과 | `elasticsearch/requests.http`, `evidence/day-02-data.md` |
| Day 2 T15 | 생성 규칙·seed·분포·1,000건 이상 Bulk·count 검증 | `data/pbl-data-template/`, `data/generation-notes.md`, `evidence/day-02-data.md` |
| Day 2 T16 | ingest pipeline 적용 또는 미적용 판단 | `elasticsearch/requests.http`, `evidence/day-02-data.md` |
| Day 3 T17~T20 | 기본/정확/전문/bool 검색, filter, sort, highlight, `_source` 요청 | `elasticsearch/requests.http` |
| Day 3 T21 | 질문 3개 테스트, 0건, 개선 전후, 동료 재현 | `docs/quality-test.md`, `evidence/day-03-search.md` |
| Day 4 T22 | 집계·분포·시간 분석 요청, 해석 문장 | `elasticsearch/requests.http`, `docs/dashboard-plan.md` |
| Day 4 T23 | Data View·Discover 탐색 증거 | `evidence/dashboard-discover.png` 또는 `evidence/day-04-discover.md` |
| Day 4 T24~T25 | Lens 차트 4개, Dashboard, control, 질문-차트 연결 | `docs/dashboard-plan.md`, `evidence/dashboard.png`, 선택 `kibana/dashboard.ndjson` |
| Day 4 T26 | 향후 운영 질문·Dashboard 비평 | `docs/dashboard-plan.md` |
| Day 5 T27 | ES\|QL 분석 요청 | `elasticsearch/requests.http` |
| Day 5 T28~T30 | AI Search 적용 판단·사례 매핑·제약 | `docs/ai-search-decision.md`, `README.md` 요약 |
| Day 5 T31 | 재현성 검증·수정 목록 | `SUBMISSION.md`, `docs/quality-test.md` |
| Day 5 T32 | 데모 구성, 피드백, 회고·다음 개선 | `README.md`, `docs/retrospective.md`, `SUBMISSION.md` |

## 4. 꼭 지킬 원칙

- 배포 저장소의 쇼핑몰 요청·data·Dashboard 예시는 참고용이다. 개인 저장소에 그대로 복사해 제출하지 않는다.
- `pbl-data-template/`은 Day 2에 개인 저장소로 복사한 뒤에만 수정한다.
- 모든 실제 명령은 `elasticsearch/requests.http`에 남긴다. Console에만 남아 있는 요청은 제출 증거가 아니다.
- 캡처만 저장하지 말고, 무엇을 실행했고 어떤 값이 통과 기준인지 `evidence/*.md`에도 적는다.
- 실제 `.env`, 비밀번호, 개인정보·실제 고객 데이터는 commit하지 않는다.
