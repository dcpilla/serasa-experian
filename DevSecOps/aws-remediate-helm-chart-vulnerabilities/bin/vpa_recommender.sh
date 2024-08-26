#!/bin/bash

if [ -f common.sh ]; then
    source common.sh
fi

vpa_recommender() {

    chart="cowboysysop" 
    namespace="kube-system"
    resource="vertical-pod-autoscaler"
    value="vpa"

    if ! helm repo list | grep $chart > /dev/null 2>&1; then
        helm repo add $chart https://cowboysysop.github.io/charts/
    fi

    helm repo update > /dev/null 2>&1

    # remediate chart namespace resource_name value
    remediate $chart $namespace $resource $value

}
