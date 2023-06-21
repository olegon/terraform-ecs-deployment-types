variable "app_name" {
  type    = string
  default = "my-app"
}

variable "app_docker_image" {
  type    = string
  default = "nginx:latest"
}

variable "app_docker_port" {
  type    = number
  default = 8080
}

variable "app_health_check_path" {
  type    = string
  default = "/my-app/actuator/health"
}

variable "ecs_cluster_name" {
  type    = string
  default = "my-ecs-cluster"
}

variable "deployment_type" {
  type    = string
  default = "Blue Green"
  validation {
    condition     = contains(["Blue Green", "Rolling Update"], var.deployment_type)
    error_message = format("Valid deployment_type values are: %s", join(", ", ["Blue Green", "Rolling Update"]))
  }
}

variable "deployment_bluegreen_strategy" {
  type    = string
  default = "CodeDeployDefault.ECSAllAtOnce"
  validation {
    // Sad to see all this configuration duplication...
    condition     = contains(["CodeDeployDefault.ECSAllAtOnce", "CodeDeployDefault.ECSCanary10percent15Minutes", "CodeDeployDefault.ECSCanary10percent5Minutes", "CodeDeployDefault.ECSLinear10PercentEvery3Minutes", "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"], var.deployment_bluegreen_strategy)
    error_message = format("Valid deployment_bluegreen_strategy values are: %s", join(", ", ["CodeDeployDefault.ECSAllAtOnce", "CodeDeployDefault.ECSCanary10percent15Minutes", "CodeDeployDefault.ECSCanary10percent5Minutes", "CodeDeployDefault.ECSLinear10PercentEvery3Minutes", "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"]))
  }
}
