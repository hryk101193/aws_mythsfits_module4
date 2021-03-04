# code build
resource "aws_codebuild_project" "codebuild" {
  name = var.codebuild_project
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/python:3.5.2"
    type = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.region
    }
  }
  service_role = var.codebuild_role_arn
  source {
    type = "CODECOMMIT"
    location = "https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.codecommit_repository}"
  }
}

#code pipeline
resource "aws_codepipeline" "code_pipeline" {
  name = "MythicalMysfitsServiceCICDPipeline"
  role_arn = var.code_pipeline_role_arn
  artifact_store {
    type = "S3"
    location = var.s3_cicd_bucket
  }
  stage {
    name = "Source"
    action {
      name = "Source"
      input_artifacts = []
      category = "Source"
      owner = "AWS"
      version = "1"
      provider = "CodeCommit"
      output_artifacts = [var.stage_source_artifact]
      configuration = {
        "BranchName" = "master"
        "RepositoryName" = var.codecommit_repository
      }
      run_order = 1
    }
  }

  stage {
    name = "Build"
    action {
      name = "Build"
      input_artifacts = [var.stage_source_artifact]
      category = "Build"
      owner = "AWS"
      version = "1"
      provider = "CodeBuild"
      output_artifacts = [var.stage_build_artifact]
      configuration = {
        "ProjectName" = var.codebuild_project
      }
      run_order = 1
    }
  }

  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      input_artifacts = [var.stage_build_artifact]
      category = "Deploy"
      owner = "AWS"
      version = "1"
      provider = "ECS"
      configuration = {
        "ClusterName" = var.ecs_cluster_name
        "ServiceName" = var.ecs_service_name
        "FileName" = "imagedefinitions.json"
      }
      run_order = 1
    }
  }
}