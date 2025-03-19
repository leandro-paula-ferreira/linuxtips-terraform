output "repository_arns" {
  value       = aws_ecr_repository.this[*].arn
  description = "Lista de ARNs dos repositórios ECR"
}

output "repository_urls" {
  value       = { for i, repo in aws_ecr_repository.this : var.repositories[i].name => repo.repository_url }
  description = "Mapa de URLs dos repositórios ECR"
}

output "repository_names" {
  value       = aws_ecr_repository.this[*].name
  description = "Lista de nomes dos repositórios ECR"
}
