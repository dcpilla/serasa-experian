# Serasa: Amazon Certificate Manager

## O que é o aws-certificate-import?

Este é um lançador para criar ou alterar certificados na AWS.

* [Pré-requisito.](https://pages.experian.com/display/CRCISR/Cockpit+%7C+Importando+ou+atulizando+Certificados+na+AWS)

Para que eu possa ser executado corretamente, é necessário que sua conta AWS já possua o onboarding realizado com o CockPit. [Clique aqui e saiba mais](https://pages.experian.com/pages/viewpage.action?pageId=1081626313).

| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | Aws
| ITIL Request           | False;True
| ITIL Change Order      | False;True
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de launch

## Parâmetros

No formulário para executar esse launch você encontrará os seguintes parâmetros a serem informados:

| Parâmetro                   | Descrição                                        | Requerido | Examplo                                               
| --------------------------- | ------------------------------------------------ | --------- | ------------------------------------------------------
| aws_account_id              | Id da Conta AWS                                  | sim       | 123456789000
| aws-region                  | Região onde o cluster EKS está                   | sim       | sa-east-1
| bu                          | Nome da unidade de negócio                       | sim       | Credit_Services
| env                         | Ambiente                                         | sim       | sandbox
| action                      | Ação a ser executada                             | sim       | create
| certificate_body            | Certificado                                      | sim       | inicia com -----BEGIN CERTIFICATE----- e termina com -----END CERTIFICATE----- 
| private_key                 | Chave privada                                    | sim       | inicia com -----BEGIN PRIVATE KEY----- e termina com -----END PRIVATE KEY----- 
| certificate_chain           | Cadeia de certificados                           | não       | inicia com -----BEGIN CERTIFICATE----- e termina com -----END CERTIFICATE----- 


## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-certificate-import`.

## Como contribuir
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.


## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-certificate-import` [Backlog](docs/BACKLOG.md)

`1.2.1` - Wed Jan 17 07:31:00 -03 2024
* `UPDATE` -  Ajuste para atualizar WildCard com o mesmo domínio

`1.2.0` - Mon Oct 30 10:36:00 -03 2023
* `UPDATE` -  Refatoração do código para usar o submodule `helpers`
* `BUG`    -  Ajustes e limpeza no código de teste para evitar BUG com a criação e atualização
* `ADD`    -  Adicionado notificãções no Joaquin infra e ajustados recursos para o cokpit

`1.1.0` - Wed Aug 19 07:30:00 -03 2023
* `ADD` -  Refatoração do código para aceitar parâmetros de criar ou atualizar  

`1.0.0` - Thu Jul 20 18:17:54 -03 2023
* `ADD` -  Criação do repositório e sua estrutura inicial  


## Author

* **TribeSRECSCross** - (srecscross@br.experian.com)
