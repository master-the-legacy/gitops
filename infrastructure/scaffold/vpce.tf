# VPC Endpoints
# https://docs.aws.amazon.com/whitepapers/latest/aws-privatelink/what-are-vpc-endpoints.html
resource "aws_vpc_endpoint" "vpce" {
  for_each = local.vpc_endpoint_names
  # AWS services that integrate with AWS Private Link
  # https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html
  service_name      = "com.amazonaws.us-east-1.${each.value}"
  vpc_endpoint_type = "Interface"
  vpc_id            = data.aws_vpc.legacy-vpc.id

  subnet_ids = data.aws_subnets.eks_subnets.ids
  security_group_ids = [data.aws_security_group.eks-cluster-sg.id]

  private_dns_enabled = true

  tags = {
    Name = "vpce-${each.value}"
  }
}