output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "certificate_id" {
  description = "ID of the ACM certificate"
  value       = aws_acm_certificate.this.id
}

output "certificate_domain_name" {
  description = "Domain name of the ACM certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "validation_record_fqdns" {
  description = "FQDNs of the validation records"
  value       = [for record in aws_route53_record.validation : record.fqdn]
}
