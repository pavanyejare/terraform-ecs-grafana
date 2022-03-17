resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = var.tag

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#resource "aws_ecs_task_definition" "definition" {
#  family                   = var.family
#  task_role_arn            = var.task_arn
#  execution_role_arn       = var.execution_role_arn
#  network_mode             = var.network_mode
#  cpu                      = var.cpu
#  memory                   = var.memory
#  requires_compatibilities = ["FARGATE"]
#  tags                     = var.tag
#  container_definitions    = jsonencode(var.c_def)
#}


#resource "aws_ecs_service" "service" {
#  name            = var.cluster_name
#  cluster         = aws_ecs_cluster.cluster.id
#  task_definition = aws_ecs_task_definition.definition.arn
#  launch_type     = "FARGATE"
#  network_configuration {
#    subnets          = var.subnet
#    assign_public_ip = true
#    security_groups = [
#      var.service_security_group
#    ]
#  }
#  load_balancer {
#    target_group_arn = var.target_group_arn
#    container_name   = var.container_name
#    container_port   = var.container_port
#  }
#  desired_count = var.desired_count
#  tags          = var.tag
#}

