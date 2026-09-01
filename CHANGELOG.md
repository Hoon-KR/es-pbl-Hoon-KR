# 학생 배포 변경 기록

## 2026-09-01 — Day 3 교시별 실습 문제지 추가

- `day-03/practice/`에 교시별 문제지 8개를 추가했다.
- 매 교시는 제공 코드를 실행해 결과를 기록하는 공통 문제 1개, 조건만 보고 Search API 전체를 직접 구현하는 공통 문제 2개, 자기 index·mapping·데이터에 적용하는 개인 PBL 문제 2개로 구성한다.
- 전체 문제 수는 공통 24개, 개인 16개, 총 40개다. 기존 `requests/04-search-and-quality.http`는 완성 요청 참고 코드로 유지한다.
- 학생은 문제지를 개인 저장소 `evidence/day-03-practice/`에 복사해 답을 작성하고, 완성한 개인 요청은 루트 `requests.http`에 정리한다.

## 2026-09-01 — Day 3 검색·품질 실습 공개

- Day 3 학생교재와 수업 진입 README를 추가했다.
- Search API, term/match, multi_match/match_phrase, filter/range, bool, sort/highlight, 0건 진단, 개인 PBL 통합을 교시별로 구성했다.
- 공통 요청 24개와 검색 품질 점검표를 제공한다. 모든 JSON body의 정적 파싱을 확인했다.
- 개인 산출물은 루트 `requests.http`(`V1-T17-P`~`V1-T21-P`), `docs/quality-test.md`, `evidence/day-03-search.md`다.
- 실제 `.env`, 비밀번호, 강사용 PPT·대본·정답, Day4~5 자료는 포함하지 않았다.

## 2026-09-01 — Day 2 폴더·교재 이름 정리

- 버전명 대신 내용을 드러내도록 `day-02/v1/`을 `day-02/practice/`(실습 안내·요청·작성 양식)로 변경했다.
- 교재 본문은 `day-02/student-workbook.md`로 통합했다. 이전 student-workbook-v1.md 링크는 새 교재로 바꾼다.
- 현재 안내 문서와 요청 파일의 관련 링크를 모두 갱신했다. 수업 내용·슬라이드/실습 ID·데이터·생성기·적재 명령은 변경하지 않았다.
- 기존 자료는 Git 이력에 남는다. 업데이트 후 [Day 2 시작 안내](day-02/README.md)의 새 링크를 사용한다.

## 2026-09-01 — Day 2 v1 최초 공개

- 현재 69장 수업에 맞춘 학생교재·실습/제출 안내·문서 작성 양식을 추가했다.
- 공통 products의 전체 mapping, 생성기, 합성10000건/표본30건/요약, Bulk 적재 도구와 수업순 요청을 제공한다.
- 개인1000건의 생성·검증·적재 도구, 설정 예시와 주제별 작성 가이드를 제공한다.
- DELETE의 refresh 옵션과 이후 count 확인을 구분하고, Day1의 간략 경로와 Day2의 구체적 작업 경로를 설명했다.
- ES9.5.0 3노드의 별도 시험 index에서 CRUD·공통10000건·개인1000건·pipeline을 실행해 확인했다. 생성/검증 시험20개와 개인 loader 모의시험5개도 통과했다.
- Day1 파일은 유지한다. v2·강사용 PPT/대본/정답·실제 비밀정보·Day3~5 자료는 이번 공개에 포함하지 않는다.

강사 배포 저장소에서 `git pull --ff-only origin main`으로 받는다. 시작점은 [Day 2 README](day-02/README.md)다.
