output "aws_codedeploy_deployment_group_arn" {
  value = local.is_managed_by_code_deploy ? aws_codedeploy_deployment_group.app[0].arn : null
}

output "lb_ingress_dns_name" {
  value = data.aws_lb.lb_ingress.dns_name
}

output "lb_ingress_listener_test_port" {
  value = data.aws_lb_listener.lb_ingress_http_test.port
}

output "lb_ingress_listener_prod_port" {
  value = data.aws_lb_listener.lb_ingress_http_prod.port
}