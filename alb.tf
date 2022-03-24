
module "alb" {
  source   = "./modules/alb"
  alb_name = var.alb_name
  alb_sg   = module.alb_sg.sg_id
  subnet   = data.aws_subnet_ids.subnet.ids
  tag      = local.tags
}



module "grafana-tg" {
  source            = "./modules/alb-tg"
  tag               = local.tags
  port              = var.grafana_port
  protocol          = var.grafana_protocol
  target_group_name = var.grafana_tg_name
  target_port       = var.grafana_tg_port
  target_protocol   = var.grafana_tg_protocol
  vpc_id            = local.vpc
  alb_arn           = module.alb.alb_id

}




