variable "name" {
  type = string
}

variable "image" {
  description = "Docker image for ECS task"
  type        = string
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
}

variable "private_subnets" {
  type = list(string)
}

variable "tg_arn" {
  description = "ALB Target Group ARN"
  type        = string
}

variable "sg_id" {
  description = "ECS Service에 적용할 보안 그룹 ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
