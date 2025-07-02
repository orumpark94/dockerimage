resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-rds-param-group"
  family = "mysql8.0"  # ❗ 올바른 family 명칭

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

  tags = {
    Name = "${var.name}-param-group"
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
  engine_version          = "8.0.34"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.db_sg_id]
  publicly_accessible     = false
  skip_final_snapshot     = true

  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  parameter_group_name    = aws_db_parameter_group.this.name

  tags = {
    Name = "${var.name}-rds"
  }
}
