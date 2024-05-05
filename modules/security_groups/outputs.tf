output "task_sg_id" {
  value = aws_security_group.ecs_task_sg.id
}
output "virtual_endpoint_sg_id" {
  value = aws_security_group.virtual_endpoints_sg.id
}
output "alb_sg_id" {
  value = aws_security_group.alb_security_group.id
}
output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
