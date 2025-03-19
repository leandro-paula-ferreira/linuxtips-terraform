resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0

  name = var.domain_name
  tags = merge(
    var.tags,
    {
      Name = var.domain_name
    }
  )
}
