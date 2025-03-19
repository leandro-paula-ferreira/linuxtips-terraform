# Módulo EKS

Este módulo configura um cluster Amazon Elastic Kubernetes Service (EKS) com configurações de segurança aprimoradas e grupo de nós gerenciado.

## Recursos Criados

- Cluster EKS com logging avançado
- Grupo de nós gerenciado em subnets privadas
- Roles IAM para o cluster e grupos de nós
- Chave KMS para criptografia de secrets do Kubernetes
- Provedor OIDC para autenticação
- Template de lançamento com criptografia e IMDSv2
- Configurações de acesso para usuários administradores

## Entradas (Variables)

| Nome | Descrição | Tipo | Obrigatório |
|------|-----------|------|------------|
| cluster_name | Nome do cluster EKS | string | Sim |
| cluster_role_name | Nome da role IAM para o cluster | string | Sim |
| enabled_cluster_log_types | Lista de tipos de logs do cluster para habilitar | list(string) | Não |
| authentication_mode | Modo de autenticação para o cluster | string | Não |
| node_group_name | Nome do grupo de nós | string | Sim |
| node_role_name | Nome da role IAM para o grupo de nós | string | Sim |
| node_instance_types | Lista de tipos de instância para o grupo de nós | list(string) | Não |
| node_scaling_config | Configuração de escala para o grupo de nós | object | Sim |
| node_capacity_type | Tipo de capacidade (ON_DEMAND ou SPOT) | string | Não |
| private_subnet_ids | Lista de IDs de subnets privadas | list(string) | Sim |
| admin_users | Lista de usuários para adicionar como administradores | list(object) | Não |
| encryption_config | Configuração de criptografia para o cluster | object | Não |
| tags | Tags dos recursos | map(string) | Não |

### Formato dos objetos

```hcl
node_scaling_config = {
  desired_size = 2
  max_size     = 4
  min_size     = 1
}

admin_users = [
  {
    username = "admin1"
    arn      = "arn:aws:iam::123456789012:user/admin1"
  }
]

encryption_config = {
  enabled    = true
  resources  = ["secrets"]
  kms_key_id = ""  # Se vazio, uma chave será criada automaticamente
}
```

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| cluster_id | O ID do cluster EKS |
| cluster_arn | O ARN do cluster EKS |
| cluster_name | O nome do cluster EKS |
| cluster_endpoint | O endpoint do servidor de API do cluster |
| cluster_certificate_authority_data | Dados da autoridade de certificação (sensível) |
| oidc_provider_arn | O ARN do provedor OIDC |
| oidc_provider_url | A URL do provedor OIDC |
| node_group_id | O ID do grupo de nós |

## Exemplo de Uso

```hcl
module "eks" {
  source = "./modules/eks"

  cluster_name              = "meu-cluster-eks"
  cluster_role_name         = "MeuClusterEKSRole"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  authentication_mode       = "API_AND_CONFIG_MAP"
  
  node_group_name           = "meu-grupo-nodes"
  node_role_name            = "MeuNodeGroupRole"
  node_instance_types       = ["t3.medium"]
  node_capacity_type        = "ON_DEMAND"
  
  node_scaling_config = {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }
  
  private_subnet_ids = module.networking.private_subnet_ids
  
  admin_users = [
    {
      username = "admin1"
      arn      = "arn:aws:iam::123456789012:user/admin1"
    }
  ]
  
  encryption_config = {
    enabled    = true
    resources  = ["secrets"]
    kms_key_id = ""
  }
  
  tags = {
    Environment = "production"
    Project     = "meu-projeto"
  }
}
```

## Boas Práticas Implementadas

1. **Segurança Aprimorada**:
   - Criptografia de secrets do Kubernetes
   - Uso de IMDSv2 para proteção contra vazamento de credenciais
   - Discos EBS criptografados para os nós
   - Rotação automática de chaves KMS

2. **Controle de Acesso**:
   - Configuração granular para usuários administradores
   - Uso de políticas específicas para cada função

3. **Logging e Auditoria**:
   - Habilitação de logs abrangentes (API, audit, authenticator, controllerManager, scheduler)
   - Integração com CloudWatch Logs

4. **Isolamento de Rede**:
   - Implantação de nós em subnets privadas
   - Proteção contra acesso direto da internet

5. **Autenticação Segura**:
   - Uso de provedor OIDC para autenticação
   - Suporte a AWS IAM para controle de acesso

6. **Disponibilidade e Escalabilidade**:
   - Configuração de auto-scaling para o grupo de nós
   - Suporte a múltiplas zonas de disponibilidade

## Considerações de Segurança

- O cluster utiliza criptografia para secrets do Kubernetes
- A comunicação com a API do Kubernetes é feita através de TLS
- Os nós são implantados em subnets privadas para maior segurança
- Metadados de instância estão protegidos com IMDSv2
- Os volumes EBS são criptografados por padrão
- A chave KMS tem rotação automática habilitada
- O acesso ao cluster é controlado via IAM e RBAC
- Todos os tipos de logs estão habilitados para facilitar auditoria

## Limitações e Recomendações

- Considere implementar Network Policies para segmentação adicional no cluster
- Para workloads críticas, avalie o uso de instâncias Fargate sem acesso ao host
- Implemente ferramentas adicionais de monitoramento como Prometheus e Grafana
- Considere habilitar o AWS GuardDuty para monitoramento de segurança avançado
- Implemente ferramentas de escaneamento de imagens no pipeline CI/CD



## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.admins](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.admins](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.eks_cluster_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_node_group_AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cluster_role_AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_iam_policy_document.eks_cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | Lista de usuários IAM para serem adicionados como administradores do cluster | <pre>list(object({<br/>    username = string<br/>    arn      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | Modo de autenticação para o cluster EKS | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nome do cluster EKS | `string` | n/a | yes |
| <a name="input_cluster_role_name"></a> [cluster\_role\_name](#input\_cluster\_role\_name) | Nome da role IAM para o cluster EKS | `string` | n/a | yes |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | Lista de tipos de logs do cluster EKS para habilitar | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | Configuração de criptografia do cluster EKS | <pre>object({<br/>    enabled    = bool<br/>    resources  = list(string)<br/>    kms_key_id = string<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "kms_key_id": "",<br/>  "resources": [<br/>    "secrets"<br/>  ]<br/>}</pre> | no |
| <a name="input_node_capacity_type"></a> [node\_capacity\_type](#input\_node\_capacity\_type) | Tipo de capacidade para o grupo de nós do EKS (ON\_DEMAND ou SPOT) | `string` | `"ON_DEMAND"` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | Nome do grupo de nós do EKS | `string` | n/a | yes |
| <a name="input_node_instance_types"></a> [node\_instance\_types](#input\_node\_instance\_types) | Lista de tipos de instância para o grupo de nós do EKS | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_node_role_name"></a> [node\_role\_name](#input\_node\_role\_name) | Nome da role IAM para o grupo de nós do EKS | `string` | n/a | yes |
| <a name="input_node_scaling_config"></a> [node\_scaling\_config](#input\_node\_scaling\_config) | Configuração de escala para o grupo de nós do EKS | <pre>object({<br/>    desired_size = number<br/>    max_size     = number<br/>    min_size     = number<br/>  })</pre> | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Lista de IDs de subnets privadas para o cluster EKS | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags dos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | O ARN do cluster EKS |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Dados do certificado de autoridade do cluster EKS |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | O endpoint do servidor de API do cluster EKS |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | O ID do cluster EKS |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | O nome do cluster EKS |
| <a name="output_node_group_id"></a> [node\_group\_id](#output\_node\_group\_id) | O ID do grupo de nós do EKS |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | O ARN do provedor OIDC |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | A URL do provedor OIDC |
