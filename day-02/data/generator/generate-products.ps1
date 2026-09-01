[CmdletBinding()]
param(
  [int]$Count = 10000,
  [int]$Seed = 9502026,
  [string]$Index = 'audio-devices-search',
  [string]$OutputDir
)

$ErrorActionPreference = 'Stop'
if (-not $OutputDir) {
  $OutputDir = Join-Path (Split-Path -Parent $PSScriptRoot) 'generated'
}
if ($Count -lt 30) { throw 'Count는 샘플 데이터 생성을 위해 30 이상이어야 합니다.' }

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$null = New-Item -ItemType Directory -Force -Path $OutputDir
if ($Index -notmatch '^[a-z0-9][a-z0-9_-]*$') { throw 'Invalid classroom index name.' }
$bulkPath = Join-Path $OutputDir ("{0}-{1}.ndjson" -f $Index,$Count)
$samplePath = Join-Path $OutputDir ("{0}-sample-30.ndjson" -f $Index)
$summaryPath = Join-Path $OutputDir 'generation-summary.json'
$rng = [System.Random]::new($Seed)

$catalog = [ordered]@{
  '이어폰' = @{ brands = @('Sony','Apple','Samsung','JBL','QCY'); items = @('인이어 이어폰','오픈형 이어폰','스포츠 이어폰'); features = @('노이즈 캔슬링','방수','멀티포인트','고음질','전용앱'); connection = @('무선','완전무선','유선'); min = 15000; max = 350000 }
  '헤드폰' = @{ brands = @('Sony','Bose','Sennheiser','Apple','Anker'); items = @('오버이어 헤드폰','온이어 헤드폰','스튜디오 헤드폰'); features = @('노이즈 캔슬링','공간음향','멀티포인트','고해상도오디오','접이식'); connection = @('무선','유선'); min = 50000; max = 600000 }
  '헤드셋' = @{ brands = @('Logitech','Razer','HyperX','Corsair','JBL'); items = @('게이밍 헤드셋','오피스 헤드셋','방송용 헤드셋'); features = @('마이크노이즈캔슬링','가상7.1채널','RGB라이팅','무선충전','가벼운무게'); connection = @('무선','유선'); min = 30000; max = 400000 }
}

$reviews = @(
  '저음이 강조되고 운동용으로 딱입니다.',
  '노이즈 캔슬링이 완벽해서 작업할 때 좋아요.',
  '10만원 이하 가성비 제품 중에서는 최고입니다.',
  '배터리가 오래가서 충전 스트레스가 없어요.',
  '음질은 무난하지만 착용감이 정말 편안합니다.',
  '통화 품질이 좋아서 회의할 때 자주 씁니다.',
  '디자인이 예쁘고 공간음향 기능이 아주 좋습니다.'
)

function Pick([object[]]$Values) { return $Values[$rng.Next($Values.Count)] }
function Write-BulkPair($Writer, $Document) {
  $action = [ordered]@{ index = [ordered]@{ _index = $Index; _id = $Document.product_id } }
  $Writer.WriteLine(($action | ConvertTo-Json -Compress))
  $Writer.WriteLine(($Document | ConvertTo-Json -Compress -Depth 4))
}

$categories = @($catalog.Keys)
$categoryCounts = [ordered]@{}
foreach ($category in $categories) { $categoryCounts[$category] = 0 }
$bulkWriter = [System.IO.StreamWriter]::new($bulkPath, $false, $utf8NoBom)
$sampleWriter = [System.IO.StreamWriter]::new($samplePath, $false, $utf8NoBom)
try {
  for ($number = 1; $number -le $Count; $number++) {
    $category = $categories[($number - 1) % $categories.Count]
    $spec = $catalog[$category]
    $priceMin = [int]([math]::Floor($spec.min / 100) * 100)
    $priceMax = [int]([math]::Floor($spec.max / 100) * 100)
    
    $selectedBrand = Pick $spec.brands
    $features = @($spec.features | Sort-Object { $rng.Next() } | Select-Object -First (1 + $rng.Next(3)))
    
    $document = [ordered]@{
      product_id = ('AD-{0:d5}' -f $number)
      product_name = ('{0} {1} {2}' -f $selectedBrand, (Pick @('프로','에디션','스탠다드','플러스','에어')), (Pick $spec.items))
      brand = $selectedBrand
      category = $category
      connection = Pick $spec.connection
      price = $rng.Next($priceMin / 100, ($priceMax / 100) + 1) * 100
      features = $features
      battery_hours = $rng.Next(5, 81)
      rating = [math]::Round((3.0 + $rng.NextDouble() * 2.0), 1)
      review_summary = Pick $reviews
    }
    
    Write-BulkPair $bulkWriter $document
    if ($number -le 30) { Write-BulkPair $sampleWriter $document }
    $categoryCounts[$category]++
  }
} finally {
  $bulkWriter.Dispose()
  $sampleWriter.Dispose()
}

$summary = [ordered]@{
  index = $Index
  document_count = $Count
  seed = $Seed
  files = [ordered]@{ bulk = (Split-Path -Leaf $bulkPath); sample = (Split-Path -Leaf $samplePath) }
  category_counts = $categoryCounts
  generated_at = 'deterministic-from-seed'
}
[System.IO.File]::WriteAllText($summaryPath, (($summary | ConvertTo-Json -Depth 5) + [Environment]::NewLine), $utf8NoBom)
$summary | ConvertTo-Json -Depth 5