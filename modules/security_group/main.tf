resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = var.description
  vpc_id      = var.vpc_id
  ingress     = var.ingress
  egress = [
    {
      description      = "All Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    }
  ]
  tags = var.tag
}


