output "synthetic_test_lambda_arn" {
  value       = var.create_synthetic_test_lambda ? aws_lambda_function.synthetic_test[0].arn : ""
  description = "ARN of synthetic test Lambda (empty if not created)"
}
