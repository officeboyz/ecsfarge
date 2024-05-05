output "db_instance_address" {
  description = "The address of the RDS instance."
  value       = aws_db_instance.db_instance.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.db_instance.endpoint
}