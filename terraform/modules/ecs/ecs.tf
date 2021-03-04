#ecs
resource "aws_ecs_service" "ecs_service" {
  name = var.ecs_service_name
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count = 2
  launch_type = "FARGATE"

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 0

  network_configuration {
    security_groups = [var.security_group_id]
    # falseにしてsgやnetworkを見直すべき。
    assign_public_ip = true
    subnets = [var.public_subnet_one_id, var.public_subnet_two_id]
  }

  load_balancer {
    container_name = "MythicalMysfits-Service"
    container_port = 8080
    target_group_arn = var.lb_target_group_arn
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "mythicalmysfitsservice"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = var.ecs_service_role_arn
  task_role_arn = var.ecs_task_role_arn
  container_definitions = data.template_file.container_definitions.rendered
}

data "template_file" "container_definitions" {
  template = file("../modules/ecs/task-definitions/service.json")
  vars = {
    ecr_image_url = var.ecr_repository_url
    region = var.region
    logs_group = var.log_group
  }
}

#cloud watch for ecs
resource "aws_cloudwatch_log_group" "log_group"{
  name = var.log_group
}