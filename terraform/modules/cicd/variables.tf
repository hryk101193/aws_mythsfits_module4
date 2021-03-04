variable "codecommit_repository" {}
variable "codebuild_project" {}
variable "stage_source_artifact" {}
variable "stage_build_artifact" {}

variable "region" {}
variable "account_id" {}
variable "codebuild_role_arn" {}
variable "code_pipeline_role_arn" {}
variable "s3_cicd_bucket" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}