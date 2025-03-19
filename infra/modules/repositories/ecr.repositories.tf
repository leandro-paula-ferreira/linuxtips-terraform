resource "aws_ecr_repository" "this" {
  count                = length(var.repositories)
  name                 = var.repositories[count.index].name
  image_tag_mutability = var.repositories[count.index].image_tag_mutability

  # Boa prática tfsec: evitar exclusão acidental
  force_delete = false

  # Boa prática tfsec: habilitar escaneamento de vulnerabilidades em imagens
  image_scanning_configuration {
    scan_on_push = var.enable_scan_on_push
  }

  # Boa prática tfsec: habilitar criptografia de imagens com chave gerenciada pelo cliente
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr.arn
  }

  tags = var.tags
}

# Boa prática: implementar política de ciclo de vida para evitar custos excessivos 
# e manter apenas as imagens necessárias
resource "aws_ecr_lifecycle_policy" "this" {
  count      = length(var.repositories)
  repository = aws_ecr_repository.this[count.index].name
  policy     = var.lifecycle_policy
}
