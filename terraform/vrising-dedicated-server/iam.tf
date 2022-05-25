data "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "application" {
  name        = local.vrising_dedicated_server
  description = "policy allowing access to infrastructure"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "kms:Decrypt"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "application_execution" {
  name        = "${local.vrising_dedicated_server}-execution"
  description = "ECS Task Execution role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = { "Service" : "ecs-tasks.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "application_execution_attach_1" {
  role       = aws_iam_role.application_execution.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

resource "aws_iam_role_policy_attachment" "application_execution_attach_2" {
  role       = aws_iam_role.application_execution.name
  policy_arn = aws_iam_policy.application.arn
}


resource "aws_iam_role" "application" {
  name        = local.vrising_dedicated_server
  description = "ECS Task role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = { "Service" : "ecs-tasks.amazonaws.com" }
      }
    ]
  })
}
