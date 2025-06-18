variable "name" {
  description = "Name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID for ALB"
  type        = string
}

variable "target_port" {
  description = "The port the ALB target group forwards traffic to (e.g., 3000 for Node.js)"
  type        = number
  default     = 3000
}
