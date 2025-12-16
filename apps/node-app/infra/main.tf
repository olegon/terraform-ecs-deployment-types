terraform {
  backend "s3" {
    bucket         = "105029661252-terraform-backend"
    key            = "github/terraform-ecs-deployment-types/node-app.tfstate"
    dynamodb_table = "105029661252-terraform-backend"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

module "infra" {
  source = "../../../terraform-modules/app-module"

  app_docker_image          = "nginx:latest"
  app_docker_port           = 5000
  app_health_check_path     = "/node-app/v1/health"
  app_name                  = "node-app"
  ecs_cluster_name          = "my-ecs-cluster"
  ecs_service_desired_count = 2

  deployment_bluegreen_strategy = "CodeDeployDefault.ECSAllAtOnce"
  deployment_type               = "Blue Green"
}

module "before_allow_traffic_lambda_hook" {
  source  = "terraform-aws-modules/lambda/aws"
  version = ">= 8, < 9"

  function_name = "node-app-code-deploy-before-allow-traffic-lambda-hook"
  handler       = "index.handler"
  runtime       = "nodejs24.x"
  publish       = true

  timeout     = 300
  memory_size = 128

  source_path = [
    "../before-allow-traffic-hook-lambda-src/index.js",
  ]

  # environment_variables = {
  #   "X" = "Y"
  # }

  allowed_triggers = {
    CodeDeployBeforeAllowTrafficHook = {
      principal = "codedeploy.amazonaws.com"
    }
  }

  cloudwatch_logs_retention_in_days = 7
  cloudwatch_logs_log_group_class   = "INFREQUENT_ACCESS"
}