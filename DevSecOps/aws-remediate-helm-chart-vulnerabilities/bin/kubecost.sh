#!/bin/bash

if [ -f common.sh ]; then
    source common.sh
fi

kubecost() {

    chart="kubecost" 
    namespace="monitoring-system"
    resource="cost-analyzer"
    value="kubecost"

    if ! helm repo list | grep $chart > /dev/null 2>&1; then
        helm repo add $chart https://kubecost.github.io/cost-analyzer/
    fi

    helm repo update > /dev/null 2>&1

    log_msg "${value} - A versão 2.X do kubecost instalará as dependencias abaixo." "INFO"
    log_msg "${value} - * kubecost-prometheus" "INFO"
    log_msg "${value} - * kubecost-grafana" "INFO"
    log_msg "${value} - * kubecost-forecasting" "INFO"
    log_msg "${value} - Iremos desabilitar todas dependencias listadas acima." "WARNING"
    log_msg "${value} - Verifique se há a necessidade de manter este chart instalado." "WARNING"

    current_version=$(get_current_version $namespace $value)
    last_version=$(get_last_version $chart $resource)

    if [ "${current_version}" != "${last_version}" ]; then
        
        log_msg "${value} - ${resource} desatualizado. Versão do chart atual: ${current_version}." "INFO" 

        backup_values $value $namespace $resource $current_version

        avaliable_versions=($(get_avaliable_versions $chart $resource $current_version))

        log_msg "${value} - O chart está a "$(printf "%s\n" "${avaliable_versions[@]}" | wc -l)" versões desatualizadas." "INFO"
        log_msg "${value} - Versões disponíveis: ${avaliable_versions[*]]}" "INFO"

        for avaliable_version in "${avaliable_versions[@]}"; do

            log_msg "${value} - Iniciando atualização para a versão ${avaliable_version}." "INFO"

            if helm upgrade $value --version $avaliable_version $chart/$resource -n $namespace\
             --set global.prometheus.enabled=false\
              --set forecasting.enabled=false\
               --set global.grafana.enabled=false\
                --set global.grafana.proxy=false\
                 --set kubecostFrontend.livenessProbe.enabled=false\
                  --set global.gcpstore.enabled=false\
                   --set global.gmp.enabled=false > /dev/null; then
                log_msg "kubecost - Chart instalado com sucesso." "INFO"
            fi

            get_status_pod $namespace $resource $value

        done

    else
        log_msg "${value} - O chart já encontra-se a ultima versão." "INFO"
        log_msg "${value} - Versão atual: ${current_version}." "INFO"
    fi

}