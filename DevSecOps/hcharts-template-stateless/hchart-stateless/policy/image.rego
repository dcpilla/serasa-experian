package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate Image tag equal Latest

warn["K8S-IMG-010 Imagem com tag latest (https://pages.experian.local/pages/viewpage.action?pageId=1349270166)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  endswith(container.image, "latest")
}

## Validate Image PullPolicy

warn["K8S-IMG-020 ImagePullPolicy como Always (https://pages.experian.local/pages/viewpage.action?pageId=1349270166)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  container.imagePullPolicy == "Always"
}

## Validate if Image Repository is internal

warn["K8S-IMG-030 Repositorio de Imagens Externo/Inseguro (https://pages.experian.local/pages/viewpage.action?pageId=1349270166)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not contains(container.image, "amazonaws.com")
}