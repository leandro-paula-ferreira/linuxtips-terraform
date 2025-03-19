resource "aws_eks_access_policy_association" "admins" {
  for_each = { for user in var.admin_users : user.username => user }

  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value.arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "admins" {
  for_each = { for user in var.admin_users : user.username => user }

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.arn
  type          = "STANDARD"
}
