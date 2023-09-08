locals {
  eks_availability_zones = toset([
    "us-east-1a",
    "us-east-1b",
  ])
}
# Reference https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/57e1156420c1f4893c7fc50da8b8dbf322961d34/main.tf#L26
resource "aws_vpc" "legacy-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true # Defaults to true, but for reference since EKS nodes needs this to be true in order to work properly
  enable_dns_hostnames = true

}

# EKS subnets
# Need to be at least two subnets in two different AZs
resource "aws_subnet" "eks_subnets" {
  for_each          = local.eks_availability_zones
  vpc_id            = aws_vpc.legacy-vpc.id
  cidr_block        = "10.0.${index(tolist(local.eks_availability_zones), each.value) + 1}.0/24"
  availability_zone = each.value # Ensure multi zones
}


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