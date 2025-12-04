output "application_vpc_id" {
  description = "ID of the Application VPC"
  value       = module.application_vpc.vpc_id
}

output "jenkins_vpc_id" {
  description = "ID of the Jenkins VPC"
  value       = module.jenkins_vpc.vpc_id
}

output "application_alb_dns_name" {
  description = "DNS name of the Application ALB"
  value       = module.application_alb.dns_name
}

output "jenkins_alb_dns_name" {
  description = "DNS name of the Jenkins ALB"
  value       = module.jenkins_alb.dns_name
}

output "application_domain" {
  description = "Application domain name"
  value       = aws_route53_record.application.fqdn
}

output "jenkins_domain" {
  description = "Jenkins domain name"
  value       = aws_route53_record.jenkins.fqdn
}

output "s3_logs_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.id
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  value       = aws_sns_topic.alerts.arn
}
