resource "aws_ssm_parameter" "db_host" {
  name  = "/app/DB_HOST"
  type  = "String"
  value = aws_db_instance.this.address
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/app/DB_USER"
  type  = "String"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/app/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}
