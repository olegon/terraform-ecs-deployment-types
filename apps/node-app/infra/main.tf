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

  app_docker_image      = "nginx:latest"
  app_docker_port       = 5000
  app_health_check_path = "/node-app/v1/health"
  app_name              = "node-app"
  ecs_cluster_name      = "my-ecs-cluster"

  deployment_bluegreen_strategy = "CodeDeployDefault.ECSAllAtOnce"
  deployment_type               = "Blue Green"
}
