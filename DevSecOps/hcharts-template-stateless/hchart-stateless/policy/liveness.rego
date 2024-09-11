package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate Liveness Probes

warn["K8S-AVA-010 Liveness nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not container.livenessProbe
}

warn["K8S-AVA-011 Liveness initialDelaySeconds nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  container.livenessProbe
  not container.livenessProbe.initialDelaySeconds
}

warn["K8S-AVA-012 Variavel livenessProbe.timeoutSeconds com valor maior que o livenessProbe.periodSeconds default(10): (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
   startswith(input.kind, "Deployment")
   container := input.spec.template.spec.containers[_]
   not container.livenessProbe.periodSeconds
   container.livenessProbe.timeoutSeconds
   container.livenessProbe.timeoutSeconds>10
}

warn["K8S-AVA-012 Variavel livenessProbe.timeoutSeconds maior que livenessProbe.periodSeconds (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
   startswith(input.kind, "Deployment")
   container := input.spec.template.spec.containers[_]
   container.livenessProbe.periodSeconds
   container.livenessProbe.timeoutSeconds
   container.livenessProbe.timeoutSeconds > container.livenessProbe.periodSeconds
}