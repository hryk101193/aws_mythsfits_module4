resource "aws_dynamodb_table" "myfits_table" {
  name ="MysfitsTable"
  billing_mode = "PROVISIONED"
  read_capacity = 5
  write_capacity = 5
  hash_key = "MysfitId"

  attribute {
    name = "MysfitId"
    type = "S"
  }

  attribute {
    name = "GoodEvil"
    type = "S"
  }

  attribute {
    name = "LawChaos"
    type = "S"
  }

  global_secondary_index {
    name = "LawChaosIndex"
    hash_key = "LawChaos"
    range_key = "MysfitId"
    write_capacity = 5
    read_capacity = 5
    projection_type = "ALL"
  }

  global_secondary_index {
    name = "GoodEvilIndex"
    hash_key = "GoodEvil"
    range_key = "MysfitId"
    write_capacity = 5
    read_capacity = 5
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table_item" "myfits_item1" {
  table_name = aws_dynamodb_table.myfits_table.name
  hash_key = aws_dynamodb_table.myfits_table.hash_key

  item = <<ITEM
{
  "MysfitId":{"S": "4e53920c-505a-4a90-a694-b9300791f0ae"},
  "Name":{"S": "Evangeline"},
  "Species":{"S": "Chimera"},
  "Description":{"S": "Evangeline is the global sophisticate of the mythical world. You’d be hard pressed to find a more seductive, charming, and mysterious companion with a love for neoclassical architecture, and a degree in medieval studies. Don’t let her beauty and brains distract you. While her mane may always be perfectly coifed, her tail is ever-coiled and ready to strike. Careful not to let your guard down, or you may just find yourself spiraling into a dazzling downfall of dizzying dimensions."},
  "Age":{"N": "43"},
  "GoodEvil":{"S": "Evil"},
  "LawChaos":{"S": "Lawful"},
  "ThumbImageUri":{"S": "https://www.mythicalmysfits.com/images/chimera_thumb.png"},
  "ProfileImageUri":{"S": "https://www.mythicalmysfits.com/images/chimera_hover.png"},
  "Likes":{"N": "0"},
  "Adopted":{"BOOL": false}
}
ITEM
}

resource "aws_dynamodb_table_item" "myfits_item2" {
  table_name = aws_dynamodb_table.myfits_table.name
  hash_key = aws_dynamodb_table.myfits_table.hash_key

  item = <<ITEM
{
  "MysfitId":{"S": "2b473002-36f8-4b87-954e-9a377e0ccbec"},
  "Name":{"S": "Pauly"},
  "Species":{"S": "Cyclops"},
  "Description":{"S": "Naturally needy and tyrannically temperamental, Pauly the infant cyclops is searching for a parental figure to call friend. Like raising any precocious tot, there may be occasional tantrums of thunder, lightning, and 100 decibel shrieking. Sooth him with some Mandrake root and you’ll soon wonder why people even bother having human children. Gaze into his precious eye and fall in love with this adorable tyke."},
  "Age":{"N": "2"},
  "GoodEvil":{"S": "Neutral"},
  "LawChaos":{"S": "Lawful"},
  "ThumbImageUri":{"S": "https://www.mythicalmysfits.com/images/cyclops_thumb.png"},
  "ProfileImageUri":{"S": "https://www.mythicalmysfits.com/images/cyclops_hover.png"},
  "Likes":{"N": "0"},
  "Adopted":{"BOOL": false} 
}
ITEM
}

resource "aws_dynamodb_table_item" "myfits_item3" {
  table_name = aws_dynamodb_table.myfits_table.name
  hash_key = aws_dynamodb_table.myfits_table.hash_key

  item = <<ITEM
{
  "MysfitId":{"S": "0e37d916-f960-4772-a25a-01b762b5c1bd"},
  "Name":{"S": "CoCo"},
  "Species":{"S": "Dragon"},
  "Description":{"S": "CoCo wears sunglasses at night. His hobbies include dressing up for casual nights out, accumulating debt, and taking his friends on his back for a terrifying ride through the mesosphere after a long night of revelry, where you pick up the bill, of course. For all his swagger, CoCo has a heart of gold. His loyalty knows no bounds, and once bonded, you’ve got a wingman (literally) for life."},
  "Age":{"N": "501"},
  "GoodEvil":{"S": "Good"},
  "LawChaos":{"S": "Chaotic"},
  "ThumbImageUri":{"S": "https://www.mythicalmysfits.com/images/dragon_thumb.png"},
  "ProfileImageUri":{"S": "https://www.mythicalmysfits.com/images/dragon_hover.png"},
  "Likes":{"N": "0"},
  "Adopted":{"BOOL": false} 
}
ITEM
}