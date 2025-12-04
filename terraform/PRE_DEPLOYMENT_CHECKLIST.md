# Pre-Deployment Checklist

Before deploying the infrastructure, ensure all prerequisites are met:

## AWS Account Setup

- [ ] AWS Account with appropriate permissions
- [ ] AWS CLI installed and configured
- [ ] Valid AWS credentials configured (`aws configure`)
- [ ] IAM role created for Terraform to assume
- [ ] Note the IAM role ARN for configuration

## Terraform Setup

- [ ] Terraform >= 1.0 installed (`terraform --version`)
- [ ] Working directory is `terraform/`
- [ ] All Terraform files are present

## Backend Resources

- [ ] S3 bucket `terraform-state-broken-pipeline` created
- [ ] S3 bucket versioning enabled
- [ ] S3 bucket encryption enabled
- [ ] DynamoDB table `terraform-state-lock` created
- [ ] DynamoDB table has `LockID` as primary key (String)

## DNS Setup

- [ ] Route53 hosted zone for `ustai.net` exists
- [ ] Hosted zone is public (not private)
- [ ] Note the hosted zone ID
- [ ] Domain nameservers configured (if using external registrar)

## Configuration Files

- [ ] Copied `terraform.tfvars.example` to `terraform.tfvars`
- [ ] Updated `assume_role_arn` with actual IAM role ARN
- [ ] Updated `notification_email` with your email address
- [ ] Reviewed and adjusted other variables as needed

## Email Notification

- [ ] Valid email address configured in `terraform.tfvars`
- [ ] Email inbox accessible for SNS subscription confirmation

## Optional: Cost Considerations

- [ ] Reviewed estimated monthly costs (~$115-120/month)
- [ ] Budget alerts configured ($1/day)
- [ ] Understand the resources that will be created
- [ ] Plan for cleanup/destruction if needed

## Network Requirements

- [ ] No conflicting VPC CIDR blocks in your AWS account
  - Application VPC: 10.40.0.0/16
  - Jenkins VPC: 10.41.0.0/16

## Access Requirements

- [ ] Understand Jenkins will only be accessible from Albanian IPs
- [ ] Application will be publicly accessible via HTTPS
- [ ] SSL certificates will be automatically provisioned via ACM

## Deployment Steps

Once all checklist items are complete:

1. Run `terraform init`
2. Run `terraform validate`
3. Run `terraform plan` and review
4. Run `terraform apply`
5. Confirm SNS email subscription
6. Wait for ACM certificate validation (5-30 minutes)
7. Access applications via HTTPS

## Post-Deployment Verification

- [ ] SNS email subscription confirmed
- [ ] ACM certificates validated
- [ ] ECS tasks running
- [ ] ALB targets healthy
- [ ] Route53 health checks passing
- [ ] Applications accessible via HTTPS
- [ ] CloudWatch alarms configured
- [ ] Budget alerts active

## Troubleshooting Resources

If you encounter issues:

1. Check `DEPLOYMENT_GUIDE.md` for detailed troubleshooting
2. Review CloudWatch Logs
3. Check AWS Console for resource status
4. Verify security groups and network ACLs
5. Ensure IAM role has necessary permissions

## Cleanup Checklist

When ready to destroy resources:

- [ ] Backup any important data
- [ ] Run `terraform destroy`
- [ ] Verify all resources are deleted in AWS Console
- [ ] Manually delete S3 bucket contents if needed
- [ ] Remove state files if no longer needed
