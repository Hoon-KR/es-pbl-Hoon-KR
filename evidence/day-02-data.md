# Day 2 데이터 준비 결과

> 예시 문장을 복사하지 말고 자신의 실제 실행 결과를 작성합니다.
> 실행하지 않은 항목은 완료로 표시하지 않습니다.

## 1. Index와 문서

- Index 이름: `audio-devices-search`
- 문서 한 건의 의미: 특정 음향기기 모델 1개의 전체 스펙(브랜드, 가격, 연결 방식 등)과 종합 리뷰 요약 데이터
- 실제 색인 건수: 10,000건
- Mapping의 `dynamic` 설정: `strict`

## 2. 최종 Field

| Field | Type | 검색에서 사용할 목적 |
|---|---|---|
| `product_id` | keyword | 문서 고유 식별 및 상세 조회 |
| `product_name` | text | 제품명 전문 검색 |
| `brand` | keyword | 특정 브랜드 필터링 및 집계 |
| `category` | keyword | 폼팩터(이어폰, 헤드폰, 헤드셋) 정확도 필터 및 집계 |
| `connection` | keyword | 유·무선 여부 정확도 필터 |
| `price` | integer | 예산 범위 검색 및 가격순 정렬 |
| `features` | keyword | '노이즈 캔슬링', '방수' 등 주요 기능 필터 |
| `battery_hours` | integer | 최소 배터리 시간 범위 검색 및 정렬 |
| `rating` | float | 평점 범위 검색 및 평점순 정렬 |
| `review_summary` | text | 리뷰 키워드 전문 검색 |

## 3. 대량 데이터 생성·색인 결과

- 생성 건수: 10,000건
- 로컬 검증 결과: 10개의 필드가 매핑 규격 및 strict 조건에 맞게 누락 없이 생성됨을 표본 파일에서 확인
- Bulk 색인 결과: `curl.exe`를 통해 10,000건 모두 오류 없이 성공적으로 색인 완료 (`errors: false`)
- ES 실제 `_count`: 10,000건
- 분류·숫자·boolean 분포 확인 결과: 카테고리별 균등 분배 및 가격(범위), 평점(3.0~5.0), 기능 배열 데이터가 정상적으로 분포됨을 확인

## 4. Day 3 연결

- 검색 질문 기준: `docs/data-model.md`의 사용자 질문 3개 (노이즈 캔슬링/가격 조건, 리뷰 키워드/배터리 조건, 브랜드/평점 정렬 조건) 연동 확인 완료

## 5. 결과 파일 위치

- Mapping: `elasticsearch/index-create.json`
- 실행 요청: `elasticsearch/requests.http`
- 대표 문서: `data/generated/audio-devices-search-sample-30.ndjson`
- 데이터 생성 설정: `generator/generate-products.ps1`
- 생성 표본: `data/generated/audio-devices-search-sample-30.ndjson`
- 생성 요약: `data/generated/generation-summary.json`

## 6. Pipeline 적용 판단

- 적용 / 미적용 / 보류: 미적용
- 판단 이유: 데이터 생성 단계(PowerShell 스크립트)에서부터 필드 타입과 배열 형태가 요구사항에 맞게 완전히 가공되어 출력되므로, 색인 시점의 Ingest Pipeline 별도 가공이 불필요함.

## 7. 미완료·오류

- 없음 또는 현재 상태: 초기 `products` 인덱스로 잘못 적재되었던 오류를 수정 및 해결하고, 올바른 `audio-devices-search` 인덱스로 10,000건 재적재 완료. 오류 없음.
- 다음에 할 작업: Day 3 쿼리 DSL(Query DSL)을 활용하여 설계한 사용자 질문 3가지에 대한 검색 및 집계 실습 진행.