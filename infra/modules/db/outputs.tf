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
