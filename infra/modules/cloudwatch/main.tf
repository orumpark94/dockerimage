# ✅ CloudWatch 모듈: ECS + RDS 모니터링 및 알람 설정

# ECS 로그 그룹
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.log_group_name
  retention_in_days = var.retention_days
}

# SNS Topic (공통 알람 채널)
resource "aws_sns_topic" "alerts" {
  name = "${var.name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# ✅ ECS CPU 알람 (70% 이상)
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.name}-ecs-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_description = "ECS CPU 70% 초과"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# ✅ ECS Memory 알람 (80% 이상)
resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "${var.name}-ecs-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  alarm_description = "ECS Memory 80% 초과"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# ✅ ECS Error 로그 탐지 ("ERROR" 문자열 포함 시)
resource "aws_cloudwatch_log_metric_filter" "ecs_error_filter" {
  name           = "ecs-error-filter"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
  pattern        = "\"ERROR\""

  metric_transformation {
    name      = "EcsAppErrorCount"
    namespace = "ECS/AppLogs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_error_alarm" {
  alarm_name          = "${var.name}-ecs-error-alarm"
  metric_name         = "EcsAppErrorCount"
  namespace           = "ECS/AppLogs"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_description   = "ECS 앱에서 ERROR 발생"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  depends_on          = [aws_cloudwatch_log_metric_filter.ecs_error_filter]
}

# ✅ RDS Slow Query 로그 설정은 RDS 모듈에서 아래와 같이 구성되어야 함:
# enabled_cloudwatch_logs_exports = ["slowquery"]
# → CloudWatch 콘솔에서 /aws/rds/cluster/rds-identifier 로그 그룹 확인 가능

# ✅ RDS CPU 알람 (70% 이상)
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.name}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_description = "RDS CPU 70% 초과"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# ✅ RDS Memory 알람 (FreeableMemory < 20%)
resource "aws_cloudwatch_metric_alarm" "rds_memory_low" {
  alarm_name          = "${var.name}-rds-low-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = var.rds_memory_threshold_bytes # 예: 214748364 (200MB)

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_description = "RDS FreeableMemory 200MB 미만"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# ✅ CloudWatch Dashboard 시각화 추가
resource "aws_cloudwatch_dashboard" "this" {
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
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name ]
          ],
          view       = "timeSeries",
          stacked    = false,
          region     = var.region,
          title      = "ECS CPU 사용률"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name ]
          ],
          view       = "timeSeries",
          stacked    = false,
          region     = var.region,
          title      = "ECS Memory 사용률"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 12,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_identifier ]
          ],
          view       = "timeSeries",
          stacked    = false,
          region     = var.region,
          title      = "RDS CPU 사용률"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 18,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", var.rds_identifier ]
          ],
          view       = "timeSeries",
          stacked    = false,
          region     = var.region,
          title      = "RDS FreeableMemory (남은 메모리)"
        }
      }
    ]
  })
}
