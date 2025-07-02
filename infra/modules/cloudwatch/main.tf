# ✅ SNS Topic 생성
resource "aws_sns_topic" "alarm_topic" {
  name = "${var.name}-alarm-topic"
}

# ✅ 이메일 구독자 등록
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# ✅ ECS CPU 알람
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.name}-ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "ECS CPU usage is above 70%"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
}

# ✅ ECS Memory 알람
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.name}-ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ECS Memory usage is above 80%"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }
}

# ✅ RDS CPU 알람
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.name}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "RDS CPU usage is above 70%"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

# ✅ RDS Memory 알람
resource "aws_cloudwatch_metric_alarm" "rds_memory_high" {
  alarm_name          = "${var.name}-rds-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = var.rds_memory_threshold  # 메모리 부족 기준 (바이트 단위)
  alarm_description   = "RDS Memory usage is high"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

# ✅ RDS 슬로우 쿼리 로그 그룹 (로그 저장)
resource "aws_cloudwatch_log_group" "rds_slow_query" {
  name              = "/aws/rds/instance/${var.rds_identifier}/slowquery"
  retention_in_days = 7
}

# ✅ CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          title = "ECS CPU & Memory",
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name ],
            [ ".", "MemoryUtilization", ".", ".", ".", "." ]
          ],
          view = "timeSeries",
          stacked = false,
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 7,
        width = 12,
        height = 6,
        properties = {
          title = "RDS CPU & FreeableMemory",
          metrics = [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_identifier ],
            [ ".", "FreeableMemory", ".", "." ]
          ],
          view = "timeSeries",
          stacked = false,
          region = var.region
        }
      }
    ]
  })
}
