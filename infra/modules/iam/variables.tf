variable "github_repo" {
  description = "Caminho do repositório GitHub (ex: 'organização/repo')"
  type        = string
}

variable "oidc_provider_thumbprint" {
  description = "SHA1 fingerprint do certificado GitHub Actions"
  type        = string
  default     = "d89e3bd43d5d909b47a18977aa9d5ce36cee184c"
}

variable "ecr_repository_arns" {
  description = "Lista de ARNs dos repositórios ECR"
  type        = list(string)
}

variable "eks_cluster_oidc_provider_url" {
  description = "URL do provedor OIDC do cluster EKS"
  type        = string
  default     = ""
}

variable "eks_cluster_oidc_provider_arn" {
  description = "ARN do provedor OIDC do cluster EKS"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags dos recursos"
  type        = map(string)
  default     = {}
}
