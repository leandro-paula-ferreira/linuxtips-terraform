resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs     = var.allowed_public_cidrs
  }

  # Usar dynamic block para criar encryption_config condicionalmente
  dynamic "encryption_config" {
    for_each = var.encryption_config.enabled ? [1] : []
    content {
      provider {
        key_arn = var.encryption_config.kms_key_id != "" ? var.encryption_config.kms_key_id : aws_kms_key.eks[0].arn
      }
      resources = var.encryption_config.resources
    }
  }

  access_config {
    authentication_mode = var.authentication_mode
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_AmazonEKSClusterPolicy,
  ]
}
