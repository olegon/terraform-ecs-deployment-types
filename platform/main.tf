terraform {
  backend "s3" {
    bucket         = "105029661252-terraform-backend"
    key            = "github/terraform-ecs-deployment-types/plataform.tfstate"
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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
