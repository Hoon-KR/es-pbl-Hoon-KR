# 메모장에서 '=' 오른쪽 값과 field 규칙만 자신의 주제에 맞게 바꿉니다.
# 이 파일은 생성기가 읽는 PowerShell 변수 설정입니다. 제공된 형식을 유지하고 값과 규칙만 수정합니다.

$IndexName = 'audio-devices-search'
$DocumentCount = 1000
$Seed = 20260901
$IdPrefix = 'AD-'
$IdField = 'product_id'
$SampleCount = 30

# choice와 tags 규칙이 참조하는 도메인별 후보 목록입니다.
$Vocabularies = [ordered]@{
  brands = @('Sony', 'Bose', 'Apple', 'Samsung', 'JBL', 'Sennheiser', 'Anker', 'QCY')
  categories = @('이어폰', '헤드폰', '헤드셋')
  features = @('노이즈 캔슬링', '방수', '공간음향', '멀티포인트', '고음질', '전용앱')
  reviews = @(
    '저음이 강조되고 운동용으로 딱입니다.',
    '노이즈 캔슬링이 완벽해서 작업할 때 좋아요.',
    '10만원 이하 가성비 제품 중에서는 최고입니다.',
    '배터리가 오래가서 충전 스트레스가 없어요.',
    '음질은 무난하지만 착용감이 정말 편안합니다.'
  )
}

# 문서는 위에서 아래 순서로 만들어집니다.
# template는 앞에서 만든 field와 {{sequence}}을 사용할 수 있습니다.
$FieldRules = @(
  @{ Name = 'product_id'; Kind = 'id'; Digits = 4 }
  @{ Name = 'brand'; Kind = 'choice'; Source = 'brands' }
  @{ Name = 'category'; Kind = 'choice'; Source = 'categories' }
  @{ Name = 'connection'; Kind = 'weighted_choice'; Values = @(
      @{ Value = '무선'; Weight = 60 },
      @{ Value = '완전무선'; Weight = 30 },
      @{ Value = '유선'; Weight = 10 }
    ) }
  @{ Name = 'price'; Kind = 'integer'; Min = 10000; Max = 500000 }
  @{ Name = 'battery_hours'; Kind = 'integer'; Min = 5; Max = 80 }
  @{ Name = 'rating'; Kind = 'decimal'; Min = 3.0; Max = 5.0; Digits = 1 }
  @{ Name = 'features'; Kind = 'tags'; Source = 'features'; MinItems = 1; MaxItems = 3; MissingRatio = 0.05 }
  @{ Name = 'product_name'; Kind = 'template'; Template = '{{brand}} {{category}} 에디션 {{sequence}}' }
  @{ Name = 'review_summary'; Kind = 'choice'; Source = 'reviews' }
)