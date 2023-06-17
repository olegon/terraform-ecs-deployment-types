variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_name" {
  type    = string
  default = "node-app-blue-green"
}

variable "app_docker_image" {
  type    = string
  default = "nginx:latest"
}

variable "app_docker_port" {
  type    = number
  default = 5000
}

variable "ecs_cluster_name" {
  type    = string
  default = "my-ecs-cluster"
}

variable "deployment_type" {
  type    = string
  default = "Blue Green"
  validation {
    condition     = contains(["Blue Green", "Rolling Update)"], var.deployment_type)
    error_message = "The deployment_type must be \"Blue Green\" or \"Rolling Update\""
  }
}
