terraform {
  backend "s3" {
    bucket         = "289389227463-terraform-backend"
    key            = "terraform-ecs-deployment-types/node-app.tfstate"
    dynamodb_table = "289389227463-terraform-backend"
    region         = "sa-east-1"
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
  app_health_check_path = "/v1/health"
  app_name              = "node-app"
  ecs_cluster_name      = "my-ecs-cluster"

  deployment_bluegreen_strategy = "CodeDeployDefault.ECSAllAtOnce"
  deployment_type               = "Blue Green"
}
