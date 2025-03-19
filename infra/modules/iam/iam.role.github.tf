data "aws_caller_identity" "current" {}

resource "aws_iam_role" "github" {
  name = "GitHubActionsRole"

  # Boa prática: adicionar descrição para facilitar auditoria
  description = "Role para GitHub Actions acessar recursos AWS"

  # Boa prática tfsec: limitar quais repositórios podem assumir esta role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "GitHubActionsECRPolicy"
  role = aws_iam_role.github.id

  # Boa prática tfsec: seguir o princípio do privilégio mínimo
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect   = "Allow"
        Resource = var.ecr_repository_arns
      },
    ]
  })
}
