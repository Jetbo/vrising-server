resource "aws_security_group" "ecs_vrising" {
  name        = "ecs_${local.vrising_dedicated_server}"
  description = "Allows steam requests"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name    = "ecs_${local.vrising_dedicated_server}"
  }
}

resource "aws_security_group_rule" "ecs_vrising_exo_ingress_rule_1" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "Game Port"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 2015
  to_port           = 2015
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_vrising_exo_ingress_rule_2" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "Query Port"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 2016
  to_port           = 2016
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_vrising_exo_egress_rule_1" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "HTTPS out"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_vrising_exo_egress_rule_2" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "HTTP out"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
