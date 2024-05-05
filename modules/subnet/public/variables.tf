variable "vpc_id" {
  description = "The VPC ID where we'll create the public subnet and its resources."
  type        = string
}

variable "region" {
  description = "The AWS region where we'll deploy the resources."
  type        = string
}
variable "bastion_sg_id" {
  type = string
}
variable "alb_sg_id" {
  type = string
}
variable "key_name" {
  description = "The name of the key pair to be created for the bastion host SSH access."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the bastion host."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the bastion host."
  default     = "t2.micro"
}

variable "igw_id" {
  type = string
}

variable "availability_cidr_map" {
  type = map(object({
    public = object({
      ipv6_cidr = string
      ipv4_cidr = string
    })
    private = object({
      ipv6_cidr = string
      ipv4_cidr = string
    })
  }))

  validation {
    condition     = length(var.availability_cidr_map) > 1
    error_message = "The availability_cidr_map must include entries for more than one availability zone."
  }

  validation {
    condition     = alltrue(flatten([
      for az in values(var.availability_cidr_map) : [
        can(regex("^\\d{1,3}(\\.\\d{1,3}){3}/\\d{1,2}$", az.public.ipv4_cidr)),
        can(regex("^\\d{1,3}(\\.\\d{1,3}){3}/\\d{1,2}$", az.private.ipv4_cidr)),
      ]
    ]))
    error_message = "One or more CIDR blocks are in an incorrect format."
  }

}
variable "subnet_blocks" {
  type = object({
    public = object({
      ipv6 = string
      ipv4 = string
    })
    private = object({
      ipv6 = string
      ipv4 = string
    })
  })
}


