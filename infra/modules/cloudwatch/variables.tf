variable "name" {
  description = "리소스 이름 prefix"
  type        = string
}

variable "email" {
  description = "알람을 수신할 이메일 주소"
  type        = string
}

variable "region" {
  description = "AWS 리전 (예: ap-northeast-2)"
  type        = string
}

variable "retention_days" {
  description = "CloudWatch 로그 보관 기간 (일 단위)"
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

variable "rds_instance_id" {
  description = "RDS 인스턴스 ID (DBInstanceIdentifier)"
  type        = string
}

variable "rds_memory_threshold_bytes" {
  description = "RDS FreeableMemory 임계값 (bytes)"
  type        = number
  default     = 214748364  # 200MB
}
