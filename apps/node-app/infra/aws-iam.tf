data "aws_iam_policy_document" "before_allow_traffic_lambda_hook" {
  statement {
    effect = "Allow"

    actions = [
      "codedeploy:PutLifecycleEventHookExecutionStatus",
    ]

    resources = [
      module.infra.aws_codedeploy_deployment_group_arn
    ]
  }
}