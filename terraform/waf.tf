
# WAF Web ACL for Jenkins ALB
resource "aws_wafv2_web_acl" "jenkins" {
  name  = "jenkins-waf"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-albania-only"
    priority = 1

    action {
      allow {}
    }

    statement {
      geo_match_statement {
        country_codes = ["AL"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "jenkins-albania-rule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "jenkins-waf"
    sampled_requests_enabled   = true
  }
}


# Associate WAF Web ACL with Jenkins ALB
resource "aws_wafv2_web_acl_association" "jenkins" {
  resource_arn = module.jenkins_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.jenkins.arn
}
