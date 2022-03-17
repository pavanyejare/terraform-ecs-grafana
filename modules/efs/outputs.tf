output "efs-id" { value = aws_efs_file_system.efs.id }
output "efs-token" { value = aws_efs_file_system.efs.creation_token }

output "access_point" { value = aws_efs_access_point.access_point.* }
