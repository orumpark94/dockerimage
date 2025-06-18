# 공통
variable "name" {
  description = "Prefix for naming AWS resources"
  type        = string
  default     = "my-app"
}

# VPC 관련
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.11.0/24"
}

variable "availability_zone" {
  description = "Single availability zone"
  type        = string
  default     = "ap-northeast-2a"
}

# ALB 모듈에서 사용하는 변수 (기본값 없는 필수 변수)
variable "vpc_id" {
  description = "VPC ID where ALB and ECS will be deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID for ALB"
  type        = string
}

# ECS 모듈에서 사용하는 변수
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
