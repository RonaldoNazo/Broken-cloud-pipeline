variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ACM certificate"
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
