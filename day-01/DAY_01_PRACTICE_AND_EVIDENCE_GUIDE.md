# Day 1 실습·작성·산출물 확인표

이 표의 번호는 `day-01-instructor.pptx`에서 PowerPoint가 보여 주는 **실제 슬라이드 번호(총 74장)**다. 대본에는 과거 중복 표기된 `슬라이드 07`이 있어, 대본 번호만으로 찾지 말고 아래의 **슬라이드 제목도 함께** 확인한다.

## 진행 원칙

- 아래 표에서 **학생 행동**이 있는 슬라이드에서 PPT를 멈춘다.
- 학생은 학생교재의 같은 토픽을 참고해 개인 PBL 저장소에 기록한다.
- `확인 방법`은 “학생이 했다고 말함”이 아니라 실제 파일·명령 출력·화면으로 확인하는 기준이다.
- 쇼핑몰 공통 예제는 강사 시연용이고, 표의 저장 위치는 학생의 **개인 PBL 저장소**다.

## 1교시 T01-1 — ES 역할과 문서 단위

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 11 | 쇼핑몰 문서 한 건 읽기 | 쇼핑몰 문서에서 검색 결과 한 줄의 대상과 field를 읽고, 내 주제의 문서 한 건을 정한다. | `README.md`의 `ES로 검색할 문서 1건`, `docs/pbl-start-card.md` | 문서 단위가 ‘여행’처럼 넓지 않고 ‘숙소 상품 1건’처럼 결과 한 줄의 대상인지 확인 |
| 12 | 내 PBL의 문서 단위 | 내 문서 단위와 화면에 보일 핵심 field를 쓴다. | `README.md`, `docs/pbl-start-card.md` | 문서 1건과 field 3개 이상을 말할 수 있는지 확인 |
| 13 | ES 역할 한 문장 완성 | 내 PBL에서 ES가 할 일을 한 문장으로 쓴다. | `README.md` 프로젝트 소개 | ‘데이터를 저장한다’가 아니라 ‘어떤 문서를 어떤 질문으로 검색/필터/정렬한다’가 드러나는지 확인 |

## 2교시 T01-2 — PBL 시작·개인 저장소

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 15 | 이 과제는 검색 질문을 데이터·쿼리·Dashboard로 검증하는 개인 프로젝트입니다. | 개인 PBL 저장소를 만들고 clone한다. 배포 저장소와 개인 저장소의 역할을 구분한다. | 개인 저장소 루트 | `git remote -v`가 개인 저장소 URL을 가리키고, 배포 저장소에는 제출 파일을 쓰지 않는지 확인 |
| 16 | 5일 마일스톤 타임라인 | 매일 무엇을 개인 저장소에 남길지 훑어본다. | `README.md` 실행 순서(선택) | Day 2 데이터 → Day 3 검색 → Day 4 Dashboard → Day 5 제출 흐름을 설명하는지 확인 |
| 17 | 최소 파일 트리 | `docs/`, `elasticsearch/`, `data/`, `kibana/`, `evidence/` 폴더를 만든다. | 개인 저장소 폴더 구조 | [PBL 저장소 작성 위치 안내](PBL_REPOSITORY_WRITING_GUIDE.md)의 트리와 대조 |
| 18 | 좋은 주제/넓은 주제 비교 | 주제를 문서 단위까지 좁히고 사용자 한 명을 정한다. | `docs/pbl-start-card.md`, `README.md` | 사용자·문서·검색 문제가 모두 한 문장에 들어가는지 확인 |
| 19 | 검색 질문 템플릿 | 검색 질문 3개, filter 후보, sort 후보, Dashboard 질문 1개를 작성한다. | `docs/pbl-start-card.md`, `README.md` | 세 질문이 서로 다르고 조건을 검증할 수 있는지 확인 |
| 20 | README 작성 순서 | 시작 카드 내용을 README의 프로젝트 소개·데이터와 mapping·검색 품질·Dashboard 절에 옮긴다. | `README.md` | 사용자, 문서 단위, 질문 3개, 데이터 규모 초안이 모두 있는지 확인 |
| 21 | 첫 commit | 개인 저장소에서 첫 commit 후 push한다. | GitHub 개인 저장소 | `git status`가 clean이고 GitHub에서 최신 commit과 README가 보이는지 확인 |
| 22 | 짝 점검 3문항 | 짝의 README에서 사용자·문서 단위·질문 3개를 찾아 피드백한다. | `README.md` 또는 `docs/pbl-start-card.md` | 짝이 파일 경로와 해당 문장을 직접 보여 주는지 확인 |

## 3교시 T02+T03 — 사례를 내 PBL로 변환

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 28 | Dashboard의 다음 행동 | 내 데이터에서 Dashboard를 본 사람이 할 다음 행동을 한 문장으로 쓴다. | `docs/dashboard-plan.md`, `README.md` Dashboard 절 | 차트가 ‘예쁘다’가 아니라 어떤 판단·행동을 돕는지 확인 |
| 29 | 내 PBL 사례 매핑표 | 사용자·문서·질문·Dashboard 행동을 내 도메인으로 매핑한다. | `README.md`, `docs/dashboard-plan.md` | 네 항목이 같은 주제와 문서 단위를 가리키는지 확인 |
| 30 | 사례 점검·T04 연결 | 짝이 매핑표를 읽고 모호한 항목을 수정한다. | 위 두 파일 | 학생이 수정 전/후 한 항목을 설명하는지 확인 |

## 4교시 T04 — 검색 질문 설계

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 35 | 검색어·filter·sort·기대 결과 표 | 쇼핑몰 표를 읽고 질문·조건·결과의 관계를 이해한다. | 기록 없음(공통 예제 읽기) | 검색어와 filter/sort를 구별해 말하는지 확인 |
| 36 | 내 질문 3개 작성 | 각 질문에 검색어, filter, sort, 기대 결과를 붙여 작성한다. | `docs/quality-test.md` 초안, `README.md` | 3개 질문 각각에 예상 결과가 있고, 최소 한 개는 filter/sort를 쓰는지 확인 |
| 37 | 짝 검토 | 짝이 질문의 모호함·검증 가능성을 점검한다. | `docs/quality-test.md` | 수정한 질문 또는 피드백 한 건을 남겼는지 확인 |

## 5교시 T05 — text·keyword field 판단

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 43 | 카드 실습 | 공통 field 카드를 검색·필터·정렬·집계 역할로 분류한다. | 기록 없음(개념 확인) | 각 역할을 설명하는지 확인 |
| 44 | 내 PBL field 분류 | 내 field를 전문 검색(text), 정확 조건/집계(keyword), 숫자, 날짜, boolean 등으로 분류한다. | `docs/data-model.md` | 각 field에 ‘왜 이 type 후보인가’ 이유가 있는지 확인 |
| 45 | 확인 질문 | 질문에 필요한 field가 빠지지 않았는지 점검한다. | `docs/data-model.md`, `docs/quality-test.md` | 질문 3개 각각이 최소 하나 이상의 field와 연결되는지 확인 |

## 6교시 T06 — 검색 품질 기준

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 50 | 0건은 정상일 수 있다 | 결과가 없어야 정상인 조건을 한 개 정한다. | `docs/quality-test.md` | 단순 오류가 아닌 의도된 0건 조건인지 확인 |
| 51 | 품질 기록표 작성 | 질문별 기대 문서·제외 문서·0건·판정 기준을 적는다. | `docs/quality-test.md`, `README.md` 검색 품질 절 | 세 질문, 기대/제외, 0건 조건이 실제로 표에 있는지 확인 |
| 52 | 짝 검토 | 짝이 결과를 보지 않고도 통과 기준을 이해할 수 있는지 점검한다. | `docs/quality-test.md` | 짝 피드백 뒤 모호한 표현을 한 건 이상 보완했는지 확인 |
| 53 | Day 1 이론 체크 | Day 2에서 mapping으로 구현할 field/type 초안을 확정한다. | `docs/data-model.md` | 문서·field·질문·품질표가 서로 같은 명칭을 쓰는지 확인 |

## 7교시 T07 — Docker 환경 실행

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 55 | 설치·가상화·Docker Desktop | Docker Desktop 설치/실행 조건을 확인한다. | 기록 없음(설치 진행) | Docker Desktop이 실행 중인지 확인 |
| 57 | 제공 파일 구조 | 배포 저장소의 `day-01/docker/`를 열어 실행 위치를 확인한다. | 기록 없음(배포 저장소 사용) | 개인 저장소가 아니라 배포 저장소의 Docker 폴더인지 확인 |
| 58 | preflight.ps1 | 포트·Docker 준비 상태를 점검한다. | `evidence/day-01-environment.md` | 성공/실패 출력과 다음 조치를 기록 |
| 59 | pull-images.ps1 | ES·Kibana 9.5.0 이미지를 받는다. | `evidence/day-01-environment.md` | pull 완료 또는 오류 메시지 기록 |
| 60 | start.ps1 | 3노드 cluster와 Kibana를 시작한다. | `evidence/day-01-environment.md` | 시작 명령·실행 시각 기록 |
| 61 | status.ps1 성공 기준 | cluster `green`, node 3개, Kibana `available`을 확인한다. | `evidence/day-01-environment.md` | 세 성공값을 모두 적거나 캡처 |
| 62 | stop.ps1 | 종료해도 Docker volume 데이터가 유지되는 원칙을 이해한다. 실습 중 계속 쓸 경우 실제 stop은 하지 않는다. | 필요 시 `evidence/day-01-environment.md` | 종료했다면 재시작 계획과 상태 기록 |
| 63 | 개인 실행 체크 | 각자 환경 성공/실패를 판정하고 미완료 원인을 표시한다. | `evidence/day-01-environment.md` | 성공 기준 3개 또는 실패 메시지·단계를 확인 |

## 8교시 T08+T09 — Kibana Console과 첫 REST 요청

| 실제 PPT | 멈출 슬라이드 | 학생 행동 | 개인 저장소 기록 위치 | 확인 방법 |
|---:|---|---|---|---|
| 64~66 | Kibana는 localhost:5601 / Dev Tools → Console / REST 요청 3요소 | Kibana 로그인 후 Dev Tools Console을 열고 method·path·body의 역할을 확인한다. | `evidence/day-01-environment.md` | Console 화면을 열었고 비밀번호가 캡처에 없는지 확인 |
| 67 | 첫 요청 | `GET /`를 실행한다. | `elasticsearch/requests.http`, `evidence/day-01-environment.md` | ES 9.5.0·cluster 이름이 응답에 보이는지 확인 |
| 68 | cluster health | cluster health 요청을 실행한다. | `elasticsearch/requests.http`, `evidence/day-01-environment.md` | `green`, `number_of_nodes: 3`을 확인 |
| 69 | JSON 응답 읽기 | version·cluster·status·node 수를 찾아 의미를 말한다. | `evidence/day-01-environment.md` | 값만 복사하지 않고 통과/실패 판정을 적었는지 확인 |
| 70 | 내 PBL 접속 증거 | 첫 요청과 health 결과를 evidence로 정리한다. | `evidence/day-01-environment.md` | 요청, 출력 핵심값, 실행일, 판정이 모두 있는지 확인 |
| 72 | Day 1 산출물 체크 | Day 1 설계 파일과 환경 evidence를 한 번에 확인한다. | 아래 Day 1 종료 체크 | 파일 존재뿐 아니라 실제 내용 확인 |
| 73~74 | Day 2 연결 / Day 1 결과 저장·다음 연결 | 변경 파일을 저장하고 Day 1 commit을 갱신한다. | 개인 GitHub 저장소 | `git status`, commit/push, 민감정보 미포함 확인 |

## Day 1 종료 체크: 학생에게 확인시킬 산출물

강사는 학생이 아래 파일을 직접 열게 하고 체크한다.

1. `README.md`: 사용자, 문서 단위, 검색 질문 3개, 데이터 규모 초안
2. `docs/pbl-start-card.md`: 주제·filter/sort 후보·Dashboard 질문
3. `docs/data-model.md`: field 역할/type 초안
4. `docs/quality-test.md`: 기대·제외·0건을 포함한 품질표 초안
5. `docs/dashboard-plan.md`: Dashboard가 답할 질문과 다음 행동
6. `evidence/day-01-environment.md`: ES 9.5.0, cluster `green`, node 3개, Kibana 접속/Console 결과
7. `elasticsearch/requests.http`: `GET /`, cluster health 요청
8. GitHub 개인 저장소: Day 1 최신 commit과 push 상태

초안이라도 빈 파일만 만들고 끝내면 통과가 아니다. 각 파일에 학생의 선택·실행 결과·판정 근거가 있어야 한다.
