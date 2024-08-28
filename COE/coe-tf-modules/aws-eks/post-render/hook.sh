#!/bin/bash

dir="temp"
mkdir ${dir}

cat > ${dir}/istio-gateway-patch.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: "any"
spec:
  loadBalancerClass: service.k8s.aws/nlb
EOF

cat > ${dir}/kustomization.yaml <<EOF
resources:
- all.yaml
patches:
- path: istio-gateway-patch.yaml
  target:
    kind: Service
    annotationSelector: 'service.beta.kubernetes.io/aws-load-balancer-nlb-target-type'
EOF

cat <&0 > ${dir}/all.yaml

kustomize build ${dir} && rm -rf ${dir}
