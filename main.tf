module "wfapi_service_sg" {
  source      = "./modules/security_group"
  sg_name     = var.ecs_sg_name
  description = var.ecs_sg_description
  vpc_id      = local.vpc
  ingress = [
    {
      description      = "All Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "all"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    }
  ]
  tag = local.tags
}

module "alb_sg" {
  source      = "./modules/security_group"
  sg_name     = var.alb_sg_name
  description = var.alb_sg_description
  vpc_id      = local.vpc
  ingress = [
    {
      description      = "All Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "all"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    }
  ]
  tag = local.tags
}


