output "sns_topic_arn" {
  description = "SNS 알림 토픽 ARN"
  value       = aws_sns_topic.alerts.arn
}

output "dashboard_name" {
  description = "CloudWatch Dashboard 이름"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}
