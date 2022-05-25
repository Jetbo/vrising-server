variable "openid_github_repo" {
  description = "Github repo org/repo for OpenID Connect"
  type = string
  nullable = false
}

variable "cpu" {
  description = "ECS Fargate Task Definition CPU"
  type = number
  nullable = false
}

variable "memory" {
  description = "ECS Fargate Task Definition memory"
  type = number
  nullable = false
}

variable "cpu_reservation" {
  description = "ECS Fargate Container Definition CPU reservation"
  type = number
  nullable = false
}

variable "memory_reservation" {
  description = "ECS Fargate Container Definition memory reservation"
  type = number
  nullable = false
}

variable "log_retention_in_days" {
  description = "How long to keep the ECS CloudWatch logs"
  type = number
  default = 7
  nullable = false
}

variable "route53" {
  description = "Settings for Route53 entries"
  type = object({
    zone_name = string
    network_lb_record_name = string
    name_server_records = set(string)
  })
  nullable = false
}