resource "aws_codebuild_project" "build_project" {
  name          = "${var.project_name}-build"
  description   = "Build project for the application"
  service_role  = var.codebuild_role_arn

  artifacts {
    type     = "CODEPIPELINE"   # Artifacts should be CODEPIPELINE when using CodePipeline source
    packaging = "ZIP"
  }

  source {
    type     = "CODEPIPELINE"   # Source should be CODEPIPELINE for CodePipeline integration
    buildspec = "blue_green/app/buildspec.yaml"  # Path to buildspec inside source code
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0" # Includes Python
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

#   source {
#     type            = "CODEPIPELINE"
#     buildspec       = file("${path.module}/blue_green/app/buildspec.yml")
#   }

  tags = {
    Name        = "${var.project_name}-build"
    Environment = var.environment
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = "github-python-app-pipeline"
  role_arn = var.pipeline_role

  artifact_store {
    location = var.pipeline_bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]
      configuration = {
        ApplicationName = var.app_name
        DeploymentGroupName = var.deployment_group_name
      }
    }
  }
}
