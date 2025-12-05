variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}


variable "tags" {
  description = "Default tags to apply to all resources"
  type = object({
    environment = optional(string, "develop")
    product     = optional(string, "cloud")
    service     = optional(string, "pipeline")
  })
  default = {
    environment = "develop"
    product     = "cloud"
    service     = "pipeline"
  }
}

variable "application_vpc_cidr" {
  description = "CIDR block for Application VPC"
  type        = string
  default     = "10.40.0.0/16"
}

variable "jenkins_vpc_cidr" {
  description = "CIDR block for Jenkins VPC"
  type        = string
  default     = "10.41.0.0/16"
}

variable "route53_zone_name" {
  description = "Route53 hosted zone name"
  type        = string
  default     = "ustai.net"
}

variable "notification_email" {
  description = "Email address for SNS notifications"
  type        = string
  default     = "nazoaldo@gmail.com"
}

# Commenting ,as the Tag is not yet in the aws account
# variable "budget_limit_amount" {
#   description = "Daily budget limit in USD"
#   type        = string
#   default     = "1"
# }
