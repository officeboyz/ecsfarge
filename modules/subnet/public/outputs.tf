output "balancer_endpoint" {
  value = module.chat_tls_balancer.alb_dns_name
}
output "chat_tls_balancer_arn" {
  value = module.chat_tls_balancer.alb_arn
}
output "target_group_arn" {
  description = "The ARN of the Target Group."
  value       = module.chat_tls_balancer.target_group_arn
}

output "bastion_ip" {
  value = module.bastion.bastion_host_public_ips
}

output "nat_gateway_ids" {
  value = [for instance in values(module.nat) : instance.id]
}