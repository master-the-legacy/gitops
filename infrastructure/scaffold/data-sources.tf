data aws_vpc "legacy-vpc" {
  id = var.legacy-vpc-id
}

data "aws_subnets" "eks_subnets" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}

data "aws_security_group" "eks-cluster-sg" {
  filter {
    name = "description"
    values = ["EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."]
  }
}

locals {
  vpc_id = data.aws_vpc.legacy-vpc.id
}
