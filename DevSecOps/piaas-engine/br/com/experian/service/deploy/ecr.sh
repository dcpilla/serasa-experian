#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           ecr.sh
# * @version        1.0.0
# * @description    Biblioteca com as chamadas para deploy no Adobe AEM
# * @copyright      2022 &copy Serasa Experian
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
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * applicationName
# * Nome da aplicacao
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
# * cyberarkSafe
# * Nome do Safe Cyberark
# * @var string
# */
cyberarkSafe=''

# /**
# * iamUser
# * Nome do usuario IAM
# * @var string
# */
iamUser=''

# /**
# * awsAccountID
# * ID da conta AWS
# * @var string
# */
awsAccountID=''

# /**
# * awsRegion
# * Regiao da conta AWS
# * @var string
# */
awsRegion=''

# /**
# * image
# * Define a imagem do container
# * @var string
# */
image=''

# /**
# * TEMP EDITAR
# * Leitura de opções
# * @var string
# */

TEMP=`getopt -o tuemirwj::h --long application-name::,version::,cyberark-safe::,iam-user::,aws-account-id::,aws-region:: -n "$0" -- "$@"`
eval set -- "$TEMP"


# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "ecr.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2022 Serasa Experian"
    echo ""
    echo -e "ecr.sh script responsavel por realizar push das imagens no ECR\n"

    echo -e "Usage: ecr.sh --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --aws-region=sa-east-1 --aws-profile=NikeArchitecture --helm-template=stateless --helm-template-version=v1.0.0 --config-repo=https://code.experian.local/scm/edvp/test-gleise-api-config.git"
    
    echo -e "Options
    --application-name          Nome da aplicacao.
    --version                   Versao da aplicacao.
    --cyberark-safe             Nome do cofre.
    --iam-user                  Nome do IAM user.
    --aws-account-id            ID da conta AWS.
    --aws-region                Regiao AWS dos recursos que serao utilizados para registro dos artefatos.
    --h, --help                 Ajuda"

    exit 1
}


# /**
# * ecr
# * Método que acessa o ECR na aws
# * @version $VERSION
# * @package DevOps
# * @author  Felipe Olivotto <felipe.olivotto@br.experian.com>
# * @param   
# * @return  true / false
# */
pushImageEcr () {
    infoMsg 'ecr.sh->pushImageEcr: Iniciando o push da imagem no ECR.'

    image="$applicationName:$version"
    infoMsg 'ecr.sh->pushImageEcr: Definindo a imagem: '${image}

    infoMsg 'ecr.sh->pushImageEcr: Coletando as credenciais no Cyberark'
    credentials=$(cyberArkDap -s $cyberarkSafe -c $iamUser -a $awsAccountID)
    
    awsAccessKey=$(echo $credentials | jq -r '.accessKey')
    awsSecretKey=$(echo $credentials | jq -r '.accessSecret')

    export AWS_ACCESS_KEY_ID=$awsAccessKey
    export AWS_SECRET_ACCESS_KEY=$awsSecretKey
    export AWS_DEFAULT_REGION=$awsRegion

    docker tag $image $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image
    sleep 5
    imageSize=$(docker images | grep "$awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image" | grep $version | awk '{print $7}')
    
    infoMsg 'ecr.sh->pushImageEcr: Autenticando no ECR'

    if [ "$piaasEnv" == "prod" ]; then
        if [ "$awsAccountID" == "707064604759" ]; then
            infoMsg 'ecr.sh->pushImageEcr: Conta produtiva de DevSecOps. Ignorando ECR login...'
        else
            authEcr
        fi
    elif [ "$piaasEnv" == "sandbox" ]; then
        if [ "$awsAccountID" == "559037194348" ]; then
            infoMsg 'ecr.sh->pushImageEcr: Conta de sandbox de DevSecOps. Ignorando ECR login...'
        else
            authEcr
        fi 
    fi

    infoMsg 'ecr.sh->pushImageEcr: Registrando imagem '${image}'['${imageSize}'] no ECR em '$awsAccountID'.dkr.ecr.'$awsRegion'.amazonaws.com/'$image
    docker push $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com/$image
    if [ "$?" -ne 0 ]; then
        errorMsg 'ecr.sh->pushImageEcr: Algo de errado aconteceu ao tentar executar o registro da imagem '${image}
        exit 1
    fi

    infoMsg 'ecr.sh->pushImageEcr: Limpando imagens criadas para registro'
    docker rmi -f $(docker images|grep ${image}) 2>/dev/null

    docker logout $awsAccountID.dkr.ecr.$awsRegion.amazonaws.com

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_REGION

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
            infoMsg 'ecr.sh->pushImageEcr: Ops, Erro em Autenticando no ECR. Tentando novamente !!!'
            keepGoing=$((keepGoing + 1))
            sleep 20 # Espera 20 segundos
        else
            infoMsg 'ecr.sh->pushImageEcr: Conectado com sucesso na tentativa '$keepGoing' !!!'
            keepGoing=99
        fi

        if [ $keepGoing -eq 5 ]; then
            errorMsg 'ecr.sh->pushImageEcr: Nao foi possivel autenticar no registry '$awsAccountID'.dkr.ecr.'$awsRegion'.amazonaws.com. Veja a msg de erro acima.'
            exit 1
        fi

    done

    infoMsg 'ecr.sh->pushImageEcr: Sucesso em se conectar no ECR'

}

# /**
# * validParameters
# * Método valida parametros obrigatorios
# * @version $VERSION
# * @package DevOps
# * @author  Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
validParameters () {
    
    resp=''

    infoMsg 'ecr.sh : Iniciando validacoes de parametros para o ecr.'

    infoMsg 'ecr.sh : app-name: '$applicationName
    infoMsg 'ecr.sh : version: '$version
    infoMsg 'ecr.sh : aws-account-id: '$awsAccountID
    infoMsg 'ecr.sh : safe: '$cyberarkSafe
    infoMsg 'ecr.sh : iam-user: '$iamUser

	if [ "$cyberarkSafe" == "" ];then
        errorMsg 'ecr.sh : E necessario informar o nome do safe do Cyberark. Exemplo: --cyberark-safe=USCLD_PAWS_18'
        exit 1
    fi

    if [ "$iamUser" == "" ];then
        errorMsg 'ecr.sh : E necessario informar o nome da conta. Exemplo: --iam-user=BUUserFor'
        exit 1
    fi

    if [ "$awsAccountID" == "" ];then
        errorMsg 'ecr.sh : E necessario informar o ID da conta AWS. Exemplo: --aws-account-id=187739130313'
        exit 1
    fi

    if [ "$awsRegion" == "" ];then
        errorMsg 'ecr.sh : E necessario informar a regiao da conta AWS. Exemplo: --aws-region=sa-east-1'
        exit 1
    fi

}

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opções passadas

while true ; do
    case "$1" in
        --application-name)
            case "$2" in
               "") shift 2 ;;
                *) applicationName="$2" ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) version="$2" ; shift 2 ;;
            esac ;;
        --cyberark-safe)
            case "$2" in
               "") shift 2 ;;
                *) cyberarkSafe="$2" ; shift 2 ;;
            esac ;;
        --iam-user)
            case "$2" in
               "") shift 2 ;;
                *) iamUser="$2" ; shift 2 ;;
            esac ;;
        --aws-account-id)
            case "$2" in
               "") shift 2 ;;
                *) awsAccountID="$2" ; shift 2 ;;
            esac ;;
        --aws-region)
            case "$2" in
               "") shift 2 ;;
                *) awsRegion="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

validParameters
pushImageEcr
