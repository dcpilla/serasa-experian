#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           iamLib.sh
# * @description    Biblioteca com as chamadas para recuperar token JWT do IAM
# * @copyright      2024 &copy Serasa Experian
# *
# **/

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * Variaveis
# */

# /**
# * authApiUri
# * URI utilizada para recuperar o token JWT
# */
authApiUri=""

# /**
# * jsonData
# * JSON utilizado no POST da chamada, contendo as informações do client id e client secret
# */
jsonData='{"clientId": "'$clientId'", "clientSecret": "'$clientSecret'"}'

# /**
# * clientId
# * Client Id do Jenkins a ser utilizado nas chamadas - Definido como variável de ambiente na pipeline
# */

# /**
# * clientSecret
# * Client Secret do Jenkins a ser utilizado nas chamadas - Definido como variável de ambiente na pipeline
# */

# /**
# * piaasEnv
# * Define o ambiente de execção do PiaaS, para validar as URI a serem utilizadas - Definido como variável de ambiente na pipeline
# */

# /**
# * Funções
# */

getJwtToken() {

    response=$(curl --insecure -X POST -H "Content-Type: application/json" -d "$jsonData" "$authApiUri" 2>/dev/null)

    jwtToken=$(echo "$response" | jq -r '.accessToken')

    if [ "$jwtToken" == "" ]; then
        errorMsg 'iamLib.sh->getJwtToken : Error in retrieve JWT Token. Contact DevSecOps PaaS Brazil Team.'
        exit 1
    else
        echo $jwtToken
    fi

}

if [ "$piaasEnv" == "prod" ]; then
    authApiUri="https://devsecops-authentication-api-prod.devsecops-paas-prd.br.experian.eeca/devsecops-authentication/v1/orgs/login"
else
    authApiUri="https://devsecops-authentication-api-sand.sandbox-devsecops-paas.br.experian.eeca/devsecops-authentication/v1/orgs/login"
fi