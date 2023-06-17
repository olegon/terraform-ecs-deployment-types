terraform {
  backend "s3" {
    bucket         = "289389227463-terraform-state"
    key            = "us-east-1/terraform-ecs-deployment-types/platform/terraform.tfstate"
    dynamodb_table = "289389227463-terraform-lock"
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
