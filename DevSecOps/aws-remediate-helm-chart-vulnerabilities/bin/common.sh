#!/bin/bash

# /**
# * log_msg
# * Método mensagem de informação
# * @author  Fabio Zinato <fabio.zinato@br.experian.com>
# * @param   $1 - Messagem
# *          $2 - Tipo [ FAILED | SUCCESS | WARNING | SKIP | INFO ]
# */
log_msg() {
  
  actualDate=$(date +"%d-%m-%Y %H:%M:%S")

  local count_char_msg=$(echo "${actualDate} - Cockpit-common > common.sh[$VERSION] -> $1 [$2]"| wc -c)
  local char_limit_terminal=130
  local normalize_line=$(($char_limit_terminal-$count_char_msg))
  local dots_line='.'

  for i in $(seq $normalize_line); do dots_line=$(echo "$dots_line."); done

  echo -e "${actualDate} -> $1$dots_line[$2]"

}


# rollback()
# 
# Args: 
# * value = Nome do resource no helm chart. Ex: vpa.
# * namespace = Namespace do resource. Ex: kube-system
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

rollback(){

    value=$1
    namespace=$2

    second_last_release=$(helm history ${value} -n ${namespace} | awk 'NR==FNR{a[NR]=$0; next} END{print a[NR-1]}' | cut -d ' ' -f1) 

    log_msg "rollback - Iniciando rollback para a versão ${second_last_release}" "INFO"

    if helm rollback -n $namespace $value $second_last_release > /dev/null; then
        log_msg "rollback - Rollback realizado com sucesso." "INFO"

        adds_on_rolled_back=$(helm list -n ${namespace} -o json | jq -r '.[] | select(.name == '\"${value}\"') | .chart')

        log_msg "rollback - Versão do ${value}: ${adds_on_rolled_back}" "INFO"
        log_msg "rollback - Recomendamos que tente realizar a atualização manualmente." "INFO"

    else
        log_msg "rollback - Nao foi possivel realizar rollback." "ERROR"
        log_msg "rollback - Por gentileza, verifique seu cluster e tente manualmente."
    fi

}


# get_current_version()
# 
# Args: 
# * namespace = Namespace do resource. Ex: kube-system
# * value = Nome do resource no helm chart. Ex: vpa
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

get_current_version() {

    namespace=$1
    value=$2

    current_version=$(helm list -n ${namespace} -o json | jq -r '.[] | select(.name == '\"${value}\"') | .chart' | cut -d '-' -f1- | tr '-' '\n' | tail -n1)

    echo $current_version
}


# get_last_version()
# 
# Args: 
# * chart = Nome do chart. Ex: cowboysysop
# * resource = Nome do resource no helm chart. Ex: vertical-pod-autoscaler
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

get_last_version(){

    chart=$1
    resource=$2

    last_version=$(helm search repo ${chart} --versions | grep ${resource} | awk '{print $2}' | head -n 1)

    echo $last_version

}


# backup_values()
# 
# Args: 
# * value = Nome do resource no helm chart. Ex: vpa
# * namespace = Namespace do resource. Ex: kube-system
# * resource = Nome do resource no helm chart. Ex: vertical-pod-autoscaler
# * current_version = Versão atual do chart.
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

backup_values(){

    value=$1
    namespace=$2
    resource=$3
    current_version=$4

    log_msg "backup_values - Gerando backup do resource." "INFO"

    helm get values $value -n $namespace -o yaml > $resource-$current_version-values.yaml

    log_msg "backup_values - $(ls -l $resource-$current_version-values.yaml)" "INFO"

}


# get_avaliable_versions()
# 
# Args: 
# * chart = Nome do chart. Ex: cowboysysop
# * resource = Nome do resource no helm chart. Ex: vertical-pod-autoscaler
# * current_version = Versão atual do chart.
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

get_avaliable_versions() {

    chart=$1
    resource=$2
    current_version=$3

    avaliable_versions=$(helm search repo ${chart} --versions | \
        grep ${resource} | \
        awk '{print $2}' | \
        sort -V | \
        awk -v current_version="$current_version" '{
            split(current_version, cv, ".")
            split($1, v, ".")
            if (v[1] > cv[1]) {
                print $1
            } else if (v[1] == cv[1]) {
                if (v[2] > cv[2]) {
                    print $1
                } else if (v[2] == cv[2]) {
                    if (v[3] > cv[3]) {
                        print $1
                    }
                }
            }
        }')

        echo $avaliable_versions
}


# get_avaliable_versions()
# 
# Args: 
# * namespace = Namespace do resource. Ex: kube-system
# * resource = Nome do resource no helm chart. Ex: vertical-pod-autoscaler
# * value = Nome do resource no helm chart. Ex: vpa
# 
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com
get_status_pod () {

    flag_error=0
    attempts=1
    pods_not_running=()
    pods_running=()

    namespace=$1
    resource=$2
    value=$3

    # pods=($(kubectl get pods -n ${namespace} | awk '{print $1}' | grep "${resource}" | sort))

    while [ $attempts -le 3 ]; do

        pods=($(kubectl get pods -n ${namespace} | awk '{print $1}' | grep "${resource}" | sort))

        log_msg "${value} - get_status_pod - Iniciando as validações do(s) pod(s) (${attempts}/3)" "INFO"

        for i in ${!pods[@]}; do

            # Se o pod nao existir, exclui da lista de pods.
            if ! kubectl get pod ${pods[$i]} -n $namespace > /dev/null 2>&1; then
                unset pods[$i]
                continue
            fi

            status=$(kubectl get pod ${pods[i]} -n $namespace -o json | jq '.status.phase')
            
            # Status diferente de running e for igual a Terminate ou ContainerCreating, pula para a proxima iteração.
            if [ "$status" != "\"Running\"" ]; then
                if ! printf "%s\n" "${pods_not_running[@]}" | grep -xq "${pods[$i]}"; then
                    pods_not_running+=("${pods[$i]}")
                fi            
            else
                if printf "%s\n" "${pods_not_running[@]}" | grep -xq "${pods[$i]}"; then
                    for j in ${!pods_not_running[@]}; do
                        if [ ${pods[i]} == ${pods_not_running[$j]} ]; then
                            unset pods_not_running[$j]
                            pods_running+=("${pods[i]}")
                        fi
                    done
                elif ! printf "%s\n" "${pods_running[@]}" | grep -xq "${pods[i]}"; then
                    pods_running+=("${pods[i]}")
                fi
            fi

        done

        lenght_pods_running=${#pods_running[@]}
        lenght_pods_not_running=${#pods_not_running[@]}
        lenght_pods=${#lenght_pods[@]}

        if [ $lenght_pods_running -eq $lenght_pods ]; then
            log_msg "${value} - get_status_pod - Todos os pods subiram com sucesso." "INFO"
            break
        elif [[ $lenght_pods_not_running -gt 0 && attempts -eq 3 ]]; then
            flag_error=1
        fi 

        ((attempts++))

        log_msg "Aguardando 15s..."

        sleep 15

    done
        
    if [ $flag_error -eq 1 ]; then
        log_msg "${value} - Existe(m) pod(s) com problema(s). Iniciando Rollback." "ERROR"
        rollback "${value}" "${namespace}"
        exit 1
    fi 

}

# Remediate()
# 
# Args: 
# * chart = nome do chart. Ex: cowboysysop
# * namespace = Namespace do resource. Ex: kube-system
# * resource = Nome do resource. Ex: vertical-pod-recommender
# * value = Nome do resource no helm chart. Ex: vpa.
#
# Author: Felipe Olivotto
# Email: felipe.olivotto@experian.com

remediate () {

    chart=$1
    namespace=$2
    resource=$3
    value=$4

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

            helm upgrade $value --version $avaliable_version $chart/$resource -n $namespace

            get_status_pod $namespace $resource $value

        done
    else
        log_msg "${value} - O chart já encontra-se a ultima versão." "INFO"
        log_msg "${value} - Versão atual: ${current_version}." "INFO"
    fi

}