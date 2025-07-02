output "sns_topic_arn" {
  description = "SNS Topic ARN used for CloudWatch alarms"
  value       = aws_sns_topic.alarm_topic.arn
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch Dashboard Name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}
