#S3バケットの作成
resource "aws_s3_bucket" "s3_for_mythical" {
  bucket = var.web_bucket
  acl    = "public-read"
  policy = data.template_file.web_bucket_policy.rendered

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

data "template_file" "web_bucket_policy" {
  template = file("../modules/storage/website-bucket-policy.json")
  vars = {
    web_bucket = var.web_bucket
  }
}

# S3保存ファイル
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "index.html"
  content = data.template_file.index_html.rendered
  content_type = "text/html"
}

data "template_file" "index_html" {
  template = file("../modules/storage/web/index.html")
  vars = {
    region = var.region
    mysfits_api_endpoint = "https://${var.api_id}.execute-api.${var.region}.amazonaws.com/staging"
    cognito_user_pool_id = var.cognito_user_pool_id
    cognito_user_pool_client_id = var.cognito_user_pool_client_id
  }
}

resource "aws_s3_bucket_object" "register" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "register.html"
  content = data.template_file.register_html.rendered
  content_type = "text/html"
}

data "template_file" "register_html" {
  template = file("../modules/storage/web/register.html")
  vars = {
    cognito_user_pool_id = var.cognito_user_pool_id
    cognito_user_pool_client_id = var.cognito_user_pool_client_id
  }
}

resource "aws_s3_bucket_object" "confirm" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "confirm.html"
  content = data.template_file.confirm_html.rendered
  content_type = "text/html"
}

data "template_file" "confirm_html" {
  template = file("../modules/storage/web/confirm.html")
  vars = {
    cognito_user_pool_id = var.cognito_user_pool_id
    cognito_user_pool_client_id = var.cognito_user_pool_client_id
  }
}

resource "aws_s3_bucket_object" "amazon_cognito_identity" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "js/amazon-cognito-identity.min.js"
  source = "../modules/storage/web/js/amazon-cognito-identity.min.js"
}

resource "aws_s3_bucket_object" "aws_cognito_sdk" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "js/aws-cognito-sdk.min.js"
  source = "../modules/storage/web/js/aws-cognito-sdk.min.js"
}

resource "aws_s3_bucket_object" "aws_sdk" {
  bucket = aws_s3_bucket.s3_for_mythical.id
  key = "js/aws-sdk-2.246.1.min.js"
  source = "../modules/storage/web/js/aws-sdk-2.246.1.min.js"
}

#s3 bucket for cidi
resource "aws_s3_bucket" "s3_for_mythical_code" {
  bucket = var.cidi_bucket
  policy = data.template_file.cidi_bucket_policy.rendered
}

data "template_file" "cidi_bucket_policy" {
  template = file("../modules/storage/artifacts-bucket-policy.json")
  vars = {
      cidi_bucket = var.cidi_bucket,
      code_build_policy_arn = var.code_build_role_arn,
      code_pipeline_role_arn = var.code_pipeline_role_arn
  }
}