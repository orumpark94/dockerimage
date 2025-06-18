variable "name" {
  description = "Name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB across multiple AZs"
  type        = list(string)
}

variable "target_port" {
  description = "The port the ALB target group forwards traffic to (e.g., 3000 for Node.js)"
  type        = number
  default     = 3000
}

variable "sg_id" {
  description = "ALB 보안 그룹 ID"
  type        = string
}

variable "target_port" {
  description = "ECS 컨테이너에서 수신할 포트 번호 (ex: 3000)"
  type        = number
}
