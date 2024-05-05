variable "cluster_arn" {
  description = "The ARN of the ECS cluster where the service will be deployed."
  type        = string
}

variable "task_definition_arn" {
  description = "The ARN of the task definition to use for the service."
  type        = string
}

variable "load_balancer_arn" {
  description = "The ARN of the Application Load Balancer to associate with the service."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Target Group to associate with the service."
  type        = string
}

variable "subnet_ids" {
  description = "The ids of the subnets to host the service in"
  type        = list(string)
}

variable "security_group_id" {
  type = string
}