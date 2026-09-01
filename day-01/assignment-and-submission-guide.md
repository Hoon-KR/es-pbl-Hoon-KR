# PBL 제출 안내

개인 저장소 이름은 `es-pbl-<github-id>`를 권장합니다. Public 저장소로 만들고 URL을 강사에게 제출합니다.

강사 배포 저장소는 교재·예제·Docker 환경을 받는 곳이고, 개인 저장소는 내 PBL 산출물을 작성·제출하는 곳입니다. Day 1에는 `README-template.md`, `SUBMISSION-template.md`, `pbl-start-card.md`, `data-model-template.md`, `dashboard-plan-template.md`를 개인 저장소로 각각 `README.md`, `SUBMISSION.md`, `docs/pbl-start-card.md`, `docs/data-model.md`, `docs/dashboard-plan.md`로 복사합니다. Day 2에는 `pbl-data-template/` 전체를 `data/pbl-data-template/`로, Day 3에는 `QUALITY_TEST_TEMPLATE.md`를 `docs/quality-test.md`로 복사합니다.

## 최소 제출 파일

```text
README.md
SUBMISSION.md
elasticsearch/index-create.json
elasticsearch/requests.http
data/generator/
data/sample.ndjson
evidence/dashboard.png
```

긴 설명이 필요할 때만 `docs/`를 추가합니다. `kibana/dashboard.ndjson`은 선택 제출입니다.

## 일일 commit

- Day 1: README 프로젝트 소개와 Docker 확인
- Day 2: mapping·생성기·Bulk 적재
- Day 3: 검색·filter·정렬·테스트
- Day 4: 집계·Dashboard
- Day 5: README 보완·최종 `SUBMISSION.md`

`SUBMISSION.md`에는 평가받을 최종 commit SHA를 적습니다.
