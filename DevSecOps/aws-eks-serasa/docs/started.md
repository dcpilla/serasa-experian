### Getting Started

#### Pré-requisitos

Para que o cluster EKS possa ser gerenciado a partir da rede Serasa Experian, atendendo aos padrões de segurança, sua conta AWS precisa atender os pré-requisitos listados na documentação: [EKS Pré-reqs](https://pages.experian.com/display/CODAENANMA/Pre-reqs).

#### Parâmetros

No formulário para executar esse launch você encontrará os seguintes parâmetros a ser informados:

| Parâmetro              | Descrição                                                                                                                                                                  | Mandatory | Example                           | Regex
| -----------------------| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------| ----------------------------------| -------------------------------------------------------------------------------|
| aws_account_id         | Account number where the cluster will be created                                                                                                                           | yes       | 123456789000                      | `^(\d{1,12}|\d{1,12})$`                                                        |
| aws-region             | AWS region of ECR repository for image registration to EKS                                                                                                                 | yes       | sa-east-1 | `^[a-z0-9\-]{1,20}$`  |                                                                                |
| eks_cluster_name       | Give a name to your new EKS Cluster MAX 22 CHARACTERS                                                                                                                      | yes       | BUName-eks-version = mlcoe-eks-01 | `^[a-zA-Z0-9-]{2,10}-eks-\d{1,7}$`                                             |
| project_name           | Name of this project                                                                                                                                                       | yes       |                                   | `\w{2,20}`                                                                     |
| env                    | Environment                                                                                                                                                                | yes       | options: dev;uat;prod;sandbox     | -                                                                              |
| acm                    | ACM ARN to be used by the LoadBalancer                                                                                                                                     | yes       |                                   | `arn:[\w+=/,.@-]+:[\w+=/,.@-]+:[\w+=/,.@-]*:[0-9]+:[\w+=,.@-]+(/[\w+=,.@-]+)*` |
| domain_name            | Domain name to be used in this EKS Cluster                                                                                                                                 | yes       | dev-mlops.br.experian.eeca        | `^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$`                            |
| ami_bottlerocket       | Bottlerocket AMI ID or 'auto' to get the latest AMI available                                                                                                              | yes       |                                   | `\w{4,100}`                                                                    |
| bucket_tf_state_name   | Name of the S3 bucket to store the Terraform state                                                                                                                         | yes       |                                   | `[a-zA-Z0-9-]{1,100}`                                                          |
| tf_state_name          | Name of the Terraform state file                                                                                                                                           | yes       |                                   | `[a-zA-Z0-9-_]{1,100}`                                                         |
| infra_node_max_size    | Max node size for infra auto scaling group                                                                                                                                 | yes       |                                   | `\d{1,5}`                                                                      |
| node_small_max_size    | Max node size for small auto scaling group                                                                                                                                 | yes       |                                   | `\d{1,5}`                                                                      |
| node_medium_max_size   | Max node size for medium auto scaling group                                                                                                                                | yes       |                                   | `\d{1,5}`                                                                      |
| node_larger_max_size   | Max node size for large auto scaling group                                                                                                                                 | yes       |                                   | `\d{1,5}`                                                                      |
| node_spot_max_size     | Max node size for spot auto scaling group                                                                                                                                  | yes       |                                   | `\d{1,5}`                                                                      |
| resource_business_unit | Business Unit Name (Required by [EEC](https://pages.experian.com/display/SC/How+to+build+EC2+instances+using+the+Experian+Golden+AMIs))                                    | yes       |                                   | `\w{2,100}`                                                                    |
| resource_name          | Name of the EC2 instances (fully qualified domain name). The approved AMIs will also use this tag to configure hostname and hosts file in the machine.                     | yes       |                                   | `\w{2,20}`                                                                     |
| resource_owner         | Team Distribution List (Mail List) that owns the cluster. This email will also be used to notify the Distribution List about any errors found in the AMI post-build phase. | yes       |                                   | `^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$`                                |
| rapid7_tag             | Tag used to activate Rapid7 and monitor the assets based on the BU which is building the cluster.                                                                          | yes       |                                   | `\w{1,255}`                                                                    |
| ad_group               | Set administrator/sudo permissions for the specific AD group. If multiple groups need to be setup they can be separated by comma.                                          | no        |                                   | `\w{1,255}`                                                                    |
| ad_domain              | Used by AMI instance post build automation to join machine to the domain. | no | options: br.experian.local;ena.us.experian.local;gdc.local                                | -         |                                   |                                                                                |
| centrify_unix_role     | The Unix Role that will be used to grant access and authorization to the Linux instance.                                                                                   | no        |                                   | `\w{1,255}`                                                                    |


#### Como lançar

* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-eks-serasa`.

#### Como contribuir

* [Contributing Guide](https://code.experian.local/projects/SCIB/repos/aws-eks-serasa/browse/docs/CONTRIBUTING.md) - Inner Source.

#### Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-eks-serasa`: [Backlog](https://code.experian.local/projects/SCIB/repos/aws-eks-serasa/browse/docs/BACKLOG.md)

`1.0.0` - Fri Feb 25 08:22:32 -03 2022
* `ADD` -  Criação do repositório e sua estrutura inicial

#### Author

* **mlops.sre** - (mlops.sre@br.experian.com)