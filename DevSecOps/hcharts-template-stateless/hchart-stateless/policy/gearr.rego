package main

### Policy to validate deployment objects 
### The validations bellow apply to Kubernetes and Openshift

## Validate Label GEARR

#warn["K8S-TAG-010 Label GEARRID inexistente (https://pages.experian.local/display/MEAB/GEARR)"] {
#        startswith(input.kind, "Deployment")
#        gearr := input.spec.template.metadata.labels.gearrid
#        gearr == ""
#}

#warn["K8S-TAG-010 Label GEARRID inexistente (https://pages.experian.local/display/MEAB/GEARR)"] {
#        startswith(input.kind, "Deployment")
#        gearr := input.spec.template.metadata.labels.gearrid
#        gearr <= 0
#}
