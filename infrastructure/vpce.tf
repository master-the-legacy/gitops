# VPC Endpoints
# https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.legacy-vpc.id
  # AWS services that integrate with AWS Private Link
  # https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
  service_name      = "com.amazonaws.us-east-1.ec2" ## Allow instances in the same VPC and subnet to communicate with ec2 endpoint, necessary to join EKS cluster
  vpc_endpoint_type = "Interface"

  subnet_ids = [for az in local.eks_availability_zones : aws_subnet.eks_subnets[az].id]

  private_dns_enabled = true

  tags = {
    Name = "vpce-ec2"
  }
}

# TODO: Import the rest of the vpc endpoints
# Consideration for accessing EKS with a VPCe https://docs.aws.amazon.com/eks/latest/userguide/vpc-interface-endpoints.html