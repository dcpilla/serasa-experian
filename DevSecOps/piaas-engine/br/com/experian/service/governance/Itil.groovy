import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.DumperOptions
import java.util.Calendar
import java.time.YearMonth
import java.text.SimpleDateFormat
import java.nio.charset.StandardCharsets

/**
 * setDetailsGearr
 * Método pega detalhes do gearr da aplicação 
 * @version 8.27.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *          Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
 * @return  $versionApp
 **/
 def setDetailsGearr() {

    def searchGearr = ''
    def gearrId = ''
    def validateGearr = ''
    def flagValidation = false

    echo "Invoking function setDetailsGearr"

    try {
        if ( changeorderConfigItens != "" ) {
            loadGearrInfo = sh(script: "${packageBasePath}/service/governance/snow.sh --action=get-full-details-gearr --gearr-id=${changeorderConfigItens}", returnStdout: true)
            gearrDetails = utilsJsonLib.jsonParse(loadGearrInfo.toString())
        }
     
        if ( gearrDetails == "" || gearrDetails == null ) {
            utilsMessageLib.warnMsg("Gearr '${changeorderConfigItens}' not found in base :(") 
        } else {
            echo "Gearr ${changeorderConfigItens} found"
                        
            validateGearr = gearrDetails.installStatus
            
            if ( validateGearr == '13' || validateGearr == '14' ) {
                flagValidation = true
            }       
            
            // NIKEDEVSEC-2986 - Get gearr criticality.          
            piaasMainInfo.gearr_business_criticality = gearrDetails.businessCriticality

            piaasMainInfo.gearr_id = changeorderConfigItens
            changeorderConfigItens = gearrDetails.name
            changeorderConfigItens = changeorderConfigItens.trim()
            piaasMainInfo.gearr_application_name = gearrDetails.name

            toolsScore.gearr.score = gearrDetails.dqScorePercentage.toFloat()
            piaasMainInfo.gearr_score = gearrDetails.dqScorePercentage

            piaasMainInfo.gearr_u_network_type = gearrDetails.networkType

            serviceGovernanceApplication.piaasEntityApi("GEARR")
            serviceGovernanceScore.scorePost(piaasMainInfo.gearr_score, "SERVICE_NOW", "score-itil-gearr")

        /** Comentando código abaixo devido a solicitação do Fernando S. Pereira na REQ: REQ3024301 (RITM3225298)
            if ( changeorderMavRoomGroups.contains(gearrDetails.result[0].managed_by_group.value) ) {
                if ( ( piaasMainInfo.gearr_business_criticality.toLowerCase() == "highly critical" ) || ( piaasMainInfo.gearr_business_criticality.toLowerCase() == "critical" ) ) {
                    echo "Gearr ${piaasMainInfo.gearr_id} - ${changeorderConfigItens} mav room configured"
                    changeorderMavRoom = 'yes'
                    piaasMainInfo.mav_room_configured = 'true'
                }
            } **/

            //Linha abaixo alterada devido a solicitação do Mauricio Rocha na REQ: REQ3414127 (RITM3640490)
            if ( ( changeorderBrScanGroups.contains(gearrDetails.managedByGroup) ) && ( ( piaasMainInfo.gearr_business_criticality.toLowerCase() == "highly critical" ) || ( piaasMainInfo.gearr_business_criticality.toLowerCase() == "critical" ) ) ) {
            	echo "Gearr ${piaasMainInfo.gearr_id} - ${changeorderConfigItens} brscan team configured"
            	changeorderBrScan = 'yes'
            }

            toolsScore.gearr.analysis_performed  = 'true'
            piaasMainInfo.gearr_analysis_performed = 'true'

            if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
                changeorderTestResult = changeorderTestResult +
                                        "**** Gearr - [ Score: " + piaasMainInfo.gearr_score + " ]{/n}{/n}";
            }
        }
    } catch (err) {
        echo "${err}"
        utilsMessageLib.warnMsg("Erro for setDetailsGearr") 
    }

    if ( ( language != "cobol" ) && ( language != "assembly" ) && ( language != "bms" ) && ( language != "c++" ) ) {
        if ( gearrDetails != "" && gearrDetails != null ) {
            if ( "${gearrDetails.managedByGroup}" == "" ) {
                utilsMessageLib.errorMsg("Managed_by_group not informed in Gearr, please access SNOW and add value on field.")
                echo ""
                currentBuild.description = "Managed_by_group not informed in Gearr. Impossible to proceed with the pipeline."
                errorPipeline = "Managed_by_group not informed in Gearr, please access SNOW and add value on field."
                helpPipeline = "Verifique no Gearr, se o campo Managed By Group está preenchido corretamente, caso não esteja, favor realizar o preenchimento para a esteira executar corretamente."
                piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSGEARR_001'
                echo "Solucao: ${helpPipeline}"
                controllerNotifications.cardStatus('helpPipeline')
                throw err
            }
        }
    }

    if ( flagValidation ) {
        utilsMessageLib.errorMsg("Gearr informed is decommissioned or divested. Aborting pipeline.")
        throw new Exception("Gearr informed is decommissioned or divested. Aborting pipeline.")
    }
}

/**
 * setDetailsProblems
 * Método pega detalhes do problemas da aplicação
 * @version 8.29.0
 * @package DevOps
 * @author  pauloricassio.dossantos@br.experian.com
 *          
 * @return  $versionApp
 **/
def setDetailsProblems() {
    def dataProblems = ''

    echo "Invoking function setDetailsProblem"

    try {
        if (!piaasMainInfo.gearr_id) {
            echo "piaasMainInfo.gearr_id is empty, setting scores to 0"
            toolsScore.problem.analysis_performed = 'true'
            toolsScore.problem.score = 0
            piaasMainInfo.problem_analysis_performed= 'true'
            piaasMainInfo.problem_score = toolsScore.problem.score
            
        } else {
            dataProblems = sh(script: "${changeorderClient} --action=get-problems --gearr-id=${piaasMainInfo.gearr_id}", returnStdout: true).trim()
            dataProblems = dataProblems.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

            def problemCodes = dataProblems.tokenize()

            if ( dataProblems.isEmpty() || !problemCodes.any { it ==~ /PRB\d{7}/ }) {
                echo "Application ${piaasMainInfo.gearr_id} - ${piaasMainInfo.name_application} does not have problem in snow"
                toolsScore.problem.analysis_performed = 'true'
                toolsScore.problem.score = 100
                piaasMainInfo.problem_analysis_performed= 'true'
                piaasMainInfo.problem_score = toolsScore.problem.score
            } else {
                echo "Application ${piaasMainInfo.gearr_id} - ${piaasMainInfo.name_application} has problems in snow"
                echo "Problema(s) encontrado(s) para o gearr id da aplicação: ${dataProblems}"
                echo "Regras : Priority = - Critical, High | State = Open, Pending*, Wip, Resolved"
                echo "Gearr ${piaasMainInfo.gearr_id} - ${piaasMainInfo.name_application} mav room configured"
                changeorderMavRoom = 'yes'
                piaasMainInfo.mav_room_configured = 'true'
                toolsScore.problem.analysis_performed = 'true'
                toolsScore.problem.score = 0
                piaasMainInfo.problem_analysis_performed = 'true'
                piaasMainInfo.problem_score = toolsScore.problem.score
                controllerNotifications.houstonWeHaveAProblem()
            }
        }    
    } catch (err) {
        errorMsg ("Error in read problems in snow")
        toolsScore.problem.analysis_performed = 'true'
        toolsScore.problem.score = 0
        piaasMainInfo.problem_analysis_performed = 'true'
        piaasMainInfo.problem_score = toolsScore.problem.score
    }

    serviceGovernanceScore.scorePost(piaasMainInfo.problem_score, "SERVICE_NOW", "score-itil-problem")
}

/**
 * changeOrderValidation
 * Método execução da validação de change order
 * @version 8.34.0
 * @package DevOps
 * @author  Fabio P. Zinato<fabio.zinato@experian.com>
 * @return  true | false
 **/
def changeOrderValidation() {
    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_000'
    piaasRunURI = ''

    if ( piaasEnv == "prod" ) {
        piaasRunURI = "https://piaas-run-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-run/v1/change-orders/"
    } else {
        piaasRunURI = "https://piaas-run-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-run/v1/change-orders/"
    }

    if ((gitBranch.contains("master")) && ((type == "lib") || (type == "parent") || (type == "test"))) {
        utilsMessageLib.warnMsg("A aplicação é do tipo ${type}, não é necessário uma CHG.")
    } else if (gitBranch.contains("master")) {
        if ( changeorderNumberProduction != "" ) {
            changeorderNumber = changeorderNumberProduction
            utilsMessageLib.infoMsg("O número da Change Order informada é ${changeorderNumber}.")

            piaasRunJwtToken = utilsIamLib.getJwtToken()
            changeOrderResponse = utilsRestLib.httpGetBearer(piaasRunURI + changeorderNumber + "/validate", piaasRunJwtToken, "change não compliance")

            if ( changeOrderResponse.contains("false") ) {
                utilsMessageLib.errorMsg("Change Order não compliance. Impossível prosseguir.")
                utilsMessageLib.errorMsg("Retorno da validação: ${changeOrderResponse}")
                throw new Exception("Change Order não compliance. Impossível prosseguir.")
            }
            
        } else {
            utilsMessageLib.errorMsg("Change Order não informada. Impossível prosseguir.")
            errorPipeline = "Change Order não informada. Impossível prosseguir."
            helpPipeline = "Você deve informar uma Change Order para prosseguir."
            echo "Solucao: ${helpPipeline}"
            
            if (gitAuthorEmail != "") {
                controllerNotifications.cardStatus('helpPipeline')
            }

            throw new Exception(errorPipeline)
        }

        utilsMessageLib.infoMsg("Justificativa para o deploy: ${gitMsgCommit}")
        changeorderWorkStart = new Date().format("yyyy-MM-dd HH:mm:ss")
        piaasMainInfo.change_order_work_start = changeorderWorkStart
        echo "Implementação iniciada em ${changeorderWorkStart}"

    }

}

/**
 * validateAssignmentGroup
 * Método valida o assignment group ITIL do usuário executor
 * @version 8.34.0
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def validateAssignmentGroup() {
    logonUser = sh(script: "${packageBasePath}/utils/getLogonUser.sh ${gitAuthorEmail}", returnStdout: true)
    logonUser = logonUser.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

    userGroups = sh(script: "${changeorderClient} --action=get-groups-user --requested-by=${logonUser}", returnStdout: true)

    flagTest = false

    switch ( type.toLowerCase() ) {
        case "devops-tool":
            if ( userGroups.contains("DevSecOps PaaS Brazil") ) {
                flagTest = true
            }
            break
        default:
            flagTest = true
    }

    if ( flagTest ) {
        utilsMessageLib.infoMsg("Você ${logonUser} está autorizado a utilizar o tipo ${type}.")
    } else {
        utilsMessageLib.errorMsg("Você ${logonUser} não está autorizado a utilizar o tipo ${type}.")
        piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSTYPE_001'
        helpPipeline = "Altere o tipo de aplicação no piaas.yml para um tipo valido e do qual você possa utilizar."

        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }

        throw new Exception(helpPipeline)
    }

}

return this
