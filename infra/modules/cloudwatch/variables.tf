variable "name" {
  description = "Prefix name used for resource naming"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "alarm_email" {
  description = "Email address to receive CloudWatch alarms"
  type        = string
}

# ECS 관련 변수
variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
}

# RDS 관련 변수
variable "rds_identifier" {
  description = "RDS DB Instance Identifier"
  type        = string
}

variable "rds_memory_threshold" {
  description = "Memory usage threshold in bytes (e.g. 500MB = 524288000)"
  type        = number
  default     = 524288000  # 예시: FreeableMemory가 500MB 미만일 경우 알람
}
