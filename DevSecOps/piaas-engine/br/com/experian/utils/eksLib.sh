#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           eksLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as chamadas para deploy no eks
# * @copyright      2021 &copy Serasa Experian
# *
# * @version        1.1.0
# * @change         [FIX] Retry aws login para push da image no eks
# * @copyright      2023 &copy Serasa Experian
# * @author         Paulo Ricassio <paulo.ricassio@br.experian.com>
# * @dependencies   common.sh
# *                 curl
# *                 /usr/local/bin/jq
# * @date           23-Mar-2023
# *
# * @version        1.0.0
# * @change         Biblioteca com as chamadas para deploy no eks
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl
# *                 /usr/local/bin/jq
# * @date           13-Dec-2021
# *
# **/

# /**
# * Configurações iniciais
# */

# Exit se erros
#set -eu   # Liga Debug

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# Carrega helmLib
test -e "$baseDir"/br/com/experian/utils/helmLib.sh || echo 'Ops, biblioteca helmLib nao encontrada'
source "$baseDir"/br/com/experian/utils/helmLib.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.1.0'

# /**
# * Stringresp
# * Armazena string de respostas ao usuario
# * @var string
# */
stringResp=''

# /**
# * resp
# * Armazena respostas
# * @var string
# */
resp=''

# /**
# * image
# * Define a imagem do container
# * @var string
# */
image=''

# /**
# * applicationName
# * Define o nome da aplicacao
# * @var string
# */
applicationName=''

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=''

# /**
# * project
# * Define o projeto (eks namespace) para o deploy
# * @var string
# */
project=''

# /**
# * awsAccountID
# * ID da conta AWS onde serah salvo a imagem
# * @var string
# */
awsAccountID=''

# /**
# * awsRegion
# * Regiao do ECR onde serah salvo a imagem
# * @var string
# */
awsRegion=''

# /**
# * tribe
# * Nome da tribe responsavel pela aplicacao
# * @var string
# */
tribe=''

# /**
# * squad
# * Nome da squad responsavel pela aplicacao
# * @var string
# */
squad=''

# /**
# * vault
# * Nome do cofre
# * @var string
# */
vault='null'

# /**
# * safe
# * Nome do cofre
# * @var string
# */
safe='null'

# /**
# * iamUser
# * Nome do usuário IAM
# * @var string
# */
iamUser='null'

# /**
# * awsAccount
# * ID da conta AWS
# * @var string
# */
awsAccount='null'

# /**
# * clusterName
# * Define o nome do Cluster EKS
# * @var string
# */
clusterName=''

# /**
# * Funções
# */

# /**
# * pushImageEcr
# * Método que registra a imagem no ECR
# * @version $VERSION
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.serasa dot com>
# * @param   
# * @return  true / false
# */
pushImageEcr (){

    noDeleteImage=$1

    docker tag $image $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image
    sleep 5
    imageSize=$(docker images | grep "$awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image" | grep $version | awk '{print $7}')

    infoMsg 'eksLib.sh->pushImageEcr: Autenticando no ECR'

    if [ "$piaasEnv" == "prod" ]; then
        if [ "$awsAccountID" == "707064604759" ]; then
            infoMsg 'eksLib.sh->pushImageEcr: Conta produtiva de DevSecOps. Ignorando ECR login...'
        else
            authEcr
        fi
    elif [ "$piaasEnv" == "sandbox" ]; then
        if [ "$awsAccountID" == "559037194348" ]; then
            infoMsg 'eksLib.sh->pushImageEcr: Conta de sandbox de DevSecOps. Ignorando ECR login...'
        else
            authEcr
        fi 
    fi

    infoMsg 'eksLib.sh->pushImageEcr: Registrando imagem '${image}'['${imageSize}'] no ECR em '$awsAccountID'.dkr.ecr.'$awsRegion'.amazonaws.com/'$image
    docker push $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image
    if [ "$?" -ne 0 ]; then
        errorMsg 'eksLib.sh->pushImageEcr: Algo de errado aconteceu ao tentar executar o registro da imagem '${image}
        exit 1
    fi


    if [ "$noDeleteImage" == "false" ]; then
        infoMsg 'eksLib.sh->pushImageEcr: Limpando imagens criadas para registro'
        docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" | grep $image)
    else
        infoMsg 'eksLib.sh->pushImageEcr: Ignorando limpeza de imagem.'
    fi
        
}

# /**
# * authEcr
# * Método que autentica no ECR
# * @version $VERSION
# * @package DevOps
# * @param   
# * @return  true / false
# */
authEcr (){

    keepGoing=1

    while [ $keepGoing -le 5 ]; do  # Tentando 5 vezes

        aws ecr get-login-password | docker login --username AWS --password-stdin $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com
        if [ "$?" -ne 0 ]; then
            infoMsg 'eksLib.sh->pushImageEcr: Ops, Erro em Autenticando no ECR. Tentando novamente !!!'
            keepGoing=$((keepGoing + 1))
            sleep 20 # Espera 20 segundos
        else
            infoMsg 'eksLib.sh->pushImageEcr: Conectado com sucesso na tentativa '$keepGoing' !!!'
            keepGoing=99
        fi

        if [ $keepGoing -eq 5 ]; then
            errorMsg 'eksLib.sh->pushImageEcr: Nao foi possivel autenticar no registry '$awsAccountID'.dkr.ecr.'$awsRegion'.amazonaws.com. Veja a msg de erro acima.'
            exit 1
        fi

    done

    infoMsg 'eksLib.sh->pushImageEcr: Sucesso em se conectar no ECR'

}

# /**
# * deploymentsEks
# * Método que prepara e dispara o deploy no EKS
# * @version $VERSION
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.serasa dot com>
# * @param   $applicationName 
# *          $version
# *          $awsRegion
# *          $project
# *          $tribe 
# *          $squad
# *          $safe
# *          $iamUser
# *          $awsAccount
# *          $environment
# * @return  true / false
# */
deploymentsEks (){

    test ! -z $1 || { errorMsg 'eksLib.sh->deploymentsEks: Nome da aplicacao nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'eksLib.sh->deploymentsEks: Versao da API nao informada' ; exit 1; }
    test ! -z $3 || { errorMsg 'eksLib.sh->deploymentsEks: Projeto (EKS Namespace) nao informado' ; exit 1; }
    test ! -z $4 || { errorMsg 'eksLib.sh->deploymentsEks: Tribe nao informada' ; exit 1; }
    test ! -z $5 || { errorMsg 'eksLib.sh->deploymentsEks: Squad nao informada' ; exit 1; }
    test ! -z $6 || { errorMsg 'eksLib.sh->deploymentsEks: Safe nao informado' ; exit 1; }
    test ! -z $7 || { errorMsg 'eksLib.sh->deploymentsEks: Iam User nao foi informado' ; exit 1; }
    test ! -z $8 || { errorMsg 'eksLib.sh->deploymentsEks: AWS Account nao foi informado' ; exit 1; }
    test ! -z $9 || { errorMsg 'eksLib.sh->deploymentsEks: Ambiente nao foi informado' ; exit 1; }
    test ! -z ${10}|| { errorMsg 'eksLib.sh->deploymentsEks: Cluster não foi informado' ; exit 1; }
    test ! -z ${11} || { errorMsg 'eksLib.sh->deploymentsEks: AWS Regiao nao informada' ; exit 1; }

    applicationName=$1
    version=$2
    project=$3
    tribe=$4
    squad=$5
    safe=$6
    iamUser=$7
    awsAccount=$8
    environment=$9
    clusterName=${10}
    awsRegion=${11}
    noDeleteImage=${12}

    # Resgatando credenciais no Cyberark Dap
    credentials=$(cyberArkDap -s "$safe" -c "$iamUser" -a "$awsAccount")

    if [ -z "$credentials" ]; then
        errorMsg "eksLib.sh->deploymentsEks: Falha ao recuperar credenciais do cofre: $safe"
        exit 1
    fi

    # Parseando as credenciais
    awsAccountID=$(echo $credentials | jq -r '.accountId')
    awsAccessKey=$(echo $credentials | jq -r '.accessKey')
    awsSecretKey=$(echo $credentials | jq -r '.accessSecret')

    # Exportando as variaveis para uso
    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=$awsRegion

    infoMsg 'eksLib.sh->deploymentsEks: Iniciando stage (1/2): Registrando imagem no ECR'
    image="$applicationName:$version"
    pushImageEcr $noDeleteImage

    infoMsg 'eksLib.sh->deploymentsEks: Iniciando stage (2/2): Executando deploy no EKS'
    helmDeployCharts $tribe $project $applicationName $version $environment $squad $safe $iamUser $awsAccount $clusterName $awsRegion

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_REGION
    
}
