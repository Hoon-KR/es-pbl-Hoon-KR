# Day 1 — ES 시작, PBL 주제, Docker 환경

## 오늘의 완료 기준

- [ ] ES가 내 프로젝트에서 맡을 역할을 한 문장으로 적었다.
- [ ] PBL 주제와 사용자·검색 질문 3개를 초안으로 만들었다.
- [ ] 개인 GitHub PBL 저장소를 만들고 첫 commit을 남겼다.
- [ ] Docker 환경에서 ES 3노드와 Kibana 접속을 확인했다.
- [ ] 첫 REST 요청의 결과를 확인했다.

## 먼저 이해할 것: 저장소는 두 개입니다

| 저장소                             | 역할                                                     | 수정·제출 여부                  |
| ------------------------------- | ------------------------------------------------------ | ------------------------- |
| 강사 배포 저장소 `es-5days-pbl-course` | 매일 받는 교재, 공통 쇼핑몰 예제, Docker 실행 환경, 복사할 템플릿             | 원본을 수정하거나 제출하지 않음         |
| 개인 PBL 저장소 `es-pbl-<github-id>` | 내 주제의 설계, 데이터 생성 규칙, mapping, 검색 요청, 테스트 근거, Dashboard | 이 저장소에서 작업·commit·push·제출 |

Docker는 강사 배포 저장소의 `day-01/docker/`에서 실행합니다. 반면 PBL 파일은 개인 PBL 저장소에만 저장합니다. 두 저장소를 하나로 합치거나 개인 PBL 저장소에 `docker/` 폴더를 복사하지 않습니다.

## 개인 PBL 저장소에 가져올 파일과 직접 만들 파일

### Day 1에 복사할 시작 문서

개인 PBL 저장소를 clone한 뒤 아래 파일을 복사해 이름을 정합니다.

```powershell
$course = "C:\수업\es-5days-pbl-course"
$pbl = "C:\수업\es-pbl-내GitHub아이디"

Copy-Item "$course\day-01\README-template.md" "$pbl\README.md"
Copy-Item "$course\day-01\SUBMISSION-template.md" "$pbl\SUBMISSION.md"
New-Item -ItemType Directory -Force "$pbl\docs"
Copy-Item "$course\day-01\pbl-start-card.md" "$pbl\docs\pbl-start-card.md"
Copy-Item "$course\day-01\data-model-template.md" "$pbl\docs\data-model.md"
Copy-Item "$course\day-01\dashboard-plan-template.md" "$pbl\docs\dashboard-plan.md"
```

`README.md`, `docs/pbl-start-card.md`, `docs/data-model.md`, `docs/dashboard-plan.md`은 Day 1에 내 주제로 작성합니다. `docs/data-model.md`의 ES type 후보는 Day 2에 mapping으로 확정하고, `docs/dashboard-plan.md`의 실제 차트·control·증거는 Day 4에 확정합니다. `SUBMISSION.md`는 Day 5에 최종 commit SHA와 Dashboard 근거를 채웁니다.

### 이후 일자에 복사할 템플릿

| 받는 날 | 강사 배포 저장소 파일 | 개인 PBL 저장소 위치 | 학생이 할 일 |
|---|---|---|---|
| Day 2 | `day-02/pbl-data-template/` 전체 | `data/pbl-data-template/` | 설정·mapping·검증 요청을 내 주제로 수정하고 데이터 생성·Bulk 적재 |
| Day 3 | `day-03/QUALITY_TEST_TEMPLATE.md` | `docs/quality-test.md` | 내 검색 질문과 기대·실제 결과를 기록 |

Day 3~5의 쇼핑몰 요청 파일과 Dashboard 예시는 복사 대상이 아니라 학습·참고 자료입니다. 학생은 개인 저장소에 `elasticsearch/index-create.json`, `elasticsearch/requests.http`, `evidence/dashboard.png`를 직접 만들고 저장합니다. `kibana/dashboard.ndjson`은 선택 제출입니다.

## 실행 순서

```powershell
git clone https://github.com/djkorea/es-5days-pbl-course.git
cd es-5days-pbl-course\day-01\docker
Copy-Item .env.example .env
# 강사가 수업 중 안내한 두 비밀번호를 .env의 CHANGE_ME 값에만 입력한다.
.\preflight.ps1
.\pull-images.ps1
.\start.ps1
.\status.ps1
```

브라우저에서 `http://localhost:5601`을 열고, 강사가 안내한 수업용 계정으로 로그인합니다.

> `.env`는 내 PC에서만 사용합니다. GitHub에 올리거나 화면 공유에 노출하지 않습니다.

## 중간 오류 시 처음부터 다시 시작하기

원인을 알 수 없는 Docker 환경 오류가 있고 강사가 초기화를 안내한 경우에만 아래를 실행합니다.

```powershell
.\reset.ps1
# RESET 을 입력해 확인
```

이 스크립트는 **이 Docker 폴더의** ES·Kibana 컨테이너, 데이터·인증서·Kibana 볼륨, `.env`를 삭제합니다. ES·Kibana 이미지는 다른 컨테이너가 사용 중이지 않을 때만 삭제합니다. 개인 PBL 저장소와 강사 배포 저장소의 파일은 삭제하지 않습니다. 완료 후 `.env`를 다시 만들고 `preflight → pull-images → start → status` 순서로 실행합니다.
