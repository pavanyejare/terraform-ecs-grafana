output "alb_tg_id" {
  description = "The ID of the ALB"
  value       = aws_lb_target_group.group.arn
}

