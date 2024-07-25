# aws-eks-argo-rollouts
----

<div align="center">

  ![Logo](https://img.youtube.com/vi/hIL0E2gLkf8/0.jpg)

  ![Version](https://img.shields.io/badge/Version-1.0.0-green)
  ![Category](https://img.shields.io/badge/Category_-Cockpit-blue)
  ![Sub-Category](https://img.shields.io/badge/Sub%20category-Automation-blue)

</div>

## O que é o aws-eks-argo-rollouts?

Olá sou um launch para instalar e configurar uma instância do argo-rollouts.
Argo Rollouts é um controlador Kubernetes e um conjunto de CRDs que fornece recursos avançados de implantação, como blue-green, canary, canary analysis, experimentação e recursos de entrega progressiva para Kubernetes.

Argo Rollouts (opcionalmente) integra-se com controladores de entrada e malhas de serviço, aproveitando suas habilidades de modelagem de tráfego para mudar gradualmente o tráfego para a nova versão durante uma atualização. Além disso, os Rollouts podem consultar e interpretar métricas de vários provedores para verificar os principais KPIs e promover promoção ou reversão automatizada durante uma atualização.

## Por que lançamentos do Argo?

Kubernetes Deployments fornece a estratégia `RollingUpdate` que fornece um conjunto básico de garantias de segurança (sondagens de prontidão) durante uma atualização. No entanto, a estratégia de atualização contínua enfrenta muitas limitações:

* Poucos controles sobre a velocidade do lançamento
* Incapacidade de controlar o fluxo de tráfego para a nova versão
* As sondagens de prontidão não são adequadas para verificações mais profundas, de estresse ou únicas
* Não é possível consultar métricas externas para verificar uma atualização
* Pode interromper a progressão, mas não pode abortar e reverter automaticamente a atualização

Por esses motivos, em ambientes de produção em larga escala e de alto volume, uma atualização contínua é muitas vezes considerada um procedimento de atualização muito arriscado, pois não fornece controle sobre o raio de explosão, pode ser implementado de forma muito agressiva e não fornece reversão automatizada em caso de falhas.

## Características

* Estratégia de atualização blue-green
* Estratégia de atualização canary
* Mudança de tráfego ponderada e refinada
* Rollback e promotions automatizadas
* Judgement manual
* Consultas de métricas personalizáveis ​​e análise de KPIs de negócios
* Integração do controlador Ingress: ALB
* Integração Service Mesh: Istio
* Integração de provedores de métricas: Prometheus

## Pré-requisitos

Para que eu possa ser executado corretamente, é necessário que sua conta AWS já possua o onboarding realizado com o CockPit. [Clique aqui e saiba mais](https://pages.experian.com/pages/viewpage.action?pageId=1081626313).

Além disso, as roles utilizadas pelo CockPit DevSecOps devem ter permissões de admin dentro do seu cluster. Você pode conferir essa informação no configmap "aws-auth" em seu cluster.

Caso não esteja, adicione:

```
- groups:
  - system:masters
  rolearn: arn:aws:iam::707064604759:role/BURoleForDevSecOpsCockpitService
  username: admin
```

```
- groups:
  - system:masters
  rolearn: arn:aws:iam::<O ID DA SUA CONTA AWS>:role/BURoleForDevSecOpsCockpitService
  username: admin
```

| Caracteristica         | Descrição             
| ---------------------- | ------------------------
| Categoria              | Aws
| ITIL                   | True
| Inner Source           | Times podem participar da evolução do mesmo
| Conformidade           | O launch garante os padrões DevSecOps PaaS para criação de launch

## Documentação

* Instalação - https://pages.experian.local/display/DDSE/Tutorial+-+Como+instalar+o+Argo+Rollouts (coberta pela automação e playbook vdi)
* Implementação - https://pages.experian.local/pages/viewpage.action?pageId=1340969950
* Oficial - https://argoproj.github.io/argo-rollouts/
* Comandos - https://argoproj.github.io/argo-rollouts/generated/kubectl-argo-rollouts/kubectl-argo-rollouts/

## Versioning

`1.0.1` - Thu Jun  18 10:00:00 -03 2024
* `ADD` -  Documentação oficial e interna 

`1.0.0` - Thu Jun  18 10:00:00 -03 2024
* `ADD` -  Criação do repositório e sua estrutura inicial 

## Author

* **joao.prado** - (joao.prado@experian.com)