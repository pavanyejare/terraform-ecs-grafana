module "grafana_dashboard_efs" {
  source     = "./modules/efs"
  efs_name   = "grafana"
  sg_group   = module.wfapi_service_sg.sg_id
  efs_subnet = data.aws_subnet_ids.subnet.ids
  access_point = [
    { name = "grafana_config"
      path = "/grafana_config"
    },
    {
      name = "grafana_dashboard"
      path = "/grafana_dashboard"
    },
    {
      name = "grafana_datasource"
      path = "/grafana_datasource"
    }
  ]
}

