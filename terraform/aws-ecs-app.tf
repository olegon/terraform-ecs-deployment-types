resource "aws_ecs_task_definition" "app" {
  family                   = "my-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name              = "my-app"
      image             = var.app_docker_image
      cpu               = 256
      memoryReservation = 512
      memory            = 512
      essential         = true
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.app_log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "logs"
        }
      }
      portMappings = [
        {
          name          = "http"
          appProtocol   = "http"
          containerPort = var.app_docker_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  cluster         = aws_ecs_cluster.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  name            = "my-app"
  task_definition = aws_ecs_task_definition.app.arn

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets = data.aws_subnets.default.ids
    # assign_public_ip = true is required to pull images from docker hub when it on a public subnet
    # docs: https://docs.aws.amazon.com/AmazonECS/latest/userguide/fargate-task-networking.html
    assign_public_ip = true
    security_groups  = [aws_security_group.app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_ingress_app_blue.arn
    container_name   = "my-app"
    container_port   = var.app_docker_port
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      load_balancer,
      task_definition
    ]
  }
}
