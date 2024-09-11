#!/bin/bash
#
# Script run the "pipeline" stage to verify kubernetes config using OPA Conftest
#

APP=$1
ENV=$2

set -o pipefail -e

#definição das variaveis do conftest
VarsPolicy=(
    #Autoscaling HPA - Autoscaling desabilitado
    "K8S-HPA-001 15"
    #Autoscaling HPA Maximo de replicas igual ou menor que o mínimo
    "K8S-HPA-010 5"
    #Imagem com tag latest
    "K8S-IMG-010 5"
    #ImagePullPolicy: Always
    "K8S-IMG-020 5"
    #Repositorio de Imagens Externo/Inseguro
    "K8S-IMG-030 5"
    #Liveness Nao Definido
    "K8S-AVA-010 15"
    #Liveness initialDelaySeconds Nao Definido
    #"K8S-AVA-011 0"
    #livenessProbe.timeoutSeconds Nao Definido
    #"K8S-AVA-012 0"
    #Readiness Nao Definido
    "K8S-AVA-020 15"
    #readinessProbe.timeoutSeconds Inconsistente
    #"K8S-AVA-021 0"
    #CPU Request Nao Definido
    "K8S-CAP-010 15"
    #CPU Limit Nao Definido
    "K8S-CAP-020 10"
    #Memory Request Nao Definido
    "K8S-CAP-030 15"
    #Memory Limits Nao Definido
    "K8S-CAP-040 10"
    #maxUnavailable Diferente de 0
    "K8S-AVA-040 0"
)

APPONDAS=(
    "11918" #experian-pme-billing-integration
    "9791" #experian-financial-health-notification-services
    "11973" #experian-pme-cobranca-notifications-domain-services
)

echo -e "\n[INFO] $0: Select the ccharts ..."
rm -rf conftest/$APP
mkdir -p conftest/$APP
cp -r build/$APP/* conftest/$APP
cd conftest/$APP

echo -e "\n[INFO] $0: Validating the charts templates with Kubeval..."
helm kubeval --ignore-missing-schemas .
if [[ $? -eq 1 ]]; then
    echo -e "[ERROR] Unable to identify valid chart templates."
    rm -rf conftest/$APP
    exit 1
fi

echo -e "\n[INFO] $0: Checking the Kubernetes config with Conftest ..."
helm conftest test . && helm conftest test . > $APP.conftest

FINAL=100
VIOLATED=""

for item in "${VarsPolicy[@]}"; do
    
    valorPolicy=$(echo "$item" | cut -d' ' -f1)
    valorPenalidade=$(echo "$item" | cut -d' ' -f2)
    
    if grep -c $valorPolicy $APP.conftest >/dev/null; then
        VIOLATED+="$valorPolicy,"
        if (( FINAL > "$valorPenalidade")); then
            (( FINAL-="$valorPenalidade" ))
        else
            FINAL=0
        fi
    fi
done
echo -e "" >> $APP.conftest
echo -e "eks_policy_score:$FINAL" >> $APP.conftest
echo -e "eks_violated_rules:$VIOLATED" >> $APP.conftest

echo -e "\n[RESULT] Your coverage for Kubernetes configurations is eks_policy_score: $FINAL %.\n"

eval "cd .."
eval "cd .."

JENINS=$PWD

GEARR=$( cat $JENINS/.jenkins.yml | grep gearr: | cut -d' ' -f4 )

flagW=false

for item1 in "${APPONDAS[@]}"
do
    
    if [ "$item1" == "$GEARR" ]; then
        if [[ $FINAL -lt 86 ]]; then
            echo -e "\n[RESULT] Reproved (WHITELIST)! Your coverage for Kubernetes configurations is $FINAL %.\n"
        else
            echo -e "\n[RESULT] Your coverage for Kubernetes configurations is $FINAL %.\n"
        fi
        
        flagW=true
        
    fi
done


if [ "$flagW" == false ]; then
    if [[ $FINAL -lt 86 ]]; then
        echo -e "\n[RESULT] Reproved! Your coverage for Kubernetes configurations is $FINAL %.\n"
        exit 99
    else
        echo -e "\n[RESULT] Your coverage for Kubernetes configurations is $FINAL %.\n"
    fi
fi
