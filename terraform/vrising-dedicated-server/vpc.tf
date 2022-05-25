
locals {
  vpc_cidr_block = "10.0.0.0/16"
  public_subnet_cidr_blocks = {
    us-west-2a = cidrsubnet(local.vpc_cidr_block, 8, 0)
    us-west-2b = cidrsubnet(local.vpc_cidr_block, 8, 1)
  }
}

resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr_block

  assign_generated_ipv6_cidr_block = false
  enable_classiclink             = false
  enable_classiclink_dns_support = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"

  tags = {
    Name = "${local.vrising}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnet_cidr_blocks

  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id

  tags = {
    Name = "${local.vrising}-public-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.vrising}-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnet_cidr_blocks

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}
