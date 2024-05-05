output "id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.nat_gateway.id
}

output "nat_eip" {
  description = "The Elastic IP address of the NAT Gateway."
  value       = aws_eip.nat_eip.public_ip
}
