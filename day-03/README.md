# Day 3 — 검색 기능 구현

## 개인 PBL 품질 기록표 만들기

강사 배포 저장소의 품질 기록표를 개인 PBL 저장소로 복사한 뒤, 내 검색 질문으로 작성합니다. 쇼핑몰 예제의 질문·field 이름은 그대로 제출하지 않습니다.

```powershell
$course = "C:\수업\es-5days-pbl-course"
$pbl = "C:\수업\es-pbl-내GitHub아이디"

New-Item -ItemType Directory -Force "$pbl\docs"
Copy-Item "$course\day-03\QUALITY_TEST_TEMPLATE.md" "$pbl\docs\quality-test.md"
```

`docs/quality-test.md`에는 전문 검색 1개, 정확 조건 검색 1개, bool/filter 검색 1개와 기대·실제 결과·개선 근거를 기록합니다.

오늘은 검색 질문을 Search API 요청으로 바꾸고, 전문 검색·정확 조건·filter·sort·highlight를 구현합니다.

## 완료 기준

- 검색 질문 3개를 요청 파일로 저장했다.
- filter 2개와 sort 2개를 구현했다.
- 기대 결과와 실제 결과를 비교해 개선 1건을 기록했다.

## 제공 자료

- `requests/04-search-and-quality.http`: 전문 검색, 정확 조건, bool/filter, 정렬, highlight 예시
- `QUALITY_TEST_TEMPLATE.md`: 학생 PBL 검색 품질 점검표

쇼핑몰 요청의 필드명·검색어·필터 기준을 자신의 주제로 바꾸되, 공통 데이터 스키마에 없는 임의 필드를 추가하지 않습니다.
