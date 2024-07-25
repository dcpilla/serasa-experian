# aws-eks-serasa
----

## O que é o aws-eks-serasa?

Sou um launch para criação e atualização de um cluster EKS, dentro dos padrões da Serasa Experian.
Além do cluster, instalo uma solução open-source de monitoramento e deixo o Istio no jeito para você poder executar canary deploys ou mesmo avançar para utilização de service mesh. Instalo também um autoscaler e opcionalmente o Karpenter, para personalização e otimização do uso de recursos por suas aplicações.
Você pode checar mais documentações sobre mim no [Confluence](https://pages.experian.local/display/SRECOREBRA/EKS+-+Kick+Start).

| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | AWS
| ITIL Request           | True
| ITIL Change Order      | False
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de cluster EKS

## Pré-requisitos

Para que o cluster EKS possa ser gerenciado a partir da rede Serasa Experian atendendo os padrões de segurança, sua conta AWS precisa atender os pré-requisitos listados na documentação [EKS Pre-reqs to Deploy](https://pages.experian.local/display/SRECOREBRA/EKS+Pre-reqs+to+Deploy).

## Parâmetros

No formulário para executar esse launch você encontrará os seguintes parâmetros a serem informados:

| Parâmetro                 | Descrição                                                                               | Mandatory | Example                           | Regex 
| ------------------------- | --------------------------------------------------------------------------------------- | --------- | --------------------------------- | ---------------------------------
| aws_account_id            | Account number where the cluster will be created                                        | yes       | 123456789000                      | `^(\d{1,12}|\d{1,12})$`
| aws_region                | AWS region of ECR repository for image registration to EKS                              | yes       | sa-east-1                         | options: sa-east-1;us-east-1
| eks_cluster_name          | Give a name to your new EKS Cluster MAX 22 CHARACTERS                                   | yes       | BUName-Serial#                    | `^[a-zA-Z0-9\-]{5,22}$`
| env                       | Environment                                                                             | yes       | -                                 | options: dev;uat;sandbox;prod
| tfstate_name              | Name of .tfstate (without extension) to store and manage automation's resources         | yes       | my-cluster-name-environment       | `^[a-zA-Z0-9\-_]+$`
| eks_cluster_version       | Kubernetes version to be deployed or upgraded to                                        | yes       | 1.27                              | options: 1.29;1.28;1.27;1.26;1.25;1.24
| acm                       | ACM ARN to be used by the LoadBalancer                                                  | yes       | -                                 | `arn:[\w+=/,.@-]+:[\w+=/,.@-]+:[\w+=/,.@-]*:[0-9]+:[\w+=,.@-]+(/[\w+=,.@-]+)*`
| domain_name               | Domain name to be used in this EKS Cluster                                              | yes       | prod-digital.br.experian.eeca     | `^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$`
| eks_ami_id                | AMI ID of Amazon Linux 2 for EKS to provision Node Groups' EC2 instances                | yes       | latest                            | `^(latest|(ami-[a-zA-Z0-9\-_]+))$`
| vpc_id                    | Specify which VPC to use or "auto" to get the first available                           | yes       | auto                              | `^(auto|(vpc-[a-zA-Z0-9\-_]+))$`
| subnets                   | Custom subnets to be used for EKS/EC2/NLB/EFS                                           | yes       | auto                              | `^(auto|(subnet-[a-zA-Z0-9\-_]+(,subnet-[a-zA-Z0-9\-_]+)+))$`
| nodegroup_names_style     | Nodegroup Prefix style to prepend names                                                 | yes       | combined                          | `^(combined|simple|([a-zA-Z0-9\-_]{5,20}))$`
| addomain                  | AD domain to register all EC2 provisioned by EKS                                        | yes       | br.experian.local                 | options: br.experian.local;ena.us.experian.local;gdc.local
| karpenter                 | Installs Karpenter and basic resources to spin up workloads                             | yes       | disabled                          | options: disabled;enabled;enabled+resources
| efs_enabled               | Boolean that indicates if EFS should be installed and configured                        | yes       | true                              | N/A
| docker_hub_cache_prefix   | Which prefix to use on Docker Hub images                                                | yes       | off                               | `^(off|own|([a-zA-Z0-9\-\.\/]{8,200}))$`
| node_infra_max_size       | Max node size for infra auto scaling group                                              | yes       | 3                                 | `\d{1,5}`
| node_small_max_size       | Max node size for small auto scaling group                                              | yes       | 3                                 | `\d{1,5}`
| node_medium_max_size      | Max node size for medium auto scaling group                                             | yes       | 3                                 | `\d{1,5}`
| node_larger_max_size      | Max node size for large auto scaling group                                              | yes       | 3                                 | `\d{1,5}`
| node_spot_max_size        | Max node size for spot auto scaling group                                               | yes       | 3                                 | `\d{1,5}`
| node_infra_instance_type  | Instance type for infrastructure Node Group                                             | yes       | c6i.xlarge                        | `^[a-z0-9.]+$`
| node_small_instance_type  | Instance type for small class Node Group                                                | yes       | t3.large                          | `^[a-z0-9.]+$`
| node_medium_instance_type | Instance type for medium class Node Group                                               | yes       | t3.xlarge                         | `^[a-z0-9.]+$`
| node_large_instance_type  | Instance type for large class Node Group                                                | yes       | t3.2xlarge                        | `^[a-z0-9.]+$`
| node_spot_instance_type   | Instance type for spot instances Node Group                                             | yes       | t3.2xlarge                        | `^[a-z0-9.]+$`
| project_name              | Name of this project                                                                    | yes       | -                                 | `\w{2,20}`
| resource_business_unit    | Required Tag Value by Global Cloud Engineering for Business Unit Name                   | yes       |                                   | `\w{2,100}`
| resource_name             | Name of the EC2 instances (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine. | yes | | `^[a-zA-Z0-9\-\._]+$`
| resource_owner            | Required Tag Value by Global Cloud Engineering for Team Distribution List (Mail List). This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase. | yes | | `^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$`
| resource_app_id           | Required Tag Value by Global Cloud Engineering for AppID binding                        | yes       | -                                 | `\d{1,10}`
| resource_cost_center      | Required Tag Value by Global Cloud Engineering for Cost Center string                   | yes       | -                                 | `^[a-zA-Z0-9\.]{15,30}$`

## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-eks-serasa`.

## Como contribuir 
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.

## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-eks-serasa` [Backlog](docs/BACKLOG.md) 

`1.0.0` - Fri Feb 25 08:22:32 -03 2022
* `ADD` -  Criação do repositório e sua estrutura inicial  

## Author

* **mlops.sre** - (mlops.sre@br.experian.com)