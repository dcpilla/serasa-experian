#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do launch aws-eks-deployment-rollback
# *
# * @package        aws-eks-deployment-rollback
# * @name           apply.sh
# * @description    Script que realiza o rollback de um deployment no EKS
# * @copyright      2023 &copy Serasa Experian
# *
# **/  

# /**
# * Variaveis de parametros
# */

#/**
# * incident
# * Recebe o parametro de changeorder
# * @var string
# **/
changeOrder='@@CHANGE_ORDER@@'

#/**
# * snowconsultasprd
# * Recebe o parametro de snowconsultasprd
# * @var string
# **/
snowconsultasprd="@@SNOWCONSULTASPRD@@"

#/**
# * eksClusterName
# * Recebe o parametro de eksClusterName
# * @var string
# **/
eksClusterName="@@EKS_CLUSTER_NAME@@"

#/**
# * charts
# * Recebe o parametro de charts
# * @var string
# **/
IFS='; ' read -r -a charts <<< "@@CHARTS@@"


#/**
# * SNOW CLI
# **/
snowCli='/opt/DevOps/bin/snow.sh'


#/**
# * Snow Env vars
# **/
export SNOW_TOKEN=$(echo $snowconsultasprd | cut -d' ' -f2)
export SNOW_SERVER="https://experianworker.service-now.com/api/eplc/exp/getStandardChangeStatus/c719bacfdb9f97402511fa910f96192e/getStandardChangeStatus?searchVal="

changeInfos=$($snowCli --action=status-change --number-change=$changeOrder)
changeStatus=$(echo $changeInfos | jq -r .result[].state)
shortDescription=$(echo $changeInfos | jq -r .result[].short_description)
description=$(echo $changeInfos | jq -r .result[].description)


validateChange() {

    echo "itil.sh - validateChange: Iniciando validações da $changeOrder para o cluster $eksClusterName"

    echo $changeStatus

    if [ "$changeStatus" == "Implement" ]; then
        echo "itil.sh -> validateChange: A change $changeOrder encontra-se com estado Implement. Prosseguindo..."
    else
        echo "itil.sh -> validateChange: Impossível prosseguir! $changeOrder com status diferente de Opened."    
        exit 1
    fi


    if echo $shortDescription | grep -wq $eksClusterName; then
        echo "itil.sh -> validateChange: A change order $changeOrder pertence ao cluster $eksClusterName. Prosseguindo..."
    else
        echo -e "itil.sh -> validateChange: A change $changeOrder não pertence ao cluster $eksClusterName\n\
itil.sh -> validateChange: Possiveis causas:\n\
itil.sh -> validateChange: \t* Verifique se no short description há o nome do seu cluster eks.\n\
itil.sh -> validateChange: Finalizando a execução."
        # exit 1
    fi

    
    for chart in ${charts[@]}; do
        if echo $description | grep -wq "$chart"; then
            echo "itil.sh -> validateChange: Chart ${chart} encontrado na descrição. Prosseguindo."
        else
            echo -e "itil.sh -> validateChange: O chart ${chart} não está incluso a change order! Abortando execução.\n\
itil.sh -> validateChange: Possiveis causas:\n\
itil.sh -> validateChange: \t* Verifique se na descrição há todos os resources que deseja atualizar.\n\
itil.sh -> validateChange: Finalizando a execução."
            #exit 1
        fi
    done

}

validateChange