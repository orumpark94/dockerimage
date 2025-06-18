variable "name" {
  description = "Prefix name for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "type" {
  description = "Security group type (alb or ecs)"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID (for ECS to allow access from ALB)"
  type        = string
  default     = ""
}
