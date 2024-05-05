output "alb_arn" {
  description = "The ARN of the Application Load Balancer."
  value       = aws_lb.ouroboros_chat_tls_balancer.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.ouroboros_chat_tls_balancer.dns_name
}

output "target_group_arn" {
  description = "The ARN of the Target Group."
  value       = module.traffic-group.target_group_arn
}

