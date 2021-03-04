output "code_build_role_arn"{
	value = aws_iam_role.code_build_role.arn
}
output "code_pipeline_role_arn"{
	value = aws_iam_role.code_pipeline_role.arn
}
output "ecs_service_role_arn"{
	value = aws_iam_role.ecs_service_role.arn
}
output "ecs_task_role_arn"{
	value = aws_iam_role.ecs_task_role.arn
}