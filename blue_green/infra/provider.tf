provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = var.github_oauth_token
}