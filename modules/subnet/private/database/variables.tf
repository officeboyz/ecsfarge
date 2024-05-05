variable "db_subnet_group_ids" {
  description = "The list of subnet IDs spanning multiple availability zones for the DB subnet group."
  type        = list(string)
}

variable "db_instance_class" {
  description = "The instance type of the database."
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "The version of the database engine to use."
  default     = "12.4"
}

variable "db_storage_type" {
  description = "The storage type of the database."
  default     = "gp2"
}

variable "db_allocated_storage" {
  description = "The allocated storage size for the database (in GB)."
  default     = "10"
}

variable "db_username" {
  description = "The username for the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the database will reside."
  type        = string
}

variable "bastion_security_group_id" {
  description = "The only permitted users for the database"
  type        = string
}