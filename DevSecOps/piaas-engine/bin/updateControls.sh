#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           updateControls.sh
# * @version        $VERSION
# * @description    Script que atualiza controles DevSecOps
# * @copyright      2021 &copy Serasa Experian
# *
# * @version        1.0.0
# * @change         - [ADD] Script que atualiza controles DevSecOps
# * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @dependencies   
# * @date           25-06-2021
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

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * mountPsaUser
# * Define o user do mount do Psa
# */
mountPsaUser="$1"

# /**
# * mountPsaPassword
# * Define a senha do mount do Psa
# */
mountPsaPassword="$2"

# /**
# * psaRepo
# * Define a url do repo psa-reports
# */
psaRepo="ssh://git@code.br.experian.local/code/EDVP/psa-reports.git"

# /**
# * goLiveDateOk
# * Define se o goLiveDate esta dentro de 90 dias
# */
goLiveDateOk=""

# /**
# * psaStatusAllowed
# * Define se o status PSA eh permitido
# */
psaStatusAllowed=""

# /**
# * Funções
# */

# /**
# * validateGoLiveDate
# * Método que verifica a validade do go live date no PSA
# * @package DevOps
# */
validateGoLiveDate() {
    goLiveDate="$1"
    goLiveDateEpoch=$(date -d "$goLiveDate" +"%s")
    goLiveDateLimit=$(date -d "$goLiveDate +90 days" +"%s")
    actualDate=$(date +"%s")

    if [ $goLiveDateLimit -lt $actualDate ]; then
        goLiveDateOk="false"
    else
        goLiveDateOk="true"
    fi
}

# /**
# * validateStatus
# * Método que verifica os status permitidos do PSA
# * @package DevOps
# */
validateStatus() {
    receivedPsaStatus="$1"
    permitedStatus="Assessment Not Needed,Go Live Approved,Go Live Approved - Contains Issues"
    IFS=',' read -ra statusList <<< $permitedStatus

    for i in "${statusList[@]}"; do
        if [ "$receivedPsaStatus" == "$i" ]; then
            psaStatusAllowed="true"
            break
        else
            psaStatusAllowed="false"
        fi
    done    
    
}

# /**
# * updatePsa
# * Método que realiza o update do psa
# * @package DevOps
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @parm    
# * @return  true | false
# */
updatePsa() {
    local credentialsFile=$(mktemp).conf
    local pathReport="/opt/infratransac/core/psa"
    local reportPsa="Projects-$(date --date=-1day +%m_%d_%Y).csv"
    local reportPsaNew="report-psa-normalizado.csv"
    local GEARR_ID=""
    local GEARR_LIST=""
    local PROJECT_NAME=""
    local PROJECT_ID=""
    local PROJECT_STATUS=""
    local TARGET_GO_LIVE_DATE=""
    local APPLICATION_NAME=""

    infoMsg 'updateControls.sh->updatePsa : Iniciando updatePsa' 

    echo "username=$mountPsaUser" >> $credentialsFile
    echo "password=$mountPsaPassword" >> $credentialsFile
    echo "domain=EXPERIANBR" >> $credentialsFile

    infoMsg 'updateControls.sh->updatePsa : Fazendo montagem de diretorio //ALNDATA1.ena.us.experian.local/Luckenbach'
    if ! sudo /bin/mount -t cifs -o credentials=$credentialsFile //ALNDATA1.ena.us.experian.local/Luckenbach /mnt/archer; then
        errorMsg 'updateControls.sh->updatePsa : Falha na montagem de diretorio //ALNDATA1.ena.us.experian.local/Luckenbach'
        rm -f $credentialsFile
        exit 1
    else
        ls -lha /mnt/archer/Pipeline
    fi

    infoMsg 'updateControls.sh->updatePsa : Recuperando /mnt/archer/Pipeline/'$reportPsa' em '$pathReport''
    if ! [[ -f "/mnt/archer/Pipeline/$reportPsa" ]]; then
        errorMsg 'updateControls.sh->updatePsa : Arquivo /mnt/archer/Pipeline/'$reportPsa' nao localizado'
        sudo umount /mnt/archer
        rm -f $credentialsFile
        exit 1
    else
        ls -lha "/mnt/archer/Pipeline/$reportPsa"
        rm -f "$pathReport/$reportPsa"
        cp -fv "/mnt/archer/Pipeline/$reportPsa" "$pathReport/$reportPsa"

        infoMsg 'updateControls.sh->updatePsa : Equalizando arquivo original '$pathReport'/'$reportPsa''
        sed -i 's/"//g' "$pathReport/$reportPsa"
        sed -i "1d" "$pathReport/$reportPsa"

        infoMsg 'updateControls.sh->updatePsa : Desmontando /mnt/archer/ e limpando credentials'
        sudo umount /mnt/archer
        rm -f $credentialsFile
    fi

    infoMsg 'updateControls.sh->updatePsa : Iniciando a geracao do '$reportPsaNew''
    > "/tmp/$reportPsaNew"
    local qtdLinhas=$(cat "$pathReport/$reportPsa" |wc -l)
    local qtdNormalizados=0

    while read linha; do
        qtdNormalizados=$(($qtdNormalizados+1))
        GEARR_ID=""
        GEARR_LIST=""
        PROJECT_NAME=""
        PROJECT_ID=""
        PROJECT_STATUS=""
        TARGET_GO_LIVE_DATE=""
        APPLICATION_NAME=""

        infoMsg 'updateControls.sh->updatePsa : Normalizando ( '$qtdNormalizados'/'$qtdLinhas' )' 
        echo "Processando linha: $linha"

        GEARR_LIST=$(echo $linha | cut -d',' -f1| sed -e 's/;/ /g')
        PROJECT_NAME=$(echo $linha | cut -d',' -f2)
        PROJECT_ID=$(echo $linha | cut -d',' -f3)
        PROJECT_STATUS=$(echo $linha | cut -d',' -f4)
        TARGET_GO_LIVE_DATE=$(echo $linha | cut -d',' -f5)
        APPLICATION_NAME=$(echo $linha | cut -d',' -f6)

        if [ "$GEARR_LIST" != "" ]; then
            validateGoLiveDate "$TARGET_GO_LIVE_DATE"
            validateStatus "$PROJECT_STATUS"
            if [ "$goLiveDateOk" == "true" ] && [ "$psaStatusAllowed" == "true" ]; then
                for ln in $GEARR_LIST
                do
                    GEARR_ID=$ln
                    echo "GEARR_ID : $GEARR_ID"
                    echo "PROJECT_NAME : $PROJECT_NAME"
                    echo "PROJECT_ID : $PROJECT_ID"
                    echo "PROJECT_STATUS : $PROJECT_STATUS"
                    echo "TARGET_GO_LIVE_DATE : $TARGET_GO_LIVE_DATE"
                    echo "APPLICATION_NAME : $APPLICATION_NAME"
                    echo "$GEARR_ID,$PROJECT_NAME,$PROJECT_ID,$PROJECT_STATUS,$TARGET_GO_LIVE_DATE,$APPLICATION_NAME" >> "/tmp/$reportPsaNew"
                done
            else
                warnMsg 'updateControls.sh->updatePsa : Gearr ID '$PROJECT_ID' da aplicacao '$APPLICATION_NAME' esta com a go live date fora de prazo ou com status nao permitido. Ignorando...'
                echo "Validacao go live resultou em $goLiveDateOk"
                echo "Validacao psa status allowed resultou em $psaStatusAllowed"
            fi
        else
            warnMsg 'updateControls.sh->updatePsa : Gearr ID nao existe na linha analizada, ignorando ...'
        fi
    done < "$pathReport/$reportPsa"

    infoMsg 'updateControls.sh->updatePsa : Atualizando lista '$pathReport'/'$reportPsaNew'' 
    sed -i 's/;/ /g' "/tmp/$reportPsaNew"
    sed -i "s/'/ /g" "/tmp/$reportPsaNew"
    cp -f "/tmp/$reportPsaNew" "$pathReport/$reportPsaNew"
    
    infoMsg 'updateControls.sh->updatePsa : Finalizando updatePsa' 

    infoMsg 'updateControls.sh->updatePsa : Enviando PSA para o repo psa-reports' 

    pathCloneTemp=$(mktemp -d)  
    git clone $psaRepo $pathCloneTemp
    cat "/tmp/$reportPsaNew" > "$pathCloneTemp/$reportPsaNew"
    cd $pathCloneTemp
    git add --all
    git commit -m "update ps in `date`"
    git push origin master
    rm -rf $pathCloneTemp

    
    infoMsg 'updateControls.sh->updatePsa : PSA enviado para o repo psa-reports' 
     
}

# /**
# * updateOpenshiftGetInfos
# * Método que realiza o update do Openshift Get Infos
# * @package DevOps
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
# * @parm    
# * @return  true | false
# */
#updateOpenshiftGetInfos() {
#    infoMsg 'updateControls.sh->updateOpenshiftGetInfos : Iniciando updateOpenshiftGetInfos' 

#    cd /opt/deploy/openshift-get-infos/ && python3.6 app.py /opt/infratransac/jenkins/jobs/core/builds/

#    infoMsg 'updateControls.sh->updateOpenshiftGetInfos : Finalizando updateOpenshiftGetInfos' 
#}

# /**
# * Start
# */

updatePsa

#updateOpenshiftGetInfos

echo "Updates finalizados!!!"
