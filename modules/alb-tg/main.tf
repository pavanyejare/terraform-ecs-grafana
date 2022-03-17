
resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.alb_arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

resource "aws_lb_target_group" "group" {
  name        = var.target_group_name
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags        = var.tag
  health_check {
    path                = "/"
    port                = var.target_port
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200-499" # has to be HTTP 200 or fails
  }
}


