package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate CPU and Memory Request and Limits

warn["K8S-CAP-010 CPU request nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1340198224)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not container.resources.requests.cpu
}

warn["K8S-CAP-020 CPU limit nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1340198224)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not container.resources.limits.cpu
}

warn["K8S-CAP-030 Memory request nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1340198224)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
 not container.resources.requests.memory
}

warn["K8S-CAP-040 Memory limit nao definido (https://pages.experian.local/pages/viewpage.action?pageId=1340198224)"] {
  startswith(input.kind, "Deployment")
  container := input.spec.template.spec.containers[_]
  not container.resources.limits.memory
}