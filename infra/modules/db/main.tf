# ✅ 파라미터 그룹: 슬로우 쿼리 로그 설정 포함
resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-mysql-params"
  family      = "mysql8.0"
  description = "MySQL 파라미터 그룹 for slow query"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.name}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.name}-rds"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  db_name     = var.db_name
  username = var.db_user
  password = var.db_password

  enabled_cloudwatch_logs_exports = ["slowquery"]

  tags = {
    Name = "${var.name}-rds"
  }
}
