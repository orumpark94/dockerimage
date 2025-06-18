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
