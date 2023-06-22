data "aws_route53_zone" "ogn" {
  name = "ogn.one."
}

resource "aws_route53_record" "lb_ingress" {
  zone_id = data.aws_route53_zone.ogn.zone_id
  name    = "*.apps.ogn.one"
  type    = "A"

  alias {
    name                   = aws_lb.lb_ingress.dns_name
    zone_id                = aws_lb.lb_ingress.zone_id
    evaluate_target_health = true
  }
}
