resource "aws_lb" "lb_ingress" {
  name               = "my-lb-ingress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_ingress.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "lb_ingress_app_blue" {
  name        = "my-lb-ingress-app-blue"
  port        = var.app_docker_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  deregistration_delay = 60
}

resource "aws_lb_target_group" "lb_ingress_app_green" {
  name        = "my-lb-ingress-app-green"
  port        = var.app_docker_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

  deregistration_delay = 60
}

resource "aws_lb_listener" "lb_ingress_http_prod" {
  load_balancer_arn = aws_lb.lb_ingress.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_ingress_app_blue.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_listener" "lb_ingress_http_test" {
  load_balancer_arn = aws_lb.lb_ingress.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_ingress_app_green.arn
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}
