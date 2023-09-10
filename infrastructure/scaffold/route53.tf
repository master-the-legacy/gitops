resource "aws_route53_zone" "private-zone" {
  name = "${terraform.workspace != "prod" ? terraform.workspace : ""}.master.legacy.com"

  vpc {
    vpc_id = local.vpc_id
  }
}
