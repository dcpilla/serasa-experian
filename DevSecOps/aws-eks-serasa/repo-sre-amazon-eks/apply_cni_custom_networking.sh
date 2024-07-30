#!/bin/bash

kubectl set env daemonset aws-node -n kube-system AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true
kubectl set env daemonset aws-node -n kube-system ENI_CONFIG_LABEL_DEF=topology.kubernetes.io/zone
kubectl set env daemonset aws-node -n kube-system MINIMUM_IP_TARGET-
kubectl set env daemonset aws-node -n kube-system WARM_IP_TARGET-
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
kubectl set env daemonset aws-node -n kube-system WARM_PREFIX_TARGET=1
kubectl rollout status -n kube-system daemonset/aws-node

