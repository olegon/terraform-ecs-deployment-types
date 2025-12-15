output "synthetic_test_lambda_arn" {
  value       = module.infra.synthetic_test_lambda_arn
  description = "ARN of synthetic test Lambda created for this app (empty string if not created)"
}
