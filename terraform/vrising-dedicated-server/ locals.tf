locals {
  vrising = "vrising"
  vrising_dedicated_server = "${local.vrising}-dedicated-server"
  public_subnet_ids = [for subnet in aws_subnet.public: subnet.id]
}
