resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.oidc_provider_thumbprint]
  url             = "https://token.actions.githubusercontent.com"

  tags = var.tags
}
