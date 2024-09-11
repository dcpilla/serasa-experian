package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate Readiness Probe

warn["K8S-AVA-020 Readiness nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not container.readinessProbe
}

warn["K8S-AVA-021 Variavel readinessProbe.timeoutSeconds com valor maior que o readinessProbe.periodSeconds default(10) (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
   startswith(input.kind, "Deployment")
   container := input.spec.template.spec.containers[_]
   not container.readinessProbe.periodSeconds
   container.readinessProbe.timeoutSeconds
   container.readinessProbe.timeoutSeconds>10
}

warn["K8S-AVA-021 Variavel readinessProbe.timeoutSeconds maior que  readinessProbe.periodSeconds (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
   startswith(input.kind, "Deployment")
   container := input.spec.template.spec.containers[_]
   container.readinessProbe.periodSeconds
   container.readinessProbe.timeoutSeconds
   container.readinessProbe.timeoutSeconds > container.readinessProbe.periodSeconds
}