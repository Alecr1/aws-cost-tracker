provider "aws" {
  region  = "us-east-2"
  profile = "alecr1" 

} 

resource "aws_s3_bucket" "my-aleccost-dash" {
  bucket = "aleccost-dashboard-unique-xyz123"
  acl = "private"
}


resource "aws_sns_topic" "budgeting_alerts" {
  name = "alec-budget-alerts"
}

resource "aws_sns_topic_subscription" "Urgetnt_alert" {
  topic_arn = aws_sns_topic.budgeting_alerts.arn
  protocol  = "email"
  endpoint  = "alecrobinson0807@gmail.com" # Replace with your email
}


resource "aws_budgets_budget" "monthly_budget" {
  name              = "alec-monthly-budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 50
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = ["alecrobinson0807@gmail.com"]
    subscriber_sns_topic_arns  = [aws_sns_topic.budgeting_alerts.arn]
  }
}



resource "aws_cloudwatch_metric_alarm" "cost_alarm" {
  alarm_name          = "monthly-cost-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600 # 6 hours
  statistic           = "Maximum"
  threshold           = 10
  alarm_description   = "Alarm when AWS charges exceed $10"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.budgeting_alerts.arn]
  dimensions = {
    Currency = "USD"
  }
}

resource "aws_cloudwatch_dashboard" "cost_dashboard" {
  dashboard_name = "aws-cost-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0,
        y = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/Billing", "EstimatedCharges", "Currency", "USD" ]
          ],
          region = "us-east-2",
          title = "AWS Estimated Charges",
          period = 21600,
          stat = "Maximum",
          annotations = {
            horizontal = [
              {
                label = "Budget Threshold",
                value = 10
              }
            ]
          }
        }
      }
    ]
  })
}
#add lamada?