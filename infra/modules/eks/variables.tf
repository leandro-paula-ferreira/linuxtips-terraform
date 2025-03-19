variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "cluster_role_name" {
  description = "Nome da role IAM para o cluster EKS"
  type        = string
}

variable "enabled_cluster_log_types" {
  description = "Lista de tipos de logs do cluster EKS para habilitar"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "authentication_mode" {
  description = "Modo de autenticação para o cluster EKS"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "node_group_name" {
  description = "Nome do grupo de nós do EKS"
  type        = string
}

variable "node_role_name" {
  description = "Nome da role IAM para o grupo de nós do EKS"
  type        = string
}

variable "node_instance_types" {
  description = "Lista de tipos de instância para o grupo de nós do EKS"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_scaling_config" {
  description = "Configuração de escala para o grupo de nós do EKS"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}

variable "node_capacity_type" {
  description = "Tipo de capacidade para o grupo de nós do EKS (ON_DEMAND ou SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subnets privadas para o cluster EKS"
  type        = list(string)
}

variable "tags" {
  description = "Tags dos recursos"
  type        = map(string)
  default     = {}
}

variable "admin_users" {
  description = "Lista de usuários IAM para serem adicionados como administradores do cluster"
  type = list(object({
    username = string
    arn      = string
  }))
  default = []
}

variable "encryption_config" {
  description = "Configuração de criptografia do cluster EKS"
  type = object({
    enabled    = bool
    resources  = list(string)
    kms_key_id = string
  })
  default = {
    enabled    = true
    resources  = ["secrets"]
    kms_key_id = "" # Se deixado vazio, a AWS criará uma chave
  }
}

variable "allowed_public_cidrs" {
  description = "Lista de CIDRs permitidos para acesso público ao endpoint do EKS"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"] # CIDRs privados comuns
}
