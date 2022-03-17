module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "prom-grafana"
  tag          = local.tags
}

module "grafana-service" {
  source                 = "./modules/ecs-service"
  cluster_name           = "grafana"
  ecs_cluster_id         = module.ecs.cluster_id
  task_defination        = module.grafana-task-def.task_arn
  subnet                 = data.aws_subnet_ids.subnet.ids
  service_security_group = module.wfapi_service_sg.sg_id
  target_group_arn       = module.grafana-tg.alb_tg_id
  container_name         = "grafana"
  container_port         = "3000"
  desired_count          = "2"
  tag                    = local.tags
}

module "grafana-task-def" {
  source             = "./modules/task-def"
  family             = "grafana"
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

