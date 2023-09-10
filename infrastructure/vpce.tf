locals {
  vpc_endpoint_names = toset([
    "ssm",
    "eks",
    "ec2messages",
    "ssmmessages",
    "ec2",
  ])
}

# VPC Endpoints
# https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html
resource "aws_vpc_endpoint" "vpce" {
  for_each = local.vpc_endpoint_names
  # AWS services that integrate with AWS Private Link
  # https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
  service_name      = "com.amazonaws.us-east-1.${each.value}"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.legacy-vpc.id

  subnet_ids = [for az in local.eks_availability_zones : aws_subnet.eks_subnets[az].id]

  private_dns_enabled = true

  tags = {
    Name = "vpce-${each.value}"
  }

}