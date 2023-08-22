resource "aws_vpc" "legacy-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}
