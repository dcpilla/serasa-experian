#!/bin/bash

if [ -f common.sh ]; then
    source common.sh
fi

metrics_server() {

    chart="metrics-server" 
    namespace="kube-system"
    resource="metrics-server"
    value="metrics-server"

    if ! helm repo list | grep $chart > /dev/null 2>&1; then
        helm repo add $chart https://kubernetes-sigs.github.io/metrics-server/
    fi

    helm repo update > /dev/null 2>&1

    # remediate chart namespace resource_name value
    remediate $chart $namespace $resource $value
    
}