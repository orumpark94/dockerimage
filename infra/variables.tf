variable "name" {
  description = "Prefix for naming AWS resources"
  type        = string
  default     = "my-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

# 🔽 새로 추가할 변수
variable "container_port" {
  description = "Port exposed by the container and used by ALB TG"
  type        = number
  default     = 3000
}

variable "image" {
  description = "Docker image used in ECS task"
  type        = string
  default     = "baram940/devops-test:1.0"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"  # 또는 원하는 리전
}

variable "db_name" {
  description = "DB 이름"
  type        = string
  default     = "myappdb"
}

variable "db_user" {
  description = "DB 사용자명"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "DB 비밀번호 (GitHub Actions에서 secrets로 전달)"
  type        = string
  sensitive   = true
}
