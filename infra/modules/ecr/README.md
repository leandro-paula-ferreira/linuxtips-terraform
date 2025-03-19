# Módulo ECR

Este módulo cria repositórios Amazon Elastic Container Registry (ECR) para armazenar e gerenciar imagens de contêineres de forma segura para o projeto ColabKids.

## Recursos Criados

- Repositórios ECR para armazenamento de imagens Docker
- Configuração de escaneamento de vulnerabilidades
- Políticas de ciclo de vida para limpeza automática de imagens
- Criptografia de imagens
- Configuração de imutabilidade de tags (opcional)

## Entradas (Variables)

| Nome | Descrição | Tipo | Obrigatório |
|------|-----------|------|------------|
| repositories | Lista de repositórios ECR para criar | list(object) | Sim |
| enable_scan_on_push | Habilitar escaneamento automático de imagens ao fazer push | bool | Não |
| lifecycle_policy | JSON da política de ciclo de vida | string | Não |
| tags | Tags dos recursos | map(string) | Não |

### Formato dos objetos

```hcl
repositories = [
  {
    name                 = "projeto/frontend"
    image_tag_mutability = "MUTABLE"
  },
  {
    name                 = "projeto/backend"
    image_tag_mutability = "IMMUTABLE"
  }
]
```

### Política de ciclo de vida padrão

```json
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
```

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| repository_urls | Mapa de URLs dos repositórios ECR |
| repository_arns | Lista de ARNs dos repositórios ECR |
| repository_names | Lista de nomes dos repositórios ECR |

## Exemplo de Uso

```hcl
module "repositories" {
  source = "./modules/ecr"

  repositories = [
    {
      name                 = "meu-projeto/frontend"
      image_tag_mutability = "MUTABLE"
    },
    {
      name                 = "meu-projeto/backend"
      image_tag_mutability = "MUTABLE"
    }
  ]
  
  enable_scan_on_push = true
  
  # Política personalizada de ciclo de vida
  lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Manter apenas imagens recentes",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF

  tags = {
    Environment = "production"
    Project     = "meu-projeto"
  }
}
```

## Boas Práticas Implementadas

1. **Segurança de Imagens**:
   - Escaneamento automático de vulnerabilidades
   - Criptografia de imagens usando KMS
   - Opção para imutabilidade de tags para prevenir sobrescrita

2. **Gerenciamento de Custos**:
   - Políticas de ciclo de vida para limpar imagens antigas
   - Prevenção de acumulação desnecessária de imagens

3. **Controle de Acesso**:
   - Permissões baseadas em roles para acesso aos repositórios
   - Integração com IAM para autenticação

4. **Prevenção de Exclusão Acidental**:
   - Configuração de `force_delete` como false por padrão

5. **Auditoria e Conformidade**:
   - Escaneamento de segurança para conformidade
   - Tags consistentes para melhor rastreabilidade

## Considerações de Segurança

- As imagens são automaticamente escaneadas em busca de vulnerabilidades conhecidas
- Os repositórios usam criptografia KMS para proteger o conteúdo das imagens
- O acesso aos repositórios é controlado via IAM
- Imutabilidade de tags pode ser habilitada para prevenir sobrescrita de versões estáveis
- A política de ciclo de vida ajuda a garantir que apenas imagens necessárias sejam mantidas, reduzindo a superfície de ataque

## Limitações e Recomendações

- Considere implementar ferramentas de escaneamento mais avançadas no pipeline CI/CD
- Para ambientes de produção críticos, considere usar tags imutáveis (IMMUTABLE)
- Estabeleça práticas de versionamento semântico para suas imagens
- Integre os resultados de escaneamento com ferramentas de notificação como o AWS Security Hub
- Considere adicionar políticas adicionais para reter imagens específicas permanentemente (por exemplo, versões de produção)
- Implemente verificação de assinatura de imagens para garantir a integridade



## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role"></a> [assume\_role](#input\_assume\_role) | n/a | <pre>object({<br/>    role_arn    = string<br/>    external_id = string<br/>  })</pre> | <pre>{<br/>  "external_id": "VALOR",<br/>  "role_arn": "arn:aws:iam::VALOR:role/terraform-role"<br/>}</pre> | no |
| <a name="input_ecr_repositories"></a> [ecr\_repositories](#input\_ecr\_repositories) | n/a | <pre>list(object({<br/>    name                 = string<br/>    image_tag_mutability = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "image_tag_mutability": "MUTABLE",<br/>    "name": "colabkids/frontend"<br/>  },<br/>  {<br/>    "image_tag_mutability": "MUTABLE",<br/>    "name": "colabkids/backend"<br/>  }<br/>]</pre> | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | n/a | <pre>object({<br/>    name                              = string<br/>    role_name                         = string<br/>    enabled_cluster_log_types         = list(string)<br/>    access_config_authentication_mode = string<br/>    node_group = object({<br/>      name                        = string<br/>      role_name                   = string<br/>      instance_types              = list(string)<br/>      scaling_config_max_size     = number<br/>      scaling_config_min_size     = number<br/>      scaling_config_desired_size = number<br/>      capacity_type               = string<br/>    })<br/>  })</pre> | <pre>{<br/>  "access_config_authentication_mode": "API_AND_CONFIG_MAP",<br/>  "enabled_cluster_log_types": [<br/>    "api",<br/>    "audit",<br/>    "authenticator",<br/>    "controllerManager",<br/>    "scheduler"<br/>  ],<br/>  "name": "colabkids-eks-cluster",<br/>  "node_group": {<br/>    "capacity_type": "ON_DEMAND",<br/>    "instance_types": [<br/>      "t3.medium"<br/>    ],<br/>    "name": "colabkids-eks-cluster-node-group",<br/>    "role_name": "colabkidsEKSClusterNodeGroup",<br/>    "scaling_config_desired_size": 2,<br/>    "scaling_config_max_size": 2,<br/>    "scaling_config_min_size": 2<br/>  },<br/>  "role_name": "colabkidsEKSClusterRole"<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region para deploy dos recursos | `string` | `"us-east-1"` | no |
| <a name="input_route53"></a> [route53](#input\_route53) | Configurações do Route 53 | <pre>object({<br/>    domain_name = string<br/>    zone_id     = optional(string)<br/>  })</pre> | <pre>{<br/>  "domain_name": "leandrospferreira.com.br"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "Environment": "production",<br/>  "Project": "colabkids"<br/>}</pre> | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | <pre>object({<br/>    name                     = string<br/>    cidr_block               = string<br/>    internet_gateway_name    = string<br/>    nat_gateway_name         = string<br/>    public_route_table_name  = string<br/>    private_route_table_name = string<br/>    eip                      = string<br/>    public_subnets = list(object({<br/>      name                    = string<br/>      map_public_ip_on_launch = bool<br/>      availability_zone       = string<br/>      cidr_block              = string<br/>    }))<br/>    private_subnets = list(object({<br/>      name                    = string<br/>      map_public_ip_on_launch = bool<br/>      availability_zone       = string<br/>      cidr_block              = string<br/>    }))<br/>  })</pre> | <pre>{<br/>  "cidr_block": "10.0.0.0/24",<br/>  "eip": "colabkids-vpc-eip",<br/>  "internet_gateway_name": "colabkids-vpc-internet-gateway",<br/>  "name": "colabkids-vpc",<br/>  "nat_gateway_name": "colabkids-vpc-nat-gateway",<br/>  "private_route_table_name": "colabkids-vpc-private-route-table",<br/>  "private_subnets": [<br/>    {<br/>      "availability_zone": "us-east-1a",<br/>      "cidr_block": "10.0.0.128/26",<br/>      "map_public_ip_on_launch": false,<br/>      "name": "colabkids-vpc-private-subnet-us-east-1a"<br/>    },<br/>    {<br/>      "availability_zone": "us-east-1b",<br/>      "cidr_block": "10.0.0.192/26",<br/>      "map_public_ip_on_launch": false,<br/>      "name": "colabkids-vpc-private-subnet-us-east-1b"<br/>    }<br/>  ],<br/>  "public_route_table_name": "colabkids-vpc-public-route-table",<br/>  "public_subnets": [<br/>    {<br/>      "availability_zone": "us-east-1a",<br/>      "cidr_block": "10.0.0.0/26",<br/>      "map_public_ip_on_launch": true,<br/>      "name": "colabkids-vpc-public-subnet-us-east-1a"<br/>    },<br/>    {<br/>      "availability_zone": "us-east-1b",<br/>      "cidr_block": "10.0.0.64/26",<br/>      "map_public_ip_on_launch": true,<br/>      "name": "colabkids-vpc-public-subnet-us-east-1b"<br/>    }<br/>  ]<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnets_arn"></a> [private\_subnets\_arn](#output\_private\_subnets\_arn) | n/a |
| <a name="output_public_subnets_arn"></a> [public\_subnets\_arn](#output\_public\_subnets\_arn) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
