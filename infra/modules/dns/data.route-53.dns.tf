data "aws_route53_zone" "this" {
  count = var.create_zone ? 0 : 1

  name = var.domain_name
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
}
