resource "aws_ecs_cluster" "this" {
  name = "${local.vrising}-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "spot" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.vrising_dedicated_server
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.application_execution.arn
  task_role_arn            = aws_iam_role.application.arn

  network_mode = "awsvpc"

  cpu    = var.cpu
  memory = var.memory

  container_definitions = jsonencode(
    [
      jsondecode(templatefile(
        "${path.module}/container_definitions/vrising.tftpl",
        {
          name = local.vrising_dedicated_server
          image_url = "${aws_ecr_repository.this.arn}:latest"
          cpu_reservation = var.cpu_reservation
          memory_reservation = var.memory_reservation
          region = data.aws_region.current.name
        }
      ))
    ]
  )

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_service" "this" {
  name             = local.vrising_dedicated_server
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.this.arn
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  desired_count           = 1
  enable_ecs_managed_tags = true
  propagate_tags          = "TASK_DEFINITION"
  enable_execute_command  = false

  network_configuration {
    subnets = local.public_subnet_ids
    security_groups = [
      aws_security_group.ecs_vrising.id
    ]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fifteen.arn
    container_name   = local.vrising_dedicated_server
    container_port   = 2015
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.sixteen.arn
    container_name   = local.vrising_dedicated_server
    container_port   = 2016
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = false
  }
}
