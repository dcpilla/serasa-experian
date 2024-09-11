package main

warn["K8S-HPA-001 Autoscaling HPA - Autoscaling desabilitado (https://pages.experian.local/pages/viewpage.action?pageId=1349270211)"] {
        startswith(input.kind, "Deployment")
        enabled := input.spec.template.metadata.labels.autoscaling
        replica := input.spec.replicas
        enabled != true
        replica > 0
}

warn["K8S-HPA-010 Autoscaling HPA - Maximo de replicas igual ou menor que o minimo (https://pages.experian.local/pages/viewpage.action?pageId=1349270211)"] {
        startswith(input.kind, "HorizontalPodAutoscaler")
        minRep := input.spec.minReplicas
        maxRep := input.spec.maxReplicas
        maxRep <= minRep
}

#warn["K8S-HPA-020 Autoscaling HPA - Autoscaling não atribuído a um Deployment (https://pages.experian.local/pages/viewpage.action?pageId=1349270211)"] {
#        startswith(input.kind, "HorizontalPodAutoscaler")
#        hpatarget := input.spec.scaleTargetRef.kind
#       hpatarget != "Deployment"
#}