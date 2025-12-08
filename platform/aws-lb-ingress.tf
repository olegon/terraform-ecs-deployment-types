resource "aws_lb" "lb_ingress" {
  name               = "my-lb-ingress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_ingress.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "lb_ingress_http_prod" {
  load_balancer_arn = aws_lb.lb_ingress.arn
  port              = 80
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = 404
      message_body = "Not found on ALB."
    }
  }
}

resource "aws_lb_listener" "lb_ingress_http_test" {
  load_balancer_arn = aws_lb.lb_ingress.arn
  port              = 8080
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = 404
      message_body = "Not found on ALB."
    }
  }
}
