variable "vpc_id" {
  description = "The ID of the VPC where the virtual endpoints will be created."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the virtual endpoints will be deployed."
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_for_endpoint_policies" {
  type = string
}
