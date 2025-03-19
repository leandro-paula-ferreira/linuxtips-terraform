output "zone_id" {
  value       = var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
  description = "O ID da zona hospedada no Route 53"
}

output "nameservers" {
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : null
  description = "Os nameservers da zona hospedada (necessários para configurar no registrador do domínio)"
}

output "certificate_arn" {
  value       = aws_acm_certificate.this.arn
  description = "O ARN do certificado"
}

output "certificate_validation_arn" {
  value       = aws_acm_certificate_validation.this.certificate_arn
  description = "O ARN do certificado validado"
}
