# Day 2 실습·작성·산출물 확인표

이 표는 Day 2 강사용 PPT의 슬라이드 제목·번호를 기준으로, PPT를 멈추고 학생이 수행할 활동을 정리한 것이다. 모든 작성물은 **개인 PBL 저장소**에 남긴다. 배포 저장소의 `day-02/`는 쇼핑몰 시연 자료와 템플릿을 받는 곳이며 직접 수정·제출하지 않는다.

## 시작 전 확인

- Day 1의 개인 PBL 저장소와 README, 문서 단위·검색 질문·field/type 초안이 있어야 한다.
- Docker 환경이 꺼졌다면 배포 저장소 `day-01/docker/`에서 `status.ps1`로 상태를 먼저 확인한다.
- Day 2에는 개인 PBL 저장소에서 `docs/data-model.md`, `elasticsearch/`, `data/`, `evidence/`를 사용한다. 파일별 역할은 [PBL 저장소 작성 위치 안내](../day-01/PBL_REPOSITORY_WRITING_GUIDE.md)를 따른다.

## 1교시 T09 — ES 구조 확인과 개인 index 이름

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 08 | 노드 확인 | CAT API로 Day 1의 3 node를 확인한다. | `evidence/day-02-data.md` | `es01`, `es02`, `es03` 또는 node 3개가 보이는 출력과 판정 기록 |
| 09 | index 목록 확인 | 현재 index 목록을 확인하고 공통 `products`와 내 index를 구분한다. | `evidence/day-02-data.md` | 개인 index를 아직 만들지 않았다면 ‘생성 전’으로 기록; 공통 예제를 개인 index로 오인하지 않음 |
| 10 | 내 PBL 이름 정하기 | 소문자·하이픈 기반의 개인 index 이름을 확정한다. | `docs/data-model.md`, `README.md` | README·mapping·요청 파일에서 같은 index 이름을 사용하는지 확인 |
| 11 | GET /{index}/_mapping은 schema를 확인한다 | mapping을 나중에 GET으로 확인할 방법을 이해한다. | `elasticsearch/requests.http`에 GET 요청 초안 | Day 2 T12 생성 뒤 실제 응답으로 확인할 준비가 되었는지 점검 |

## 2교시 T10 — 데이터 모델링

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 18 | 대표 문서 3건 작성 | 검색 결과에 나타날 동일한 단위의 JSON 문서 3건을 작성한다. | `docs/data-model.md` | 3건이 같은 field 구조를 가지며 Day 1 질문에 답할 값·분류·숫자/날짜를 갖는지 확인 |
| 19 | field 목적 표 | 각 field를 표시·전문 검색·정확 filter·정렬·집계 중 어디에 쓰는지 표시한다. | `docs/data-model.md` | 질문 3개와 각 field 목적이 연결되는지 확인 |
| 20 | 짝 검토 | 짝이 문서 단위·field 이름·개인정보 제외 여부를 검토한다. | `docs/data-model.md` | 피드백 또는 수정한 항목 1건을 남김 |

## 3교시 T11 — mapping 설계

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 26 | 공통 mapping 읽기 | 쇼핑몰 `products` mapping에서 field/type을 읽는다. | 기록 없음(공통 예제 이해) | `text`와 `keyword`의 역할 차이를 설명 |
| 27 | 내 mapping 초안 | 대표 문서·field 목적을 JSON mapping으로 옮긴다. | `docs/data-model.md`, `elasticsearch/index-create.json` 초안 | 모든 대표 문서 field에 type이 있으며 type 선택 이유가 있는지 확인 |
| 28 | 설계 점검 | text/keyword, 숫자, boolean, date, multi-field를 질문 기준으로 재검토한다. | 위 두 파일 | 검색·filter·sort·aggregation에 필요한 field가 모두 있는지 확인 |

## 4교시 T12 — 개인 index와 mapping 생성

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 31 | 생성 요청 읽기 | settings와 mappings를 포함하는 생성 요청을 읽는다. | `elasticsearch/index-create.json` | index 이름·settings·mappings가 개인 주제와 일치 |
| 32 | 공통 생성 시연 | 강사의 `products` 생성 시연을 본다. | 기록 없음(공통 시연) | 공통 index와 개인 index 요청을 구분 |
| 33 | 개인 index 생성 | `index-create.json` body로 개인 index를 Kibana Console에서 생성한다. 실행한 요청은 `.http`에도 저장한다. | `elasticsearch/index-create.json`, `elasticsearch/requests.http`, `evidence/day-02-data.md` | 생성 응답 `acknowledged: true` 또는 이미 존재하는 이유를 확인 |
| 34 | GET으로 검증 | `GET /<내-index>/_mapping`과 settings를 실행한다. | `elasticsearch/requests.http`, `evidence/day-02-data.md` | 기대한 field/type·setting이 응답에 보이는지 확인 |
| 35 | shard 관찰 | shard 상태를 읽고 3 node 환경을 관찰한다. | `evidence/day-02-data.md` | 단순 node 수와 shard 수를 혼동하지 않는지 확인 |
| 36 | 오류 처리 | `resource_already_exists_exception` 등 오류를 원인과 함께 기록한다. | `evidence/day-02-data.md` | 임의로 삭제하지 않고 대상 index·요청 body를 먼저 확인 |

## 5교시 T13 — analyzer 확인

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 40 | `_analyze` 요청 | analyzer 요청의 text와 analyzer를 읽는다. | `elasticsearch/requests.http` | 요청이 내 text field의 검색어와 연결되는지 확인 |
| 41 | 공통 실행 | 쇼핑몰 예제의 token 결과를 확인한다. | 기록 없음(공통 시연) | 입력 문장과 token 결과를 구분 |
| 42 | 내 검색어 실행 | 내 PBL 검색어로 `_analyze`를 실행하고 token을 기록한다. | `elasticsearch/requests.http`, `evidence/day-02-data.md` | token 결과가 예상과 다르면 analyzer/입력값을 함께 기록 |
| 43 | text/keyword 대비 | 동일 field의 전문 검색/정확 비교 용도를 결정한다. | `docs/data-model.md` | 나중에 Day 3 `match`와 `term`을 어느 field에 쓸지 설명 |

## 6교시 T14 — CRUD

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 48 | C·R 시연 | 공통 문서 생성·조회 시연을 본다. | 기록 없음(공통 시연) | id와 `_source`를 구분 |
| 49 | U 시연 | 부분 수정 시연을 본다. | 기록 없음(공통 시연) | 전체 문서 교체와 update의 차이를 설명 |
| 50 | D 시연 | 삭제 시연을 본다. | 기록 없음(공통 시연) | 이후 대량 적재 전 테스트 문서인지 확인 |
| 51 | 학생 실행 | 내 index에 테스트 문서 C/R/U/D를 실행한다. | `elasticsearch/requests.http`, `evidence/day-02-data.md` | 생성→조회→수정→삭제 각각의 응답 또는 조회 결과가 남아 있는지 확인 |
| 52 | 정리 검증 | 테스트 문서가 남아 있는지, 대량 데이터와 혼동할 여지가 없는지 점검한다. | `evidence/day-02-data.md` | 삭제한 문서 GET 또는 다음 적재 전 상태를 확인 |

## 7교시 T15 — 더미 데이터 생성·Bulk 적재

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 53~55 | 대량 더미 데이터 / 생성 규칙과 seed / Bulk NDJSON | 검색·filter·sort·aggregation을 검증할 분포, 최소 1,000건, seed를 정하고 NDJSON의 action/source 쌍을 이해한다. | `data/generation-notes.md`, `docs/data-model.md` | 데이터 건수·seed·분류/숫자/날짜 분포가 질문과 Dashboard에 필요한지 확인 |
| 56 | 공통 파일 구조 | 공통 쇼핑몰 생성기와 개인 템플릿의 역할을 구분한다. | 기록 없음(배포 자료 읽기) | `data/` 원본을 개인 저장소에서 직접 수정하지 않을 것을 확인 |
| 57~58 | 생성·적재 시연 / count·분포 검증 | 강사가 공통 1만 건 생성·Bulk·검증을 시연한다. | 기록 없음(공통 시연) | Bulk 응답 `errors: false`, count와 분포 검증의 의미를 확인 |
| 59 | 내 PBL 계획 | 아래의 개인 템플릿 절차를 수행한다. | 아래 개인 템플릿 파일 | count·분포·생성 규칙이 개인 데이터 기준인지 확인 |
| 60 | 실패 읽기 | Bulk 오류가 있으면 오류 행·field·mapping을 읽고 원인을 기록한다. | `evidence/day-02-data.md` | 오류를 무시하지 않고 `errors` 값·원인·수정 내용을 남김 |

### T15 개인 템플릿: 반드시 이 순서로 한다

1. 배포 저장소에서 `git pull origin main`으로 Day 2 자료를 받는다.
2. 배포 저장소 `day-02/pbl-data-template/` 전체를 **개인 PBL 저장소** `data/pbl-data-template/`로 복사한다.
3. 개인 복사본의 `my-data-settings.ps1`만 내 주제에 맞게 수정한다. 생성된 NDJSON은 직접 편집하지 않는다.
4. 개인 저장소 `data/pbl-data-template/`에서 `generator/generate-data.ps1 -SettingsFile .\my-data-settings.ps1`을 실행한다.
5. T12에서 만든 개인 mapping이 있는 상태에서 `load-data.ps1`으로 Bulk 적재한다.
6. `requests/verify-data-template.http`를 내 index·field로 바꿔 count·분포 요청을 실행한다.
7. seed·건수·분포·검증 결과를 `data/generation-notes.md`와 `evidence/day-02-data.md`에 기록한다.

## 8교시 T16 — ingest pipeline 판단과 Day 2 commit

| PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 63~65 | pipeline 정의 / `_simulate` / 공통 simulate | pipeline과 `_simulate` 공통 시연을 확인한다. | 기록 없음(공통 시연) | 색인 전 변환이라는 목적을 설명 |
| 66 | 적용 판단 | 내 데이터에 pipeline이 필요한지 적용/미적용을 근거와 함께 결정한다. | `docs/data-model.md`, `evidence/day-02-data.md` | 필요 없으면 ‘미적용’ 사유를 남기며 억지로 구현하지 않음 |
| 67 | 선택 구현 | 필요한 학생만 pipeline 정의·simulate 요청을 실행한다. | `elasticsearch/requests.http`, `evidence/day-02-data.md` | simulate 결과에서 변환 전/후 값이 확인되는지 점검 |
| 68 | Day 2 commit | Day 2 파일을 점검하고 개인 저장소에 commit/push한다. | 아래 Day 2 종료 체크 | GitHub에서 최신 commit과 필요한 파일을 확인 |
| 69 | Day 2 결과 저장·다음 연결 | 변경 파일을 저장하고 Day 3 검색에 사용할 개인 index·데이터 상태를 마지막으로 확인한다. | 개인 GitHub 저장소 | commit/push와 Day 3 시작 조건을 확인 |

## Day 2 종료 체크: 학생에게 확인시킬 산출물

강사는 학생이 개인 PBL 저장소에서 다음을 직접 열게 한다.

1. `docs/data-model.md`: 대표 문서 3건, field 목적·type 선택 이유, 개인정보 제외 판단
2. `elasticsearch/index-create.json`: 개인 index의 settings와 mappings
3. `elasticsearch/requests.http`: mapping 검증, `_analyze`, CRUD, 선택 pipeline 요청
4. `data/pbl-data-template/my-data-settings.ps1`: 개인 도메인용 생성 규칙·seed
5. `data/generation-notes.md`: 건수, seed, 값 분포, 생성·Bulk 검증 요약
6. `evidence/day-02-data.md`: index/mapping, count, 분포, CRUD, pipeline 판단의 실제 근거
7. `README.md`: 데이터와 mapping 절이 최신 선택과 일치
8. GitHub 개인 저장소: Day 2 최신 commit/push, 실제 `.env`·비밀번호·개인정보 미포함

**Day 3로 넘어가는 조건:** 개인 index와 mapping이 생성되어 있고, 1,000건 이상 데이터의 Bulk 적재·count·분포 검증이 완료되어야 한다.
