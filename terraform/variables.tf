variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_log_group_name" {
  type    = string
  default = "my-app"
}

variable "app_docker_image" {
  type    = string
  default = "nginx:latest"
}

variable "app_docker_port" {
  type    = number
  default = 5000
}
