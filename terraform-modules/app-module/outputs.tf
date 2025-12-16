output "aws_codedeploy_deployment_group_arn" {
  value = var.deployment_type == "Blue Green" ? aws_codedeploy_deployment_group.app[0].arn : null
}