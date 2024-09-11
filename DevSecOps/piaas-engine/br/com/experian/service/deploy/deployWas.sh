#!/usr/bin/env bash


# Carrega commons

baseDir="/opt/infratransac/core"

test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh


# /**
# * environment
# * Ambiente para o deploy
# * @var string
# */
environment=''

# /**
# * target
# * Local onde sera realizado o deploy
# * @var string
# */
target=''

# /**
# * method
# * Define metodo de deploy
# * @var string
# */
method=''

# /**
# * urlPackage
# * Url pacote para o deploy
# * @var string
# */
urlPackage=''

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
TEMP=`getopt -o tuemirwj::h --long application-name::,target::,url-package::,help,environment::,method:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  devsecops-paas-brazil@br.experian.com
# */
usage () {

    echo "deployWas.sh version $VERSION - by DevSecOps PaaS Team"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo "deployWas.sh script para deploy em ambientes WebSphere.\n"

    echo -e "Options:
    --target                    : Instalação (default: was)
    --url-package               : Url do pacote registrado no nexus.
    --environment               : Qual ambiente será instalado o pacote.
    --method                    : Tipo de deploy Ansible ou wsadmin (default wsadmin).    "

    echo -e "\nExemplos:
    deployWas.sh --target=was --url-package=url_pacote --environment=de
    deployWas.sh --target=was --method=ansible --url-package=url_pacote --environment=de
    deployWas.sh --target=was --method=wsadmin --url-package=url_pacote --environment=hi,he"
}


# /**
# * validPackage
# * Método valida package informado
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
validParameters () {

    infoMsg 'deployWas.sh : Iniciando validacoes de parametros obrigatorios para deploy WebSphere'

    if [ "$environment" != "de" ] && \
       [ "$environment" != "hi" ] && \
       [ "$environment" != "he" ] && \
       [ "$environment" != "pi" ] && \
       [ "$environment" != "pe" ] && \
       [ "$environment" != "deeid" ] && \
       [ "$environment" != "hieid" ] && \
       [ "$environment" != "peeid" ] && \
       [ "$environment" != "pefree" ] && \
       [ "$environment" != "pehttps1" ] && \
       [ "$environment" != "pehttps3" ]; then
           errorMsg 'deployWas.sh : Ambiente '${environment}' para deploy invalido. Consulte deploy.sh --help para se informar de ambientes disponiveis de deploy'
           exit 1
    fi

    if [ "$target" == "" ];then
        errorMsg 'deployWas.sh : É necessario informar o target. Exemplo: --target=was'
        exit 1
    fi

    if [ "$method" == "" ]; then
        warnMsg 'deploy.sh : Metodo nao informado para deploy, considerando parametro como --method=wsadmin'
        method='wsadmin'
    fi

    if [ "$method" != "wsadmin" ]; then
        errorMsg 'deploy.sh : Metodo '${method}' para deploy invalido. Consulte deployWas.sh --help para se informar de metodos disponiveis de deploy'
        exit 1
    fi

    if [ "$urlPackage" == "" ];then
        errorMsg 'deployWas.sh : Para o deploy no WebSphere e necessario informar o urlPackage versao da aplicacao. Exemplo: --version=1.2.0'
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

    resp=`curl -I -k "$urlPackage"|grep 'HTTP'|cut -f2 -d" "`
        
    infoMsg 'validPackage -> Retorno do status do pacote '${resp}' '
    if [ "$resp" == "200" ] || [ "$resp" == "307" ]; then
        infoMsg 'validPackage -> Pacote '${urlPackage}' encontrado seguindo com o deploy'
    else
        errorMsg 'validPackage -> Pacote informado '${urlPackage}' nao encontrado impossivel prosseguir'
        exit 1
    fi
}


# /**
# * deployWithWsadmin
# * Método valida package informado
# * @version $VERSION
# * @package DevOps
# * @author  joao paulo bastos <jpbl.bastos at gmail dot com>
# */
deployWithWsadmin(){

    infoMsg  'deployWas.sh : Criando o container WebSphere...'

    containerID=$(docker run -d ibmcom/websphere-traditional:8.5.5.24-ubi8-amd64)
    
    files='/opt/infratransac/core/br/com/experian/utils/wasLib.sh /opt/infratransac/core/br/com/experian/utils/common.sh /opt/infratransac/core/br/com/experian/utils/wasInstallApp.sh /opt/infratransac/core/br/com/experian/utils/was_install_app.py /opt/infratransac/core/br/com/experian/utils/wasInstallCert.sh /opt/infratransac/core/br/com/experian/utils/wsadminlib.py'
        
    for i in $(echo $files); do
        chmod 777 -R $i
        docker cp $i $containerID:/
    done

    credentials=$(cyberArkDap -s BR_PAPP_EITS_DSECOPS_STATIC -c connection_was)

    wsadminPwd=$(echo $credentials | jq -r '.password')

    # Instalando o certificado autoassinado do WebSphere
    infoMsg "deployWas.sh -> Instalando o certificado da console $environment"
    
    if docker exec $containerID bash -c "./wasInstallCert.sh $environment usr_ci_integra $wsadminPwd"; then
        # Executando o wasInstallApp.py
        infoMsg "deployWas.sh -> Executando o script na console $environment"
        docker exec $containerID bash -c "./wasInstallApp.sh $environment $urlPackage usr_ci_integra $wsadminPwd"
    else
        errorMsg "deployWas.sh : Não foi possível realizar a configuração do certificado da console ${environment}."
        errorMsg "deployWas.sh : Verifique se a console administrativa ${environment} está ativa."
    fi


    if [ $(docker ps -q --filter "id=${containerID}") ]; then

        infoMsg "deployWas.sh -> Finalizando a execução do container $containerID"

        docker kill $containerID > /dev/null
    
    fi

}

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opções passadas
while true; do
    case "$1" in
        -t|--target)
            case "$2" in
               "") shift 2 ;;
                *) target=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
            esac ;;
        -e|--environment)
            case "$2" in
               "") shift 2 ;;
                *) environment=`echo ${2} | tr [:upper:] [:lower:]` ; shift 2 ;;
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
        -h|--help) usage ;;
        --) shift ; break ;;
        *) break ;;
    esac
done

validParameters
validPackage

case $method in
    wsadmin)
        deployWithWsadmin
    ;;
    *)
        errorMsg 'deployWas.sh : Tipo de deploy '${method}' não existe ou foi descontinuado :)'
        exit 1
    ;;
esac
