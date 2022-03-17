resource "aws_ecs_service" "service" {
  name            = var.cluster_name
  cluster         = var.ecs_cluster_id
  task_definition = var.task_defination
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet
    assign_public_ip = true
    security_groups = [
      var.service_security_group
    ]
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  desired_count = var.desired_count
  tags          = var.tag
}
