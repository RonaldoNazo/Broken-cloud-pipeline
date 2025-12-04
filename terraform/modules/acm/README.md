# ACM Certificate Module

This module creates an AWS ACM (AWS Certificate Manager) certificate with DNS validation using Route53.

## Description

The module creates an ACM certificate for a specified domain and automatically handles DNS validation by creating the necessary Route53 records in the specified hosted zone.

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| domain_name | Domain name for the ACM certificate | string | - | yes |
| zone_id | Route53 hosted zone ID for DNS validation | string | - | yes |
| tags | Tags to apply to the ACM certificate | object | see variables.tf | no |

## Output Variables

| Name | Description |
|------|-------------|
| certificate_arn | ARN of the ACM certificate |
| certificate_id | ID of the ACM certificate |
| certificate_domain_name | Domain name of the ACM certificate |
| validation_record_fqdns | FQDNs of the validation records |

## Usage

```hcl
module "acm_certificate" {
  source = "./modules/acm"

  domain_name = "example.com"
  zone_id     = "Z1234567890ABC"

  tags = {
    environment = "production"
    product     = "web"
    service     = "frontend"
  }
}
```

## Resources Created

- `aws_acm_certificate` - ACM certificate
- `aws_acm_certificate_validation` - Certificate validation waiter
- `aws_route53_record` - DNS validation records (one per domain validation option)

## Notes

- The certificate uses DNS validation method
- Validation records are automatically created in the specified Route53 hosted zone
- The module waits for certificate validation to complete before proceeding
- The certificate has `create_before_destroy` lifecycle policy enabled
