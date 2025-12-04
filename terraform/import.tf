# Import existing IAM roles from AWS account
# These roles already exist and should not be recreated

# Import ECS Task Execution Role
import {
  to = aws_iam_role.ecs_task_execution_role
  identity = {
    name = "ecsTaskExecutionRole"
  }

}

# Import ECS Task Execution Role Policy Attachment
import {
  to = aws_iam_role_policy_attachment.ecs_task_execution_role_policy
  identity = {
    role       = "ecsTaskExecutionRole"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  }
}


# Import ECS Instance Role
import {
  to = aws_iam_role.ecs_instance_role
  identity = {
    name = "ecsInstanceRole"
  }
}

# Import ECS Instance Role Policy Attachment
import {
  to = aws_iam_role_policy_attachment.ecs_instance_role_policy

  identity = {
    role       = "ecsInstanceRole"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  }
}
