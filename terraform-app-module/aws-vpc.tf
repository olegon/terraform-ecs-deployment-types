data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "lb_ingress" {
  name = "my-lb-ingress-sg"
}

resource "aws_security_group" "app" {
  name        = format("%s-sg", var.app_name)
  description = "allows app traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "app port"
    from_port       = var.app_docker_port
    to_port         = var.app_docker_port
    protocol        = "tcp"
    security_groups = [data.aws_security_group.lb_ingress.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
