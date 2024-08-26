# aws-eks-nodes-autoscale
----

## O que é o aws-eks-nodes-autoscale?

Lançador para fazer um agendamento de autoscale (para cima ou para baixo) dos Nodes do cluster EKS, sugestão para ser usado em ambientes não produtivos.

<div align="center">

![Topology](https://code.experian.local/projects/SCIB/repos/aws-eks-nodes-autoscale/raw/imgs/aws_autoscaling.png "Topology")

</div>
<br>

## Pré-requisitos

 - Para que eu possa ser executado corretamente, é necessário que sua conta AWS já possua o onboarding realizado com o CockPit. [Clique aqui e saiba mais](https://pages.experian.com/pages/viewpage.action?pageId=1081626313).

 - Antes de usar a automação, garanta que a role **BURoleForDevSecOpsCockpitService** tenha as permissões:
   - tag:*
   - ec2:*
   - cloudwatch:*
   - lambda:*
   - s3:*
   - eks:*
   - sqs:*
   - events:*

| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | Aws
| ITIL Request           | False;True
| ITIL Change Order      | False;True
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de launch


## Como lançar
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-eks-nodes-autoscale`.

## Como contribuir 
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.

## Versioning

Não deixe de saber e contribuir para as próximas versões do `aws-eks-nodes-autoscale` [Backlog](docs/BACKLOG.md) 

`1.0.0` - Tue Sep 26 14:52:17 -03 2023
* `ADD` -  Criação do repositório e sua estrutura inicial  

## Author

* **TribeSRECSCross** - (TribeSRECSCross@br.experian.com)
