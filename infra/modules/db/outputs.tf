output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_name" {
  value = var.db_name
}

output "db_user" {
  value = var.db_user
}

output "rds_instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.this.id
}

# ✅ modules/db/outputs.tf
output "db_identifier" {
  value       = aws_db_instance.this.id
  description = "RDS DB Identifier"
}
