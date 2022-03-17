
module "wfapi_service_sg" {
  source      = "./modules/security_group"
  sg_name     = "wafednet-lvdev-w2-dev-wfapiservice"
  description = "Allow default inbound http and outbound traffic"
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
  sg_name     = "wafednet-lvdev-w2-dev-wfapialb"
  description = "Allows all traffic to nginx"
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


