variable "region" {}
variable "public_subnet_one_id" {}
variable "public_subnet_two_id" {}
variable "security_group_id" {}
variable "lb_target_group_arn" {}
variable "ecs_service_role_arn" {}
variable "ecs_task_role_arn" {}
variable "ecr_repository_url" {}

variable "ecs_service_name" {}
variable "ecs_cluster_name" {}
variable "log_group"{}