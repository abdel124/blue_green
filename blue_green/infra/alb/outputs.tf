output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "alb_target_group_arn_green" {
  description = "ARN of the green target group for the ALB"
  value       = aws_lb_target_group.green.arn
}

output "alb_target_group_arn_blue" {
  description = "ARN of the blue target group for the ALB"
  value       = aws_lb_target_group.blue.arn
}

output "listener" {
  description = "ARN of the blue target group for the ALB"
  value       = [aws_lb_listener.listener.arn]
}

