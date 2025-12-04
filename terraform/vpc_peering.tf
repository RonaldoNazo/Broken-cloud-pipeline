# VPC Peering Connection between Application and Jenkins VPCs
resource "aws_vpc_peering_connection" "application_jenkins" {
  vpc_id      = module.application_vpc.vpc_id
  peer_vpc_id = module.jenkins_vpc.vpc_id
  auto_accept = true

  tags = {
    Name = "application-jenkins-peering"
  }
}

# Add routes from Application VPC to Jenkins VPC
resource "aws_route" "application_to_jenkins_private" {
  count = length(module.application_vpc.private_route_table_ids)

  route_table_id            = module.application_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = var.jenkins_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.application_jenkins.id
}

resource "aws_route" "application_to_jenkins_public" {
  count = length(module.application_vpc.public_route_table_ids)

  route_table_id            = module.application_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = var.jenkins_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.application_jenkins.id
}

# Add routes from Jenkins VPC to Application VPC
resource "aws_route" "jenkins_to_application_private" {
  count = length(module.jenkins_vpc.private_route_table_ids)

  route_table_id            = module.jenkins_vpc.private_route_table_ids[count.index]
  destination_cidr_block    = var.application_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.application_jenkins.id
}

resource "aws_route" "jenkins_to_application_public" {
  count = length(module.jenkins_vpc.public_route_table_ids)

  route_table_id            = module.jenkins_vpc.public_route_table_ids[count.index]
  destination_cidr_block    = var.application_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.application_jenkins.id
}
