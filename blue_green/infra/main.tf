# 0. VPC Module

module "vpc" {
  source              = "./vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  enable_nat_gateway  = var.enable_nat_gateway
  availability_zones  = var.availability_zones
}

module "nat" {
  source         = "./nat"
  public_subnets = module.vpc.public_subnets
  tags           = { Environment = "Dev" }
  private_route_table_ids = module.vpc.private_route_table_ids
  private_subnets = module.vpc.private_subnets
}

module "s3" {
  source      = "./s3"
  bucket_name = "my-codepipeline-artifacts-bucket-abdel"
  environment = "dev"
}

module "iam" {
    source = "./iam"  // Adjust to the path of your IAM module
    artifact_bucket_name = "my-codepipeline-artifacts-bucket-abdel"
    // Add required variables for your IAM configuration
}

# Use VPC Outputs in Other Modules
module "alb" {
  source     = "./alb"
  vpc_id     = module.vpc.vpc_id
  subnets = module.vpc.public_subnet_ids
  
}

module "ec2" {
  source                = "./ec2"
  instance_type         = var.instance_type
  ami_id                = var.ami_id
  subnets = module.vpc.private_subnets
  alb_blue_target = module.alb.alb_target_group_arn_blue
  alb_green_target = module.alb.alb_target_group_arn_green
  #asg_desired_capacity  = 2
  #asg_min_size          = 1
  #asg_max_size          = 3
  #vpc_id                = module.vpc.vpc_id
  #ubnet_ids            = module.vpc.private_subnet_ids
}

module "codedeploy" {
  source                     = "./codedeploy"
  alb_name = "app-load-balancer"
  #app_name                   = "python-app"
  iam_role = module.iam.codedeploy_role_arn
  #deployment_group_name      = "python-app-group"
  blue_target = module.alb.alb_target_group_arn_blue
  green_target = module.alb.alb_target_group_arn_green
  alb_listner = module.alb.listener
  #alb_target_group_arn_blue  = module.alb
  #alb_target_group_arn_green = module.alb.alb_target_group_arn_green
}

# 5. CodePipeline Module
module "codepipeline" {
  source                     = "./codepipeline"
  github_owner               = var.github_owner
  github_repo                = var.github_repo
  github_branch              = var.github_branch
  github_oauth_token         = var.github_oauth_token
  pipeline_role = module.iam.pipeline_role_arn
  pipeline_bucket = "my-codepipeline-artifacts-bucket-abdel"
  environment = "dev"
  codebuild_role_arn = module.iam.codebuild_role_arn
  deployment_group_name = module.codedeploy.deployment_group_name
  app_name = module.codedeploy.app_name
  project_name = "dev-test-build"

 # pipeline_role_arn          = module.iam.pipeline_role_arn
  #codedeploy_application_arn = module.codedeploy.application_arn
  #deployment_group_name      = "python-app-group"
}