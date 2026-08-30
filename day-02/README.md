# Day 2 — 데이터 모델링과 적재

오늘은 문서 모델·mapping·analyzer·CRUD·Bulk 적재를 완성합니다.

## 완료 기준

- 대표 문서 3건과 핵심 필드 목록을 설계했다.
- `text`, `keyword`, 숫자, 날짜 필드를 구분해 mapping을 만들었다.
- 생성기로 1,000건 이상을 만들고 Bulk 오류 없이 적재했다.

## 제공 자료

- `data/product-mapping.json`
- `data/generator/generate-products.ps1`
- `data/requests/01-create-products.http`
- `data/load-products.ps1`
- `data/requests/02-verify-products.http`
- `requests/03-analyze-and-crud.http`
- `pbl-data-template/` — 개인 주제용 설정 기반 더미 데이터 생성·Bulk 적재 템플릿

자신의 PBL에는 쇼핑몰 필드명을 그대로 복사하지 말고, 문서 단위와 검색 질문에 맞게 바꿉니다.

`pbl-data-template/README.md`의 순서대로 템플릿을 개인 저장소로 복사합니다. 학생은 메모장으로 `my-data-settings.ps1`을 수정하고, 제공된 PowerShell 생성기로 NDJSON을 만든 뒤 Bulk로 적재합니다.
