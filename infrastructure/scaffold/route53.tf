resource "aws_route53_zone" "legacy-private-zone" {
  name = "legacy-private-zone"

  vpc {
    vpc_id = aws_vpc.legacy-vpc.id
  }
}
