module "prom-tg" {
  source            = "./modules/alb-tg"
  tag               = local.tags
  port              = var.prom_tg_port
  protocol          = var.prom_tg_protocol
  target_group_name = var.prom_tg_name
  target_port       = var.prom_tg_target_port
  target_protocol   = var.prom_tg_target_protocol
  vpc_id            = local.vpc
  alb_arn           = module.alb.alb_id
}

module "prom-service" {
  source                 = "./modules/ecs-service"
  cluster_name           = var.prom_svc_name
  ecs_cluster_id         = module.ecs.cluster_id
  task_defination        = module.prom-task-def.task_arn
  subnet                 = data.aws_subnet_ids.subnet.ids
  service_security_group = module.wfapi_service_sg.sg_id
  target_group_arn       = module.prom-tg.alb_tg_id
  container_name         = var.prom_container_name
  container_port         = var.prom_container_port
  desired_count          = var.prom_container_protocol
  tag                    = local.tags
}

module "prom-task-def" {
  source             = "./modules/task-def"
  family             = var.prom_svc_name
  execution_role_arn = data.aws_iam_role.ecs_role.arn
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  tag                = local.tags
  task_def           = local.prom_defination
  efs_volume = [
    {
      volume_name  = "prometheus"
      volume_id    = module.prom_dashboard_efs.efs-id
      path         = "/prometheus"
      access_point = [for u in module.prom_dashboard_efs.access_point : u.id if u.tags["Name"] == "prometheus"][0]
    },
    {
      volume_name  = "prometheus_data"
      volume_id    = module.prom_dashboard_efs.efs-id
      path         = "/prometheus_data"
      access_point = [for u in module.prom_dashboard_efs.access_point : u.id if u.tags["Name"] == "prometheus_data"][0]
    }
  ]
}

module "prom_dashboard_efs" {
  source     = "./modules/efs"
  efs_name   = var.prom_efs_name
  sg_group   = module.wfapi_service_sg.sg_id
  efs_subnet = data.aws_subnet_ids.subnet.ids
  access_point = [
    { name = "prometheus"
      path = "/prometheus"
    },
    {
      name = "prometheus_data"
      path = "/prometheus_data"
    }
  ]
}

locals {
  prom_defination = [
    {
      image = "prom/prometheus:v2.25.0"
      name  = "prometheus"
      user  = "root"
      command = [
        "--config.file=/etc/prometheus/proetheus.yml",
        "--storage.tsdb.path=/promtheus",
        "--web.console.libraries=/etc/prometheus/console_librairies",
        "--web.console.templates=/etc/prometheus/consoles",
        "--web.enable-lifecycle",
        "--web.external-url=http:/"
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/grafana"
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = [
        {
          containerPath = "/etc/prometheus"
          sourceVolume  = "prometheus"
          readOnly      = false
        },
        {
          containerPath = "/prometheus"
          sourceVolume  = "prometheus_data"
          readOnly      = false
        }
      ]
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
      }]
    }
  ]
}
