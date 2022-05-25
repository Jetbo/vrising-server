resource "aws_efs_file_system" "this" {
  encrypted = false
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  
  tags = {
    Name = local.vrising_dedicated_server
  }
}

resource "aws_efs_mount_target" "mount_1" {
  file_system_id = aws_efs_file_system.this.id
  security_groups = [ aws_security_group.efs_vrising.id ]
  subnet_id      = local.public_subnet_ids[0]
}

resource "aws_efs_mount_target" "mount_2" {
  file_system_id = aws_efs_file_system.this.id
  security_groups = [ aws_security_group.efs_vrising.id ]
  subnet_id      = local.public_subnet_ids[1]
}
