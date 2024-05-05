variable "alb_arn" {
  description = "The ARN of the Application Load Balancer."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the Target Group to route traffic to."
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate to use for HTTPS listeners."
  type        = string
}

