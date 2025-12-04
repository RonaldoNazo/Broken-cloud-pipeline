# Terraform Infrastructure for Broken Pipeline Challenge

This Terraform configuration deploys a complete AWS infrastructure including:
- Two VPCs (Application and Jenkins)
- ECS clusters with EC2 launch type
- Application Load Balancers
- WAF configurations
- Route53 DNS records
- CloudWatch monitoring and SNS notifications
- S3 bucket for logs
- AWS Budgets

## Public Modules Used

This infrastructure leverages the following public Terraform modules:
- **VPC Module** (terraform-aws-modules/vpc/aws ~> 5.0)
- **ALB Module** (terraform-aws-modules/alb/aws ~> 9.0)
- **ECS Module** (terraform-aws-modules/ecs/aws ~> 5.0)
- **Auto Scaling Module** (terraform-aws-modules/autoscaling/aws ~> 7.0)

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- S3 bucket for Terraform state: `terraform-state-broken-pipeline`
- DynamoDB table for state locking: `terraform-state-lock`
- IAM role ARN for assuming

## Input Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region to deploy resources | string | us-east-1 |
| assume_role_arn | ARN of the IAM role to assume | string | - |
| tags | Default tags to apply to all resources | object | see variables.tf |
| application_vpc_cidr | CIDR block for Application VPC | string | 10.40.0.0/16 |
| jenkins_vpc_cidr | CIDR block for Jenkins VPC | string | 10.41.0.0/16 |
| route53_zone_name | Route53 hosted zone name | string | ustai.net |
| notification_email | Email address for SNS notifications | string | nazoaldo@gmail.com |
| budget_limit_amount | Daily budget limit in USD | string | 1 |

## Output Variables

| Name | Description |
|------|-------------|
| application_vpc_id | ID of the Application VPC |
| jenkins_vpc_id | ID of the Jenkins VPC |
| application_alb_dns_name | DNS name of the Application ALB |
| jenkins_alb_dns_name | DNS name of the Jenkins ALB |
| application_domain | Application domain name |
| jenkins_domain | Jenkins domain name |
| s3_logs_bucket_name | Name of the S3 bucket for logs |
| sns_topic_arn | ARN of the SNS topic for notifications |

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Create a terraform.tfvars file with your values:
```hcl
assume_role_arn = "arn:aws:iam::123456789012:role/TerraformRole"
notification_email = "your-email@example.com"
```

3. Plan the deployment:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

## Resources Created

- 2 VPCs with public and private subnets
- ECS clusters and services
- Application Load Balancers
- WAF Web ACLs
- Route53 DNS records and health checks
- S3 bucket for logs
- SNS topic and CloudWatch alarms
- AWS Budget alerts
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_acm"></a> [application\_acm](#module\_application\_acm) | ./modules/acm | n/a |
| <a name="module_application_alb"></a> [application\_alb](#module\_application\_alb) | terraform-aws-modules/alb/aws | 10.3.1 |
| <a name="module_application_asg"></a> [application\_asg](#module\_application\_asg) | terraform-aws-modules/autoscaling/aws | 9.0.2 |
| <a name="module_application_ecs"></a> [application\_ecs](#module\_application\_ecs) | terraform-aws-modules/ecs/aws | 6.10.0 |
| <a name="module_application_vpc"></a> [application\_vpc](#module\_application\_vpc) | terraform-aws-modules/vpc/aws | 6.5.1 |
| <a name="module_jenkins_acm"></a> [jenkins\_acm](#module\_jenkins\_acm) | ./modules/acm | n/a |
| <a name="module_jenkins_alb"></a> [jenkins\_alb](#module\_jenkins\_alb) | terraform-aws-modules/alb/aws | 10.3.1 |
| <a name="module_jenkins_asg"></a> [jenkins\_asg](#module\_jenkins\_asg) | terraform-aws-modules/autoscaling/aws | 9.0.2 |
| <a name="module_jenkins_ecs"></a> [jenkins\_ecs](#module\_jenkins\_ecs) | terraform-aws-modules/ecs/aws | 6.10.0 |
| <a name="module_jenkins_vpc"></a> [jenkins\_vpc](#module\_jenkins\_vpc) | terraform-aws-modules/vpc/aws | 6.5.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.application](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.application_alb_5xx](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.application_health](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.jenkins_alb_5xx](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.jenkins_health](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.route53_5xx](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_service.application](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/ecs_service) | resource |
| [aws_ecs_service.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.application](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_instance_profile.ecs_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs_instance_role](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_execution_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_instance_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route.application_to_jenkins_private](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route) | resource |
| [aws_route.application_to_jenkins_public](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route) | resource |
| [aws_route.jenkins_to_application_private](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route) | resource |
| [aws_route.jenkins_to_application_public](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route) | resource |
| [aws_route53_health_check.application](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route53_health_check) | resource |
| [aws_route53_health_check.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route53_health_check) | resource |
| [aws_route53_record.application](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route53_record) | resource |
| [aws_route53_record.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.logs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.application_alb](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_security_group.application_ec2](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_security_group.application_ecs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_security_group.jenkins_alb](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_security_group.jenkins_ec2](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_security_group.jenkins_ecs](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/security_group) | resource |
| [aws_sns_topic.alerts](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/sns_topic_subscription) | resource |
| [aws_vpc_peering_connection.application_jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/vpc_peering_connection) | resource |
| [aws_wafv2_web_acl.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.jenkins](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/resources/wafv2_web_acl_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.ecs_optimized_ami](https://registry.terraform.io/providers/hashicorp/aws/6.24.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_vpc_cidr"></a> [application\_vpc\_cidr](#input\_application\_vpc\_cidr) | CIDR block for Application VPC | `string` | `"10.40.0.0/16"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources | `string` | `"eu-central-1"` | no |
| <a name="input_budget_limit_amount"></a> [budget\_limit\_amount](#input\_budget\_limit\_amount) | Daily budget limit in USD | `string` | `"1"` | no |
| <a name="input_jenkins_vpc_cidr"></a> [jenkins\_vpc\_cidr](#input\_jenkins\_vpc\_cidr) | CIDR block for Jenkins VPC | `string` | `"10.41.0.0/16"` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for SNS notifications | `string` | `"nazoaldo@gmail.com"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 hosted zone name | `string` | `"ustai.net"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags to apply to all resources | <pre>object({<br/>    environment = optional(string, "develop")<br/>    product     = optional(string, "cloud")<br/>    service     = optional(string, "pipeline")<br/>  })</pre> | <pre>{<br/>  "environment": "develop",<br/>  "product": "cloud",<br/>  "service": "pipeline"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_alb_dns_name"></a> [application\_alb\_dns\_name](#output\_application\_alb\_dns\_name) | DNS name of the Application ALB |
| <a name="output_application_domain"></a> [application\_domain](#output\_application\_domain) | Application domain name |
| <a name="output_application_vpc_id"></a> [application\_vpc\_id](#output\_application\_vpc\_id) | ID of the Application VPC |
| <a name="output_jenkins_alb_dns_name"></a> [jenkins\_alb\_dns\_name](#output\_jenkins\_alb\_dns\_name) | DNS name of the Jenkins ALB |
| <a name="output_jenkins_domain"></a> [jenkins\_domain](#output\_jenkins\_domain) | Jenkins domain name |
| <a name="output_jenkins_vpc_id"></a> [jenkins\_vpc\_id](#output\_jenkins\_vpc\_id) | ID of the Jenkins VPC |
| <a name="output_s3_logs_bucket_name"></a> [s3\_logs\_bucket\_name](#output\_s3\_logs\_bucket\_name) | Name of the S3 bucket for logs |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic for notifications |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
