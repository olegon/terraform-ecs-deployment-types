data "aws_iam_policy_document" "codedeploy_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codedeploy" {
  name               = format("%s-codedeploy-role", var.app_name)
  assume_role_policy = data.aws_iam_policy_document.codedeploy_trust.json
}

resource "aws_iam_role_policy_attachment" "aws_codedeploy_role_for_ecs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.codedeploy.name
}

resource "aws_codedeploy_app" "app" {
  compute_platform = "ECS"
  name             = format("%s-codedeploy", var.app_name)
}

resource "aws_codedeploy_deployment_group" "app" {
  app_name               = aws_codedeploy_app.app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = format("%s-codedeploy", var.app_name)
  service_role_arn       = aws_iam_role.codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = aws_ecs_service.app.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [data.aws_lb_listener.lb_ingress_http_prod.arn]
      }

      test_traffic_route {
        listener_arns = [data.aws_lb_listener.lb_ingress_http_test.arn]
      }

      target_group {
        name = aws_lb_target_group.lb_ingress_app_blue.name
      }

      target_group {
        name = aws_lb_target_group.lb_ingress_app_green.name
      }
    }
  }
}
