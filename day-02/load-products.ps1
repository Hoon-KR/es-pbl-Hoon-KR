[CmdletBinding()]
param(
  [string]$DataFile = (Join-Path $PSScriptRoot 'generated\products-10000.ndjson')
)

$ErrorActionPreference = 'Stop'
$dockerRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..\day-01\docker') -ErrorAction SilentlyContinue
if (-not $dockerRoot) { throw 'Docker 실습 패키지 경로를 찾지 못했습니다. 강사 배포본의 안내 경로에서 실행합니다.' }
if (-not (Test-Path -LiteralPath $DataFile)) { throw "데이터 파일이 없습니다: $DataFile" }

Push-Location $dockerRoot
try {
  if (-not (Test-Path -LiteralPath '.env')) { throw '.env가 없습니다. Docker 실습환경을 먼저 준비합니다.' }
  $containerId = (docker compose ps -q es01).Trim()
  if (-not $containerId) { throw 'es01 컨테이너가 실행 중이지 않습니다. .\start.ps1 후 다시 실행합니다.' }
  $password = (Get-Content .env | Where-Object { $_ -match '^ELASTIC_PASSWORD=' } | Select-Object -First 1).Split('=', 2)[1]
  docker cp $DataFile "${containerId}:/tmp/products-10000.ndjson"
  if ($LASTEXITCODE -ne 0) { throw 'Bulk 데이터 파일을 es01 컨테이너로 복사하지 못했습니다.' }
  $bulk = docker compose exec -T es01 sh -c "curl -s --cacert config/certs/ca/ca.crt -u 'elastic:$password' -H 'Content-Type: application/x-ndjson' -X POST 'https://localhost:9200/_bulk?refresh=wait_for&filter_path=errors' --data-binary @/tmp/products-10000.ndjson"
  if ($LASTEXITCODE -ne 0 -or $bulk -notmatch '"errors":false') { throw "Bulk 적재 실패: $bulk" }
  $count = docker compose exec -T es01 sh -c "curl -s --cacert config/certs/ca/ca.crt -u 'elastic:$password' 'https://localhost:9200/products/_count'"
  Write-Host "PASS: Bulk 적재 오류 없음. $count"
} finally {
  Pop-Location
}
