# 학생 공개 자료 — 일별 공개 전 확인

이 문서는 강사가 각 Day 폴더를 공개하기 직전에 확인하는 공개 범위 체크리스트입니다. 학생은 내용을 수정할 필요가 없습니다.

## 모든 Day 공통

- [ ] 해당 Day의 README.md와 student-workbook.md가 있다.
- [ ] 교재가 안내한 요청·데이터·Kibana 파일이 실제 경로에 있다.
- [ ] 실제 .env, 비밀번호, API key, 개인정보, 강사용 PPT·대본·정답·평가 메모가 없다.
- [ ] Elasticsearch·Kibana 버전 표기가 9.5.0으로 일치한다.
- [ ] 다음 Day 이후의 학생용 자료를 미리 공개하지 않는다.

## Day별 추가 확인

- Day 1: Docker Desktop 설치 안내, pull-images.ps1, start.ps1, status.ps1을 확인한다.
- Day 2: mapping, 생성기, 10,000건 NDJSON과 Bulk 요청을 확인한다.
- Day 3: 검색 요청과 품질 테스트 양식을 확인한다.
- Day 4: aggregation 요청, Dashboard 기준, 공개 가능한 예시 화면과 NDJSON을 확인한다.
- Day 5: ES|QL 요청, 제출·발표 안내를 확인한다. AI Search 구현용 비밀정보나 API 요청은 포함하지 않는다.
