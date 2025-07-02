output "log_group_name" {
  description = "ECS 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.ecs_log_group.name
}

output "dashboard_name" {
  description = "CloudWatch Dashboard 이름"
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}

output "sns_topic_arn" {
  description = "SNS 알람 토픽 ARN"
  value       = aws_sns_topic.alerts.arn
}
