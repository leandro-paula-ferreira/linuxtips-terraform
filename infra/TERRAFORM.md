## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_repositories"></a> [repositories](#module\_repositories) | ./modules/repositories | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

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
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | ARN do certificado ACM |
| <a name="output_ecr_repository_urls"></a> [ecr\_repository\_urls](#output\_ecr\_repository\_urls) | URLs dos repositórios ECR |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint do cluster EKS |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Nome do cluster EKS |
| <a name="output_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#output\_eks\_oidc\_provider\_arn) | ARN do provedor OIDC do EKS |
| <a name="output_github_role_arn"></a> [github\_role\_arn](#output\_github\_role\_arn) | ARN da role para GitHub Actions |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs das subnets privadas |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs das subnets públicas |
| <a name="output_route53_nameservers"></a> [route53\_nameservers](#output\_route53\_nameservers) | Nameservers do domínio |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id) | ID da zona do Route53 |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID da VPC |
