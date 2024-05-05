variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "The ID of the public subnet where the bastion host will reside"
  type        = list(string)
}

variable "key_name" {
  description = "The name of the SSH key pair for the bastion host"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the bastion host"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the bastion host"
  default     = "t2.micro"
}

variable "bastion_sg_id" {
  type = string
}