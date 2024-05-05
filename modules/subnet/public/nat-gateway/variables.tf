variable "vpc_id" {
  description = "The VPC ID where the NAT Gateway will be created."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet where the NAT Gateway will reside."
  type        = string
}

