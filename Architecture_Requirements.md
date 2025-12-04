# Solution Architecture Document

## Networking Components

VPC 1 :
    - Name: Application-VPC
    - CIDR: 10.40.0.0/16
    - 4 Subnets (2 Public, 2 Private)
    - 2 Route Tables
    - 2 NACLs per Subnet type
    - 1 Internet Gateway
    - 1 NAT Gateway in one Public Subnet

VPC 2 :
    - Name: Jenkins-VPC
    - CIDR: 10.41.0.0/16
    - 4 Subnets (2 Public, 2 Private)
    - 2 Route Tables
    - 2 NACLs per Subnet type
    - 1 Internet Gateway
    - 1 NAT Gateway in one Public Subnet

## Compute Components

Application/Jenkins deployed as ECS with EC2 , deployed as a service , fronted by a load balancer , resolved by Route53

EC2 Container Instances:
    - Desired number 2 per each VPC (4 in total)
    - t3.micro instance type
    - Amazon Linux 2 AMI
    - Auto Scaling Group for each ECS Cluster
    - Deployed in Private Subnets

ECS Cluster:
    - One cluster for Application , one for Jenkins
    - Each in its respective VPC


ECS Service:
    - Use ECS with EC2 launch type
    - Desired count: 2 tasks per application , 1 task for jenkins
    - Use Application Load Balancer to distribute traffic to Application tasks
    - Use Application Load Balancer to distribute traffic to Jenkins task
    - Configure health check for the load balancer on path /health

ECS Tasks:
    - Application Task Definition:
        - Container Image: 'infrastructureascode/hello-world'
        - CPU: 256
        - Memory: 512
        - Container port : 8000
        - Health check on /health
    - Jenkins Task Definition:
        - Container Image: jenkins/jenkins:lts
        - CPU: 512
        - Memory: 1024
        - Container port : 8080

ALB:
    - One ALB for Application in Application-VPC
    - One ALB for Jenkins in Jenkins-VPC
    - ALB in Public Subnets
    - Security Group allowing inbound HTTPS (443) traffic from anywhere , outbound anywhere
    - Target Groups for Application and Jenkins tasks

## Security

WAF :
    - Create a waf for both ALBs
    - Allow only https traffic
    - For Jenkins ALB allow only traffic from Albania IP ranges using GeoMatch

## Route53 Components

Route53 Routes:
    - Application domain : helloworld.cloud.ustai.net -> points to Application ALB
    - Jenkins domain : jenkins.cloud.ustai.net -> points to Jenkins ALB
    - Use ustai.net as the hosted zone
    - Configure health checks for both domains pointing to their respective ALB health check paths

## Observability components

Cloud Watch :
    - Create a monitoring alarm for Route53 http 5xx errors > 0 send notification to an sns topic

SNS :
    - Create a sns topic to send alarm notifications to
    - Subscribe an email : nazoaldo@gmail.com

S3 :
    - Create an s3 bucket for ALB access logs, ECS container logs and pipeline logs.
    - Attach a bucket policy allowing log writes from ALB and ECS services.

## Cost Optimization

Enable Cost Allocation Tags for tag name "product",

Enable AWS Budgets to monitor costs and set alerts if daily costs $ exceed 1 USD . Set up only for tag name "product" with value "cloud"
Send notifications to the SNS topic
