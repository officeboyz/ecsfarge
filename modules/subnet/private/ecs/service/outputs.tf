
output "service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.ouroboros_chat_service.name
}

output "service_id" {
  description = "The ID of the ECS service."
  value       = aws_ecs_service.ouroboros_chat_service.id
}
