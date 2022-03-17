resource "aws_ecs_task_definition" "definition" {
  family = var.family
  #task_role_arn            = var.task_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  tags                     = var.tag
  container_definitions    = jsonencode(var.task_def)
  dynamic "volume" {
    for_each = var.efs_volume
    content {
      name = volume.value.volume_name
      efs_volume_configuration {
        file_system_id     = volume.value.volume_id
        root_directory     = volume.value.path
        transit_encryption = "ENABLED"
        #transit_encryption_port = 0
        authorization_config {
          access_point_id = volume.value.access_point
          iam             = "DISABLED"
        }


      }
    }
  }
}

