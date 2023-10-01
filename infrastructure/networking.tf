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
  map_public_ip_on_launch = true
}

# EKS Nodes need internet access to download stuff. I'll remove this later when we have all charts into Harbor, for example.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.legacy-vpc.id
}
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.legacy-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "associate-rt-public" {
  for_each = local.eks_availability_zones
  subnet_id = aws_subnet.eks_subnets[each.value].id
  route_table_id = aws_route_table.public-rt.id
}
