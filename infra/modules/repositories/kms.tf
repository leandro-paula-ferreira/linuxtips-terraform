resource "aws_kms_key" "ecr" {
  description             = "KMS key para criptografia de repositórios ECR"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "ecr" {
  name          = "alias/ecr-encryption-key"
  target_key_id = aws_kms_key.ecr.key_id
}
