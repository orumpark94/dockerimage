variable "name" {
  description = "Prefix name for RDS and related resources"
  type        = string
}

variable "db_name" {
  description = "Initial DB name to create"
  type        = string
}

variable "db_user" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "db_subnet_ids" {
  description = "List of private subnet IDs for RDS deployment"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}
