output "sns_topic_arn" {
  description = "ARN of the budget alert SNS topic"
  value       = aws_sns_topic.budgeting_alerts.arn
}

output "dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home#dashboards:name=${aws_cloudwatch_dashboard.cost_dashboard.dashboard_name}"
}
