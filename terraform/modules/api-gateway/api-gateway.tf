resource "aws_api_gateway_vpc_link" "vpc_link" {
    name = "MysfitsApiVpcLink"
    target_arns = [var.lb_arn]
}

resource "aws_api_gateway_rest_api" "rest_api" {
    name = "MysfitsApi"
    body = data.template_file.swagger.rendered
    endpoint_configuration {
      types = ["REGIONAL"]
    }
}

data "template_file" "swagger" {
    template = file("../modules/api-gateway/api-swagger.json")
    vars = {
        region = var.region
        my_account_id = var.my_account_id
        cognito_user_pool_id = var.cognito_user_pool_id
        vpc_link_id = aws_api_gateway_vpc_link.vpc_link.id
        nlb_dns = var.lb_dns_name
    }
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "staging"

  triggers = {
    redeployment = "v0.1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/staging
# https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/staging/mysfits
# で接続