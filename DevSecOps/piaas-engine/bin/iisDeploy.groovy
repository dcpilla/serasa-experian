#!/usr/bin/env groovy

/**
*
* Este arquivo é parte do projeto DevOps Serasa Experian 
*
* @package        DevOps
* @name           iisDeploy.groovy
* @version        1.0
* @description    Script que faz deploy no iis
* @author         João Paulo Bastos Leite <Joao.Leite2@br.experian.com>
* @date           05-Jun-2020
*
**/ 

import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurper
import org.yaml.snakeyaml.Yaml
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL
import java.io.*
import java.util.Map
import jenkins.util.*
import jenkins.model.*
import static groovy.io.FileType.FILES
import hudson.FilePath;
import hudson.FilePath;
import groovy.io.FileType;
import hudson.model.User;

/**
 * Declaração Variaveis
 **/

 /**
 * Define as variaveis utilizadas pela classe DashBoardCore
 **/

class DashBoardCore {

    String author = ""
    String gearr_id = ""
    String name_application = ""
    String environment_deploy = ""
    String type_application = ""
    String date_execution_start = ""
    String date_execution_end = ""
    String change_order = ""
    String pipeline_code_execution = ""
    String pipeline_status = ""
    String pipeline_code_error = ""
    String change_order_work_start = ""
    String change_order_work_end = ""
    String score = ""

}    

/**
 * Define as variaveis utilizadas no job
 **/
def urlPackageNexus   = ''
def changeorderNumber = ''
def deployHost        = ''
def applicationName   = ''
def nameArtifactory   = ''
def environmentName   = ''
def gearrId           = ''
def triggerTestHomolog= ''
searchGearr           = ''
group_validate        = 'SIST_IA_OPERACOESDETI'
current_user          = ''
urlBaseJenkins        = 'http://spobrjenkins:8080/view/DevSecOps/job/IIS.Deploy/'
respInput             = ''
iisEnvironments       = ''
iisHostsDeploy        = ''
iisSite               = ''
keepGoing             = true
numberAttempts        = 1


/**
 * changeorder variables
 * Define as variaveis utilizadas para changeorder
 **/
flagChangeOrderCreated = 0
changeorderAuthorized = 0 
changeorderNumber = ''
changeorderJustification = ''
changeorderTemplate = 'Brazil DevSecOps Continuous Deployment .NET'
changeorderHowto = 'https://pages.experian.com/pages/viewpage.action?pageId=1033936437'
changeorderCreatedState = '-5'
changeorderBusinessService = 'Other'
changeorderCategory = 'Applications Software'
changeorderAssignmentGroup = ''
changeorderAssignedTo = ''
changeorderSummary = '[DevSecOps Continous Deployment .NET]'
changeorderDescription = ''
changeorderTestResult = ''
changeorderUEnvironment = 'Production'
changeorderUSysOutage = 'no'
changeorderStartDate= '' 
changeorderEndDate=''
changeorderRiskImpactAnalysis = ''
changeorderRollout = 'O deploy será feito via job http://spobrjenkins:8080/view/DevSecOps/job/IIS.Deploy/ pelo time de SIST_IA_OPERACOESDETI com os parametros informados pelo solicitante no campo de descrição'
changeorderRollback = 'Em caso da implementação não surtir o efeito esperado, deverá ser executado  um novo deploy da aplicação. Este deploy poderá ser de uma nova versão com os devidos ajustes ou com a versão anterior.'
changeorderConfigItens = ''
changeorderState = ''
changeorderRequirements = ''
changeorderCloseCode='successful'
changeorderCloseNotes=''
changeorderWorkStart=''
changeorderWorkEnd=''
changeorderClient = '/opt/infratransac/core/br/com/experian/service/governance/snow.sh'


/**
 * etl
 * Método que etorna o status da execução
 * @version 1.0
 * @author  Paulo Ricassio C. dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/

def etl(def statusExecution, DashBoardCore dashBoardCore) {
    def etlDir = ''
    def etlFile = ''
    def stringEtl = ''
    
    dashBoardCore.setPipeline_status(statusExecution)

    if (statusExecution == 'success') {
        dashBoardCore.setPipeline_code_error('00')
        stringEtl = new JsonBuilder(dashBoardCore).toString()
        etlDir = '/opt/infratransac/core/etl/'
        etlFile = etlDir + UUID.randomUUID().toString() + '.etl'
        //println stringEtl
        writeFile(file: etlFile, text: stringEtl)
    } else if (statusExecution == 'error') {
        stringEtl = new JsonBuilder(dashBoardCore).toString()
        etlDir = '/opt/infratransac/core/errors/'
        etlFile = etlDir + UUID.randomUUID().toString() + '.error'
        //println stringEtl
        writeFile(file: etlFile, text: stringEtl)
    }
}

/**
 * getCurrentUser
 * Método retorna o usuário que disparou o job
 * @version 1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def getCurrentUser(){
    wrap([$class: 'BuildUser']){
        return env.BUILD_USER_ID
    }
}

/**
 * isAllowed
 * Método que verifica se execução do job é permitida para usuário e grupo de permissão
 * @version 1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def isAllowed(def current_user, def group_validate) { 
    User u = User.get(current_user);
    return u.getAuthorities().find{it.equalsIgnoreCase(group_validate)} != null
}

/**
 * setIISEnvironments
 * Método que seta os site do iss por ambiente
 * @version 1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  
 **/
def setIISEnvironments() { 
    if ( environmentName == "DE" ) {
        iisEnvironments = "webdesenv.serasa.intranet:spobriisde10" + "\n" 
        iisEnvironments = iisEnvironments + "webdesenv.serasa.intranet:spobriisde11" + "\n" 
    } else if ( environmentName == "HI" ) {
        iisEnvironments = "webhomolog.serasa.intranet:spobriishi10,spobriishi11" + "\n" 
        iisEnvironments = iisEnvironments + "webhomolog.serasa.intranet:spobriishi12" + "\n"
        iisEnvironments = iisEnvironments + "webhomolog.serasa.intranet:spobriishi13" + "\n"
        iisEnvironments = iisEnvironments + "applint01hi.serasa.intranet:spobriishi13" + "\n"
    } else if ( environmentName == "HE" ) {
        iisEnvironments = "gw-homologa.serasa.com.br:spobriishe10,spobriishe11" + "\n" 
        iisEnvironments = iisEnvironments + "gw-homologa.serasa.com.br:spobriishe12" + "\n"
        iisEnvironments = iisEnvironments + "gw-homologa.serasa.com.br:spobriishe13" + "\n"
        iisEnvironments = iisEnvironments + "gw-homologacert.serasa.com.br:spobriishe10,spobriishe11" + "\n"
    } else if ( environmentName == "PI" ) {
        iisEnvironments = "lb02.serasa.intranet:spobriispi10,spobriispi11" + "\n"
        iisEnvironments = iisEnvironments + "LB02:spobriispi12,spobriispi13" + "\n"
        iisEnvironments = iisEnvironments + "LB02:spobriispi14,spobriispi15" + "\n"
    } else if ( environmentName == "PE" ) {
        iisEnvironments = "sitenet05.serasa.com.br:spobriispe10,spobriispe11" + "\n"
        iisEnvironments = iisEnvironments + "sitenet05.serasa.com.br:spobriispe12,spobriispe13" + "\n"
        iisEnvironments = iisEnvironments + "Sitenet55:spobriisgnet10,spobriisgnet11,spobriisgnet12,spobriisgnet13" + "\n"
        iisEnvironments = iisEnvironments + "Sitenet55:spobriisclaro10,spobriisclaro11" + "\n"
        iisEnvironments = iisEnvironments + "sitenet05.serasa.com.br:spobriispe14,spobriispe15" + "\n"
        
    }
}

/**
 * inputUser
 * Método recebe interação de usuário 
 * @version 1.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          defaultValue   - Valor default do campo
 *          description    - Decrição da pergunta
 *          field          - Nome do campo
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 *          timeoutExit    - Parametros para tratar tipo de saida do timeout
 * @return  respInput
 **/
def inputUser(def question, def defaultValue, def description, def field, def inputTimeout, def timeoutExit='error') {
    respInput = ""
    try {
        timeout(time: inputTimeout, unit: 'SECONDS') {
            userInput = input(
                id: 'userInput', message: "${question}", parameters: [
                    [$class: 'TextParameterDefinition', defaultValue: "${defaultValue}", description: "${description}", name: "${field}"]
                ])
            respInput = userInput
        }
    } catch (err) {
        if ( timeoutExit == 'error' ){
            throw err
        }
    }
}

/**
 * selectedProperty
 * Método recebe interação de usuário via select box
 * @version 1.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          choices        - Valores do select box
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 * @return  respInput
 **/
def selectedProperty(def question, def choices, def field, def inputTimeout) {
    choices   =  choices.replaceAll(";", "\n")
    respInput = ""

    timeout(time: inputTimeout, unit: 'SECONDS') {
        userInput = input(
            message: "${question}", parameters: [choice(name: "${field}", choices: "${choices}")]
        )
    }

    respInput = userInput
}

/**
 * deploy
 * Método faz o controle e execução do deploy
 * @version 1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def deploy () {
    DashBoardCore dashBoardCore = new DashBoardCore()

    changeorderWorkStart   = new Date().format("yyyy-MM-dd HH:mm:ss")
    current_user   = getCurrentUser()
    setIISEnvironments()

    echo "Job iniciado por ${current_user} para o ambiente ${environmentName} - ${changeorderWorkStart} "

    if ( applicationName == "" ) {
        echo "Opsss, Parametro foi esquecido no start do job applicationName .... Impossivel prosseguir!"
        currentBuild.description = "Falta de parametro applicationName"
        throw err 
    }

    if ( urlPackageNexus == "" ) {
        echo "Opsss, Parametro foi esquecido no start do job urlPackageNexus .... Impossivel prosseguir!"
        currentBuild.description = "Falta de parametro urlPackageNexus"
        throw err 
    }

    if ( nameArtifactory == "" ) {
        echo "Opsss, Parametro foi esquecido no start do job nameArtifactory .... Impossivel prosseguir!"
        currentBuild.description = "Falta de parametro nameArtifactory"
        throw err 
    }

    if ( environmentName == "" ) {
        echo "Opsss, Parametro foi esquecido no start do job environmentName .... Impossivel prosseguir!"
        currentBuild.description = "Falta de parametro environmentName"
        throw err 
    }

    if ( gearrId == "" ) {
        echo "Opsss, Parametro foi esquecido no start do job gearrId .... Impossivel prosseguir!"
        currentBuild.description = "Falta de parametro gearrId"
        throw err 
    } else {
        searchGearr = sh(script: "/opt/infratransac/core/br/com/experian/service/governance/snow.sh --action=get-details-gearr --gearr-id=${gearrId}", returnStdout: true)
        searchGearr = searchGearr.replaceAll("\r", "").replaceAll("\t", "")
        
        if ( searchGearr == "" ) {
            echo "Gearr ID '${gearrId}' nao localizado .... Impossivel prosseguir ! :("
            currentBuild.description = "Gearr ID '${gearrId}' nao localizado"
            throw err
        } else {
            searchGearr = searchGearr.split(";")
            changeorderConfigItens = searchGearr[0]
            echo "Gearr ID ${gearrId} localizado " +  changeorderConfigItens
        }
    }

    if ( ( environmentName == "PI" ) || ( environmentName == "PE" ) ) {
        if ( changeorderNumber == "" ) {
            echo "Opsss, Para deploy em producao o parametro changeorderNumber deve ser informado .... Impossivel prosseguir!"
            currentBuild.description = "Falta de parametros changeorderNumber"
            throw err 
        }

        if (!isAllowed(current_user,group_validate)) {
            echo "Opsss te peguei, Usuario ${current_user} nao permitido para execução do job para ambientes produtivos.... Impossivel prosseguir!"
            currentBuild.description = "Usuario ${current_user} nao permitido para producao"
            throw err 
        } else {
           echo "Eba, O Usuario ${current_user} se encontra no grupo ${group_validate} vamos seguir com o deploy para producao"
        }

        currentBuild.description = "Pesquisando status change Order ${changeorderNumber} ..."
        changeorderState = sh(script: "${changeorderClient} --action=status-change --number-change=${changeorderNumber} --field-name=state --check-planned-window", returnStdout: true)
        changeorderState = changeorderState.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        echo "Status ${changeorderState} da change order ${changeorderNumber}"
        if ( changeorderState != "Implement" ) {
            echo "Opsss, change order ${changeorderNumber} ainda nao foi autorizada para implementação.... Impossivel prosseguir!"
            currentBuild.description = "Change Order ${changeorderNumber} nao autorizada"
            throw err
        } else {
            echo "Eba, change order  ${changeorderNumber} se encontra autorizada vamos seguir com o deploy para producao"
        }
    }

    echo "Pergunta: Escolha o site IIS de ${environmentName} para o deploy"
    selectedProperty("Escolha o site IIS para o deploy", iisEnvironments, "iisEnvironments", 180)
    iisEnvironments = respInput
    echo "Resposta: ${iisEnvironments}"

    echo "Pergunta: Site IIS para o deploy ${iisEnvironments} foi escolhido. Deseja continuar?"
    selectedProperty("Site IIS para o deploy ${iisEnvironments} foi escolhido. Deseja continuar?", "nao;sim", "startDeploy", 180)
    echo "Resposta: ${iisEnvironments}"
    if ( respInput == "nao" ) {
        echo "Deploy abortado por ${current_user}"
        currentBuild.description = "Deploy abortado por ${current_user}"
        throw err
    }
    
    echo "Iniciado deploy em ${environmentName} - ${iisEnvironments} o/"
    if ( ( environmentName == "PI" ) || ( environmentName == "PE" ) ) {
        echo "Detalhes [ Url: ${urlPackageNexus} | Change Order: ${changeorderNumber} ]"
    } else {
        echo "Detalhes [ Url: ${urlPackageNexus} ]"
    }

    iisEnvironments= iisEnvironments.split(":")
    iisSite        = iisEnvironments[0]
    iisHostsDeploy = iisEnvironments[1]
    iisHostsDeploy.split(',').each {
        echo "Site IIS para Deploy " + iisSite + " servidor " + it
        sh(script: "/opt/infratransac/core/bin/deploy.sh --target=ansible --runin=tower --job-id=611 --extra-vars='deployHost=${it} urlPackageNexus=${urlPackageNexus} applicationName=${applicationName} nameArtifactory=${nameArtifactory} site=${iisSite} environmentName=${environmentName}'", , returnStdout: false)
    }

    if ( ( environmentName == "HI" ) || ( environmentName == "HE" ) ) {
        echo "Pergunta: Deseja abrir uma change order para producao desta implantação"
        selectedProperty("Deseja abrir uma change order para producao desta implantação", "nao;sim", "openChangeOrder", 180)
        echo "Resposta: ${respInput}"
        if ( respInput == "sim" ) {
            echo "Pergunta: Qual a justificativa da implantação"
            inputUser("Qual a justificativa da implantação", "MAIOR QUE 30 CARACTERES", "THIS IS AN AUDIT POINT: The justification must contain the minimal information necessary to identify this implementation to a business request. 'Eg.: Alteration of web page XPTO according to Story 123 to add a new promotional banner'", "justException", 300)
            echo "Resposta: '${respInput}'"
            if ( respInput.length() < 30 ) {
                echo "Resposta menor que 30 caracteres"
                currentBuild.description = "Resposta menor que 30 caracteres"
                throw err
            }
            changeorderJustification = respInput
            changeorderJustification = changeorderJustification.toString().replace("\"", "\\n").replace("\n", "\\n").replaceAll("'", " ")

            def snowGroups = sh(script: "${changeorderClient} --action=get-groups-user --requested-by=${current_user}", returnStdout: true)
            snowGroups = snowGroups.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
            echo "Pergunta: Por favor, escolha seu grupo para abrir a change order?"
            selectedProperty("Por favor, escolha seu grupo para abrir a change order?", "${snowGroups}", "openChangeOrder", 100)
            echo "Answer informed: '${respInput}'"
            changeorderAssignmentGroup = respInput

            changeorderAssignedTo = current_user

            changeorderTestResult = "@@@FAVOR PREENCHER COM O LOG DA CONSOLE DO JENKINS DA SUA IMPLANTAÇÃO DE HOMOLOGAÇÃO@@@"
            changeorderDescription = "*** Esteira DevSecOps Continous Deployment .NET ***{/n}" +
                                     "{/n}" +
                                     "*** Detalhes da Aplicação{/n}" +
                                     "Score DevSecOps: N/A{/n}" +
                                     "Nome da aplicação no IIS : ${applicationName}{/n}" +
                                     "Site de produção : @@@FAVOR PREENCHER@@@{/n}" +
                                     "Url do pacote : @@@FAVOR PREENCHER@@@{/n}" +
                                     "Tipo aplicação : IIS{/n}" +
                                     "Linguagem : .NET{/n}" +
                                     "Versão: 1.0{/n}" +
                                     "Responsável pela homologação: ${current_user}{/n}" +
                                     "Obrigatoriedades: Veracode Anexado Atualizado" +
                                     "{/n}";
            changeorderDescription = changeorderDescription.toString().replace("{/n}", "\\n")

            echo "Abrindo change order para deploy em producao"
            while (keepGoing) {
                try {
                    changeorderNumber = sh(script: "${changeorderClient}  --action=create-change \
                                                                          --state=${changeorderCreatedState} \
                                                                          --template='${changeorderTemplate}' \
                                                                          --business-service='${changeorderBusinessService}' \
                                                                          --category='${changeorderCategory}' \
                                                                          --cmdb-ci='${changeorderConfigItens}' \
                                                                          --justification='${changeorderJustification}' \
                                                                          --risk-impact-analysis='${changeorderRiskImpactAnalysis}' \
                                                                          --assignment-group='${changeorderAssignmentGroup}' \
                                                                          --assigned-to='${changeorderAssignedTo}' \
                                                                          --short-description='${changeorderSummary}' \
                                                                          --description='${changeorderDescription}' \
                                                                          --backout-plan='${changeorderRollback}' \
                                                                          --implementation-plan='${changeorderRollout}' \
                                                                          --u-environment='${changeorderUEnvironment}' \
                                                                          --u-test-results='${changeorderTestResult}' \
                                                                          --u-sys-outage='${changeorderUSysOutage}' \
                                                                          --start-date='${changeorderStartDate}' \
                                                                          --end-date='${changeorderEndDate}' ", returnStdout: true)
                    changeorderNumber = changeorderNumber.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
                    echo "Clique no link e saiba quais são os procedimentos e orientações para conclusão da sua mudança ${changeorderHowto}"
                    echo "Sucesso na abertura da Change Order ${changeorderNumber}"
                    flagChangeOrderCreated = 1
                    keepGoing = false
                } catch (err) {
                    echo "Service desk is not available for integration try ${numberAttempts}, trying again in 60 seconds"
                    println("Descricao da Falha: " + err)
                    sleep(60)
                    numberAttempts = numberAttempts + 1
                }

                if ( numberAttempts == 5 ) {
                    echo "Erro na integracao com Service Now .... Impossivel abrir a change order!"
                    currentBuild.description = "Erro na integracao com Service Now"
                    throw err
                }
            }
        }
    }

    changeorderWorkEnd     = new Date().format("yyyy-MM-dd HH:mm:ss")
    changeorderCloseNotes  = "Implantação realizada por ${current_user}[${group_validate}] as ${changeorderWorkStart} evidencias do job de execucao " + urlBaseJenkins + currentBuild.number + '/console'
    if ( ( environmentName == "PI" ) || ( environmentName == "PE" ) ) {
    /*    sh(script: "${changeorderClient} --action=close-change \
                                           --number-change=${changeorderNumber} \
                                           --close-code='${changeorderCloseCode}' \
                                           --close-notes='${changeorderCloseNotes}' \
                                           --work-start='${changeorderWorkStart}' \
                                           --work-end='${changeorderWorkEnd}'", returnStdout: false)
    */

        currentBuild.description = "Change Order ${changeorderNumber} executada"
        
        try {
            def url = "https://prod-146.westus.logic.azure.com:443/workflows/b8dbac23eed7471fbb7dc7360021b2ae/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=K_mIgapc1kl2Z1-GKbtwRu1pNeDDRZNiqEsoubYQcyQ"     
            def payload = """
            {
                "ChangeOrder": "${changeorderNumber}",
                "Status": "Sucesso",
                "Application": "${gearrId} - ${changeorderConfigItens}",
                "ExecutionStart": "${changeorderWorkStart}",
                "ExecutionEnd": "${changeorderWorkEnd}",
                "Environment": "${environmentName}",
                "Severity": "Unknow",
                "Type": "IIS",
                "contents": [
                    {
                        "type": "text",
                        "text": "PipelineChange"
                    }
                ]
            }
            """

            def maxAttempts = 3
            def success = false
            
            for (int attempt = 1; attempt <= maxAttempts && !success; attempt++) {
                HttpURLConnection conn = null
                try {     
                    conn = new URL(url).openConnection() as HttpURLConnection
                    conn.setDoOutput(true)
                    conn.setRequestMethod("POST")
                    conn.setRequestProperty("Content-Type", "application/json")
                    conn.setRequestProperty( "charset", "utf-8")
                    conn.setRequestProperty("Content-Length", String.valueOf(payload.length()))
                    conn.setUseCaches(false)
                    conn.setConnectTimeout(5000)

                    def os = conn.getOutputStream()
                    os.write(payload.getBytes("utf-8"))
                    os.flush()
                    os.close()
            
                    def responseCode = conn.getResponseCode()
                    def responseMessage = conn.getResponseMessage()

                    if (responseCode == 202) {
                        println "POST request from OM to EGOC completed successfully in attempt ${attempt}!"
                        success = true
                    } else {
                        println "Attempt ${attempt}: Request failed - Return code ${responseCode} ${responseMessage}"
                    }
                } catch (SocketTimeoutException ste) {
                    println "Connection timeout on attempt ${attempt}"
                } catch (Exception e) {
                    println "Failed in attempt ${attempt}: ${e.message}"
                } finally {
                    if (conn != null) {
                        try {
                            conn.getInputStream().close()
                        } catch (Exception e) {

                        }
                        conn.disconnect()
                    }
                }
            }        
            
            if (!success) {
                println " All attempts to send the POST failed."
            }

        } catch (err) {
            warnMsg("Ops, error in send post for egoc team about this implementation" + err) 
        }

    } else {
        currentBuild.description = "Deploy executado com sucesso - ${environmentName}"
    }

    echo "Deploy executado com sucesso em ${environmentName} - ${iisEnvironments}, BYBY ${current_user} - ${changeorderWorkEnd}"

    if ( ( environmentName == "HI" ) || ( environmentName == "HE" ) ) {
        if ( triggerTestHomolog != "" ) {
            echo "Step de testes foram adicionados para ${environmentName} - ${iisEnvironments} ${current_user} "        
            echo "Invocando ${triggerTestHomolog}"
            def job = build job: triggerTestHomolog
            echo "Acompanhe os testes pelo CORE em http://spobrjenkins:8080/job/core/"
        } else {
            echo "Step de testes foram ignorados para ${environmentName} - ${iisEnvironments} ${current_user} "        
        }
    }

    

    try {
        dashBoardCore.setAuthor(getCurrentUser())
        dashBoardCore.setChange_order("$changeorderNumber")
        dashBoardCore.setEnvironment_deploy("$environmentName")
        dashBoardCore.setGearr_id("$gearrId")
        dashBoardCore.setName_application("$changeorderConfigItens")
        dashBoardCore.setPipeline_code_execution(currentBuild.number.toString())
        dashBoardCore.setType_application("IIS")
        dashBoardCore.setDate_execution_start("$changeorderWorkStart")
        dashBoardCore.setDate_execution_end("$changeorderWorkEnd")
        dashBoardCore.setChange_order_work_start("$changeorderWorkStart")
        dashBoardCore.setChange_order_work_end("$changeorderWorkEnd")
        dashBoardCore.setScore("100")

        echo "Invoking function etl"

        etl("success", dashBoardCore)
    } catch (Exception e) {
        println("Error: " + e.getMessage())
    }

}

return this
