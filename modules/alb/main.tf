resource "aws_lb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg]
  subnets                    = var.subnet
  enable_deletion_protection = false
  tags                       = var.tag
}
