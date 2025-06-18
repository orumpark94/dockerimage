variable "name" {
  description = "Name prefix for ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID from ALB"
  type        = string
}

variable "tg_arn" {
  description = "Target Group ARN from ALB"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens (e.g., 3000 for Node.js)"
  type        = number
  default     = 3000
}
