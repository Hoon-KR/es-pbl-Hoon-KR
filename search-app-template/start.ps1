$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw 'Docker 명령을 찾을 수 없습니다. Docker Desktop을 먼저 실행하세요.'
}
docker info | Out-Null

$localEnv = Join-Path $PSScriptRoot '.env'
$courseEnv = Join-Path $PSScriptRoot '..\day-01\docker\.env'
if (Test-Path -LiteralPath $localEnv) {
  $envFile = $localEnv
} elseif (Test-Path -LiteralPath $courseEnv) {
  $envFile = $courseEnv
  Write-Host 'Day 1 Docker의 .env를 사용합니다.'
} else {
  Write-Host '개인 저장소에서 처음 실행하는 것으로 확인했습니다.'
  if ($env:ELASTIC_PASSWORD) {
    $plainPassword = $env:ELASTIC_PASSWORD
  } else {
    $securePassword = Read-Host 'Day 1 ES의 elastic 비밀번호를 입력하세요' -AsSecureString
    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try {
      $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
    } finally {
      [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
    }
  }
  if ([string]::IsNullOrWhiteSpace($plainPassword) -or $plainPassword -match "[`r`n]") {
    throw '비밀번호가 비어 있거나 줄바꿈을 포함합니다.'
  }
  @(
    'APP_PORT=3000'
    'ES_URL=https://host.docker.internal:9200'
    'ES_USERNAME=elastic'
    "ELASTIC_PASSWORD=$plainPassword"
    'ES_TLS_REJECT_UNAUTHORIZED=false'
  ) | Set-Content -LiteralPath $localEnv -Encoding utf8
  $plainPassword = $null
  $envFile = $localEnv
  Write-Host '.env를 자동 생성했습니다. 이 파일은 GitHub에 올라가지 않습니다.'
}

docker compose --env-file $envFile up --build --detach
if ($LASTEXITCODE -ne 0) { throw '검색 앱 시작에 실패했습니다.' }

$portLine = Get-Content -LiteralPath $envFile | Where-Object { $_ -match '^APP_PORT=' } | Select-Object -First 1
$appPort = if ($portLine) { $portLine.Substring('APP_PORT='.Length) } else { '3000' }
Write-Host ''
Write-Host "검색 앱이 시작되었습니다: http://localhost:$appPort"
Write-Host '설정 변경 후 브라우저에서 다시 검색하면 바로 반영됩니다.'
