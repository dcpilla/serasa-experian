<!-- BEGIN_TF_DOCS -->
# Serasa: aws-route53
---------------------

## O que é o aws-route53?

Olá sou um lançador para ajudar na criação ou remoção de novos registros de DNS.

* Se você estiver **adicionando um novo registro**, é importante que TODOS os campos deste lançador sejam preenchidos.
* Se estiver **removendo** um registro existente, então os campos **records** e **ttl** não são requeridos.

## Pré-requisitos

Para que eu possa ser executado corretamente, é necessário que sua conta AWS já possua o onboarding realizado com o CockPit. [Clique aqui e saiba mais](https://pages.experian.com/pages/viewpage.action?pageId=1081626313).

| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | Aws
| ITIL Request           | False;True
| ITIL Change Order      | False;True
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de launch

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_route_53"></a> [route\_53](#module\_route\_53) | git::https://code.experian.local/scm/trsrecs/aws-route53-module.git | develop |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | Action | `string` | `"@@ACTION@@"` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Assume Role ARN | `string` | `"arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account id | `string` | `"@@AWS_ACCOUNT_ID@@"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"@@AWS_REGION@@"` | no |
| <a name="input_bu_name"></a> [bu\_name](#input\_bu\_name) | BU Name | `string` | `"@@BU@@"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of environment | `string` | `"@@ENV@@"` | no |
| <a name="input_hosted_zones"></a> [hosted\_zones](#input\_hosted\_zones) | Host zone name | `string` | `"@@HOSTED_ZONES@@"` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | Record name (subdomain) | `string` | `"@@RECORD_NAME@@"` | no |
| <a name="input_record_type"></a> [record\_type](#input\_record\_type) | Type record | `string` | `"@@RECORD_TYPE@@"` | no |
| <a name="input_records"></a> [records](#input\_records) | List of objects of DNS records | `string` | `"@@RECORDS@@"` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL in seconds Default. 300 | `string` | `"@@TTL@@"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Name of the hostname |
| <a name="output_record_created"></a> [record\_created](#output\_record\_created) | n/a |
| <a name="output_record_deleted"></a> [record\_deleted](#output\_record\_deleted) | n/a |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | Zone ID |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | Name of the hosted zone to contain the records |

## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-route53`.

## Como contribuir
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.

## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-route53` [Backlog](docs/BACKLOG.md)

`1.0.0` - Sun Aug  6 19:40:54 -03 2023
* `ADD` -  Criação do repositório e sua estrutura inicial  

## Author

* **TribeSRECSCross** - (TribeSRECSCross@br.experian.com)
<!-- END_TF_DOCS -->