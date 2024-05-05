variable "image_tag" {
  description = "The tag of the Docker image to use in the task definition."
  type        = string
}

variable "execution_role_arn" {
  type = string
}

variable "ecs_task_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
variable "api_key" {
  description = "API key for accessing the service"
  type        = string
}
