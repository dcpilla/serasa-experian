# aws-eks-oidc
----

## O que é o aws-eks-oidc?

Olá sou um launch para associar um Identity Provider a um cluster EKS. Essa configuração é necessária para instalação do Kubernetes Dashboard.



| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | AWS
| ITIL Request           | False
| ITIL Change Order      | False
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS



## Parâmetros

No formulário para executar esse launch você encontrará os seguintes parâmetros a serem informados:

| Parâmetro                   | Descrição                                        | Mandatory | Example                                             | Regex 
| --------------------------- | ------------------------------------------------ | --------- | --------------------------------------------------- | ---------------------------------
| aws_account_id              | Account number where the cluster will be created | yes       | 123456789000                                        | `^(\d{1,12}|\d{1,12})$`
| aws-region                  | Region where the cluster is deployed             | yes       | sa-east-1                                           | `^[a-z0-9\-]{1,20}$`
| eks_cluster_name            | EKS cluster name where the fix will be applied   | yes       | bu-eks-version-env = da-eks-01-prod                 | `^[a-zA-Z0-9\-]{2,10}-eks-\d{1,7}-\w{2,7}$`
| oidc_config_name            | Identity provider name                           | yes       | Okta                                                | `^[a-zA-Z0-9\-_]{1,50}$`
| oidc_client_id              | Identity provider client id                      | yes       | jk32shdSGD55763547wD                                | `^[a-zA-Z0-9\-_.]{1,50}$`
| oidc_issuer_url             | Identity provider authorization server           | yes       | https://experian.okta.com/oauth2/jsdfiuwiurwyiusdfg | `^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$`



## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-eks-oidc`.



## Como contribuir 
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.



## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-eks-oidc` [Backlog](docs/BACKLOG.md) 

`1.0.0` - Thu Sep  8 19:02:21 -03 2022
* `ADD` -  Criação do repositório e sua estrutura inicial  



## Author

* **Cristian.Alexandre** - (Cristian.Alexandre@br.experian.com)