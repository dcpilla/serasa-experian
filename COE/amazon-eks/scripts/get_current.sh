#!/bin/bash

rm -v scripts/creds.json

CLUSTER_NAME=$1
CLUSTER_LIST=$(aws eks list-clusters | jq '.clusters[]' -r)
echo $CLUSTER_LIST | grep -G ^${CLUSTER_NAME}$
if [ $? -eq 1 ]; then
	echo "Não existe cluster com o nome informado, saindo"
	exit 0
fi

set -e 

# garante que o namespace apigee-system existe
echo "Verificando se existe o namespace apigee-system"
kubectl --kubeconfig ${KUBECONFIG} get ns | grep "apigee-system"
if [ $? -eq 0 ]; then
	# garante que o apigee-microgateway ja existe
	echo "Verificando se existe o release apigee-microgateway"
	helm --kubeconfig ${KUBECONFIG} -n apigee-system status apigee-microgateway | grep "STATUS: deployed"
	if [ $? -eq 0 ]; then
	    echo "Deployment do apigee-microgateway encontrado, recuperando credenciais salvas"
	    kubectl --kubeconfig ${KUBECONFIG} -n apigee-system get secret ${CLUSTER_NAME}-microgateway-secrets -o json | jq -r '.data | {EDGEMICRO_KEY,EDGEMICRO_SECRET}' > scripts/creds.json
	fi
fi
