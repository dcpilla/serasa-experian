package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate Rollout Strategy

warn["K8S-AVA-040 maxUnavailable sendo = 0 evita queda de performance (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
  startswith(input.kind, "Deployment")
  maxUnavailable := input.spec.strategy.rollingUpdate.maxUnavailable
  is_string(maxUnavailable)
  not re_match("^0%?$", maxUnavailable)
}

warn["K8S-AVA-040 maxUnavailable sendo = 0 evita queda de performance (https://pages.experian.local/pages/viewpage.action?pageId=1349270154)"] {
  startswith(input.kind, "Deployment")
  maxUnavailable := input.spec.strategy.rollingUpdate.maxUnavailable
  is_number(maxUnavailable)
  maxUnavailable != 0
}