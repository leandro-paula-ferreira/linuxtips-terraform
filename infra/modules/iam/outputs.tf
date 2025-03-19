output "github_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "O ARN do provedor OIDC GitHub"
}

output "github_role_arn" {
  value       = aws_iam_role.github.arn
  description = "O ARN da role GitHub Actions"
}

output "github_role_name" {
  value       = aws_iam_role.github.name
  description = "O nome da role GitHub Actions"
}
