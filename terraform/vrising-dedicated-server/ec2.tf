resource "aws_lb" "network" {
  name               = local.vrising_dedicated_server
  internal           = false
  load_balancer_type = "network"
  subnets            = local.public_subnet_ids
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "fifteen" {
  name        = local.vrising_dedicated_server
  port        = 2015
  protocol    = "UDP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    enabled             = false
  }
}

resource "aws_lb_target_group" "sixteen" {
  name        = local.vrising_dedicated_server
  port        = 2015
  protocol    = "UDP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    enabled             = false
  }
}

resource "aws_lb_listener" "fifteen" {
  load_balancer_arn = aws_lb.network.arn
  port              = "2015"
  protocol          = "UDP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.fifteen.arn
  }
}

resource "aws_lb_listener" "sixteen" {
  load_balancer_arn = aws_lb.network.arn
  port              = "2016"
  protocol          = "UDP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.sixteen.arn
  }
}
