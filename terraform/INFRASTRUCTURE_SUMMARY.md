# Terraform Infrastructure Summary

## Project Structure

```
terraform/
├── .gitignore                    # Git ignore file for Terraform
├── DEPLOYMENT_GUIDE.md           # Step-by-step deployment instructions
├── README.md                     # Project documentation
├── terraform.tfvars.example      # Example variables file
│
├── providers.tf                  # Provider configuration and S3 backend
├── variables.tf                  # Input variables
├── outputs.tf                    # Output values
│
├── application_vpc.tf            # Application VPC configuration
├── jenkins_vpc.tf                # Jenkins VPC configuration
├── security_groups.tf            # Security groups for ALB, ECS, and EC2
├── iam.tf                        # IAM roles and policies for ECS
│
├── s3.tf                         # S3 bucket for logs
├── acm.tf                        # ACM certificates using custom module
├── alb.tf                        # Application Load Balancers
├── asg.tf                        # Auto Scaling Groups for EC2 instances
├── ecs.tf                        # ECS clusters, task definitions, and services
│
├── waf.tf                        # WAF Web ACLs
├── route53.tf                    # Route53 DNS records and health checks
├── cloudwatch.tf                 # CloudWatch alarms and SNS topic
├── budgets.tf                    # AWS Budgets and cost allocation tags
│
└── modules/
    └── acm/                      # Custom ACM certificate module
        ├── main.tf               # ACM resources
        ├── variables.tf          # Module input variables
        ├── outputs.tf            # Module outputs
        ├── providers.tf          # Provider requirements
        └── README.md             # Module documentation
```

## Resources Created

### Networking (18 resources)
- 2 VPCs (Application and Jenkins)
- 8 Subnets (4 public, 4 private)
- 2 Internet Gateways
- 2 NAT Gateways
- 4 Route Tables
- 8 Network ACLs

### Compute (22 resources)
- 2 ECS Clusters
- 2 ECS Task Definitions
- 2 ECS Services
- 2 Auto Scaling Groups
- 2 Launch Templates
- 2 ECS Capacity Providers
- 4 EC2 Instances (managed by ASG)
- 6 Security Groups

### Load Balancing (6 resources)
- 2 Application Load Balancers
- 2 Target Groups
- 2 HTTPS Listeners

### SSL/TLS (6 resources)
- 2 ACM Certificates
- 2 ACM Certificate Validations
- 2 Route53 Certificate Validation Records

### Security (4 resources)
- 2 WAF Web ACLs
- 2 WAF Web ACL Associations

### DNS (6 resources)
- 2 Route53 A Records
- 2 Route53 Health Checks
- 2 CloudWatch Health Check Alarms

### Storage (6 resources)
- 1 S3 Bucket for logs
- 1 S3 Bucket Versioning Configuration
- 1 S3 Bucket Encryption Configuration
- 1 S3 Bucket Public Access Block
- 1 S3 Bucket Lifecycle Configuration
- 1 S3 Bucket Policy

### Monitoring & Alerting (6 resources)
- 1 SNS Topic
- 1 SNS Email Subscription
- 4 CloudWatch Metric Alarms

### Cost Management (2 resources)
- 1 AWS Budget
- 1 Cost Allocation Tag

### IAM (5 resources)
- 2 IAM Roles
- 2 IAM Role Policy Attachments
- 1 IAM Instance Profile

### Logging (2 resources)
- 2 CloudWatch Log Groups

**Total: ~87 AWS Resources**

## Key Features

### High Availability
- Multi-AZ deployment across 2 Availability Zones
- Auto Scaling Groups for EC2 instances
- Application Load Balancers with health checks
- ECS Service auto-recovery

### Security
- HTTPS-only traffic enforced by WAF
- Geographic restrictions (Albania-only for Jenkins)
- Private subnets for compute resources
- Security groups with least-privilege access
- Encrypted S3 buckets
- SSL/TLS certificates from ACM

### Monitoring & Alerting
- CloudWatch alarms for 5xx errors
- Route53 health checks
- SNS notifications via email
- ECS Container Insights enabled
- Centralized logging to S3 and CloudWatch

### Cost Optimization
- Daily budget alerts at $1/day
- Cost allocation tags enabled
- Single NAT Gateway per VPC
- Right-sized instance types (t3.micro)
- S3 lifecycle policies for log retention

## Quick Start

```bash
# 1. Navigate to terraform directory
cd terraform

# 2. Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Initialize Terraform
terraform init

# 4. Plan deployment
terraform plan

# 5. Apply configuration
terraform apply

# 6. Confirm SNS email subscription
# Check your email and confirm the subscription

# 7. Wait for certificate validation
# This can take 5-30 minutes

# 8. Access applications
# Application: https://helloworld.cloud.ustai.net
# Jenkins: https://jenkins.cloud.ustai.net (Albania IPs only)
```

## Public Modules Used

- **terraform-aws-modules/vpc/aws** (~> 5.0): VPC module for both Application and Jenkins VPCs
- **terraform-aws-modules/alb/aws** (~> 9.0): Application Load Balancer module for both ALBs
- **terraform-aws-modules/ecs/aws** (~> 5.0): ECS cluster module with capacity provider integration
- **terraform-aws-modules/autoscaling/aws** (~> 7.0): Auto Scaling Group module for EC2 instances

## Custom Modules Created

- **modules/acm**: Custom ACM certificate module with DNS validation
  - Used for both Application and Jenkins domain certificates
  - Handles automatic DNS validation via Route53
  - Reusable across multiple domains

All other resources are created using native AWS provider resources following Terraform best practices.

## Configuration Management

### Tags Applied to All Resources
```hcl
{
  environment = "develop"
  product     = "cloud"
  service     = "pipeline"
}
```

### Default Values
- Region: `us-east-1`
- Application VPC CIDR: `10.40.0.0/16`
- Jenkins VPC CIDR: `10.41.0.0/16`
- Instance Type: `t3.micro`
- Budget Limit: `$1 USD daily`

## DNS Configuration

| Domain | Target | Type |
|--------|--------|------|
| helloworld.cloud.ustai.net | Application ALB | A (Alias) |
| jenkins.cloud.ustai.net | Jenkins ALB | A (Alias) |

## Health Check Paths

| Service | Path | Expected Status |
|---------|------|----------------|
| Application | /health | 200 |
| Jenkins | /login | 200, 403 |

## Container Images

| Service | Image | Port |
|---------|-------|------|
| Application | infrastructureascode/hello-world | 8000 |
| Jenkins | jenkins/jenkins:lts | 8080 |

## State Management

- **Backend**: S3
- **State File**: `terraform-state-broken-pipeline/terraform.tfstate`
- **State Locking**: DynamoDB table `terraform-state-lock`
- **Encryption**: Enabled (AES256)

## Notes

1. The Route53 hosted zone `ustai.net` must exist before deployment
2. SNS email subscription requires manual confirmation
3. ACM certificate validation may take up to 30 minutes
4. Jenkins is only accessible from Albanian IP addresses (AL) due to WAF geo-blocking
5. All resources are tagged with default tags for cost tracking
6. Budget alerts are configured for resources tagged with `product=cloud`
