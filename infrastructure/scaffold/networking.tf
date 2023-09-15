data "aws_subnets" "eks_subnets" {
  filter {
    name = "vpc-id"
    values = [ local.vpc_id ]
  }
}

locals {
  vpc_id = "vpc-0c972480e791df4a8"
}