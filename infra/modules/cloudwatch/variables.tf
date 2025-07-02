variable "name" {
  description = "리소스 네이밍 prefix"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "retention_days" {
  description = "CloudWatch 로그 보존 기간"
  type        = number
  default     = 7
}

variable "ecs_cluster_name" {
  description = "ECS 클러스터 이름"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS 서비스 이름"
  type        = string
}

variable "log_group_name" {
  description = "ECS 로그 그룹 이름"
  type        = string
}

variable "rds_identifier" {
  description = "RDS 인스턴스 ID"
  type        = string
}

variable "alarm_email" {
  description = "알람 전송 대상 이메일"
  type        = string
}

variable "rds_memory_threshold_bytes" {
  description = "RDS 메모리 알람 기준값 (bytes)"
  type        = number
  default     = 214748364 # 200MB
}
