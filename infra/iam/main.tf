resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "codedeploy-permissions"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["ec2:*", "elasticloadbalancing:*", "autoscaling:*"],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "pipeline_role" {
  name = "codepipeline-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "pipeline-permissions"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["s3:*", "codedeploy:*", "codebuild:*"],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "codebuild_role" {
  name = "dev-test-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "dev-test-codebuild-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.artifact_bucket_name}",
          "arn:aws:s3:::${var.artifact_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codepipeline:PutJobSuccessResult",
          "codepipeline:PutJobFailureResult",
          "codepipeline:PollForJobs"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}
