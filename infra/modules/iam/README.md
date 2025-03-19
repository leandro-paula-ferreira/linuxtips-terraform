## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_repository_arns"></a> [ecr\_repository\_arns](#input\_ecr\_repository\_arns) | Lista de ARNs dos repositórios ECR | `list(string)` | n/a | yes |
| <a name="input_eks_cluster_oidc_provider_arn"></a> [eks\_cluster\_oidc\_provider\_arn](#input\_eks\_cluster\_oidc\_provider\_arn) | ARN do provedor OIDC do cluster EKS | `string` | `""` | no |
| <a name="input_eks_cluster_oidc_provider_url"></a> [eks\_cluster\_oidc\_provider\_url](#input\_eks\_cluster\_oidc\_provider\_url) | URL do provedor OIDC do cluster EKS | `string` | `""` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | Caminho do repositório GitHub (ex: 'organização/repo') | `string` | n/a | yes |
| <a name="input_oidc_provider_thumbprint"></a> [oidc\_provider\_thumbprint](#input\_oidc\_provider\_thumbprint) | SHA1 fingerprint do certificado GitHub Actions | `string` | `"d89e3bd43d5d909b47a18977aa9d5ce36cee184c"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags dos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_oidc_provider_arn"></a> [github\_oidc\_provider\_arn](#output\_github\_oidc\_provider\_arn) | O ARN do provedor OIDC GitHub |
| <a name="output_github_role_arn"></a> [github\_role\_arn](#output\_github\_role\_arn) | O ARN da role GitHub Actions |
| <a name="output_github_role_name"></a> [github\_role\_name](#output\_github\_role\_name) | O nome da role GitHub Actions |
