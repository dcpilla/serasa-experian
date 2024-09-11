#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           helmLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as chamadas para deploy no helm
# * @copyright      2021 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         Biblioteca com as chamadas para deploy no helm
# * @copyright      2022 &copy Serasa Experian
# * @author         Diego Alves Dias L. <diego.adias@br.experian.com>
# * @dependencies   common.sh              
# * @date           29-Mar-2022
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

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=''

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=''

# /**
# * clusterName
# * Nome do cluster EKS
# * @var string
# */
clusterName=''
# /**
# * gearrId
# * Gearr ID da aplicacao. Sera adicionada como tag
# * @var string
# */
gearrID=''

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
# * environment
# * Ambiente para deploy utilizando o artefato
# * @var string
# */
environment=''

# /**
# * awsAccountID
# * ID da Conta AWS onde serah registrada a imagem da app no ECR e o pacote do Charts
# * @var string
# */
awsAccountID=''

# /**
# * awsRegion
# * Regiao AWS dos recursos que serao utilizados para registro dos artefatos e deploy no EKS
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
# * urlChartsRepo
# * URL do repositorio para o Helm Charts (S3, ECR)
# * @var string
# */
urlChartsRepo=''

# /**
# * artifact
# * 
# * @var string
# */
artifact=''

# /**
# * chartRepo
# * URL completa para registrar os charts da aplicacao. Usada para separar o chart por ambiente.
# *  Construido no padrao $urlChartsRepo'/'$environment
# * @var string
# */
chartRepo=''

# /**
# * repoAlias
# * Alias do repo para registro local. Construido no padrão $applicationName'-'$environment
# * @var string
# */
repoAlias=''


# /**
# * getConfigRepo
# * Método que baixa o repositorio de configuracao da aplicacao
# * @package DevOps
# * @author  Diego Alves Dias <diego.adias@br.serasa.com>
# * @param   
# * @return  true / false
# */
getConfigRepo (){
	
	if [ "$configRepo" != "local" ];then
	
		if [ "$configRepoVersion" == "latest" ];then
			infoMsg 'helmLib.sh->getConfigRepo: Versao do repositorio de configuracao informada: LATEST, localizando release mais recente disponivel'
			configRepoVersion=$(git ls-remote --tags --exit-code --refs $configRepo | sed -E 's/^[[:xdigit:]]+[[:space:]]+refs\/tags\/(.+)/\1/g' | tail -n1)
		fi

		infoMsg 'helmLib.sh->getConfigRepo: Baixando as configuracao da aplicacao no repositorio '$configRepo' na versao '$configRepoVersion
		git clone -b $configRepoVersion $configRepo build/config
		if [ "$?" -ne 0 ]; then
			errorMsg 'helmLib.sh->getConfigRepo: Nao foi possivel clonar o repositorio '$configRepo' na versao '$configRepoVersion
			exit 1
		fi
		infoMsg 'helmLib.sh->getConfigRepo: Copiando os arquivos do repositorio'
		cp -r build/config/* build/$applicationName
		infoMsg 'helmLib.sh->getConfigRepo: Apagando pasta clonada'
		rm -rf build/config
	
	else
	
		infoMsg 'helmLib.sh->getConfigRepo: Copiando os arquivos locais no diretorio "kubernetes/helm" para o ambiente '$environment
		cp -r kubernetes/helm/$environment/* build/$applicationName
	
	fi
    
}

# /**
# * getChartTemplate
# * Método baixa o template na versão indicada
# * @version $VERSION
# * @package DevOps
# * @author  Diego Alves Dias <diego.adias@br.serasa.com>
# * @param   
# * @return  true / false
# */
getChartTemplate (){

    if [ "$helmTemplateVersion" == "latest" ];then
        infoMsg 'helmLib.sh->getChartTemplate: Versao de template informada: LATEST, localizando release mais recente disponivel'
        helmTemplateVersion=$(git ls-remote --tags --exit-code --refs ssh://git@code.experian.local/scib/hcharts-template-$helmTemplate.git | sed -E 's/^[[:xdigit:]]+[[:space:]]+refs\/tags\/(.+)/\1/g' | tail -n1)
    fi

    infoMsg 'helmLib.sh->getChartTemplate: Baixando o template '$helmTemplate' na versao '$helmTemplateVersion
    git clone -b $helmTemplateVersion ssh://git@code.experian.local/scib/hcharts-template-$helmTemplate.git
    if [ "$?" -ne 0 ]; then
        errorMsg 'helmLib.sh->getChartTemplate: Nao foi possivel clonar o repositorio ssh://git@code.experian.local/scib/hcharts-template-'$helmTemplate'.git na versao '$helmTemplateVersion' '
        exit 1
    fi
    infoMsg 'helmLib.sh->getChartTemplate: Copiando os arquivos de template'
    cp -r hcharts-template-$helmTemplate/hchart-$helmTemplate/* build/$applicationName
    cp -r hcharts-template-$helmTemplate/conftest.sh build/$applicationName/conftest.sh
    infoMsg 'helmLib.sh->getChartTemplate: Apagando pasta clonada'
    rm -rf hcharts-template-$helmTemplate
}

# /**
# * replaceParameters
# * Método de processamento de parametros para o template
# * @version $VERSION
# * @package DevOps
# * @author  Diego Alves Dias <diego.adias@br.serasa.com>
# * @param   
# * @return  true / false
# */
replaceParameters (){

    infoMsg 'helmLib.sh->replaceParameters: Iniciando processamento dos arquivos de configuracao'
    export app_name="$applicationName"
    export cluster_name="$clusterName"
    export version="$version"
    export gearr_id="$gearrID"
    export environment="$environment"
    export aws_region="$awsRegion"
    export aws_account_id="$awsAccountID"

    infoMsg 'helmLib.sh->replaceParameters: Processando Chart.yaml'
    ( echo "cat <<EOF >build/Chart2.yml";
     cat build/$applicationName/Chart.yaml;
    echo "EOF";
    ) >temp.yml
    . temp.yml

    rm temp.yml

    infoMsg 'helmLib.sh->replaceParameters: Processando values.yaml'
    ( echo "cat <<EOF >build/values2.yml";
    cat build/$applicationName/values.yaml;
    echo "EOF";
    ) >temp.yml
    . temp.yml

    rm temp.yml

    cp build/Chart2.yml build/$applicationName/Chart.yaml
    cp build/values2.yml build/$applicationName/values.yaml

    infoMsg 'helmLib.sh->replaceParameters: Validation configs with conftest'
    bash build/$applicationName/conftest.sh $applicationName $environment
    
    rm build/Chart2.yml
    rm build/values2.yml
}


# /**
# * helmBuildCharts
# * Método que gera o charts da aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Diego Alves Dias <diego.adias@br.serasa.com>
# * @param   
# * @return  true / false
# */
helmBuildCharts (){

    infoMsg 'helmLib.sh->helmBuildCharts: Iniciando build do charts'

    test ! -z $1 || { errorMsg 'helmLib.sh->deploymentsEks: Nome da aplicacao nao informada' ; exit 1; }
    test ! -z $2 || { errorMsg 'helmLib.sh->deploymentsEks: Versao da API nao informada' ; exit 1; }
    test ! -z $3 || { errorMsg 'helmLib.sh->deploymentsEks: Repositório de configuração não informado' ; exit 1; }

    applicationName=$1
    version=$2
    configRepo=$3
    configRepoVersion=$4
    helmTemplate=$5
    helmTemplateVersion=$6
    environment=$7
    gearrID=$8
    tribe=$9
    squad=${10}
    safe=${11}
    iamUser=${12}
    awsAccount=${13}


    # Resgatando credenciais no Cyberark Dap
    credentials=$(cyberArkDap -s "$safe" -c "$iamUser" -a "$awsAccount")

    if [ -z "$credentials" ]; then
        errorMsg "eksLib.sh->helmBuildCharts: Falha ao recuperar credenciais do cofre: $safe"
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

    mkdir -p build/$applicationName

    # Método baixa o template na versão indicada
    getChartTemplate

    # Método que baixa o repositório de configuração da aplicação
    getConfigRepo 

    # Método de processamento de parametros para o template
    replaceParameters

    result=$(helm package build/$applicationName --version $version --app-version $version -d build)
    packageName=$(echo $result | cut -d' ' -f8)
    echo $packageName
}

# /**
# * helmRegisterChartsS3
# * Método que registra o Charts no S3
# * @version $VERSION
# * @package DevOps
# * @author  Diego Alves Dias <diego.adias@br.serasa.com>
# * @param   
# * @return  true / false
# */
helmRegisterChartsS3 (){

    tribe=$1
    squad=$2
    safe=$3
    iamUser=$4
    awsAccount=$5
    urlChartsRepo=$6 
    applicationName=$7
    environment=$8
    awsRegion=$9

    chartRepo=$urlChartsRepo'/'$environment
    repoAlias=$applicationName'-'$environment
    artifact=build/$applicationName-$version.tgz

    # Resgatando credenciais no Cyberark Dap
    credentials=$(cyberArkDap -s "$safe" -c "$iamUser" -a "$awsAccount")

    if [ -z "$credentials" ]; then
        errorMsg "eksLib.sh->helmRegisterChartsS3: Falha ao recuperar credenciais do cofre: $safe"
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

    infoMsg 'helmLib.sh->helmRegisterChartsS3: Inicializando o repositorio '$chartRepo' '
    helm s3 init --force $chartRepo
    if [ "$?" -ne 0 ]; then
        errorMsg 'helmLib.sh->helmRegisterChartsS3: Nao foi possivel inicializar o repositorio.'
        exit 1
    fi

    infoMsg 'helmLib.sh->helmRegisterChartsS3: Adicionando o repositorio '$chartRepo' como o alias '$repoAlias' '
    helm repo add --force-update $repoAlias $chartRepo
    if [ "$?" -ne 0 ]; then
        errorMsg 'helmLib.sh->helmRegisterChartsS3: Nao foi possivel adicionar o repositorio.'
        exit 1
    fi

    infoMsg 'helmLib.sh->helmRegisterChartsS3: Carregando o chart '$artifact' no repositorio Helm '$repoAlias' no Amazon S3 ('$chartRepo')'
    helm s3 push --force $artifact $repoAlias
    if [ "$?" -ne 0 ]; then
        errorMsg 'helmLib.sh->helmRegisterChartsS3: Falha no envio do chart '$artifact' para '$chartRepo'. Veja mensagem de erro acima'
        exit 1
    fi
    infoMsg 'helmLib.sh : Sucesso no registro do charts em '$chartRepo' \o/'

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_REGION

}

# /**
# * appExists
# * Método que verifica se jah tem uma versao da aplicacao implantada no EKS
# * @version $VERSION
# * @package DevOps
# * @author  Gleise Teixeira <gleise.teixeira@br.serasa.com>
# * @param   
# * @return  true / false
# */
appExists (){
    kubectl -n $project describe deployment $applicationName
    if [ "$?" -ne 0 ]; then
        return 1
    else
        return 0
    fi
}

# /**
# * verifyNamespace
# * Método que verifica se o namespace jah existe no EKS e se nao existe o cria
# * @version $VERSION
# * @package DevOps
# * @author  Gleise Teixeira <gleise.teixeira@br.serasa.com>
# * @param   
# * @return  true / false
# */
verifyNamespace (){

    infoMsg 'helmLib.sh->verifyNamespace: Verificando o namespace '$project
    kubectl get ns $project || (kubectl create ns $project && kubectl label ns $project istio-injection=enabled --overwrite)
    if [ "$?" -ne 0 ]; then
        errorMsg 'helmLib.sh->verifyNamespace: Falha na checagem/criacao do namespace '$project
        exit 1
    fi
}

# /**
# * helmInstallCharts
# * Método faz a instalacao do charts no EKS
# * @version $VERSION
# * @package DevOps
# * @author  Gleise Teixeira <gleise.teixeira@br.serasa.com>
# * @param   
# * @return  true / false
# */
helmInstallCharts() {

    repoAlias=$applicationName'-'$environment

    infoMsg 'helmLib.sh->helmInstallCharts: Iniciando a instalacao da app '$applicationName', na versao '$version', do ambiente '$environment', no namespace '$project

    keepGoing=1

    while [ $keepGoing -le 2 ]; do # Tentando 2 vezes

        if [ "$clusterName" != "" ]; then
            helm upgrade --install --atomic --timeout 10m $applicationName $repoAlias'/'$applicationName --namespace $project --version $version --set deployment.cluster=$clusterName
        else
            helm upgrade --install --atomic --timeout 10m $applicationName $repoAlias'/'$applicationName --namespace $project --version $version
        fi
        
        if [ "$?" -ne 0 ]; then
            infoMsg 'helmLib.sh->helmInstallCharts: Falha na instalacao da app '$applicationName' no namespace '$project', tentando novamente !!!'
            keepGoing=$((keepGoing + 1))
            sleep 10 # Espera 10 segundos
        else
            infoMsg 'helmLib.sh->helmInstallCharts: Finalizado na tentativa '$keepGoing' da app '$applicationName' no namespace '$project
            keepGoing=99
        fi

        if [ $keepGoing -eq 2 ]; then
            if [ "$clusterName" != "" ]; then
                helm upgrade --install --atomic --timeout 10s $applicationName $repoAlias'/'$applicationName --namespace $project --version $version --set deployment.cluster=$clusterName --debug
            else
                helm upgrade --install --atomic --timeout 10s $applicationName $repoAlias'/'$applicationName --namespace $project --version $version --debug
            fi

            errorMsg 'helmLib.sh->helmInstallCharts: Falha na instalacao da app '$applicationName' no namespace '$project'. Veja a msg de erro acima'
            exit 1
        fi

    done

}

# /**
# * helmDeployCharts
# * Método faz o deploy da aplicacao no namespace do projeto
# * @version $VERSION
# * @package DevOps
# * @author  Gleise Teixeira <gleise.teixeira@br.serasa.com>
# * @param   
# * @return  true / false
# */
helmDeployCharts () {
    
    tribe=$1
    project=$2 
    applicationName=$3
    version=$4
    environment=$5
    squad=$6
    safe=$7
    iamUser=$8
    awsAccount=$9
    clusterName=${10}
    awsRegion=${11}
    
    # Resgatando credenciais no Cyberark Dap
    credentials=$(cyberArkDap -s "$safe" -c "$iamUser" -a "$awsAccount")

    if [ -z "$credentials" ]; then
        errorMsg "helmLib.sh->helmDeployCharts: Falha ao recuperar credenciais do cofre: $safe"
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

    aws eks update-kubeconfig --name $clusterName --kubeconfig $HOME'/.kube/kubeconfig-'$awsAccountID

    export KUBECONFIG=$HOME'/.kube/kubeconfig-'$awsAccountID

    repoAlias=$applicationName'-'$environment

    infoMsg 'helmLib.sh->helmDeployCharts: Iniciando o deploy da app '$applicationName', na versao '$version', do ambiente '$environment', no namespace '$project

    verifyNamespace
    
    helmInstallCharts

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_REGION
    unset KUBECONFIG

    rm -rf $HOME'/.kube/kubeconfig-'$awsAccountID

}
