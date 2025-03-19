output "cluster_id" {
  value       = aws_eks_cluster.this.id
  description = "O ID do cluster EKS"
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "O ARN do cluster EKS"
}

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "O nome do cluster EKS"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "O endpoint do servidor de API do cluster EKS"
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "Dados do certificado de autoridade do cluster EKS"
  sensitive   = true
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.eks.arn
  description = "O ARN do provedor OIDC"
}

output "oidc_provider_url" {
  value       = aws_iam_openid_connect_provider.eks.url
  description = "A URL do provedor OIDC"
}

output "node_group_id" {
  value       = aws_eks_node_group.this.id
  description = "O ID do grupo de nós do EKS"
}
