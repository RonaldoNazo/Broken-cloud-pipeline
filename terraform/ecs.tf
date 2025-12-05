# CloudWatch Log Group for Application
resource "aws_cloudwatch_log_group" "application" {
  name              = "/ecs/application"
  retention_in_days = 365
  kms_key_id        = "alias/aws/logs"
}

# CloudWatch Log Group for Jenkins
resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/ecs/jenkins"
  retention_in_days = 365
  kms_key_id        = "alias/aws/logs"
}

# Application ECS Cluster
module "application_ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.10.0"

  cluster_name = "application-cluster"

  default_capacity_provider_strategy = {
    application = {
      weight = 1
      base   = 0
    }
  }

  autoscaling_capacity_providers = {
    application = {
      auto_scaling_group_arn         = module.application_asg.autoscaling_group_arn
      managed_termination_protection = "DISABLED"

      managed_scaling = {
        maximum_scaling_step_size = 2
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }
    }
  }
}

# Jenkins ECS Cluster
module "jenkins_ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.10.0"

  cluster_name = "jenkins-cluster"

  default_capacity_provider_strategy = {
    jenkins = {
      weight = 1
      base   = 0
    }
  }

  autoscaling_capacity_providers = {
    jenkins = {
      auto_scaling_group_arn         = module.jenkins_asg.autoscaling_group_arn
      managed_termination_protection = "DISABLED"

      managed_scaling = {
        maximum_scaling_step_size = 2
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }
    }
  }
}

# ECS Task Definition for Application
resource "aws_ecs_task_definition" "application" {
  family                   = "application"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "application"
      image     = "infrastructureascode/hello-world"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.application.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "application"
        }
      }
    }
  ])
}

# ECS Task Definition for Jenkins
resource "aws_ecs_task_definition" "jenkins" {
  family                   = "jenkins"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "jenkins"
      image     = "jenkins/jenkins:lts"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.jenkins.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "jenkins"
        }
      }
    }
  ])
}

# ECS Service for Application
resource "aws_ecs_service" "application" {
  name            = "application-service"
  cluster         = module.application_ecs.cluster_id
  task_definition = aws_ecs_task_definition.application.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = module.application_alb.target_groups["application"].arn
    container_name   = "application"
    container_port   = 8080
  }

  depends_on = [
    module.application_alb,
    aws_iam_role_policy_attachment.ecs_instance_role_policy
  ]
}

# ECS Service for Jenkins
resource "aws_ecs_service" "jenkins" {
  name            = "jenkins-service"
  cluster         = module.jenkins_ecs.cluster_id
  task_definition = aws_ecs_task_definition.jenkins.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = module.jenkins_alb.target_groups["jenkins"].arn
    container_name   = "jenkins"
    container_port   = 8080
  }

  depends_on = [
    module.jenkins_alb,
    aws_iam_role_policy_attachment.ecs_instance_role_policy
  ]
}
