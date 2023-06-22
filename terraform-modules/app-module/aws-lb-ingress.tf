data "aws_lb" "lb_ingress" {
  name = "my-lb-ingress"
}

# Blue

data "aws_lb_listener" "lb_ingress_http_prod" {
  load_balancer_arn = data.aws_lb.lb_ingress.arn
  port              = 443
}

resource "aws_lb_listener_rule" "lb_ingress_http_prod_app" {
  listener_arn = data.aws_lb_listener.lb_ingress_http_prod.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_ingress_app_blue.arn
  }

  condition {
    host_header {
      values = [format("%s.ogn.one", var.app_name)]
    }
  }

  # When Blue Green is active, Code Deploy will change traffic between Blue and Green Target Groups.
  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

resource "aws_lb_target_group" "lb_ingress_app_blue" {
  name        = format("%s-blue", var.app_name)
  port        = var.app_docker_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled = true

    healthy_threshold   = 2
    interval            = 10
    matcher             = "200-299"
    path                = var.app_health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  deregistration_delay = 60
}



# Green

data "aws_lb_listener" "lb_ingress_http_test" {
  load_balancer_arn = data.aws_lb.lb_ingress.arn
  port              = 8443
}

resource "aws_lb_listener_rule" "lb_ingress_http_test_app" {
  listener_arn = data.aws_lb_listener.lb_ingress_http_test.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_ingress_app_green.arn
  }

  condition {
    host_header {
      values = [format("%s.ogn.one", var.app_name)]
    }
  }

  # When Blue Green is active, Code Deploy will change traffic between Blue and Green Target Groups.
  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

resource "aws_lb_target_group" "lb_ingress_app_green" {
  name        = format("%s-green", var.app_name)
  port        = var.app_docker_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    enabled = true

    healthy_threshold   = 2
    interval            = 10
    matcher             = "200-299"
    path                = var.app_health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  deregistration_delay = 60
}
