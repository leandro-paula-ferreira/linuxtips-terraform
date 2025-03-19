# Adicionar data source para caller identity
data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region

  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }

  default_tags {
    tags = var.tags
  }
}

# Remover opções não suportadas do provider strict
provider "aws" {
  alias  = "strict"
  region = var.region

  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }

  default_tags {
    tags = var.tags
  }
}

module "networking" {
  source = "./modules/networking"

  vpc_name                 = var.vpc.name
  vpc_cidr                 = var.vpc.cidr_block
  internet_gateway_name    = var.vpc.internet_gateway_name
  nat_gateway_name         = var.vpc.nat_gateway_name
  public_route_table_name  = var.vpc.public_route_table_name
  private_route_table_name = var.vpc.private_route_table_name
  eip_name                 = var.vpc.eip
  public_subnets           = var.vpc.public_subnets
  private_subnets          = var.vpc.private_subnets
  tags                     = var.tags
}

module "dns" {
  source = "./modules/dns"

  domain_name = var.route53.domain_name
  create_zone = var.route53.zone_id == null
  tags        = var.tags
}

module "repositories" {
  source = "./modules/repositories"

  repositories = [
    {
      name                 = "colabkids/frontend"
      image_tag_mutability = "IMMUTABLE"
    },
    {
      name                 = "colabkids/backend"
      image_tag_mutability = "IMMUTABLE"
    }
  ]

  enable_scan_on_push = true
  tags                = var.tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name              = var.eks_cluster.name
  cluster_role_name         = var.eks_cluster.role_name
  enabled_cluster_log_types = var.eks_cluster.enabled_cluster_log_types
  authentication_mode       = var.eks_cluster.access_config_authentication_mode
  node_group_name           = var.eks_cluster.node_group.name
  node_role_name            = var.eks_cluster.node_group.role_name
  node_instance_types       = var.eks_cluster.node_group.instance_types
  node_capacity_type        = var.eks_cluster.node_group.capacity_type
  node_scaling_config = {
    desired_size = var.eks_cluster.node_group.scaling_config_desired_size
    max_size     = var.eks_cluster.node_group.scaling_config_max_size
    min_size     = var.eks_cluster.node_group.scaling_config_min_size
  }
  private_subnet_ids = module.networking.private_subnet_ids
  admin_users = [
    {
      username = "leandro"
      arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/leandro"
    }
  ]
  encryption_config = {
    enabled    = true
    resources  = ["secrets"]
    kms_key_id = ""
  }
  tags = var.tags
}

module "iam" {
  source = "./modules/iam"

  github_repo                   = "colabkids-2025/trabalho-ci-cd"
  ecr_repository_arns           = module.repositories.repository_arns
  eks_cluster_oidc_provider_url = module.eks.oidc_provider_url
  eks_cluster_oidc_provider_arn = module.eks.oidc_provider_arn
  tags                          = var.tags
}
