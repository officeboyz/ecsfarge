variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "load_balancer_arn" {
  type = string
}

variable "target_group_arn" {
  type       = string
}

variable "availability_cidr_map" {
  type = map(object({
    public = object({
      ipv6_cidr = string
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

variable "ecs_task_sg_id" {
  type = string
}
variable "virtual_endpoint_sg_id" {
  type = string
}

variable "nat_gateway_ids" {
  type = list(string)
}
variable "api_key" {
  description = "API key for accessing the service"
  type        = string
}
