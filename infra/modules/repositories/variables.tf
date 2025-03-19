variable "repositories" {
  description = "Lista de repositórios ECR para criar"
  type = list(object({
    name                 = string
    image_tag_mutability = string
  }))
  default = []

  validation {
    condition = length([
      for repo in var.repositories : repo
      if contains(["MUTABLE", "IMMUTABLE"], repo.image_tag_mutability)
    ]) == length(var.repositories)
    error_message = "O valor de image_tag_mutability deve ser 'MUTABLE' ou 'IMMUTABLE'."
  }
}

variable "enable_scan_on_push" {
  description = "Habilitar escaneamento automático de imagens ao fazer push"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags dos recursos"
  type        = map(string)
  default     = {}
}

variable "lifecycle_policy" {
  description = "JSON da política de ciclo de vida para limpar imagens antigas"
  type        = string
  default     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Manter apenas as 10 imagens mais recentes para cada tag",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

variable "default_image_tag_mutability" {
  description = "Mutabilidade padrão das tags de imagem"
  type        = string
  default     = "IMMUTABLE" # Alterado para IMMUTABLE como recomendado pelo tfsec
}
