# aws-fix-eks-disk-pressure
----

## O que é o aws-fix-eks-disk-pressure?

Olá sou um launch para corrigir o erro "DiskPressure" ou Pods com status "Evicted".
Esse problema ocorre por falta de espaço em disco no nó. Esse launch corrige isso, ele cria uma nova versão do Launch Template com o tamanho de disco atualizado.



| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | AWS
| ITIL Request           | False
| ITIL Change Order      | False
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de launch



## Parâmetros

No formulário para executar esse launch você encontrará os seguintes parâmetros a serem informados:

| Parâmetro                        | Descrição                                        | Mandatory | Example                                                | Regex 
| -------------------------------- | ------------------------------------------------ | --------- | ------------------------------------------------------ | ---------------------------------
| aws_account_id                   | Account number where the cluster will be created | yes       | 123456789000                                           | `^(\d{1,12}|\d{1,12})$`
| aws-region                       | Region where the cluster is deployed             | yes       | sa-east-1                                              | `^[a-z0-9\-]{1,20}$`
| eks_cluster_name                 | EKS cluster name where the fix will be applied   | yes       | bu-eks-version-env = da-eks-01-dev                     | `^[a-zA-Z0-9\-]{2,10}-eks-\d{1,7}-\w{2,7}$`
| eks_nodegroup_name               | EKS cluster node group name                      | yes       | node_group_on_demand_infra-20220825162242563700000011  | `^[a-zA-Z0-9\-_]{1,255}$`
| eks_nodegroup_template_id        | EKS cluster node group launch template id        | yes       | lt-00a0e2630edd001f8                                   | `^[a-zA-Z0-9\-_]{1,255}$`
| eks_nodegroup_instance_disk_size | EKS cluster node group instance disk size in GB  | yes       | 80                                                     | `\d{1,5}`



## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-fix-eks-disk-pressure`.



## Como contribuir 
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.



## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-fix-eks-disk-pressure` [Backlog](docs/BACKLOG.md) 

`1.0.0` - Fri Dec  9 17:00:00 -03 2022
* `ADD` -  Criação do repositório e sua estrutura inicial  



## Author

* **Cristian.Alexandre** - (Cristian.Alexandre@br.experian.com)