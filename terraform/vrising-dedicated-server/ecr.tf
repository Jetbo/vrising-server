resource "aws_ecr_repository" "this" {
  name                 = "dedicated-servers/${local.vrising}"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
