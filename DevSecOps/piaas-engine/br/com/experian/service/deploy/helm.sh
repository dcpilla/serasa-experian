#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           helm.sh
# * @version        $VERSION
# * @description    Script que executa o processo de build e deploy com Helm Charts
# * @copyright      2022 &copy Serasa Experian
# *
# * @version        1.0.0
# * @description    Criacao da script
# * @copyright      2022 &copy Serasa Experian
# * @author         Gleise Teixeira <gleise.teixeira@br.experian.com>
# *                 Diego Alves Dias <diego.adias@br.experian.com>
# * @dependencies   common.sh
# *                 helmLib.sh
# * @date           29-Mar-2022
# *
# **/

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

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
VERSION='1.0.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o tuemirwj::h --long application-name::,target::,help,environment::,version::,project::,image::,parameters::,tribe::,gearr-id::,squad::,safe::,iamUser::,awsAccount::,vault::,config-repo::,config-repo-version::,url-charts-repo::,helm-template-version::,helm-template::,aws-region::,cluster-name:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * target
# * Local onde sera realizado o deploy
# * @var string
# */
target=''

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=

# /**
# * environment
# * Ambiente para deploy utilizando o artefato
# * @var string
# */
environment=''

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
# * awsRegion
# * Regiao AWS dos recursos que serao utilizados para registro dos artefatos e deploy no EKS
# * @var string
# */
awsRegion=''

# /**
# * gearrID
# * Gearr ID da aplicacao. Sera adicionada como tag
# * @var string
# */
gearrID=''

# /**
# * project
# * Define o projeto de deploy
# * @var string
# */
project=''

# /**
# * image
# * Define a imagem do conteiner
# * @var string
# */
image=''

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=

# /**
# * parameters
# * Define os parametros para configuracao do charts
# * @var string
# */
parameters=''

# /**
# * urlChartsRepo
# * URL do repositorio para o Helm Charts (S3, ECR)
# * @var string
# */
urlChartsRepo=''

# /**
# * configRepo
# * Repositorio de configuracao de deploy da app
# * @var string
# */
configRepo=''

# /**
# * configRepoVersion
# * Versao do repositorio de configuracao de deploy da app
# * @var string
# */
configRepoVersion=''

# /**
# * helmTemplate
# * Nome do template Helm Charts que serah utilizado
# * @var string
# */
helmTemplate=''

# /**
# * helmTemplateVersion
# * Versao do template Helm Charts que serah utilizado.
# * @var string
# */
helmTemplateVersion=''



# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "helm.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2022 Serasa Experian"
    echo ""
    echo -e "helm.sh script responsavel pelas funcoes de build e deploy de Helm Charts nos diversos ambientes onde podemos usar esse tipo de pacote. Parametrizando como o mesmo irah ocorrer. Sendo independente de vendor e de facil implantacao de outros que possam surgir.\n"

    echo -e "Usage: helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --aws-region=sa-east-1 --aws-profile=NikeArchitecture --helm-template=stateless --helm-template-version=v1.0.0 --config-repo=https://code.experian.local/scm/edvp/test-gleise-api-config.git
    or helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --aws-region=sa-east-1 --aws-profile=NikeArchitecture --helm-template=stateless --helm-template-version=v1.0.0 --config-repo=https://code.experian.local/scm/edvp/test-gleise-api-config.git --config-repo-version=v1.0.0 --environment=stg
    or helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --image=app-image-name:test --url-charts-repo=s3://my-helm-charts/charts --aws-region=sa-east-1 --aws-profile=NikeArchitecture --helm-template=stateless --helm-template-version=v1.0.0 --config-repo=https://code.experian.local/scm/edvp/test-gleise-api-config.git --environment=stg
    or helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --tribe=nike --squad=accelerators --safe=aws --iamUser=BURoleForTest --awsAccount=123454 --helm-template=stateless --helm-template-version=v1.0.0 --config-repo=https://code.experian.local/scm/edvp/test-gleise-api-config.git parameters='a=5 b=3'\n
	or helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --tribe=nike --squad=accelerators --safe=aws --iamUser=BURoleForTest --awsAccount=123454
    or helm.sh --target=s3 --project=projeto-teste --application-name=app-name --version=v1.0.0 --url-charts-repo=s3://my-helm-charts/charts --tribe=nike --squad=accelerators --safe=aws --iamUser=BURoleForTest --awsAccount=123454 --cluster-name=ABCDEF"
    echo -e "Options
    --application-name          Nome da aplicacao 
    --tribe                     Nome da tribe responsavel pela aplicacao
    --squad                     Nome da squad responsavel pela aplicacao
    --safe                      Nome do cofre
    --iamUser                  Nome do IAM user
    --awsAccount               ID da conta AWS
    --aws-region                Regiao AWS dos recursos que serao utilizados para registro dos artefatos e deploy no EKS 
    --gearr-id                  Gearr ID da aplicacao
    --e, --environment          Ambiente para deploy utilizando o artefato [de|deeid|hi|hieid|he|pi|pe|peeid|develop|qa|master]
    --image                     Imagem do conteiner
    --project                   Nome do projeto/namespace para ser realizado o deploy
    --t, --target               Destino para registro de charts. Disponiveis: s3
    --parameters                Parametros para configuracao do charts
    --version                   Versao da aplicacao
    --config-repo               Repositorio de configuracao de deploy da aplicacao
    --config-repo-version       Versao do repositorio de configuracao de deploy da aplicacao
    --url-charts-repo           URL do repositorio para o Helm Charts (S3, ECR) 
    --helm-template             Nome do template Helm Charts que serah utilizado [stateless]
    --helm-template-version     Versao do template Helm Charts que serah utilizado
    --cluster-name              Nome do cluster onde serah feito o deploy
    --h, --help                 Ajuda"

    exit 1
}

# /**
# * validParameters
# * Método valida parametros obrigatorios
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validParameters () {
    resp=''

    infoMsg 'helm.sh : Iniciando validacoes de parametros de helm para '${target}' '

    # Validações de destino
    if [ ${#target} -lt 1 ]; then
        errorMsg 'helm.sh : Opcao --target nao informada impossivel prosseguir. Consulte helm.sh --help para se informar de destinos disponiveis para registro de charts'
        exit 1
    fi

    if [ "$environment" == "" ];then
        errorMsg 'helm.sh : Para o registro do Charts eh necessario informar o ambiente. Exemplo: --environment=qa'
        exit 1
    fi

    if [ "$project" == "" ];then
        errorMsg 'helm.sh : Para o registro do Charts eh necessario informar o projeto (eks namespace). Exemplo: --project=project-namespace'
        exit 1
    fi

    if [ "$applicationName" == "" ];then
        errorMsg 'helm.sh : Para o registro do Charts eh necessario informar o nome da aplicacao. Exemplo: --application-name=app-name'
        exit 1
    fi

    if [ "$version" == "" ];then
        errorMsg 'helm.sh : Para o registro do Charts eh necessario informar a versao da aplicacao. Exemplo: --version=1.2.0'
        exit 1
    fi

    if [ "$urlChartsRepo" == "" ];then
        errorMsg 'helm.sh : Para o registro do Charts eh necessario informar a URL do recurso onde serah registrado o artefato. Exemplo: --url-charts-repo=s3://my-helm-charts/charts'
        exit 1
    fi

	if [ "$configRepo" != "" ];then
        infoMsg 'helm.sh : Repositorio de configuracao da aplicacao definido para: '${configRepo}' '
    else
        warnMsg 'helm.sh : Nao foi informado um repositorio de configuracao. Serao utilizadas as configuracoes locais no diretorio: kubernetes/helm/'${environment}' '
        configRepo="local"
    fi

    if [ "$configRepoVersion" != "" ];then
        infoMsg 'helm.sh : Versao do repositorio de configuracao da aplicacao definida para: '${configRepoVersion}' '
    else
        warnMsg 'helm.sh : Nao foi informada uma versao para o repositorio de configuracao. A versao do repositorio de configuracao serah definida como: latest'
        configRepoVersion="latest"
    fi

    if [ "$helmTemplate" != "" ];then
        infoMsg 'helm.sh : Template definido para o charts: '${helmTemplate}' '
    else
        warnMsg 'helm.sh : Nao foi informado um template para este charts. O template serah definido como: stateless'
        helmTemplate="stateless"
    fi

    if [ "$helmTemplateVersion" != "" ];then
        infoMsg 'helm.sh : Versao do template definida para o charts: '${helmTemplateVersion}' '
    else
        warnMsg 'helm.sh : Nao foi informada uma versao de template para este charts. A versao do template serah definida como: latest'
        helmTemplateVersion="latest"
    fi

    if [ "$parameters" != "" ]; then
        infoMsg 'helm.sh : Parametros definidos para o charts: '${parameters}' '
    else
        warnMsg 'helm.sh : Nenhum parametro foi definido para este charts.'
        parameters=""
    fi

    if [ "$tribe" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome da tribe. Exemplo: --tribe=nike'
        exit 1
    fi

    if [ "$squad" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome da squad. Exemplo: --squad=accelerators'
        exit 1
    fi

    if [ "$safe" == "" ] && [ "$vault" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome do cofre. Exemplo: --safe=aws ou --vault=aws'
        exit 1
    fi

    if [[ -n "$gearrID" && "$gearrID" != [] ]]; then
        infoMsg 'helm.sh : GEARR ID definido para o charts: '${gearrID}' '
    else
        warnMsg 'helm.sh : Nao foi informado um GEARR ID para este charts. A tag gearr serah definida como: unknown'
        gearrID="unknown"
    fi
    if [ "$clusterName" != "" ];then
        infoMsg 'helm.sh : Nome do Cluster definido para o charts: '${clusterName}' '
    else
        warnMsg 'helm.sh : Nao foi informado o nome do Cluster para este charts.'
    fi 

}

# /**
# * validTargetS3
# * Método valida quando destino for S3
# * @version 1.0.0
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.experian dot com>
# */
validTargetS3 () {

    if [ "$safe" == "null" ] && [ "$vault" == "null" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome do cofre. Exemplo: --safe=aws ou --vault=aws'
        exit 1
    fi

    if [ "$awsRegion" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar a regiao AWS do Repositorio ECR. Exemplo: --aws-region=sa-east-1'
        exit 1
    fi

}

# /**
# * buildCharts
# * Método prepara parametros para executar o build do charts
# * @version 1.0.0
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.experian dot com>
# */
buildCharts () {

    helmBuildCharts $applicationName $version $configRepo $configRepoVersion $helmTemplate $helmTemplateVersion $environment $gearrID $tribe $squad $safe $iamUser $awsAccount $vault
    
}

# /**
# * registerCharts
# * Método para envio do charts ao repositório no S3
# * @version 1.0.0
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.experian dot com>
# */
registerCharts () {

    helmRegisterChartsS3 $tribe $squad $safe $iamUser $awsAccount $urlChartsRepo $applicationName $environment $awsRegion $vault
    
}

clearEnv (){
    rm -rf build
}


# /**
# * Start
# */

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
        -e|--environment)
            case "$2" in
               "") shift 2 ;;
                *) environment=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -t|--target)
            case "$2" in
               "") shift 2 ;;
                *) target=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --project)
            case "$2" in
               "") shift 2 ;;
                *) project="$2" ; shift 2 ;;
            esac ;;
        --image)
            case "$2" in
               "") shift 2 ;;
                *) image="$2" ; shift 2 ;;
            esac ;;
        --parameters)
            case "$2" in
               "") shift 2 ;;
                *) parameters="$2" ; shift 2 ;;
            esac ;;
        --version)
            case "$2" in
               "") shift 2 ;;
                *) version="$2" ; shift 2 ;;
            esac ;;
        --tribe)
            case "$2" in
               "") shift 2 ;;
                *) tribe="$2" ; shift 2 ;;
            esac ;;
        --gearr-id)
            case "$2" in
               "") shift 2 ;;
                *) gearrID="$2" ; shift 2 ;;
            esac ;;
        --squad)
            case "$2" in
               "") shift 2 ;;
                *) squad="$2" ; shift 2 ;;
            esac ;;
        --vault)
            case "$2" in
               "") shift 2 ;;
                *) vault="$2" ; shift 2 ;;
            esac ;;
        --safe)
            case "$2" in
               "") shift 2 ;;
                *) safe="$2" ; shift 2 ;;
            esac ;;
        --iamUser)
            case "$2" in
               "") shift 2 ;;
                *) iamUser="$2" ; shift 2 ;;
            esac ;;
        --awsAccount)
            case "$2" in
               "") shift 2 ;;
                *) awsAccount="$2" ; shift 2 ;;
            esac ;;
        --aws-region)
            case "$2" in
               "") shift 2 ;;
                *) awsRegion="$2" ; shift 2 ;;
            esac ;;
        --config-repo)
            case "$2" in
               "") shift 2 ;;
                *) configRepo="$2" ; shift 2 ;;
            esac ;;
        --config-repo-version)
            case "$2" in
               "") shift 2 ;;
                *) configRepoVersion="$2" ; shift 2 ;;
            esac ;;
        --url-charts-repo)
            case "$2" in
               "") shift 2 ;;
                *) urlChartsRepo="$2" ; shift 2 ;;
            esac ;;
        --helm-template)
            case "$2" in
               "") shift 2 ;;
                *) helmTemplate="$2" ; shift 2 ;;
            esac ;;
        --helm-template-version)
            case "$2" in
               "") shift 2 ;;
                *) helmTemplateVersion="$2" ; shift 2 ;;
            esac ;;
        --cluster-name)
            case "$2" in
               "") shift 2 ;;
                *) clusterName="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Valida parametros obrigatorios
validParameters

# Executa acoes lidas de helm
case $target in
    s3)
        validTargetS3
        #setProxy
        infoMsg 'helm.sh : Executando o build e registro do charts em '${target}''
        infoMsg 'helm.sh : Ambiente que serah configurado para deploy '${environment}''

        buildCharts
        registerCharts
	    clearEnv
    ;;
    ecr)
        echo "Calma estamos implementando :)"
        infoMsg 'helm.sh : Sucesso no deploy \o/'    ;;
    *)
        errorMsg 'helm.sh : Destino de deploy '${target}' ainda nao implementado :('
        exit 1
    ;;
esac