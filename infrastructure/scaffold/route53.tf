resource "aws_route53_zone" "legacy-private-zone" {
  name = "legacy-private-zone"

  vpc {
    vpc_id = local.vpc_id
  }
}
