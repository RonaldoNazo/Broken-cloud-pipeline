# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "infrastructure-alerts"
}

# SNS Topic Subscription for email notifications
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# CloudWatch Metric Alarm for Route53 5xx errors
resource "aws_cloudwatch_metric_alarm" "route53_5xx" {
  alarm_name          = "route53-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors Route53 HTTP 5xx errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = module.application_alb.arn_suffix
  }
}

# CloudWatch Metric Alarm for Application ALB 5xx errors
resource "aws_cloudwatch_metric_alarm" "application_alb_5xx" {
  alarm_name          = "application-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors Application ALB HTTP 5xx errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = module.application_alb.arn_suffix
  }
}

# CloudWatch Metric Alarm for Jenkins ALB 5xx errors
resource "aws_cloudwatch_metric_alarm" "jenkins_alb_5xx" {
  alarm_name          = "jenkins-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "This metric monitors Jenkins ALB HTTP 5xx errors"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = module.jenkins_alb.arn_suffix
  }
}
