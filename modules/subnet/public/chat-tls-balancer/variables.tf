variable "vpc_id" {
  description = "The VPC ID where the Application Load Balancer will be created."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs spread across multiple availability zones for the ALB."
  type        = list(string)
}

variable "alb_sg_id" {
  type = string
}
