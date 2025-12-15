data "archive_file" "synthetic_test_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/synthetic_test/lambda_function.py"
  output_path = "${path.module}/lambda/synthetic_test/lambda_function.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "synthetic_test_lambda" {
  count               = var.create_synthetic_test_lambda ? 1 : 0
  name                = format("%s-synthetic-test-lambda", var.app_name)
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "synthetic_test_lambda_basic_exec" {
  count      = var.create_synthetic_test_lambda ? 1 : 0
  role       = aws_iam_role.synthetic_test_lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "synthetic_test" {
  count = var.create_synthetic_test_lambda ? 1 : 0

  filename         = data.archive_file.synthetic_test_lambda.output_path
  source_code_hash = data.archive_file.synthetic_test_lambda.output_base64sha256
  function_name    = format("%s-synthetic-test", var.app_name)
  role             = aws_iam_role.synthetic_test_lambda[0].arn
  handler          = "lambda_function.lambda_handler"
  runtime          = var.synthetic_test_lambda_runtime
  memory_size      = var.synthetic_test_lambda_memory
  timeout          = var.synthetic_test_lambda_timeout

  environment {
    variables = {
      ALB_DNS       = data.aws_lb.lb_ingress.dns_name
      ALB_PORT      = tostring(var.synthetic_test_listener_port)
      SYNTHETIC_PATH = var.synthetic_test_path
    }
  }
}

resource "aws_lambda_permission" "allow_codedeploy" {
  count = var.create_synthetic_test_lambda ? 1 : 0

  statement_id  = "AllowInvocationFromCodeDeploy"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.synthetic_test[0].function_name
  principal     = "codedeploy.amazonaws.com"
}
