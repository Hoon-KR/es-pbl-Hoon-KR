# Day 1 — ES 시작, PBL 주제, Docker 환경

## 오늘의 완료 기준

- [ ] ES가 내 프로젝트에서 맡을 역할을 한 문장으로 적었다.
- [ ] PBL 주제와 사용자·검색 질문 3개를 초안으로 만들었다.
- [ ] 개인 GitHub PBL 저장소를 만들고 첫 commit을 남겼다.
- [ ] Docker 환경에서 ES 3노드와 Kibana 접속을 확인했다.
- [ ] 첫 REST 요청의 결과를 확인했다.

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
