# aws-eks-argo-rollouts-control
----

<div align="center">

  ![Logo](https://img.youtube.com/vi/hIL0E2gLkf8/0.jpg)

  ![Version](https://img.shields.io/badge/Version-1.0.0-green)
  ![Category](https://img.shields.io/badge/Category_-Cockpit-blue)
  ![Sub-Category](https://img.shields.io/badge/Sub%20category-Automation-blue)

</div>

## O que é o aws-eks-argo-rollouts-control?

Olá sou um launch para enviar comandos para o argo-rollout.

Argo Rollouts é um controlador Kubernetes e um conjunto de CRDs que fornece recursos avançados de implantação, como blue-green, canary, canary analysis, experimentação e recursos de entrega progressiva para Kubernetes.

Argo Rollouts (opcionalmente) integra-se com controladores de entrada e malhas de serviço, aproveitando suas habilidades de modelagem de tráfego para mudar gradualmente o tráfego para a nova versão durante uma atualização. Além disso, os Rollouts podem consultar e interpretar métricas de vários provedores para verificar os principais KPIs e promover promoção ou reversão automatizada durante uma atualização.

## Quais controles são enviados para o argo-rollouts?

### rollouts_command: abort (Abort a rollout)
kubectl argo rollouts abort guestbook

### rollouts_command: pause (Pause a rollout)
kubectl argo rollouts pause guestbook

### rollouts_command: promote (Promote a paused rollout)
kubectl argo rollouts promote guestbook

### rollouts_command: promote-full (Fully promote a rollout to desired version, skipping analysis, pauses, and steps)
kubectl argo rollouts promote guestbook --full

### rollouts_command: retry (Retry an aborted rollout)
kubectl argo rollouts retry rollout guestbook

### rollouts_command: retry-experiment (Retry a failed experiment)
kubectl argo rollouts retry experiment my-experiment


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

* Instalação - https://pages.experian.local/display/DDSE/Tutorial+-+Como+instalar+o+Argo+Rollouts (coberta pela automação)
* Implementação - https://pages.experian.local/pages/viewpage.action?pageId=1340969950
* Oficial - https://argoproj.github.io/argo-rollouts/
* Comandos - https://argoproj.github.io/argo-rollouts/generated/kubectl-argo-rollouts/kubectl-argo-rollouts/

## Versioning

`1.0.0` - Thu Jun  26 17:00:00 -03 2024
* `ADD` -  Criação do repositório e sua estrutura inicial 

## Author

* **joao.prado** - (joao.prado@experian.com)