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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.24 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for the ACM certificate | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the ACM certificate | <pre>object({<br/>    environment = optional(string, "develop")<br/>    product     = optional(string, "cloud")<br/>    service     = optional(string, "pipeline")<br/>  })</pre> | <pre>{<br/>  "environment": "develop",<br/>  "product": "cloud",<br/>  "service": "pipeline"<br/>}</pre> | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 hosted zone ID for DNS validation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of the ACM certificate |
| <a name="output_certificate_domain_name"></a> [certificate\_domain\_name](#output\_certificate\_domain\_name) | Domain name of the ACM certificate |
| <a name="output_certificate_id"></a> [certificate\_id](#output\_certificate\_id) | ID of the ACM certificate |
| <a name="output_validation_record_fqdns"></a> [validation\_record\_fqdns](#output\_validation\_record\_fqdns) | FQDNs of the validation records |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
