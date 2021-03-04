#ecs service role

# # has been taken in this accountの場合はコメントアウト
# resource "aws_iam_service_linked_role" "ecs" {
#     aws_service_name = "ecs.amazonaws.com"
# }

resource "aws_iam_role" "ecs_service_role" {
  name = "ecs_service_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_assume_policy_doc.json
  path = "/"
}

resource "aws_iam_role_policy" "ecs_service_policy"{
    name = "ecs_service_policy"
    role = aws_iam_role.ecs_service_role.id
    policy = data.aws_iam_policy_document.ecs_service_policy_doc.json
}

data "aws_iam_policy_document" "ecs_service_assume_policy_doc"{
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "ecs_service_policy_doc"{
    statement {
        actions = [
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteNetworkInterfacePermission",
            "ec2:Describe*",
            "ec2:DetachNetworkInterface",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "iam:PassRole",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:DescribeLogStreams",
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
        ]
        effect = "Allow"
        resources = [ "*" ]
    }
}

#ecs task role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_policy_doc.json
  path = "/"
}

resource "aws_iam_role_policy" "ecs_task_policy"{
    name = "ecs_task_policy"
    role = aws_iam_role.ecs_task_role.id
    policy = data.aws_iam_policy_document.ecs_task_policy_doc.json
}

data "aws_iam_policy_document" "ecs_task_assume_policy_doc"{
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "ecs_task_policy_doc"{
    statement {
        actions = [
           "ecr:GetAuthorizationToken",
           "ecr:BatchCheckLayerAvailability",
           "ecr:GetDownloadUrlForLayer",
           "ecr:BatchGetImage",
           "logs:CreateLogStream",
           "logs:CreateLogGroup",
           "logs:PutLogEvents"
        ]
        effect = "Allow"
        resources = [ "*" ]
    }

    statement {
        actions = [
           "dynamodb:Scan",
           "dynamodb:Query",
           "dynamodb:UpdateItem",
           "dynamodb:GetItem"
        ]
        effect = "Allow"
        resources = [ "arn:aws:dynamodb:*:*:table/MysfitsTable*" ]
    }
}

#code pipeline role
resource "aws_iam_role" "code_pipeline_role" {
  name = "code_pipeline_role"
  assume_role_policy = data.aws_iam_policy_document.code_pipeline_assume_policy_doc.json
  path = "/"
}

resource "aws_iam_role_policy" "code_pipeline_policy"{
    name = "code_pipeline_policy"
    role = aws_iam_role.code_pipeline_role.id
    policy = data.aws_iam_policy_document.code_pipeline_policy_doc.json
}

data "aws_iam_policy_document" "code_pipeline_assume_policy_doc"{
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["codepipeline.amazonaws.com"]
        }
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "code_pipeline_policy_doc"{
    version = "2012-10-17"
    statement {
        actions = [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:UploadArchive",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:CancelUploadArchive"
        ]
        effect = "Allow"
        resources = ["*"]
    }

    statement {
        actions = [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning"
        ]
        effect = "Allow"
        resources = ["*"]
    }

    statement {
        actions = [
            "s3:PutObject"
        ]
        effect = "Allow"
        resources = ["arn:aws:s3:::*"]
    }

    statement {
        actions = [
            "elasticloadbalancing:*",
            "autoscaling:*",
            "cloudwatch:*",
            "ecs:*",
            "codebuild:*",
            "iam:PassRole"
        ]
        effect = "Allow"
        resources = ["*"]
    }
}

#code build role
resource "aws_iam_role" "code_build_role" {
  name = "code_build_role"
  assume_role_policy = data.aws_iam_policy_document.code_build_assume_policy_doc.json
  path = "/"
}

resource "aws_iam_role_policy" "code_build_policy"{
    name = "code_build_policy"
    role = aws_iam_role.code_build_role.id
    policy = data.aws_iam_policy_document.code_build_policy_doc.json
}

data "aws_iam_policy_document" "code_build_assume_policy_doc"{
    version = "2012-10-17"
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["codebuild.amazonaws.com"]
        }
        effect = "Allow"
    }
}

data "aws_iam_policy_document" "code_build_policy_doc"{
    version = "2012-10-17"
    statement {
        actions = [
            "codecommit:ListBranches",
            "codecommit:ListRepositories",
            "codecommit:BatchGetRepositories",
            "codecommit:Get*",
            "codecommit:GitPull"
        ]
        effect = "Allow"
        resources = ["arn:aws:codecommit:${var.region}:${var.account_id}:MythicalMysfitsServiceRepository"]
    }

    statement {
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        effect = "Allow"
        resources = ["*"]
    }

    statement {
        actions = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:ListBucket"
        ]
        effect = "Allow"
        resources = ["*"]
    }

    statement {
        actions = [
            "ecr:InitiateLayerUpload",
            "ecr:GetAuthorizationToken"
        ]
        effect = "Allow"
        resources = ["*"]
    }
}

#code commit
resource "aws_iam_user" "code_commit" {
  name = "code_commit"
  path = "/"
}

resource "aws_iam_user_ssh_key" "code_commit_ssh" {
  username = aws_iam_user.code_commit.name
  encoding = "SSH"
  public_key = file("../modules/iam/aws_code_commit.pub")
}

resource "aws_iam_user_policy" "code_commit" {
  name = "code_commit"
  user = aws_iam_user.code_commit.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codecommit:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}