#terraform version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#set provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#IAM
module "iam"{
  source = "../modules/iam"
  region = var.region
  account_id = var.account_id
}

#codecommit repository
module "codecommit_repository" {
  source = "../modules/codecommit-repository"

  codecommit_repository = "MythicalMysfitsService-Repository"
}

#S3
module "storage"{
	source = "../modules/storage"
  web_bucket = "hryk-mythicalmysfits"
  cidi_bucket = "hryk-cidi"

  api_id = module.api_gateway.api_id
  code_build_role_arn = module.iam.code_build_role_arn
  code_pipeline_role_arn = module.iam.code_pipeline_role_arn
  depends_on = [module.iam, module.elb, module.cognito]
  region = var.region
  cognito_user_pool_id = module.cognito.cognito_user_pool_id
  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
}

#VPC
module "network"{
  source = "../modules/network"
  region = var.region
  prefix = var.prefix
}

#elb
module "elb" {
  source = "../modules/elb"
  vpc_id = module.network.vpc_id
  public_subnet_one_id = module.network.public_subnet_one_id
  public_subnet_two_id = module.network.public_subnet_two_id
}

#ecr
module "ecr"{
  source = "../modules/ecr"
  code_build_role_arn = module.iam.code_build_role_arn
}

#ecs
module "ecs" {
  source = "../modules/ecs"

  ecs_service_name = "MythicalMysfits-Service"
  ecs_cluster_name = "MythicalMysfits-Cluster"
  log_group = "mythicalmysfits-logs"

  region = var.region
  public_subnet_one_id = module.network.public_subnet_one_id
  public_subnet_two_id = module.network.public_subnet_two_id
  security_group_id = module.network.security_group_id
  lb_target_group_arn = module.elb.lb_target_group_arn
  ecs_service_role_arn = module.iam.ecs_service_role_arn
  ecs_task_role_arn = module.iam.ecs_task_role_arn
  ecr_repository_url = module.ecr.ecr_repository_url

  depends_on = [module.elb]
}

#cicd
module "cicd" {
  source = "../modules/cicd"

  codecommit_repository = module.codecommit_repository.codecommit_repository_name
  codebuild_project = "MythicalMysfitsServiceCodeBuildProject"
  stage_source_artifact = "MythicalMysfitsService-SourceArtifact"
  stage_build_artifact = "MythicalMysfitsService-BuildArtifact"

  region = var.region
  account_id = var.account_id
  codebuild_role_arn = module.iam.code_build_role_arn
  code_pipeline_role_arn = module.iam.code_pipeline_role_arn
  s3_cicd_bucket = module.storage.s3_cicd_bucket
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
}

#dynamodb
module "dynamodb"{
  source = "../modules/dynamodb"
}

# cognito
module "cognito"{
  source = "../modules/cognito"
}

# api-gateway
module "api_gateway" {
  source = "../modules/api-gateway"

  lb_arn = module.elb.lb_arn

  region = var.region
  my_account_id = var.account_id
  cognito_user_pool_id = module.cognito.cognito_user_pool_id
  lb_dns_name = module.elb.lb_dns_name
}