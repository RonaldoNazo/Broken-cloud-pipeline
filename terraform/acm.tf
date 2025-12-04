# Data source for Route53 hosted zone
data "aws_route53_zone" "main" {
  name         = var.route53_zone_name
  private_zone = false
}

# ACM Certificate for Application domain
module "application_acm" {
  source = "./modules/acm"

  domain_name = "helloworld.cloud.ustai.net"
  zone_id     = data.aws_route53_zone.main.zone_id

  tags = var.tags
}

# ACM Certificate for Jenkins domain
module "jenkins_acm" {
  source = "./modules/acm"

  domain_name = "jenkins.cloud.ustai.net"
  zone_id     = data.aws_route53_zone.main.zone_id

  tags = var.tags
}
