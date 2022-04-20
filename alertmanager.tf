module "alert-tg" {
  source            = "./modules/alb-tg"
  tag               = local.tags
  port              = var.alert_tg_port
  protocol          = var.alert_tg_protocol
  target_group_name = var.alert_tg_name
  target_port       = var.alert_tg_target_port
  target_protocol   = var.alert_tg_target_protocol
  vpc_id            = local.vpc
  alb_arn           = module.alb.alb_id
}

module "alert-service" {
  source                 = "./modules/ecs-service"
  cluster_name           = var.alert_svc_name
  ecs_cluster_id         = module.ecs.cluster_id
  task_defination        = module.alert-task-def.task_arn
  subnet                 = data.aws_subnet_ids.subnet.ids
  service_security_group = module.wfapi_service_sg.sg_id
  target_group_arn       = module.alert-tg.alb_tg_id
  container_name         = var.alert_container_name
  container_port         = var.alert_container_port
  desired_count          = var.alert_container_count
  tag                    = local.tags
}

module "alert-task-def" {
  source             = "./modules/task-def"
  family             = var.alert_svc_name
  execution_role_arn = data.aws_iam_role.ecs_role.arn
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  tag                = local.tags
  task_def           = local.alert_defination
  efs_volume = [
    {
      volume_name  = "alertmanager"
      volume_id    = module.alert_dashboard_efs.efs-id
      path         = "/alertmanager"
      access_point = [for u in module.alert_dashboard_efs.access_point : u.id if u.tags["Name"] == "alertmanager"][0]
    }
  ]
}

module "alert_dashboard_efs" {
  source     = "./modules/efs"
  efs_name   = var.alert_efs_name
  sg_group   = module.wfapi_service_sg.sg_id
  efs_subnet = data.aws_subnet_ids.subnet.ids
  access_point = [
    { name = "alertmanager"
      path = "/alertmanager"
    }
  ]
}

locals {
  alert_defination = [
    {
      image = "prom/alertmanager:v0.22.0"
      name  = "alertmanager"
      user  = "root"
      command = [
        "--config.file=/etc/alertmanager/config.yml",
        "--storage.path=/alertmanager",
        "web.external-url=http://tsdocker-099-02.wafed.net:9093"
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
          containerPath = "/etc/alertmanager"
          sourceVolume  = "alertmanager"
          readOnly      = false
        }
      ]
      portMappings = [
        {
          containerPort = 9093
          hostPort      = 9093
      }]
    }
  ]
}
