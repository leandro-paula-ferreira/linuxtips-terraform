terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
  }

  # Configuração do backend S3
  backend "s3" {
    bucket         = "nome-do-seu-bucket-terraform-state"
    key            = "terraform/colabkids/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock" # Opcional, para controle de concorrência
  }
}

# Obter informações sobre a conta atual
data "aws_caller_identity" "current" {}

# Configuração do provider AWS
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
