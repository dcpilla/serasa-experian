#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           deploy.sh
# * @version        $VERSION
# * @description    Script que faz diferentes tipos de deploy
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        8.4.0
# * @description    [FEATURE] Implementação de suporte da função de deploy para banco de dados;
# * @copyright      2022 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# *                 eksLib.sh
# *                 databaseLib.sh
# * @date           16-Set-2022
# *
# * @version        8.3.0
# * @description    [FEATURE] Suporte ao deploy no aws eks;
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# *                 eksLib.sh
# * @date           13-Dec-2021
# *
# * @version        8.2.0
# * @description    [FEATURE] Função de start/stop de api no openshift;
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           03-Dec-2021
# *
# * @version        8.1.0
# * @description    [FEATURE] Criacao da label 'tribe' no namespace sempre que o deploy é executado para contabilizar o consumo de recursos por tribe;
# * @copyright      2020 &copy Serasa Experian
# * @author         Renato M Thomazine <renato.thomazine@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           06-Jul-2020
#
# * @version        7.2.0
# * @change         [Feature] Suporte a promoção de images em deploy com openshift;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           28-May-2020
# *
# * @version        7.1.0
# * @change         [Feature] Suporte a deploy WAS via wsadmin para desativação do RA;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# *                 Thiago Costa <Thiago.Costa@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           09-Jan-2020
# *
# * @version        7.0.0
# * @change         [Feature] Suporte a deploy WAS via ansible para desativação do RA;
# *                 [Feature] Suportes a aws:
# *                           - lambda;
# *                           - terraform;
# * @copyright      2019 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           14-Out-2019
# *
# * @version        6.0.0
# * @change         [FEATURE] Definição de ambientes para deploy de job schedules com rundeck dev/qa/prod
# * @copyright      2019 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           07-Out-2019
# *
# * @version        5.9.0
# * @change         [Feature] Adicionado parametro --region-latam para tratar DevSecOps LATAM;
# *                 [Feature] Deploy de job schedule no rundeck;
# *                 [Feature] Deploy de aplicações no openshift por templates;
# * @copyright      2019 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# *                 rundeckLib.sh
# * @date           19-Jun-2019
# *
# * @version        5.8.0
# * @change         Feature:
# *                    - Implementação de deploy unico para WAS em dois ambientes he,hi;
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Joao aloia <joao.aloia@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# * @date           26-Fev-2019
# *
# * @version        5.7.0
# * @change         Feature:
# *                    - Implementação de deploy de batch;
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# * @date           14-Jan-2019
# * 
# * @version        5.6.0
# * @change         Feature:
# *                    - Implementação de deploy para banco de dados oracle/sqlserver;
# *                    - Implementação de deploy para hadoop;
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# *                 hadoopLib.sh
# * @date           03-Dez-2018
# *
# * @version        5.5.0
# * @change         Feature:
# *                    - Implementação da função playbook para o step install:
# *                    - Essa função irá disponibilizar para a SQUAD a aplicação de playbook's para infra as code para criação ou atualização dos serviços;
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# * @date           30-Jul-2018
# * 
# * @version        5.1.0
# * @change         Alterado biblioteca de manipulação de playbook ansible de towerLib.sh para ansibleLib.sh
# *                 para manter compatibilidade com awx e tower
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 ansibleLib.sh
# *                 openshiftLib.sh
# * @date           05-Jun-2018
# * 
# * @version        5.0.0
# * @change         Implementação funções para integraçao com openshift
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 towerLib.sh
# *                 openshiftLib.sh
# * @date           07-Maio-2018
# *
# * @version        4.0.0
# * @change         Implementação funções para integraçao com ansible tower
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# *                 towerLib.sh
# * @date           20-Abril-2018
# *
# * @version        3.1.0
# * @change         Implementação funções blue&green para WAS
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# * @date           15-Mar-2018
# *
# * @version        3.0.0
# * @description    Script que faz diferentes tipos de deploy
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# * @date           15-Jan-2018
# *
# * @version        1.0.0
# * @description    Script que faz diferentes tipos de deploy
# * @copyright      2017 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
# *                 Michel Miranda <Michel.Miranda@br.experian.com>
# * @dependencies   common.sh
# *                 wasLib.sh
# *                 raLib.sh
# *                 nexusLib.sh
# * @date           10-Out-2017
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


# Carrega raLib
test -e "$baseDir"/lib/raLib.sh || echo 'Ops, biblioteca raLib nao encontrada'
source "$baseDir"/lib/raLib.sh

# Carrega nexusLib
test -e "$baseDir"/br/com/experian/utils/nexusLib.sh || echo 'Ops, biblioteca nexusLib nao encontrada'
source "$baseDir"/br/com/experian/utils/nexusLib.sh

# Carrega ansibleLib
test -e "$baseDir"/br/com/experian/utils/ansibleLib.sh || echo 'Ops, biblioteca ansibleLib nao encontrada'
source "$baseDir"/br/com/experian/utils/ansibleLib.sh 

# Carrega openshiftLib
# test -e "$baseDir"/lib/openshiftLib.sh || echo 'Ops, biblioteca openshiftLib nao encontrada'
# source "$baseDir"/lib/openshiftLib.sh

# Carrega hadoopLib
# test -e "$baseDir"/lib/hadoopLib.sh || echo 'Ops, biblioteca hadoopLib nao encontrada'
# source "$baseDir"/lib/hadoopLib.sh

# Carrega outsystemLib
test -e "$baseDir"/lib/outsystemLib.sh || echo 'Ops, biblioteca outsystemLib nao encontrada'
source "$baseDir"/lib/outsystemLib.sh

# Carrega rundeckLib
# test -e "$baseDir"/lib/rundeckLib.sh || echo 'Ops, biblioteca rundeckLib nao encontrada'
# source "$baseDir"/lib/rundeckLib.sh

# Carrega eksLib
test -e "$baseDir"/br/com/experian/utils/eksLib.sh || echo 'Ops, biblioteca eksLib nao encontrada'
source "$baseDir"/br/com/experian/utils/eksLib.sh

# Carrega helmLib
test -e "$baseDir"/br/com/experian/utils/helmLib.sh || echo 'Ops, biblioteca helmLib nao encontrada'
source "$baseDir"/br/com/experian/utils/helmLib.sh

# Carrega databaseLib
test -e "$baseDir"/lib/databaseLib.sh || echo 'Ops, biblioteca databaseLib nao encontrada'
source "$baseDir"/lib/databaseLib.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='8.4.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o tuemirwj::h --long application-name::,target::,url-package::,help,environment::,version::,method::,instance-name::,ra-job::,workflow-id::,runin::,project::,path-package::,image::,extensao::,token::,job-id::,extra-vars::,parameters::,no-route::,no-service::,no-delete-image::,region-latam::,promotion-src::,promotion-dst::,tribe::,s3-trigger::,squad::,safe::,iamUser::,awsAccount::,cluster-name::,aws-region::,vault:: -n "$0" -- "$@"`
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
# * urlPackage
# * Url pacote para o deploy
# * @var string
# */
urlPackage=''

# /**
# * pathPackage
# * Caminho do pacote para o deploy
# * @var string
# */
pathPackage=''

# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=''

# /**
# * regionLatam
# * Regiao LATAM para DevSecOps
# * @var string
# */
regionLatam=''

# /**
# * parameters
# * Parametros para o deploy
# * @var string
# */
parameters=''

# /**
# * noRoute
# * Ignorar criacao de rotas no deploy no openshift
# * @var string
# */
noRoute='false'

# /**
# * noDeleteImage
# * Ignorar delete de conteiner no deploy
# * @var string
# */
noDeleteImage='false'

# /**
# * noService
# * Ignorar criacao de servico no deploy no openshift
# * @var string
# */
noService='false'

# /**
# * s3Trigger
# * Define criação de trigger no s3 para lambda
# * @var string
# */
s3Trigger='false'

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
# * safe
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
# * promotionSrc
# * Origem de promoção da imagem para deploy com openshift
# * @var string
# */
promotionSrc=''

# /**
# * promotionDst
# * Destino de promoção da imagem para deploy com openshift
# * @var string
# */
promotionDst=''

# /**
# * method
# * Define metodo de deploy
# * @var string
# */
method=''

# /**
# * project
# * Define o projeto de deploy
# * @var string
# */
project=''


# /**
# * runin
# * Define o executor de deploy ansible
# * @var string
# */
runin=''

# /**
# * token
# * Define o token de conecção
# * @var string
# */
token=''

# /**
# * image
# * Define a imagem do conteiner
# * @var string
# */
image=''

# /**
# * extensao
# * Define a extenção do arquivo para deploy
# * @var string
# */
extensao=''

# /**
# * instanceName
# * Nome da instancia a ser ser feito o deploy
# * @var string
# */
instanceName=''

# /**
# * raJob
# * Define o nome do job do RA para executar
# * @var string
# */
raJob=''

# /**
# * typeExecution
# * Define o tipo de execução no ansible
# * @var string
# */
typeExecution=''

# /**
# * workflowId
# * Define o id do workflow para usar no deploy
# * @var int
# */
workflowId=0

# /**
# * jobId
# * Define o id do job para usar no deploy
# * @var int
# */
jobId=0

# /**
# * version
# * Versao da aplicacao que sera submetida
# * @var string
# */
version=

# /**
# * extraVars
# * Define as variaveis extras de deploy
# * @var string
# */
extraVars=''

# /**
# * ecrRepo
# * Repositorio ECR onde serah salvo a imagem
# * @var string
# */
ecrRepo=''

# /**
# * clusterName
# * Nome do Cluster EKS
# * @var string
# */
clusterName=''

# /**
# * configRepo
# * Repositorio de configuracao de deploy da app
# * @var string
# */
configRepo=''

# /**
# * awsRegion
# * Regiao do ECR onde serah salvo a imagem
# * @var string
# */
awsRegion=''

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
usage () {
    echo "deploy.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2022 Serasa Experian"
    echo ""
    echo -e "deploy.sh script que explora as API's de diferentes ambientes para deploy. Parametrizando como o mesmo ira ocorrer. Sendo independente de vendor e de facil implantacao de outros que possam surgir.\n"

    echo -e "Usage: deploy.sh --target=was --url-package=url_pacote --environment=de
    or deploy.sh --target=was --method=provisioning --instance-name=sof5305_inc041290 --url-package=url_pacote --environment=hi
    or deploy.sh --target=was --ra-job=experian-relato-ear --url-package=url_pacote --environment=de
    or deploy.sh --target=was --method=normal --ra-job=experian-relato-ear --url-package=url_pacote --environment=de
    or deploy.sh --target=was --method=ansible --url-package=url_pacote --environment=de
    or deploy.sh --target=was --method=wsadmin --url-package=url_pacote --environment=de
    or deploy.sh --target=was --method=bluegreen --url-package=url_pacote
    or deploy.sh --target=iis --instance-name=server --url-package=url_pacote
    or deploy.sh --target=openshift --method=package --environment=qa --image=experian-sme-credit-services --project=eauth-identific --path-package=/tmp/ --extensao=jar
    or deploy.sh --target=openshift --method=container --project=sme-staging --environment=qa --version=1.0.0 --image=experian-sme-credit-services:latest 
    or deploy.sh --target=openshift --method=container --project=sme-staging --environment=develop --version=1.0.0 --image=experian-sme-credit-services:latest --no-route
    or deploy.sh --target=openshift --method=infra --image=eauth-identific --environment=develop --project=eauth-identific-develop --path-package=/path/da/infra
    or deploy.sh --target=openshift --method=template --image=mongo-express:latest --environment=develop --project=eauth-identific-develop --path-package=/path/da/infra --region-latam=colombia
    or deploy.sh --target=openshift --method=template --image=mongo-express:latest --environment=develop --project=eauth-identific-develop --path-package=/path/da/infra --region-latam=colombia --no-route
    or deploy.sh --target=openshift --method=discovery --project=eauth-identific-develop
    or deploy.sh --target=openshift --method=rollout --project=eauth-identific-develop --image=experian-sme-credit-services
    or deploy.sh --target=openshift --method=stopapi --project=eauth-identific-develop --image=experian-sme-credit-services
    or deploy.sh --target=openshift --method=startpapi --project=eauth-identific-develop --image=experian-sme-credit-services --extra-vars=NUMERO-DE-REPLICAS
    or deploy.sh --target=hadoop --application-name=nome-aplicacao --environment=develop --url-package=url_pacote --path-package=/path/do/deploy
    or deploy.sh --target=hadoop --application-name=nome-aplicacao --environment=develop --url-package=url_pacote
    or deploy.sh --target=hadoop --application-name=nome-aplicacao --environment=develop --url-package=url_pacote --no-service
    or deploy.sh --target=rundeck --project=Data_Strategy --application-name=experian-hadoop-s3 --path-package=/path/do/rundeck_file.yml --environment=[develop|qa|prod]
    or deploy.sh --target=outsystem --method=getapplications
    or deploy.sh --target=outsystem --method=getenvironmets
    or deploy.sh --target=aws --method=terraform
    or deploy.sh --target=aws --method=lambda
    or deploy.sh --target=aws --method=lambda --path-package=serverless.yml
    or deploy.sh --target=aws --method=lambda --s3-trigger
    or deploy.sh --target=aws --method=lambda_serverlessv3
    or deploy.sh --target=aws --method=lambda_serverlessv3 --path-package=serverless.yml
    or deploy.sh --target=aws --method=lambda_serverlessv3 --s3-trigger
    or deploy.sh --target=eks --tribe=nike --squad=accelerators --safe=aws --aws-region=sa-east-1 --project=project-namespace --application-name=app-name --version=1.2.0 --environment=qa --cluster-name=nike-eks-01-uat
    or deploy.sh --target=database --method=sqlserver --cluster-name=spobrserafat --project=serafat --safe=serafat-dev-safe --path-package=/path/do/deploy"

    echo -e "Options
    --application-name          Nome da aplicacao 
    --tribe                     Nome da tribe responsavel pela aplicacao
    --squad                     Nome da squad responsavel pela aplicacao
    --safe                      Nome do cofre
    --iamUser                   Nome do IAM user
    --awsAccount                ID da conta AWS
    --aws-region                Regiao AWS do repositorio ECR para registro da imagem para o EKS
    --cluster-name              Nome do Cluster EKS onde sera realizado o deploy   
    --e, --environment          Ambiente para deploy [de|deeid|hi|hieid|he|pi|pe|peeid|develop|qa|master]
    --extensao                  Extensao do pacote para ser feito o deploy
    --m, --method               Metodo de deploy a ser usado [normal|provisioning|bluegreen|package|ansible]
    --i,--instance-name         Nome da instancia a ser ser feito o deploy
    --r,--ra-job                Nome do job do RA para executar
    --u, --url-package          Pacote para deploy
    --w, --workflow-id          Id do workflow no ansible tower
    --j, --job-id               Id do job no ansible tower
    --extra-vars                Variaveis extras usadas para o deploy no ansible tower
    --path-package              Caminho do pacote para ser feito o deploy
    --image                     Imagem do conteiner
    --project                   Nome do projeto para ser realizado o deploy
    --t, --target               Destino para deploy. Disponiveis: was|iis|openshift|aws|tower|eks
    --token                     Token de conecção 
    --runin                     Executor ansible que irá ser chamado para deploy
                                Executores: tower
                                            tower-experian
                                            awx-midd
    --parameters                Parametros para o deploy                                       
    --version                   Versao da aplicacao
    --no-route                  Ignorar criacao de rotas no deploy no openshift
    --no-delete-image           Ignorar delecao da image do conteiner usado no deploy
    --no-service                Ignorar criacao de servico no deploy 
    --promotion-src             Origem da imagem para promocao de deploy no openshift  <projeto>/<aplicacao>:<TAG:SNAPHOT|RC|RELEASE>
    --promotion-dst             Destino da imagem para promocao de deploy no openshift <projeto>/<aplicacao>:<TAG:SNAPHOT|RC|RELEASE>
    --region-latam              Regiao LATAM para DevSecOps [ colombia | brazil ]
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

    infoMsg 'deploy.sh : Iniciando validacoes de parametros de deploy para '${target}' '

    # Validações de destino
    if [ ${#target} -lt 1 ]; then
        errorMsg 'deploy.sh : Opcao --target nao informada impossivel prosseguir. Consulte deploy.sh --help para se informar de destinos disponiveis de deploy'
        exit 1
    fi
}

# /**
# * validPackage
# * Método valida package informado
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validPackage () {
    # Validações de pacote
    if [ ${#urlPackage} -lt 1 ]; then
        errorMsg 'deploy.sh : Opcao --url-package nao informada impossivel prosseguir'
        exit 1
    fi

    resp=`getInfoPackage "statusPackage" "$urlPackage"`
    infoMsg 'deploy.sh: Retorno do status do pacote '${resp}' '
    if [ "$resp" == "200" ] || [ "$resp" == "307" ]; then
        infoMsg 'deploy.sh : Pacote '${urlPackage}' encontrado seguindo com o deploy'
    else
        errorMsg 'deploy.sh : Pacote informado '${urlPackage}' nao encontrado impossivel prosseguir'
        exit 1
    fi
}

# /**
# * validTargetWas
# * Método valida quando destino for was
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetWas () {
    # Validações de environment
    if [ "$environment" != "de" ] && \
       [ "$environment" != "hi" ] && \
       [ "$environment" != "he" ] && \
       [ "$environment" != "pi" ] && \
       [ "$environment" != "pe" ] && \
       [ "$environment" != "deeid" ] && \
       [ "$environment" != "hieid" ] && \
       [ "$environment" != "hi,he" ] && \
       [ "$environment" != "he,hi" ] && \
       [ "$environment" != "peeid" ] && \
       [ "$environment" != "pefree" ] && \
       [ "$environment" != "pehttps1" ] && \
       [ "$environment" != "pehttps3" ]&& \
       [ "$method" != "wsadmin" ]; then
           warnMsg 'deploy.sh : Metodo de deploy '${method}' invalido para omissao de ambientes'
           errorMsg 'deploy.sh : Ambiente '${environment}' para deploy invalido. Consulte deploy.sh --help para se informar de ambientes disponiveis de deploy'
           exit 1
    fi

    # Validações de metodo
    if [ "$method" == "" ]; then
        warnMsg 'deploy.sh : Metodo nao informado para deploy, considerando parametro como --method=wsadmin'
        method='wsadmin'
    fi
}

# /**
# * validTargetDatabase
# * Método valida quando destino for data base 
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetDatabase () {
    if [ "$method" == "" ]; then 
        errorMsg 'deploy.sh : Para o deploy de batase e necessario informar o method de deploy. Exemplo: --method=sqlserver'
        exit 1
    fi

    if [ "$pathPackage" == "" ]; then 
        errorMsg 'deploy.sh : Para o deploy de batase e necessario informar o path-package de deploy. Exemplo: --path-package=/tmp/xpto'
        exit 1
    fi

    if [ "$project" == "" ]; then 
        errorMsg 'deploy.sh : Para o deploy de batase e necessario informar o project de deploy. Exemplo: --project=serafat'
        exit 1
    fi

    if [ "$clusterName" == "" ]; then 
        errorMsg 'deploy.sh : Para o deploy de batase e necessario informar o cluster-name de deploy. Exemplo: --cluster-name=spobrserafat'
        exit 1
    fi

    if [ "$safe" == "" ]; then 
        errorMsg 'deploy.sh : Para o deploy de batase e necessario informar o safe de deploy. Exemplo: --safe=serafat-dev-safe'
        exit 1
    fi
}

# /**
# * validTargetHadoop
# * Método valida quando destino for hadoop
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetHadoop () {
    if [ "$applicationName" == "" ]; then
        errorMsg 'deploy.sh : Para o deploy no hadoop e necessario informar o nome da aplicacao. Exemplo: --application-name=experian-novajunta'
        exit 1
    fi

    if [ "$environment" == "" ]; then
        errorMsg 'deploy.sh : Ambiente '${environment}' para deploy no hadoop invalido. Disponiveis develop|qa|prod'
        exit 1
    fi

    if [ "$pathPackage" == "" ];then
        pathPackage="/opt/deploy/$applicationName/"
        infoMsg 'deploy.sh: O parametro --path-package nao foi usado, definindo caminho padrao de deploy '${pathPackage}' '
    fi
}

# /**
# * validTargetRundeck
# * Método valida quando destino for rundeck
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetRundeck () {
    if [ "$project" == "" ]; then
        errorMsg 'deploy.sh : Para o deploy no rundeck e necessario informar o nome do projeto. Exemplo: --project=Data_Strategy'
        exit 1
    fi

    if [ "$applicationName" == "" ]; then
        errorMsg 'deploy.sh : Para o deploy no rundeck e necessario informar o nome da aplicacao do projeto. Exemplo: --application-name=experian-hadoop-s3'
        exit 1
    fi

    if [ "$pathPackage" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no rundeck e necessario informar o arquivo para deploy. Exemplo: --path-package=/path/do/rundeck_file.yml'
        exit 1
    fi

    if [ "$environment" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no rundeck e necessario informar a environment de deploy. Exemplo: --environment=develop|qa|prod'
        exit 1
    fi

    if ! [[ -e "$pathPackage" ]]; then
        errorMsg 'deploy.sh : O arquivo '${pathPackage}' para deploy informado nao existe, impossivel prosseguir'
        exit 1
    fi
}

# /**
# * validTargetAws
# * Método valida quando destino for aws
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetAws () {
    if [ "$regionLatam" == "" ];then
        regionLatam='brasil'
    fi
}

# /**
# * validTargetOpenshift
# * Método valida quando destino for openshift
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validTargetOpenshift () {
    if [ "$method" != "package" ] && [ "$method" != "container" ] && [ "$method" != "infra" ] && [ "$method" != "template" ] && [ "$method" != "discovery" ] && [ "$method" != "rollout" ] && [ "$method" != "stopapi" ] && [ "$method" != "startpapi" ]; then
        errorMsg 'deploy.sh : Metodo informado '${method}' invalido informado para este destino de deploy '${target}'' 
        errorMsg 'deploy.sh : Metodos disponiveis para '${target}': --method=package | --method=container | --method=infra | --method=template | --method=discovery | --method=rollout | --method=stopapi | --method=startpapi'
        exit 1
    fi

    if  [ "$method" == "container" ] || [ "$method" == "package" ] || [ "$method" == "infra" ] || [ "$method" == "template" ] || [ "$method" == "discovery" ] || [ "$method" == "rollout" ] || [ "$method" == "stopapi" ] || [ "$method" == "startpapi" ] && [  "$project" == ""  ]; then
        errorMsg 'deploy.sh : O nome do projeto nao foi informado e neste metodo '${method}' para o target '${target}' e necessario. Ex.: --project=eauth-identific'
        exit 1
    fi

    if [ "$method" == "container" ] || [ "$method" == "package" ] || [ "$method" == "infra" ] || [ "$method" == "template" ] && [  "$image" == ""  ]  && [  "$environment" == ""  ]; then
        errorMsg 'deploy.sh : Para o metodo '${method}', sao necessarios os parametros --image  --environment sao necessarios'
        errorMsg '            Exemplo --image=application --environment=develop'
        exit 1
    fi

    if [ "$method" == "package" ] && [  "$extensao" == ""  ] && [ "$pathPackage" == "" ]; then
        errorMsg 'deploy.sh : Para o metodo '${method}', sao necessarios os parametros --project --path-package --extensao sao necessarios'
        errorMsg '            Exemplo --project=eauth-identific --path-package=/tmp/ --extensao=jar'
        exit 1
    fi

    if [ "$method" == "package" ];then
        local fileUpload=`ls -R ${pathPackage} | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'|grep ${extensao}|head -1`
        if ! [[ -e "$fileUpload" ]]; then
            errorMsg 'deploy.sh : Arquivo .'${extensao}' para o deploy nao existe em '${pathPackage}''
            exit 1
        else
            pathPackage=$fileUpload
        fi
    fi

    if [ "$regionLatam" == "" ];then
        regionLatam='brasil'
    fi

    if [ "$method" == "infra" ] || [ "$method" == "template" ];then
        if ! [[ -d "$pathPackage" ]]; then
            errorMsg 'deploy.sh : Impossivel continuar:'
            errorMsg 'deploy.sh : Diretorio de playbook para o deploy nao existe em '${pathPackage}''
            errorMsg 'deploy.sh : Informe um diretorio ou faca a criacao do mesmo'
            exit 1
        fi

        local qtdPlaybook=`ls ${pathPackage} |wc -l`
        if [ $qtdPlaybook -eq 0 ]; then
            errorMsg 'deploy.sh : Impossivel continuar:'
            errorMsg 'deploy.sh : Nao encontrado playbook para aplicar em '${pathPackage}''
            errorMsg 'deploy.sh : Faca a criacao dos mesmos'
            exit 1
        fi

        infoMsg 'deploy.sh : Playbook localizados iniciando deploy de '${method}''
    fi
}

# /**
# * validTargetEks
# * Método valida quando destino for eks
# * @version 1.0.0
# * @package DevOps
# * @author  gleise teixeira <gleise.teixeira at br.experian dot com>
# */
validTargetEks () {

    if [ "$environment" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o ambiente. Exemplo: --environment=qa'
        exit 1
    fi

    if [ "$project" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o projeto (eks namespace). Exemplo: --project=project-namespace'
        exit 1
    fi

    if [ "$applicationName" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome da aplicacao. Exemplo: --application-name=app-image:latest'
        exit 1
    fi

    if [ "$version" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar a versao da aplicacao. Exemplo: --version=1.2.0'
        exit 1
    fi

    if [ "$tribe" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome da tribe. Exemplo: --tribe=nike'
        exit 1
    fi

    if [ "$squad" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome da squad. Exemplo: --squad=accelerators'
        exit 1
    fi

    if [ "$safe" == "null" ] && [ "$vault" == "null" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome do cofre. Exemplo: --safe=aws ou --vault=aws'
        exit 1
    fi

    if [ "$clusterName" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar o nome do Cluster. Exemplo: --cluster-name=cluster-01'
        exit 1
    fi

     if [ "$awsRegion" == "" ];then
        errorMsg 'deploy.sh : Para o deploy no EKS e necessario informar a regiao AWS do Repositorio ECR. Exemplo: --aws-region=sa-east-1'
        exit 1
    fi

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
        -i|--instance-name)
            case "$2" in
               "") shift 2 ;;
                *) instanceName=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -m|--method)
            case "$2" in
               "") shift 2 ;;
                *) method=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -u|--url-package)
            case "$2" in
               "") shift 2 ;;
                *) urlPackage=$2 ; shift 2 ;;
            esac ;;
        -t|--target)
            case "$2" in
               "") shift 2 ;;
                *) target=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -w|--workflow-id)
            case "$2" in
               "") shift 2 ;;
                *) workflowId=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -j|--job-id)
            case "$2" in
               "") shift 2 ;;
                *) jobId=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --extra-vars)
            case "$2" in
               "") shift 2 ;;
                *) extraVars="$2" ; shift 2 ;;
            esac ;;
        --runin)
            case "$2" in
               "") shift 2 ;;
                *) runin=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        --project)
            case "$2" in
               "") shift 2 ;;
                *) project="$2" ; shift 2 ;;
            esac ;;
        --path-package)
            case "$2" in
               "") shift 2 ;;
                *) pathPackage="$2" ; shift 2 ;;
            esac ;;
        --extensao)
            case "$2" in
               "") shift 2 ;;
                *) extensao="$2" ; shift 2 ;;
            esac ;;
        --token)
            case "$2" in
               "") shift 2 ;;
                *) token="$2" ; shift 2 ;;
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
        -r|--ra-job)
            case "$2" in
               "") shift 2 ;;
                *) raJob=$2 ; shift 2 ;;
            esac ;;
        --no-route)
            case "$2" in
               "") noRoute='true' ; shift 2;;
                *) noRoute='true' ; shift 2;;
            esac ;;
        --no-delete-image)
            case "$2" in
               "") noDeleteImage='true' ; shift 2;;
                *) noDeleteImage='true' ; shift 2;;
            esac ;;
        --no-service)
            case "$2" in
               "") noService='true' ; shift 2;;
                *) noService='true' ; shift 2;;
            esac ;;
        --s3-trigger)
            case "$2" in
               "") s3Trigger='true' ; shift 2;;
                *) s3Trigger='true' ; shift 2;;
            esac ;;
        --region-latam)
            case "$2" in
               "") shift 2 ;;
                *) regionLatam="$2" ; shift 2 ;;
            esac ;;
        --promotion-src)
            case "$2" in
               "") shift 2 ;;
                *) promotionSrc="$2" ; shift 2 ;;
            esac ;;
        --promotion-dst)
            case "$2" in
               "") shift 2 ;;
                *) promotionDst="$2" ; shift 2 ;;
            esac ;;
        --tribe)
            case "$2" in
               "") shift 2 ;;
                *) tribe="$2" ; shift 2 ;;
            esac ;;
        --squad)
            case "$2" in
               "") shift 2 ;;
                *) squad="$2" ; shift 2 ;;
            esac ;;
        --safe)
            case "$2" in
               "") shift 2 ;;
                *) safe="$2" ; shift 2 ;;
            esac ;;
        --vault)
            case "$2" in
               "") shift 2 ;;
                *) vault="$2" ; shift 2 ;;
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
        --cluster-name)
            case "$2" in
               "") shift 2 ;;
                *) clusterName="$2" ; shift 2 ;;
            esac ;;
        --config-repo)
            case "$2" in
               "") shift 2 ;;
                *) configRepo="$2" ; shift 2 ;;
            esac ;;
        -h|--help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Valida parametros obrigatorios
validParameters

# Executa ações lidas de deploy
case $target in
    was)

        # BUILD CONTAINER
        
        infoMsg  'deploy.sh : Criando o container WebSphere...'
        containerID=$(docker run -d --name sha256:e943bc58266095a52bb54b25f6df6817471c8987555ddc050e781fb71da74c5c -t $buildId:websphere-8.5.5.24-ubi8 ibmcom/websphere-traditional:8.5.5.24-ubi8-amd64)
        
        infoMsg  'deploy.sh : Preparando o ambiente para deploy...'
        
        files='/opt/infratransac/core/lib/wasLib.sh /opt/infratransac/core/br/com/experian/utils/common.sh /opt/infratransac/core/bin/deployWas.sh /opt/infratransac/core/bin/was_install_app.py /opt/infratransac/core/bin/wasInstallCert.sh /opt/infratransac/core/br/com/experian/utils/wsadminlib.py'
         
        for i in $(echo $files); do
            chmod 777 -R $i
            docker cp $i $containerID:/
        done

        credentials=$(cyberArkDap -s BR_PAPP_EITS_DSECOPS_STATIC -c connection_was)

        wsadminPwd=$(echo $credentials | jq -r '.password')

        qtdEnvs=$(echo $environment | grep -o ','| wc -l)
        envsWas=$environment
        qtdEnvs=$(( $qtdEnvs + 1 ))

        for (( i=1; i <= $qtdEnvs ; i++ )); do
            flagEnvWas=""
            flagEnvWas=`echo "$envsWas"|cut -d ',' -f${i}`

            infoMsg "deploy.sh -> Executando o script na console $flagEnvWas"

            docker exec $containerID bash -c "./deployWas.sh $environment $urlPackage usr_ci_integra $wsadminPwd"
            
            if [ $(docker ps -q --filter "id=${containerID}") ]; then

                infoMsg "deploy.sh -> Finalizando a execução do container $containerID"

                docker kill $containerID > /dev/null
            
                imageID=$(docker images | grep -E '^ibmcom*' | awk -e '{print $3}')
                
                infoMsg "Limpando a imagem $imageID"

                if ! [ -z $imageID ]; then
                    docker rmi $imageID -f > /dev/null
                fi
            fi
        done
    ;;
    iis)
        infoMsg 'deploy.sh : Iniciando deploy em '${instanceName}' no caminho '${pathPackage}''
        infoMsg 'Implementando iis....'
    ;;
    openshift)
        validTargetOpenshift
        #setProxy
        infoMsg 'deploy.sh : Executando o deploy em '${target}''
        infoMsg 'deploy.sh : Usando o metodo de deploy '${method}''
        infoMsg 'deploy.sh : Regiao LATAM  '${regionLatam}''
        case $method in
            package)
                deploymentsPackage $project "$image" $environment $pathPackage
                infoMsg 'deploy.sh : Sucesso no deploy \o/'
            ;;
            container)
                deploymentsContainer $project "$image" $environment $noRoute $regionLatam $tribe $noDeleteImage $promotionSrc $promotionDst 
                infoMsg 'deploy.sh : Sucesso no deploy \o/'
            ;;
            template)
                deploymentsTemplate $project "$image" $environment $pathPackage $regionLatam $noRoute
                infoMsg 'deploy.sh : Sucesso no deploy \o/'
            ;;
            infra)
                deploymentsInfra $project "$image" $environment $pathPackage
                infoMsg 'deploy.sh : Sucesso no deploy da infra \o/'
            ;;
            discovery)
                deploymentsDiscovery $project
            ;;
            rollout)
                deploymentsRollout $project "$image"
                infoMsg 'deploy.sh : Sucesso no rollout da infra \o/'
            ;;
            stopapi)
                stopApi $project "$image"
                infoMsg 'deploy.sh : Sucesso no stop da api \o/'
            ;;
            startpapi)
                startpApi $project "$image" $extraVars
                infoMsg 'deploy.sh : Sucesso no start da api \o/'
            ;;
            *)
                errorMsg 'deploy.sh : Tipo de deploy '${method}' ainda nao implementado para o destino '${target}'  :('
                exit 1
            ;;
        esac
    ;;
    aws)
        validTargetAws
        #setProxy
        infoMsg 'deploy.sh : Executando o deploy em '${target}''
        infoMsg 'deploy.sh : Usando o metodo de deploy '${method}''
        infoMsg 'deploy.sh : Ambiente de deploy '${environment}''
        infoMsg 'deploy.sh : Regiao LATAM  '${regionLatam}''
        case $method in
            lambda)
                export PATH=$PATH:/usr/local/bin
                export LD_LIBRARY_PATH=/opt/rh/rh-nodejs6/root/usr/lib64
                npm install
                export ENVIRONMENT=$environment
                infoMsg 'deploy.sh : Aplicando deploy usando serverless'

                if [ ! "$safe" == "null" ]; then
                    credentials=$(cyberArkDap -s $safe -c $iamUser -a $awsAccount)

                    if [ "$?" -ne 0 ]; then
                        errorMsg 'helmLib.sh->helmBuildCharts: Algo de errado aconteceu ao recuperar credenciais do cofre: '$safe
                        exit 1
                    fi

                    awsAccessKey=$(echo $credentials | jq -r '.accessKey')
                    awsSecretKey=$(echo $credentials | jq -r '.accessSecret')

                    export AWS_ACCESS_KEY_ID=$awsAccessKey
                    export AWS_SECRET_ACCESS_KEY=$awsSecretKey

                else
                    errorMsg 'deploy.sh: A partir do dia 30/10, é necessário usar o CyberArk para realizar deploys para a AWS.'
                    infoMsg 'deploy.sh: Confira a documentação aqui https://pages.experian.com/display/EDPB/How+to+retrieve+secrets+from+CyberArk+to+use+in+AWS+deploys'
                    exit 1
                fi

                if [ "$pathPackage" != "" ]; then 
                    infoMsg 'deploy.sh : Parametrizando o arquivo de configuracao '${pathPackage}' para execucao'
                    if ! /opt/rh/rh-nodejs6/root/usr/bin/serverless deploy --config $pathPackage --verbose; then 
                        errorMsg 'deploy.sh: Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                else    
                    if ! /opt/rh/rh-nodejs6/root/usr/bin/serverless deploy --verbose; then 
                        errorMsg 'deploy.sh: Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                fi
                if [ "$s3Trigger" == "true" ]; then 
                    infoMsg 'deploy.sh : Aplicando configuracao da trigger no s3 para o lambda'
                    if ! /opt/rh/rh-nodejs6/root/usr/bin/sls s3deploy --config $pathPackage --verbose; then 
                        errorMsg 'deploy.sh: Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                fi
            ;;
            lambda_serverlessv3)
                infoMsg 'deploy.sh : Aplicando deploy usando serverless versão 3'

                if [ ! "$safe" == "null" ]; then
                    credentials=$(cyberArkDap -s $safe -c $iamUser -a $awsAccount)

                    if [ "$?" -ne 0 ]; then
                        errorMsg 'deploy.sh : Algo de errado aconteceu ao recuperar credenciais do cofre: '$safe
                        exit 1
                    fi

                    awsAccessKey=$(echo $credentials | jq -r '.accessKey')
                    awsSecretKey=$(echo $credentials | jq -r '.accessSecret')

                else
                    errorMsg 'deploy.sh : A partir do dia 30/10, é necessário usar o CyberArk para realizar deploys para a AWS.'
                    infoMsg 'deploy.sh : Confira a documentação aqui https://pages.experian.com/display/EDPB/How+to+retrieve+secrets+from+CyberArk+to+use+in+AWS+deploys'
                    exit 1
                fi

                if [ "$pathPackage" != "" ]; then 
                    infoMsg 'deploy.sh : Parametrizando o arquivo de configuracao '${pathPackage}' para execucao'
                    if ! docker run --rm -v $PWD:/app -e ENVIRONMENT=$environment -e AWS_ACCESS_KEY_ID=$awsAccessKey -e AWS_SECRET_ACCESS_KEY=$awsSecretKey serverless-v3 serverless deploy --config $pathPackage --verbose; then 
                        errorMsg 'deploy.sh : Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                else
                    infoMsg 'deploy.sh : Serverless v3 deploy com serverless.yml'
                    if ! docker run --rm -v $PWD:/app -e ENVIRONMENT=$environment -e AWS_ACCESS_KEY_ID=$awsAccessKey -e AWS_SECRET_ACCESS_KEY=$awsSecretKey serverless-v3 serverless deploy --verbose; then 
                        errorMsg 'deploy.sh : Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                fi
                if [ "$s3Trigger" == "true" ]; then 
                    infoMsg 'deploy.sh : Aplicando configuracao da trigger no s3 para o lambda'
                    if ! docker run --rm -v $PWD:/app -e ENVIRONMENT=$environment -e AWS_ACCESS_KEY_ID=$awsAccessKey -e AWS_SECRET_ACCESS_KEY=$awsSecretKey serverless-v3 serverless deploy --config $pathPackage --verbose; then 
                        errorMsg 'deploy.sh : Ops, erro ao realizar o deploy em '${target}''
                        exit 1
                    fi
                fi
            ;;
            terraform)
                echo "Calma estamos implementando :)"
                infoMsg 'deploy.sh : Sucesso no deploy \o/'
            ;;
            *)
                warnMsg 'deploy.sh : Implementando deploy AWS para metodo '${method}''
            ;;
        esac
        infoMsg 'deploy.sh : Sucesso no deploy \o/'
    ;;
    database)
        validTargetDatabase
        deploymentsDatabases $method $pathPackage $project $clusterName $environment
        infoMsg 'deploy.sh : Sucesso no deploy \o/'
    ;;
    eks)
        validTargetEks
        infoMsg 'deploy.sh : Executando o deploy em '${target}''
        deploymentsEks $applicationName $version $project $tribe $squad $safe $iamUser $awsAccount $environment $clusterName $awsRegion $vault $noDeleteImage
        infoMsg 'deploy.sh : Sucesso no deploy \o/'
    ;;
    outsystem)
        case $method in
            getapplications)
               infoMsg 'deploy.sh : Executando o metodo '${method}''
               getApplications
            ;;
            getenvironmets)
               infoMsg 'deploy.sh : Executando o metodo '${method}''
               getEnvironmets
            ;;
            *)
                errorMsg 'deploy.sh : Tipo de deploy '${method}' ainda nao implementado para o destino '${target}'  :('
                exit 1
            ;;
        esac
    ;;
    *)
        errorMsg 'deploy.sh : Destino de deploy '${target}' ainda nao implementado :('
        exit 1
    ;;
esac