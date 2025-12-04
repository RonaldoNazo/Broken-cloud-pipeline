# Application Load Balancer
module "application_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.3.1"

  name = "application-alb"

  load_balancer_type = "application"
  vpc_id             = module.application_vpc.vpc_id
  subnets            = module.application_vpc.public_subnets
  security_groups    = [aws_security_group.application_alb.id]

  enable_deletion_protection = false

  access_logs = {
    bucket  = aws_s3_bucket.logs.id
    prefix  = "application-alb"
    enabled = true
  }

  target_groups = {
    application = {
      name              = "application-tg"
      backend_protocol  = "HTTP"
      backend_port      = 8000
      target_type       = "instance"
      create_attachment = false
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }


      deregistration_delay = 30
    }
  }

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn = module.application_acm.certificate_arn

      forward = {
        target_group_key = "application"
      }
    }
  }
}

# Jenkins Load Balancer
module "jenkins_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.3.1"

  name = "jenkins-alb"

  load_balancer_type = "application"
  vpc_id             = module.jenkins_vpc.vpc_id
  subnets            = module.jenkins_vpc.public_subnets
  security_groups    = [aws_security_group.jenkins_alb.id]

  enable_deletion_protection = false

  access_logs = {
    bucket  = aws_s3_bucket.logs.id
    prefix  = "jenkins-alb"
    enabled = true
  }

  target_groups = {
    jenkins = {
      name             = "jenkins-tg"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200,403"
        path                = "/login"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      create_attachment    = false
      deregistration_delay = 30
    }
  }

  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn = module.jenkins_acm.certificate_arn

      forward = {
        target_group_key = "jenkins"
      }
    }
  }
}
