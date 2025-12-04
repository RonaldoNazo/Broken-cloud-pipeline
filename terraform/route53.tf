# Route53 record for Application domain
resource "aws_route53_record" "application" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "helloworld.cloud.ustai.net"
  type    = "A"

  alias {
    name                   = module.application_alb.dns_name
    zone_id                = module.application_alb.zone_id
    evaluate_target_health = true
  }
}

# Route53 record for Jenkins domain
resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "jenkins.cloud.ustai.net"
  type    = "A"

  alias {
    name                   = module.jenkins_alb.dns_name
    zone_id                = module.jenkins_alb.zone_id
    evaluate_target_health = true
  }
}

# Route53 Health Check for Application
resource "aws_route53_health_check" "application" {
  fqdn              = module.application_alb.dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "application-health-check"
  }
}

# Route53 Health Check for Jenkins
resource "aws_route53_health_check" "jenkins" {
  fqdn              = module.jenkins_alb.dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/login"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "jenkins-health-check"
  }
}

# CloudWatch Metric Alarm for Application Health Check
resource "aws_cloudwatch_metric_alarm" "application_health" {
  alarm_name          = "application-health-check-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "This metric monitors application health check status"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.application.id
  }
}

# CloudWatch Metric Alarm for Jenkins Health Check
resource "aws_cloudwatch_metric_alarm" "jenkins_health" {
  alarm_name          = "jenkins-health-check-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "This metric monitors jenkins health check status"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    HealthCheckId = aws_route53_health_check.jenkins.id
  }
}
