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
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_scan_on_push"></a> [enable\_scan\_on\_push](#input\_enable\_scan\_on\_push) | Habilitar escaneamento automático de imagens ao fazer push | `bool` | `true` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | JSON da política de ciclo de vida para limpar imagens antigas | `string` | `"{\n  \"rules\": [\n    {\n      \"rulePriority\": 1,\n      \"description\": \"Manter apenas as 10 imagens mais recentes para cada tag\",\n      \"selection\": {\n        \"tagStatus\": \"any\",\n        \"countType\": \"imageCountMoreThan\",\n        \"countNumber\": 10\n      },\n      \"action\": {\n        \"type\": \"expire\"\n      }\n    }\n  ]\n}\n"` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Lista de repositórios ECR para criar | <pre>list(object({<br/>    name                 = string<br/>    image_tag_mutability = string<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags dos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arns"></a> [repository\_arns](#output\_repository\_arns) | Lista de ARNs dos repositórios ECR |
| <a name="output_repository_names"></a> [repository\_names](#output\_repository\_names) | Lista de nomes dos repositórios ECR |
| <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls) | Mapa de URLs dos repositórios ECR |
