#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           snow.sh
# * @version        $VERSION
# * @description    Script que integra via API ao service now
# * @copyright      2018 &copy Serasa Experian
# *
# * @version        2.9.2
# * @change         [ADD] Timeout function getPing;
# * @copyright      2023 &copy Serasa Experian
# * @author         Felipe Olivotto <felipe.olivotto@br.experian.com>
# *                
# * @date           02-10-2023
# *
# * @version        2.9.1
# * @change         [ADD] Funcao para checar informacoes de AWS accounts e environments da conta;
# * @copyright      2023 &copy Serasa Experian
# * @author         Lucas C Francoi <lucas.francoi@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           26-07-2023
# *
# * @version        2.9.0
# * @change         [ADD] Parametro para checar janela de implantacao da change order;
# * @copyright      2022 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           29-11-2022
# *
# * @version        2.8.2
# * @change         [FIX] Ajuste de fuso -3 na abertura de change order e fechamento da change order;
# * @copyright      2022 &copy Serasa Experian
# * @author         Lucas Francoi <lucas.francoi@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           30-Jun-2022
# *
# * @version        2.8.1
# * @change         [FIX] Ajuste de fuso -3 na abertura de change order;
# * @copyright      2021 &copy Serasa Experian
# * @author         Renato M Thomazine <renato.thomazine@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           19-Nov-2021
# *
# * @version        2.8.0
# * @change         [FEATURE] Parametro de incidente para abertura de change orders;
# *                 [FIX] Ajuste de fuso -4 na abertura de change order;
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           17-Ago-2021
# *
# * @version        2.7.0
# * @change         [FEATURE] Add busca de incidentes --status-incident
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           10-Ago-2021
# * 
# * @version        2.6.0
# * @change         [FEATURE] Buscar lista de request liberadas para auto implantação;
# * @copyright      2021 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           16-Mar-2021
# *
# * @version        2.5.0
# * @change         [FEATURE] Get dados request;
# *                 [FEATURE] Fechamento da request;
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           14-Jan-2021
# *
# * @version        2.4.0
# * @change         [FEATURE] Get u_network_type do gearr
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           14-Out-2020
# * 
# * @version        2.3.0
# * @change         [FEATURE] Função para expurgo de OM paradas por X dias
# *                 [FEATURE] Novo campo de u_change_country para aberturas de OM's
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           17-Set-2020
# * 
# * @version        2.2.0
# * @change         [FEATURE] Buscar change orders aberta de uma categoria
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *                 Luiz.Bartholomeu <Luiz.Bartholomeu@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           14-Jul-2020
# *
# * @version        2.1.0
# * @change         [FEATURE] Implementado função de ping para teste da api
# * @copyright      2020 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           30-Mar-2020
# *
# * @version        2.2.0
# * @description    [Feature] adicionado campos de schedule inicio e fim
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           25-Marco-2019
# *
# * @version        2.1.1
# * @description    Script que integra via API ao service now    
# * @copyright      2018 &copy Serasa Experian
# * @author         Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *                 Joao Aloia <joao.aloia@br.experian.com>
# *                 Alexandre Frankiw <alexandre.frankiw@br.experian.com>
# * @dependencies   common.sh
# *                 curl >= 7.29.0
# *                  jq - Ref.: https://starkandwayne.com/blog/bash-for-loop-over-json-array-using-jq/
# *                                            https://giovannireisnunes.wordpress.com/2016/10/28/json-em-shell-script/
# * @date           21-Ago-2018
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

# Carrega iamLib
test -e "$baseDir"/br/com/experian/utils/iamLib.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/iamLib.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='2.9.0'

# /**
# * TEMP
# * Leitura de opções
# * @var string
# */
TEMP=`getopt -o a::h --long help::,action::,verbose::,state::,requested-by::,template::,business-service::,category::,cmdb-ci::,justification::,risk-impact-analysis::,assignment-group::,assigned-to::,short-description::,description::,backout-plan::,test-result::,u-environment::,u-sys-outage::,start-date::,end-date::,u-test-results::,u-related-incident::,implementation-plan::,field-name::,field-id::,table-name::,number-change::,number-ritm::,number-incident::,close-code::,close-notes::,work-start::,work-end::,gearr-id::,aws-account::,all-states::,check-planned-window::,ping -n "$0" -- "$@"`
eval set -- "$TEMP"

# /**
# * snowServer
# * Servidor service now
# * @var string
# */
snowServer=""

# /**
# * endpointSnow
# * Endpoint service now
# * @var string
# */
endpointSnow="https://experian.service-now.com/api"

# /**
# * snowUser
# * Usuário service now
# * @var string
# */
snowUser=""

# /**
# * snowToken
# * Token service now
# * @var string
# */
snowToken=""

# /**
# * verbose
# * Modo verbose
# * @var string
# */
verbose=""

# /**
# * action
# * Endpoint para conexão
# * @var string
# */
action=""

# /**
# * assignedTo
# * Assintante da change order
# * @var string sxo3695
# */
assignedTo=""

# /**
# * businessService
# * Unidade de negocio
# * @var string
# */
businessService=""

# /**
# * category
# * Categoria da change order
# * @var string
# */
category=""


# /**
# * template
# * Template do tipo de change order
# * @var string
# */
template=""

# /**
# * cmdbCi
# * Itens de configuração
# * @var string
# */
cmdbCi=""

# /**
# * gearrId
# * Define o ID o Gearr
# * @var string
# */
gearrId=""

# /**
# * aswAccountID
# * Define o ID o Gearr
# * @var string
# */
awsAccountID=""

# /**
# * justification
# * Justificativa da implantação
# * @var string
# */
justification=""

# /**
# * riskImpactAnalysis
# * Analise de impacto
# * @var string
# */
riskImpactAnalysis=""

# /**
# * uRelatedIncident
# * Incidente relacionado
# * @var string
# */
uRelatedIncident=""

# /**
# * assignmentGroup
# * Grupo afetado da change order
# * @var string
# */
assignmentGroup=""

# /**
# * shortDescription
# * Sumário da change order
# * @var string
# */
shortDescription=""

# /**
# * description
# * Descrição da change order
# * @var string
# */
description=""

# /**
# * backoutPlan
# * Plano de rollback
# * @var string
# */
backoutPlan=""

# /**
# * testResult
# * Teste executados
# * @var string
# */
testResult=""

# /**
# * implementationPlan
# * Plano de rollout
# * @var string
# */
implementationPlan=""

# /**
# * uEnvironment
# * Ambiente de implantação
# * @var string
# */
uEnvironment=""

# /**
# * uRegion
# * Região da experian
# * @var string
# */
uRegion='LATAM'

# /**
# * uChangeCountry
# * Define país 
# * @var string
# */
uChangeCountry='Brazil'

# /**
# * uSysOutage
# * @var string
# */
uSysOutage=""

# /**
# * startDate
# * Inicio da implantação
# * @var string
# */
startDate=""

# /**
# * endDate
# * Fim da implantação
# * @var string
# */
endDate=""

# /**
# * gmtFuso
# * Fim da implantação
# * @var string
# */
gmtFuso="5"

# /**
# * resp
# * Respostas das chamadas
# * @var string
# */
resp=""

# /**
# * snowData
# * Dados para envio ao snow
# * @var string
# */
snowData=""

# /**
# * changeOrder
# * Numero da change order
# * @var string
# */
changeOrder=""

# /**
# * numberRitm
# * Numero do ritm
# * @var string
# */
numberRitm=""      

# /**
# * numberIncident
# * Numero do incidente
# * @var string
# */
numberIncident=""

# /**
# * fieldId
# * Id do field reference
# * @var string
# */      
fieldId="" 

# /**
# * tableName
# * Nome da tabela para buscar campos de referencia
# * @var string
# */                  
tableName=""              

# /**
# * fieldName
# * Campo que deseja retornar da change order
# * @var string
# */
fieldName=""

# /**
# * closeCode
# * Campo que informa o codigo de fechamento da change order
# * @var string
# */
closeCode='successful'

# /**
# * closeNotes
# * Campo que informa o descritivo do fechamento
# * @var string
# */
closeNotes=""

# /**
# * workStart
# * Campo que informa a data inicial real da implementação da change order
# * @var string
# */
workStart=""

# /**
# * workEnd
# * Campo que informa a data final real da implementação da change order
# * @var string
# */
workEnd=""

# /**
# * typeChange
# * Campo que o tipo de change order
# * @var string
# */
typeChange='standard'


# /**
# * state
# * Campo utilizado na criação que define a fase change order 
# * @var string
# */
state=''

# /**
# * requestedBy
# * Campo utilizado na criação da change que define o nome de quem criou a change order 
# * @var string
# */
requestedBy=''

# /**
# * checkPlannedWindow
# * Checar janela de implantação
# * @var string
# */
checkPlannedWindow='false'

# /**
# * allStates
# * Traz todas as requests, independente do status
# * @var string
# */
allStates='false'

# /**
# * Funções
# */

# /**
# * usage
# * Método help do script
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Joao Aloia <joao.aloia@br.experian.com>
# *          Alexandre Frankiw <alexandre.frankiw@br.experian.com>
# */
usage () {
    echo "snow.sh version $VERSION - by SRE Team"
    echo "Copyright (C) 2018 Serasa Experian"
    echo ""
    echo -e "snow.sh script que explora as API's SERVICE NOW \n"
    echo -e "Usage: snow.sh --verbose=true --action=create-change --state=-3 --template='Software Deployment' --business-service='Taleo.TalentAcquisitionSystem' --category='Application Software' --cmdb-ci='' --justification='Teste de criação Change Order Linha 1 Linha 2 Linha 3' --risk-impact-analysis='Risco de impacto teste' --assignment-group='Change Management BR' --assigned-to='' --short-description='Pequena descrição Linha 1 Linha 2 Linha 3' --description='Descrição Linha 1 Linha 2 Linha 3' --backout-plan='Plano RoLLBACK Linha 1 Linha 2 Linha 3' --implementation-plan='Plano de rollout' --test-result='teste resultado Linha 1 Linha 2 Linha 3' --u-environment='Test' --u-sys-outage='no' --u-related-incident=INC3661570
    or snow.sh --action=status-change --number-change=CHG0075076
    or snow.sh --action=status-change --number-change=CHG0075076 --check-planned-window
    or snow.sh --action=status-change --number-change=CHG0075076 --field-name=NomeVariavel
    or snow.sh --action=close-change --number-change=CHG0075076 --close-code='successful' --close-notes='descricao fechamento' --work-start='2018-08-28 01:30:15' --work-end='2018-08-29 01:15:13'
    or snow.sh --action=get-change-open-category --category='Brazil%20DevSecOps%20Infrastructure%20Service%20Catalog' 
    or snow.sh --action=get-groups-user --requested-by=sof5305
    or snow.sh --action=get-details-gearr --gearr-id=12641
    or snow.sh --action=get-aws-account-details --aws-account=187739130313 --field-name=u_environment
    or snow.sh --action=get-aws-account-details --aws-account=187739130313
    or snow.sh --action=get-full-details-gearr --gearr-id=12641
    or snow.sh --action=status-request --number-ritm=RITM1265110 
    or snow.sh --action=close-request --number-ritm=RITM1265110 --close-notes='descricao fechamento'
    or snow.sh --action=status-incident --number-incident=INC3202640 
    or snow.sh --action=get-request-auto-implement --category=e1c64531db018810f221241848961994
    or snow.sh --action=get-request-auto-implement --category=32e8df771bf241144ec7b8c8dc4bcbd7 --all-states
    or snow.sh --action=get-field-reference  --table-name=sys_user --field-id=86cab9b7db5c94d40b6b1f3b4b9619ab --field-name=u_nome_tabela
    or snow.sh --action=get-field-reference  --table-name=sys_user --field-id=86cab9b7db5c94d40b6b1f3b4b9619ab 
    or snow.sh --action=get-problems --gearr-id=22705
    or snow.sh --action=cleanup-change
    or snow.sh --ping\n"


    echo -e "Options
    --a, --action                  Opcao de endpoint para consumir [create-change|status-change|close-change|get-change-open-category|get-groups-user|get-details-gearr|cleanup-change|get-request-auto-implement|status-incident|status-request]
         --verbose                 Define modo verbose para execucao [true|false]
         --state                   Define fase de abertura da change order
                                   -2 = Implement
                                   -3 = Authorize
                                   -4 = Access and plane
                                   -5 = Draft
         --template                Template usado para abertura da change order
         --requested-by            Logon AD de quem esta criando a Change Order 
         --business-service        Unidade de negocio
         --category                Categoria da change order
         --cmdb-ci                 Item de configuração da aplicação
         --aws-account             AWS Account ID 
         --gearr-id                Id do Gearr
         --justification           Justificativa da implantacao. Para quebra de linha use o delimitador \\\n
         --risk-impact-analysis    Analise de impacto
         --assignment-group        Grupo afetado da change order
         --assigned-to             Assintante da change order
         --short-description       Sumario da change order
         --description             Descrição da change order. Para quebra de linha use o delimitador \\\n
         --backout-plan            Plano de rollback. Para quebra de linha use o delimitador \\\n
         --u-environment           Ambiente de implantacao
         --u-test-results          Resultados de testes. Para quebra de linha use o delimitador \\\n
         --u-sys-outage            Indiponibilidade da implantacao [yes|no]
         --u-related-incident      Incidente relacionado com change order
         --start-date              Inicio da implantacao AAAA-MM-DD HH:MIN:SEG 
         --end-date                Fim da implantacao AAAA-MM-DD HH:MIN:SEG 
         --implementation-plan     Plano de rollout. Para quebra de linha use o delimitador \\\n
         --number-change           Numero da change order
         --number-ritm             Numero do ritm
         --number-incident         Numero do incidente
         --field-id                Id do field reference
         --table-name              Nome da tabela para buscar campos de referencia
         --field-name              Nome do parametro 
         --param-change            Parametro de retorno
         --close-code              Codigo de fechamento
         --close-notes             Sumario do fechamento 
         --work-start              Data inicial da implementação da change order
         --work-end                Data final da implementação da change order
         --check-planned-window    Checar janela de implantacao e sai com erro caso esteja fora
         --all-states              Traz todas as requisicoes da fila de requisicoes
         --ping                    Testa status da API
         --h, --help               Ajuda"

    exit 1
}

# /**c
# * createChange
# * Método que cria a change order
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Joao Aloia <joao.aloia@br.experian.com>
# *          Alexandre Frankiw <alexandre.frankiw@br.experian.com>
# */
createChange () {

    snowToken=`getJwtToken`
    snowServerCreateChange="$snowServer/change-orders"

    snowData="{ \"type\":\"${typeChange}\", \"template\" : \"${template}\", \"businessService\":\"${businessService}\", \"category\":\"${category}\", \"cmdbCi\":\"${cmdbCi}\", \"endDate\":\"${endDate}\", \"justification\":\"${justification}\", \"riskImpactAnalysis\":\"${riskImpactAnalysis}\", \"assignmentGroup\":\"${assignmentGroup}\", \"assignedTo\":\"${assignedTo}\", \"shortDescription\":\"${shortDescription}\", \"description\":\"${description}\", \"backoutPlan\":\"${backoutPlan}\", \"implementationPlan\":\"${implementationPlan}\", \"testResults\":\"${testResult}\", \"startDate\":\"${startDate}\", \"environment\":\"${uEnvironment}\", \"region\":\"${uRegion}\", \"changeCountry\":\"${uChangeCountry}\", \"stateFinal\":\"${state}\", \"requestedBy\":\"${requestedBy}\", \"sysOutage\":\"${uSysOutage}\" , \"relatedIncident\":\"${uRelatedIncident}\" }"

    if [ "$verbose" == "true" ]; then
        infoMsg 'snow.sh->createChange : Modo verbose ativado'
        infoMsg 'snow.sh->createChange : Iniciando criacao de change order no service now'
        #setProxy    
        infoMsg 'snow.sh->createChange : Detalhes para criacao '${snowData}''
        curl --verbose \
             --request POST \
             --insecure \
             --url $snowServerCreateChange \
             --header 'accept: application/json' \
             --header 'authorization: Bearer '$snowToken'' \
             --header 'cache-control: no-cache' \
             --header 'content-type: application/json' \
             --data "${snowData}" 
    else   
        resp=$(curl --verbose \
                    --request POST \
                    --insecure \
                    --url $snowServerCreateChange \
                    --header 'accept: application/json' \
                    --header 'authorization: Bearer '$snowToken'' \
                    --header 'cache-control: no-cache' \
                    --header 'content-type: application/json' \
                    --data "${snowData}" 2>/dev/null |jq '.number'|sed -e 's/"//;s/"//')
        
        if [ "$resp" == "" ]; then
            errorMsg 'snow.sh->createChange : Ops, erro na criacao da change order'
            exit 1
        else
            echo $resp
        fi    
    fi
}

# /**
# * closeChange
# * Método que fecha change order
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Joao Aloia <joao.aloia@br.experian.com>
# *          Alexandre Frankiw <alexandre.frankiw@br.experian.com>
# */
closeChange(){   

    snowToken=`getJwtToken` 
    snowServerCloseChange="$snowServer/change-orders/$changeOrder/close"
    if [ "$changeOrder" == "" ]; then
        errorMsg 'snow.sh->close-change : Numero da change order nao informado, impossivel continuar. Exemplo --number-change=CHG0075076'
        exit 1
    fi
   
    infoMsg 'snow.sh->closeChange : Iniciando fechamento da change order '$changeOrder' no service now'

    snowData="{\"closeCode\":\"${closeCode}\", \"closeNotes\":\"${closeNotes}\", \"workStart\":\"${workStart}\", \"workEnd\":\"${workEnd}\"}"

    infoMsg 'snow.sh->closeChange : Detalhes do fechamento '${snowData}''

    resp=$(curl --verbose \
         --request PATCH \
         --insecure \
         --url $snowServerCloseChange \
         --header 'accept: application/json' \
         --header 'authorization: Bearer '$snowToken'' \
         --header 'cache-control: no-cache' \
         --header 'content-type: application/json' \
         --data "${snowData}" 2>/dev/null | jq '.')

    if [ "$resp" == "" ]; then
        errorMsg 'snow.sh->createChange : Ops, erro ao fechar change order'
        exit 1
    else
        echo $resp
    fi 
    
}

# /**
# * statusChange
# * Método que consulta change order
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Joao Aloia <joao.aloia@br.experian.com>
# *          Alexandre Frankiw <alexandre.frankiw@br.experian.com>
# */
statusChange(){
    local dataCheckNow=$(date +"%Y-%m-%d %H:%M")
    local dataCheckNow=$(date -d "$dataCheckNow" +"%s")
    local dataCheckStart=''
    local dataCheckEnd='' 
    local statusResult=''
    snowToken=`getJwtToken`
    snowServerStatusChange="$snowServer/change-orders/$changeOrder"
    
    if [ "$changeOrder" == "" ]; then
        errorMsg 'snow.sh->status-change : Numero da change order nao informado, impossivel continuar. Exemplo --number-change=CHG0075076'
        exit 1
    fi    

    statusResult=$(curl --request GET \
                        --insecure \
                        --url $snowServerStatusChange \
                        --header 'authorization: Bearer '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null)

    if [ "$checkPlannedWindow" == "true" ]; then
        dataCheckStart=$(echo $statusResult | jq -r '.startDate')
        dataCheckStart=$(date -d "$dataCheckStart" +"%s")

        dataCheckEnd=$(echo $statusResult | jq -r '.endDate')
        dataCheckEnd=$(date -d "$dataCheckEnd" +"%s")

        if [ "$dataCheckNow" -lt "$dataCheckStart" ] || [ "$dataCheckNow" -gt "$dataCheckEnd" ]; then
            dataCheckStart=$(date -d "@$dataCheckStart")
            dataCheckEnd=$(date -d "@$dataCheckEnd")
            errorMsg 'snow.sh->status-change : Ops, sua janela de implantação se inicia em '$dataCheckStart' e finaliza em '$dataCheckEnd'. Você esta fora da sua janela de implantação. A implantação deve acontecer durante a janela planejada e aprovada!'
            echo "Planned start date: $dataCheckStart"
            echo "Planned end date: $dataCheckEnd"
            echo "Agora sao: $(date)"
            echo "Prazo de implantação expirado ou fora do horário planejado!"
            echo "Clique no link e saiba quais são os procedimentos e orientações para conclusão da sua mudança https://pages.experian.com/x/NZ6gPQ"
            exit 1
        fi
    fi

    if [ "$fieldName" != "" ]; then
        echo $statusResult | jq -r ".$fieldName"
    else
        echo $statusResult | jq -r '.'
    fi
}

# /**
# * statusRequest
# * Método que consulta request
# * @version $VERSION
# * @package DevOps
# * @param   numberRitm  - Numero do ritm
# * @return  strJson     - Json com os dados
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# */
statusRequest(){
    
    snowToken=`getJwtToken` 
    snowServerRequest="$snowServer/request-items/$numberRitm?includeFields=true"
    
    if [ "$numberRitm" == "" ]; then
        errorMsg 'snow.sh->status-request : Numero do ritm nao informado, impossivel continuar. Exemplo --number-ritm=RITM1265110'
        exit 1
    fi

    statusRequest=$(curl --request GET \
                        --insecure \
                        --url $snowServerRequest \
                        --header 'authorization: Bearer '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null)
    
    jsonTmp=$(echo $statusRequest | jq -r '.fields')

    jsonStatusRequest=$(echo $jsonTmp | jq -r '. += {"number_ritm": "'$numberRitm'"}') 

    echo $jsonStatusRequest
}

# /**
# * statusIncident
# * Método que consulta incidente
# * @version $VERSION
# * @package DevOps
# * @param   numberIncident  - Numero do incidente
# * @return  strJson         - Json com os dados
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# */
statusIncident(){
    
    snowToken=`getJwtToken`
    snowServerIncident="$snowServer/incidents/$numberIncident"
    
    if [ "$numberIncident" == "" ]; then
        errorMsg 'snow.sh->status-incident : Numero do incidente nao informado, impossivel continuar. Exemplo --number-incident=INC3202640'
        exit 1
    fi

    statusIncResult=$(curl --request GET \
                   --insecure \
                   --url $snowServerIncident \
                   --header 'authorization: Bearer '$snowToken'' \
                   --header 'cache-control: no-cache' 2>/dev/null | jq -r '.')

    if [ "$statusIncResult" != "" ];then
        echo $statusIncResult
    fi
}

# /**
# * closeRequest
# * Método que fecha a request
# * @version $VERSION
# * @package DevOps
# * @param   numberRitm  - Numero do ritm
# *          closeNotes  - Notas de fechamento
# * @return  true | false
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# */
closeRequest(){
    
    snowToken=`getJwtToken`
    snowServerCloseRequest="$snowServer/request-items/$numberRitm/close" 
    snowData="{\"closeNotes\":\"${closeNotes}\"}"
    
    if [ "$numberRitm" == "" ]; then
        errorMsg 'snow.sh->close-request : Numero do ritm nao informado, impossivel continuar. Exemplo --number-ritm=RITM1265110'
        exit 1
    fi
    if [ "$closeNotes" == "" ]; then 
        errorMsg 'snow.sh->close-request : Notas do fechamento da request nao informado, impossivel continuar. Exemplo --close-notes=Detalhes do fechamento'
        exit 1
    fi

    statusCode=$(curl --verbose \
                   --request POST \
                   --insecure \
                   --url $snowServerCloseRequest \
                   --header 'accept: application/json' \
                   --header 'authorization: Bearer '$snowToken'' \
                   --header 'cache-control: no-cache' \
                   --header 'content-type: application/json' \
                   --data "$snowData" 2>/dev/null | jq '.code')

    if [ "$statusCode" == "400" ]; then
        warnMsg 'snow.sh->close-request : Falha ao encerrar a RITM '${numberRitm}'. Prossiga com o fechamento manual'
    else  
        infoMsg 'snow.sh->close-request : RITM '${numberRitm}' encerrada com sucesso!'
    fi
}

# /**
# * getFieldReference
# * Método que consulta um campo de tipo referencia 
# * @version $VERSION
# * @package DevOps
# * @param  tableName       -  Nome da tabela
# *         fieldId         -  Id do campo de referencia
# *         fieldName       -  Nome do campo para retornar (Opcional)
# * @return valueReference  - O valor real da referencia
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# */
getFieldReference(){

    snowToken=`getJwtToken` 
    snowServerFieldReference="$snowServer/tables/$tableName/fields/$fieldId"
    
    if [ "$tableName" == "" ]; then
        errorMsg 'snow.sh->get-field-reference : Nome da tabela nao informado, impossivel continuar. Exemplo --table-name=sys_user'
        exit 1
    fi
    if [ "$fieldId" == "" ]; then
        errorMsg 'snow.sh->get-field-reference : Id do campo nao informado, impossivel continuar. Exemplo --field-id=86cab9b7db5c94d40b6b1f3b4b9619ab'
        exit 1
    fi

    if [ "$fieldName" != "" ]; then
        valueReference=$(curl --request GET \
                              --insecure \
                              --url $snowServerFieldReference \
                              --header 'authorization: Bearer '$snowToken'' \
                              --header 'cache-control: no-cache' 2>/dev/null | jq -r ".[].$fieldName")
        echo $valueReference
    else
        curl --request GET \
             --insecure \
             --url $snowServerFieldReference \
             --header 'authorization: Bearer '$snowToken'' \
             --header 'cache-control: no-cache' 2>/dev/null | jq "."
    fi
}

# /**
# * getChangeOrderOpenCategory
# * Método que consulta change order abertas por categoria
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
# * @return 
# */
getChangeOrderOpenCategory(){

    category=$(echo "$category" | sed 's/ /%20/g')
    snowToken=`getJwtToken`
    snowServerOpenCategory="$snowServer/change-orders?category=$category" 
    
    if [ "$category" == "" ]; then
        errorMsg 'snow.sh->get-change-open-category : Nome da categoria nao informado, impossivel continuar. Exemplo --category=Brazil DevSecOps Continuous Integration and Deployment HighScore'
        exit 1
    fi

    listChangeOrder=$(curl --request GET \
                           --insecure \
                           --url $snowServerOpenCategory \
                           --header 'authorization: Bearer '$snowToken'' \
                           --header 'cache-control: no-cache' 2>/dev/null | jq -r '.[].number' | tr '\n' ' ')

    if [ "$listChangeOrder" != "" ];then
        echo $listChangeOrder
    fi
}

# /**
# * getRequestAutoImplement
# * Método que consulta request liberadas para auto implementação
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
# * @return 
# */
getRequestAutoImplement(){

    snowToken=`getJwtToken` 

    if [ "$allStates" == "true" ]; then
        snowServer="$snowServer/request-items?category=$category"
    else
        snowServer="$snowServer/request-items?category=$category&state=1"
    fi


    if [ "$category" == "" ]; then
        errorMsg 'snow.sh->get-request-auto-implement : ID da categoria nao informado, impossivel continuar. Exemplo --category=e1c64531db018810f221241848961994'
        exit 1
    fi

    listRitm=$(curl --request GET \
                        --insecure \
                        --url $snowServer \
                        --header 'authorization: Bearer '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null | jq -r '.[].number')

    if [ "$listRitm" != "[]" ];then
        echo $listRitm
    fi
}

# /**
# * cleanupChange
# * Método que realiza expurgo de change orders paradas em draft e plan depois de X dias
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# *          Fracis Blascke <Deloitte.Francis.Blascke@br.experian.com>
# *          Gustavo Raspante <Gustavo.Raspante@br.experian.com>
# * @return 
# */
cleanupChange(){
    snowServer="$endpointSnow/now/table/change_request?sysparm_query=u_regionNOT%20LIKE0163cef9dba6a280af053b2ffe9619b5%5Eu_regionNOT%20LIKE3a2342f9dba6a280af053b2ffe961983%5Eu_regionNOT%20LIKE510fa331dbb38f80de5d3f3ffe9619c8%5Eu_regionNOT%20LIKE78a3023ddba6a280af053b2ffe9619fb%5Eu_regionNOT%20LIKE7e9dc119dbddfe007bd1317ffe9619ec%5Eu_regionNOT%20LIKEd7b146b9dba6a280af053b2ffe96193b%5Eu_regionLIKEc993423ddba6a280af053b2ffe96195e%5EstateIN-5%2C-4%5Eopened_atRELATIVELT%40dayofweek%40ago%405%5Eactive%3Dtrue&sysparm_fields=number"
    snowToken=`getCredentialsToken snow-consultas-prd` 
    snowToken=$(echo ${snowToken} | base64 -d)
    local listChangeOrder=''   

    listChangeOrder=$(curl --request GET \
                           --insecure \
                           --url $snowServer \
                           --header 'authorization: Basic '$snowToken'' \
                           --header 'cache-control: no-cache' 2>/dev/null | jq -r ".result[].number")

    if [ "$listChangeOrder" != "" ];then
        infoMsg 'snow.sh->cleanupChange : Oba change order encontradas para expurgo de inatividade'
        echo "Lista : $listChangeOrder"
        for ln in $listChangeOrder; do
            infoMsg 'snow.sh->cleanupChange : Cancelando '${ln}' '
            echo "Implantar chamada a api de cancelamento"
        done
    else
        infoMsg 'snow.sh->cleanupChange : Ops sem change order para expurgo de inatividade'
    fi
}

# /**
# * getGroupsUser
# * Método que consulta os grupos de um usuário
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
getGroupsUser(){
    snowToken=`getJwtToken`
    snowServerGetGroupUser="$snowServer/users?logon=$requestedBy"
    local listGroupsNotUse='Brazil ITSM Dashboard|Exp ITIL|Exp Request Approval|Brazil DevSecOps Developers|BR_Rundeck_users|BR_Rundeck_executors|APM - Application Owners'

    if [ "$requestedBy" == "" ]; then
        errorMsg 'snow.sh->get-groups-user : Request by nao informado, impossivel continuar. Exemplo --requested-by=sof5305'
        exit 1
    fi 

    listGroups=$(curl --request GET \
                      --insecure \
                      --url $snowServerGetGroupUser \
                      --header 'authorization: Bearer '$snowToken'' \
                      --header 'cache-control: no-cache' 2>/dev/null | jq -r '.groups | map(.) | join(";") + ";"' | sort | uniq | egrep -v "$listGroupsNotUse")

    if [ "$listGroups" != "" ];then
        echo $listGroups
    fi
}

# /**
# * getDetailsGearr
# * Método que consulta os dados do gearr de uma aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
getDetailsGearr(){
    snowServer="$endpointSnow/now/table/cmdb_ci_business_app?sysparm_query=u_reported_countryLIKEBrazil%5EORu_countryLIKEBrazil%5EORu_countryLIKEPeru%5EORu_countryLIKEColombia%5EORu_reported_countryLIKEPeru%5EORu_reported_countryLIKEColombia%5EORu_regionLIKELATAM%5EORu_regionNOT%20LIKESP%20LATAM%5Eu_application_id%3D$gearrId&sysparm_limit=1"
    snowToken=`getCredentialsToken snow-consultas-prd` 
    snowToken=$(echo ${snowToken} | base64 -d)
    local detailsGearr=''

    if [ "$gearrId" == "" ]; then
        errorMsg 'snow.sh->get-details-gearr : Gearr Id by nao informado, impossivel continuar. Exemplo --gearr-id=123456'
        exit 1
    fi

    detailsGearr=$(curl --request GET \
                        --insecure \
                        --url $snowServer \
                        --header 'authorization: Basic '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null | jq -r '.result[].name , .result[].u_dq_score_percentage, .result[].u_network_type' | tr '\n' ';' )

    if [ "$detailsGearr" != "" ];then
        echo $detailsGearr
    fi
}

# /**
# * getProblems
# * Método que consulta os dados de problemas da aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Joao Paulo Bastos L. <joao.leite2@br.experian.com>
# * @return 
# */
getProblems(){
    snowToken=`getJwtToken`
    snowServerProblems="$snowServer/applications/$gearrId?includeProblems=true" 

    if [ "$gearrId" == "" ]; then
        errorMsg 'snow.sh->get-problem : Gearr Id by nao informado, impossivel continuar. Exemplo --gearr-id=123456'
        exit 1
    fi

    detailsProblems=$(curl --request GET \
                            --insecure \
                            --url $snowServerProblems \
                            --header 'authorization: Bearer '$snowToken'' \
                            --header 'cache-control: no-cache' 2>/dev/null | jq -r '[.problems[].number] | join(", ")')

    if [ "$detailsProblems" != "" ]; then
        echo $detailsProblems
    fi     

}

# /**
# * getAWSaccountDetails
# * Método que consulta os dados de uma conta AWS no CMDB
# * @version $VERSION
# * @package DevOps
# * @author  Lucas Francoi <lucas.francoi@br.experian.com>
# * @return 
# */
getAWSaccountDetails(){
    
    snowToken=`getJwtToken`
    snowServerAws="$snowServer/accounts/$awsAccountID/aws" 

    if [ "$awsAccountID" == "" ]; then
        errorMsg 'snow.sh->get-aws-account-details : AWS ID  nao informado, impossivel continuar. Exemplo --aws-account=187739130313'
        exit 1
    fi

    statusResult=$(curl --request GET \
                        --insecure \
                        --url $snowServerAws \
                        --header 'authorization: Bearer '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null)


    checkResult=$(echo "$statusResult" | jq -r ".")
    if [ "$checkResult" = "" ]; then
        errorMsg 'snow.sh->get-aws-account-details : AWS ID Account nao encontrado no CMDB'
        exit 1
    fi   

    if [ "$fieldName" != "" ]; then
        echo $statusResult | jq -r ".$fieldName"
    else
        echo $statusResult | jq -r '.'
    fi
}


# /**
# * getFullDetailsGearr
# * Método que consulta os dados do gearr de uma aplicação
# * @version $VERSION
# * @package DevOps
# * @author  Marcelo L. Oliveira <marcelo.oliveira@br.experian.com>
# * @return json
# */
getFullDetailsGearr(){

    snowToken=`getJwtToken`
    snowServerGearr="$snowServer/applications/$gearrId"

    if [ "$gearrId" == "" ]; then
        errorMsg 'snow.sh->get-full-details-gearr : Gearr Id by nao informado, impossivel continuar. Exemplo --gearr-id=123456'
        exit 1
    fi

    detailsGearr=$(curl --request GET \
                        --insecure \
                        --url $snowServerGearr \
                        --header 'authorization: Bearer '$snowToken'' \
                        --header 'cache-control: no-cache' 2>/dev/null)

    if [ "$detailsGearr" != "" ];then
        echo $detailsGearr | jq '.'
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
        -a|--action)
            case "$2" in
               "") shift 2 ;;
                *) action=$2 ; shift 2 ;;
            esac ;;
        --verbose)
            case "$2" in
               "") shift 2 ;;
                *) verbose="$2" ; shift 2 ;;
            esac ;;
        --state)
            case "$2" in
               "") shift 2 ;;
                *) state="$2" ; shift 2 ;;
            esac ;;
#        --allstates)
#            case "$2" in
#               "") shift 2 ;;
#                *) allStates="$2" ; shift 2 ;;
#            esac ;;
        --requested-by)
            case "$2" in
               "") shift 2 ;;
                *) requestedBy="$2" ; shift 2 ;;
            esac ;;
        --template)
            case "$2" in
               "") shift 2 ;;
                *) template="$2" ; shift 2 ;;
            esac ;;              
        --business-service)
            case "$2" in
               "") shift 2 ;;
                *) businessService="$2" ; shift 2 ;;
            esac ;;       
        --category)
            case "$2" in
               "") shift 2 ;;
                *) category="$2" ; shift 2 ;;
            esac ;;
        --cmdb-ci)
            case "$2" in
               "") shift 2 ;;
                *) cmdbCi="$2" ; shift 2 ;;
            esac ;;
        --gearr-id)
            case "$2" in
               "") shift 2 ;;
                *) gearrId="$2" ; shift 2 ;;
            esac ;;
        --aws-account)
            case "$2" in
               "") shift 2 ;;
                *) awsAccountID="$2" ; shift 2 ;;
            esac ;;
        --justification)
            case "$2" in
               "") shift 2 ;;
                *) justification="$2" ; shift 2 ;;
            esac ;;
        --risk-impact-analysis)
            case "$2" in
               "") shift 2 ;;
                *) riskImpactAnalysis="$2" ; shift 2 ;;
            esac ;;
        --assignment-group)
            case "$2" in
               "") shift 2 ;;
                *) assignmentGroup="$2" ; shift 2 ;;
            esac ;;
        --assigned-to)
            case "$2" in
               "") shift 2 ;;
                *) assignedTo="$2" ; shift 2 ;;
            esac ;;
        --short-description)
            case "$2" in
               "") shift 2 ;;
                *) shortDescription="$2" ; shift 2 ;;
            esac ;;
        --description)
            case "$2" in
               "") shift 2 ;;
                *) description="$2" ; shift 2 ;;
            esac ;;
        --backout-plan)
            case "$2" in
               "") shift 2 ;;
                *) backoutPlan="$2" ; shift 2 ;;
            esac ;;
        --implementation-plan)
            case "$2" in
               "") shift 2 ;;
                *) implementationPlan="$2" ; shift 2 ;;
            esac ;;
        --u-test-results)
            case "$2" in
               "") shift 2 ;;
                *) testResult="$2" ; shift 2 ;;
            esac ;;
        --u-environment)
            case "$2" in
               "") shift 2 ;;
                *) uEnvironment="$2" ; shift 2 ;;
            esac ;;
        --u-sys-outage)
            case "$2" in
               "") shift 2 ;;
                *) uSysOutage="$2" ; shift 2 ;;
            esac ;;
        --u-related-incident)
            case "$2" in
               "") shift 2 ;;
                *) uRelatedIncident="$2" ; shift 2 ;;
            esac ;;
        --start-date)
            case "$2" in
               "") shift 2 ;;
                *) startDate="$2" ; shift 2 ;;
            esac ;;
        --end-date)
            case "$2" in
               "") shift 2 ;;
                *) endDate="$2" ; shift 2 ;;
            esac ;;
        --number-change)
            case "$2" in
               "") shift 2 ;;
                *) changeOrder="$2" ; shift 2 ;;
            esac ;;
        --number-ritm)
            case "$2" in
               "") shift 2 ;;
                *) numberRitm="$2" ; shift 2 ;;
            esac ;;
        --number-incident)
            case "$2" in
               "") shift 2 ;;
                *) numberIncident="$2" ; shift 2 ;;
            esac ;;
        --field-name)
            case "$2" in
               "") shift 2 ;;
                *) fieldName="$2" ; shift 2 ;;
            esac ;;
        --field-id)
            case "$2" in
               "") shift 2 ;;
                *) fieldId="$2" ; shift 2 ;;
            esac ;;
        --table-name)
            case "$2" in
               "") shift 2 ;;
                *) tableName="$2" ; shift 2 ;;
            esac ;;
        --close-code)
            case "$2" in
               "") shift 2 ;;
                *) closeCode="$2" ; shift 2 ;;
            esac ;;
        --close-notes)
            case "$2" in
               "") shift 2 ;;
                *) closeNotes="$2" ; shift 2 ;;
            esac ;;
        --work-start)
            case "$2" in
               "") shift 2 ;;
                *) workStart="$2" ; shift 2 ;;
            esac ;;
        --work-end)
            case "$2" in
               "") shift 2 ;;
                *) workEnd="$2" ; shift 2 ;;
            esac ;;
        --check-planned-window)
            case "$2" in
               "") checkPlannedWindow='true' ; shift 2;;
                *) checkPlannedWindow='true' ; shift 2;;
            esac ;;
        --all-states)
            case "$2" in
               "") allStates='true' ; shift 2;;
                *) allStates='true' ; shift 2;;
            esac ;;
        --ping) getPing ;;
        --help) usage ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ "$piaasEnv" == "prod" ]; then
    snowServer="https://piaas-itil-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-itil/v1"
else
    snowServer="https://piaas-itil-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-itil/v1"
fi


# Executa ações 
case $action in
    create-change)
       createChange;;
    status-change)
       statusChange;;
    close-change)
       closeChange;;
    cleanup-change)
       cleanupChange;;
    get-change-open-category)
       getChangeOrderOpenCategory;;
    get-groups-user)
        getGroupsUser;;
    get-aws-account-details)
        getAWSaccountDetails;;
    get-details-gearr)
        getDetailsGearr;;
    get-full-details-gearr)
        getFullDetailsGearr;;    
    status-request)
        statusRequest;;
    status-incident)
        statusIncident;;
    close-request)
       closeRequest;;
    get-request-auto-implement)
        getRequestAutoImplement;;
    get-field-reference)
        getFieldReference;;
    get-problems)
        getProblems;;
    *)
        errorMsg 'snow.sh : Opcao para o service now '${action}' ainda nao implementado :('
        exit 1
    ;;
esac
