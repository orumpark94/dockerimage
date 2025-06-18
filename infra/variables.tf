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
