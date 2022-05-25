resource "aws_cloudwatch_log_group" "application_group" {
  name = "/aws/ecs/${local.vrising_dedicated_server}"

  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_group" "health_check_group" {
  name = "/aws/ecs/health_check"

  retention_in_days = 1
}
