variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "app_log_group_name" {
  type    = string
  default = "my-app"
}

variable "app_docker_image" {
  type = string
  # default = "nginx:1-alpine"
  default = "httpd:2-alpine"
}

variable "app_docker_port" {
  type    = number
  default = 80
}
