locals {
  is_managed_by_code_deploy = var.deployment_type == "Blue Green"
}