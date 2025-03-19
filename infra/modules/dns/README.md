# Módulo DNS

Este módulo gerencia recursos de DNS e certificados SSL/TLS para o projeto ColabKids, incluindo zonas hospedadas no Route53 e certificados do AWS Certificate Manager (ACM).

## Recursos Criados

- Zona hospedada no Route53 para gerenciamento de domínio
- Certificado SSL/TLS usando o AWS Certificate Manager
- Registros DNS para validação do certificado
- Configuração de transparência de certificado

## Entradas (Variables)

| Nome | Descrição | Tipo | Obrigatório |
|------|-----------|------|------------|
| domain_name | Nome de domínio para a zona do Route53 | string | Sim |
| create_zone | Se deve criar uma nova zona Route53 ou usar uma existente | bool | Não |
| tags | Tags dos recursos | map(string) | Não |

## Saídas (Outputs)

| Nome | Descrição |
|------|-----------|
| zone_id | O ID da zona hospedada no Route 53 |
| nameservers | Os nameservers da zona hospedada |
| certificate_arn | O ARN do certificado |
| certificate_validation_arn | O ARN do certificado validado |

## Exemplo de Uso

```hcl
module "dns" {
  source = "./modules/dns"

  domain_name = "exemplo.com.br"
  create_zone = true
  
  tags = {
    Environment = "production"
    Project     = "meu-projeto"
  }
}
```

### Usando uma zona existente

```hcl
module "dns" {
  source = "./modules/dns"

  domain_name = "exemplo.com.br"
  create_zone = false
  
  tags = {
    Environment = "production"
    Project     = "meu-projeto"
  }
}
```

## Funcionamento do Módulo

### Criação de Zona

O módulo pode operar em dois modos:

1. **Criar uma nova zona hospedada** (create_zone = true):
   - Cria uma nova zona hospedada no Route53 para o domínio especificado
   - Retorna os nameservers que devem ser configurados no registrador de domínio

2. **Usar uma zona existente** (create_zone = false):
   - Busca uma zona hospedada existente no Route53 para o domínio especificado
   - Usa essa zona para criar registros DNS

### Certificado ACM

Em ambos os casos, o módulo:
- Solicita um certificado SSL/TLS via ACM para o domínio
- Cria automaticamente registros DNS para validação do certificado
- Configura transparência de certificado para maior segurança
- Espera a validação do certificado ser concluída




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
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_zone"></a> [create\_zone](#input\_create\_zone) | Se deve criar uma nova zona Route53 ou usar uma existente | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nome de domínio para a zona do Route53 | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags dos recursos | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | O ARN do certificado |
| <a name="output_certificate_validation_arn"></a> [certificate\_validation\_arn](#output\_certificate\_validation\_arn) | O ARN do certificado validado |
| <a name="output_nameservers"></a> [nameservers](#output\_nameservers) | Os nameservers da zona hospedada (necessários para configurar no registrador do domínio) |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | O ID da zona hospedada no Route 53 |
