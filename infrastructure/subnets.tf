locals {
  eks_availability_zones = toset([
    "us-east-1a",
    "us-east-1b",
  ])
}

# EKS subnets
# Need to be at least two subnets in two different AZs
resource "aws_subnet" "eks_subnets" {
  for_each          = local.eks_availability_zones
  vpc_id            = aws_vpc.legacy-vpc.id
  cidr_block        = "10.0.${index(tolist(local.eks_availability_zones), each.value) + 1}.0/24"
  availability_zone = each.value # Ensure multi zones
}