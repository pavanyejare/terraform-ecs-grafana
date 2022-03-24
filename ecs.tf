module "ecs" {
  source       = "./modules/ecs"
  cluster_name = var.ecs_cluster_name
  tag          = local.tags
}

module "grafana-service" {
  source                 = "./modules/ecs-service"
  cluster_name           = var.grafana_service_name
  ecs_cluster_id         = module.ecs.cluster_id
  task_defination        = module.grafana-task-def.task_arn
  subnet                 = data.aws_subnet_ids.subnet.ids
  service_security_group = module.wfapi_service_sg.sg_id
  target_group_arn       = module.grafana-tg.alb_tg_id
  container_name         = var.grafana_container_name
  container_port         = var.grafana_container_port
  desired_count          = var.grafana_desired_count
  tag                    = local.tags
}

module "grafana-task-def" {
  source             = "./modules/task-def"
  family             = var.grafana_service_name
  execution_role_arn = data.aws_iam_role.ecs_role.arn
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  tag                = local.tags
  task_def           = local.container_defination
  efs_volume = [
    {
      volume_name  = "grafana_config"
      volume_id    = module.grafana_dashboard_efs.efs-id
      path         = "/grafana_config"
      access_point = [for u in module.grafana_dashboard_efs.access_point : u.id if u.tags["Name"] == "grafana_config"][0]
    },
    {
      volume_name  = "grafana_dashboard"
      volume_id    = module.grafana_dashboard_efs.efs-id
      path         = "/grafana_dashboard"
      access_point = [for u in module.grafana_dashboard_efs.access_point : u.id if u.tags["Name"] == "grafana_dashboard"][0]
    },
    {
      volume_name  = "grafana_datasource"
      volume_id    = module.grafana_dashboard_efs.efs-id
      path         = "/grafana_datasource"
      access_point = [for u in module.grafana_dashboard_efs.access_point : u.id if u.tags["Name"] == "grafana_datasource"][0]
    }
  ]
}

