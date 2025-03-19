output "vpc_id" {
  value       = module.networking.vpc_id
  description = "ID da VPC"
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
  description = "IDs das subnets públicas"
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids
  description = "IDs das subnets privadas"
}

output "ecr_repository_urls" {
  value       = module.repositories.repository_urls
  description = "URLs dos repositórios ECR"
}

output "ecr_repository_arns" {
  value       = module.repositories.repository_arns
  description = "ARNs dos repositórios ECR"
}

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "Nome do cluster EKS"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint do cluster EKS"
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "ARN do provedor OIDC do EKS"
}

output "github_role_arn" {
  value       = module.iam.github_role_arn
  description = "ARN da role para GitHub Actions"
}

output "route53_zone_id" {
  value       = module.dns.zone_id
  description = "ID da zona do Route53"
}

output "route53_nameservers" {
  value       = module.dns.nameservers
  description = "Nameservers do domínio"
}

output "acm_certificate_arn" {
  value       = module.dns.certificate_arn
  description = "ARN do certificado ACM"
}
