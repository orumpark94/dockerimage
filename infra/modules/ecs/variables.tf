variable "name" {
  description = "Name prefix for ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Private Subnet ID for ECS tasks"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID from ALB"
  type        = string
}

variable "tg_arn" {
  description = "Target Group ARN from ALB"
  type        = string
}

# ✅ 추가적으로 명확히 하고 싶다면, 포트를 변수로 뺄 수도 있습니다:
variable "container_port" {
  description = "Port on which the container listens (Node.js: 3000)"
  type        = number
  default     = 3000
}
