terraform {
  backend "s3" {
    bucket         = "289389227463-terraform-backend"
    key            = "terraform-ecs-deployment-types/spring-app/infra/terraform.tfstate"
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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
