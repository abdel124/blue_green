output "codedeploy_role_arn" {
  description = "IAM role ARN for CodeDeploy"
  value       = aws_iam_role.codedeploy_role.arn
}

output "pipeline_role_arn" {
  description = "IAM role ARN for CodePipeline"
  value       = aws_iam_role.pipeline_role.arn
}


output "codebuild_role_arn" {
  description = "IAM role ARN for codebuild"
  value       = aws_iam_role.codebuild_role.arn
}
