#ecr
resource "aws_ecr_repository" "ecr_repository" {
  name = "mythicalmysfits/service"
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy = data.template_file.ecr_repository_policy.rendered
}

data "template_file" "ecr_repository_policy" {
  template = file("../modules/ecr/ecr-policy.json")
  vars = {
    codebuild_role_arn = var.code_build_role_arn
  }
}