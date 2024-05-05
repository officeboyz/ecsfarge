output "private_subnet_ids" {
  description = "The list of IDs for the private subnets."
  value       = [for s in aws_subnet.private_subnet : s.id]
}
