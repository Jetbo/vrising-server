# ----
# ECS
# ----

resource "aws_security_group" "ecs_vrising" {
  name        = "ecs_${local.vrising_dedicated_server}"
  description = "Allows steam requests"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name    = "ecs_${local.vrising_dedicated_server}"
  }
}

resource "aws_security_group_rule" "ecs_vrising_intra_ingress_rule_1" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "Game Port"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 27015
  to_port           = 27015
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "ecs_vrising_intra_ingress_rule_2" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "Query Port"
  type              = "ingress"
  protocol          = "udp"
  from_port         = 27016
  to_port           = 27016
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "ecs_vrising_intra_egress_rule_1" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "NFS"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.efs_vrising.id
}

resource "aws_security_group_rule" "ecs_vrising_exo_ingress_rule_1" {
  security_group_id = aws_security_group.ecs_vrising.id
  description       = "Health Check"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8000
  to_port           = 8000
  cidr_blocks       = ["10.0.0.0/16"]
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

# ----
# EFS
# ----

resource "aws_security_group" "efs_vrising" {
  name        = "efs_${local.vrising_dedicated_server}"
  description = "Allows EFS requests"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name    = "efs_${local.vrising_dedicated_server}"
  }
}

resource "aws_security_group_rule" "efs_vrising_intra_ingress_rule_2" {
  security_group_id = aws_security_group.efs_vrising.id
  description       = "NFS in"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 2049
  to_port           = 2049
  source_security_group_id = aws_security_group.ecs_vrising.id
}
