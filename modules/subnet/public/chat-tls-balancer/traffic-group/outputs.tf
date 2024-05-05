output "target_group_arn" {
  description = "The ARN of the Target Group."
  value       = aws_lb_target_group.ouroboros_chat_traffic_group.arn
}

output "target_group_name" {
  description = "The name of the Target Group."
  value       = aws_lb_target_group.ouroboros_chat_traffic_group.name
}
