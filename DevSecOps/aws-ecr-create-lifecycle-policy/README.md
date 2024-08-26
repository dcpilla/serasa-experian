# aws-ecr-create-lifecycle-policy
----

<div align="center">

![Topology](https://d1.awsstatic.com/legal/AmazonElasticContainerRegistry/Product-Page-Diagram_Amazon-ECR.2f9e7f26ef78f4dc6f058f7eeb07cf696f6951c1.png "Topology")

<p>Topology aws-ecr-create-lifecycle-policy - Version 1.1.0 o/</p>
</div>
<br>

## O que é o aws-ecr-create-lifecycle-policy?

Olá sou um launch para editar o ECR, criando e editando a policy para remoção das imagens mais antigas dentro do repository. A quantidade é para que mantenha no repository as imagens mais recentes, sendo a top1 e mais a quantidade que desejar ou somente a mais recente se inserir somente 1 na quantidade desejada.

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

| Parâmetro          | Descrição                                | Requerido | Examplo                                               
|--------------------|------------------------------------------| --------- | ------------------------------------------------------
| aws_account_id     | Id da Conta AWS                          | sim       | 123456789000
| aws-region         | Região onde o cluster EKS está           | sim       | sa-east-1
| bu                 | Nome da unidade de negócio               | sim       | Credit_Services
| images_to_retain   | Quantidade de imagens para manter no ECR | sim       | 20

## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-ecr-create-lifecycle-policy`.

## Como contribuir 
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.

## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-ecr-create-lifecycle-policy` [Backlog](docs/BACKLOG.md) 

`1.1.0` - Thu Oct 26 14:43:00 -03 2023
* `FIX` -  Refatoração do código para simplificar e facilitar o re-uso
* `ADD` -  Adicionada ação para remover imagens sem TAG

`1.0.1` - Wed Oct 25 15:59:27 -03 2023
* `FIX` -  Ajustado campo para escolher a região
* `FIX` -  Email de alerta do Joaquin infra
* `ADD` -  Adicionada opção para passar o nome do repositório  

`1.0.0` - Thu Sep 21 11:59:49 -03 2023
* `ADD` -  Criação do repositório e sua estrutura inicial  

## Author

* **TribeSRECSCross** - (TribeSRECSCross@br.experian.com)
