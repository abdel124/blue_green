variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "abdel124"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "blue_green"
}

variable "github_branch" {
  description = "GitHub branch for the source code"
  type        = string
  default     = "main"
}

# variable "github_oauth_token" {
#   description = "GitHub OAuth token for accessing the repository"
#   type        = string
  
# }


variable "pipeline_role" {
  description = "iam role for pipeline"
  type        = string
}

variable "codebuild_role_arn" {
  description = "IAM role ARN for CodeBuild"
  type        = string
}

variable "pipeline_bucket" {
  description = "bucket for pipeline artifact stores"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "project_name" {
  description = "project_name"
  type        = string
}

variable "deployment_group_name" {
  description = "deployment_group_name"
  type        = string
}
variable "app_name" {
  description = "app_name"
  type        = string
}

