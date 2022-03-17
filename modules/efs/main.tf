resource "aws_efs_file_system" "efs" {
  creation_token   = var.efs_name
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags = {
    Name = var.efs_name
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.efs_subnet)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = tolist(var.efs_subnet)[count.index]
  security_groups = [var.sg_group]
}

locals {
  access_point = [
    { name = "grafana"
      path = "/grafana"
    }
  ]
}



resource "aws_efs_access_point" "access_point" {
  count          = length(var.access_point)
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = element(var.access_point.*.path, count.index)
    creation_info {
      permissions = 777
      owner_gid   = 1000
      owner_uid   = 1000
    }
  }
  tags = {
    "Name" = element(var.access_point.*.name, count.index)
  }
}
