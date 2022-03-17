
module "alb" {
  source   = "./modules/alb"
  alb_name = "grafana-prom"
  alb_sg   = module.alb_sg.sg_id
  subnet   = data.aws_subnet_ids.subnet.ids
  tag      = local.tags
}



module "grafana-tg" {
  source            = "./modules/alb-tg"
  tag               = local.tags
  port              = "80"
  protocol          = "HTTP"
  target_group_name = "grafana-tg"
  target_port       = "3000"
  target_protocol   = "HTTP"
  vpc_id            = local.vpc
  alb_arn           = module.alb.alb_id

}




