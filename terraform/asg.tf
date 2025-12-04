# Data source for latest ECS-optimized Amazon Linux 2 AMI
data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

# Application Auto Scaling Group
module "application_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.0.2"

  name = "application-ecs-asg"

  image_id      = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = "t3.micro"

  vpc_zone_identifier = module.application_vpc.private_subnets

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  iam_instance_profile_arn = aws_iam_instance_profile.ecs_instance_profile.arn
  security_groups          = [aws_security_group.application_ec2.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${module.application_ecs.cluster_name} >> /etc/ecs/ecs.config
              EOF
  )

  enable_monitoring = true

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name             = "application-ecs-instance"
    AmazonECSManaged = "true"
  }
}

# Jenkins Auto Scaling Group
module "jenkins_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.0.2"

  name = "jenkins-ecs-asg"

  image_id      = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type = "t3.micro"

  vpc_zone_identifier = module.jenkins_vpc.private_subnets

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  iam_instance_profile_arn = aws_iam_instance_profile.ecs_instance_profile.arn
  security_groups          = [aws_security_group.jenkins_ec2.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${module.jenkins_ecs.cluster_name} >> /etc/ecs/ecs.config
              EOF
  )

  enable_monitoring = true

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name             = "jenkins-ecs-instance"
    AmazonECSManaged = "true"
  }
}
