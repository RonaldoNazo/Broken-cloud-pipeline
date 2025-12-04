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
