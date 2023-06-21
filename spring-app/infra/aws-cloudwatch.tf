resource "aws_cloudwatch_log_group" "app" {
  name              = format("/ecs/apps/%s", var.app_name)
  retention_in_days = 7
}

