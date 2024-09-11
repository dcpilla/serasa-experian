#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           teams.sh
# * @version        1.0.0
# * @description    Script que envia notificações webhook para canais do Teams
# * @copyright      2022 &copy Serasa Experian
# *
# * @version        1.0.0
# * @copyright      2022 &copy Serasa Experian
# * @contribution   André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# * @date           24-02-22

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * channel
# * URL do incoming Webhook do Teams 
# * @var string
# */
channel=''

# /**
# * channel
# * Tipo de retorno enviado da execução da esteira
# * @var string
# */
type=''

# /**
# * applicationName
# * Nome da aplicacao 
# * @var string
# */
applicationName=''

# /**
# * versionApp
# * Versão da aplicacao 
# * @var string
# */
versionApp=''

# /**
# * author
# * Autor da execução na esteira
# * @var string
# */
author=''

# /**
# * coreUrl
# * URL da execução no PiaaS
# * @var string
# */
coreUrl=''

# /**
# * buildNumber
# * ID number da build no PiaaS
# * @var string
# */
buildNumber=''

# /**
# * gitBranch
# * Branch utilizada
# * @var string
# */
gitBranch=''

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o a::h --long channel::,type::,applicationName::,versionApp::,author::,coreUrl::,gitBranch::,buildNumber::,help:: -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package teams.sh
# * @author  André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
usage () {
    echo "teams.sh version $VERSION - by DevSecOps Paas Brazil"
    echo "Copyright (C) 2022 Serasa Experian"
    echo ""
    echo -e "teams.sh script que manda notificações a grupos do teams. \n"

    echo -e "Usage example: teams.sh --applicationName=serasa-experian-frontend --versionApp=1.0 --author=André --url=http://spobrjenkins:8080/job/core/1/ --gitBranch=develop --buildNumber=1 --type=sucesso --channel=https://experian.webhook.office.com/webhookb2/4250df33-e62b-4ca9-b47a-45a878cb9e4d@be67623c-1932-42a6-9d24-6c359fe5ea71/IncomingWebhook/312321321321/ \n"

    echo -e "Options
    --channel           URL do Incoming Webhook do Teams
    --type              Retorno da esteira (se sucesso ou erro)
    --applicationName   Nome da aplicação 
    --versionApp        Versão de APP
    --author            Autor da execução na esteira
    --gitBranch         Branch da execução da aplicação
    --coreUrl           URL da execução no PiaaS
    --buildNumber       Número do build na esteira"

    exit 1
}

# /**
# * validateParameters
# * Método que valida parametros
# * @version $VERSION
# * @package DevOps
# * @author  André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
validateParameters () {
    if [ "$channel" == "" ]; then
        echo 'teams.sh->validateParameters: URL de incoming webhook do Teams não informado.'
        exit 1
    fi
}

# /**
# * sendNotificationTeams
# * Método que realiza POST no webhook do Teams
# * @version $VERSION
# * @package DevOps
# * @author  André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
sendNotificationTeams () {

    if [ "$type" == "erro" ]; then
        curl -s -o /dev/null -H 'Content-Type: application/json' -d "$(errorMessage)" "$channel"
    elif [ "$type" == "sucesso" ]; then
        curl -s -o /dev/null -H 'Content-Type: application/json' -d "$(successMessage)" "$channel"
    fi

    echo 'teams.sh->sendNotificationsTeams: Notificação enviada para o Teams com sucesso!'
}

# /**
# * successMessage
# * Método que realiza formatação do JSON para envio em caso de sucesso
# * @version $VERSION
# * @package DevOps
# * @author  André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
successMessage () {

    cat <<EOF

{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "0076D7",
    "summary": "Sua execução ocorreu com sucesso!",
    "sections": [{
        "activityTitle": "Sua execução ocorreu com sucesso!",
        "activityImage": "https://avatars.githubusercontent.com/u/107424?s=200&v=4",
        "facts": [{
            "name": "Autor",
            "value": "$author"
        }, {
            "name": "Aplicação",
            "value": "$applicationName-$versionApp"
        }, {
            "name": "Branch",
            "value": "$gitBranch"
        },
        {
            "name": "Build Number",
            "value": "$buildNumber"
        }],
        "markdown": true
    }],
    "potentialAction": [{
        "@type": "OpenUri",
        "name": "Acesse a execução na esteira",
        "targets": [{
            "os": "default",
            "uri": "http://spobrjenkins:8080/job/core/328856/console"
        }]
    }, {
        "@type": "OpenUri",
        "name": "Acesse o Help PiaaS",
        "targets": [{
            "os": "default",
            "uri": "https://pages.experian.com/display/EDPB/Help+PiaaS+-+Pipeline+as+a+Services"
        }]
    }

    ]
}

EOF
}

# /**
# * errorMessage
# * Método que realiza formatação do JSON para envio em caso de erro
# * @version $VERSION
# * @package DevOps
# * @author  André Arioli <andre.arioli@br.experian.com>, Lucas Francoi <lucas.francoi@br.experian.com>, Felipe Olivotto <felipe.olivotto@br.experian.com>
# */
errorMessage () {

    cat <<EOF

{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "0076D7",
    "summary": "Sua execução na esteira falhou!",
    "sections": [{
        "activityTitle": "Sua execução na esteira falhou",
        "activityImage": "https://www.ogprogrammer.com/wp-content/uploads/2017/07/jenkins-angry.png",
        "facts": [{
            "name": "Autor",
            "value": "$author"
        }, {
            "name": "Aplicação",
            "value": "$applicationName-$versionApp"
        }, {
            "name": "Branch",
            "value": "$gitBranch"
        },
        {
            "name": "Build Number",
            "value": "$buildNumber"
        }],
        "markdown": true
    }],
    "potentialAction": [{
        "@type": "OpenUri",
        "name": "Acesse a execução na esteira",
        "targets": [{
            "os": "default",
            "uri": "http://spobrjenkins:8080/job/core/328856/console"
        }]
    }, {
        "@type": "OpenUri",
        "name": "Acesse o Help PiaaS",
        "targets": [{
            "os": "default",
            "uri": "https://pages.experian.com/display/EDPB/Help+PiaaS+-+Pipeline+as+a+Services"
        }]
    }

    ]
}

EOF
}

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

# Extrai opções passadas
while true ; do
    case "$1" in
        -a|--channel)
            case "$2" in
               "") shift 2 ;;
                *) channel="$2" ; shift 2 ;;
            esac ;;
        --applicationName)
            case "$2" in
               "") shift 2 ;;
                *) applicationName="$2" ; shift 2 ;;
            esac ;;
        --versionApp)
            case "$2" in
               "") shift 2 ;;
                *) versionApp="$2" ; shift 2 ;;
            esac ;;
        --author)
            case "$2" in
               "") shift 2 ;;
                *) author="$2" ; shift 2 ;;
            esac ;;
        --coreUrl)
            case "$2" in
               "") shift 2 ;;
                *) coreUrl="$2" ; shift 2 ;;
            esac ;;
        --gitBranch)
            case "$2" in
               "") shift 2 ;;
                *) gitBranch="$2" ; shift 2 ;;
            esac ;;
        --buildNumber)
            case "$2" in
               "") shift 2 ;;
                *) buildNumber="$2" ; shift 2 ;;
            esac ;;
        --type)
            case "$2" in
               "") shift 2 ;;
                *) type="$2" ; shift 2 ;;
            esac ;;
        --help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

validateParameters

sendNotificationTeams