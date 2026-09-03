$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$localEnv = Join-Path $PSScriptRoot '.env'
$courseEnv = Join-Path $PSScriptRoot '..\day-01\docker\.env'
$envFile = if (Test-Path -LiteralPath $localEnv) { $localEnv } elseif (Test-Path -LiteralPath $courseEnv) { $courseEnv } else { $null }
if (-not $envFile) { throw '.env를 찾을 수 없습니다.' }
docker compose --env-file $envFile down
if ($LASTEXITCODE -ne 0) { throw '검색 앱 종료에 실패했습니다.' }
Write-Host '검색 앱을 종료했습니다.'
