# Reference https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/57e1156420c1f4893c7fc50da8b8dbf322961d34/main.tf#L26
resource "aws_vpc" "legacy-vpc" {
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"
  enable_dns_support = true # Defaults to true, but for reference since EKS nodes needs this to be true in order to work properly

}

# EKS subnets
# Need to be at least two subnets in two different AZs
resource "aws_subnet" "eks_subnets" {
  count             = 2
  vpc_id            = aws_vpc.legacy-vpc.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = "us-east-1a"
}
