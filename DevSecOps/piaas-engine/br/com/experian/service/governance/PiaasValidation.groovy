import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.DumperOptions
import java.nio.charset.StandardCharsets
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

/**
 * checkMadeByApollo11
 * Método retorna se a aplicação foi criada pelo onboarding do Apollo 11
 * @version 1.0.0  
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def checkMadeByApollo11() {

    echo "Invoking function checkMadeByApollo11"

    try {
        def urlSearch = "http://spobrmetabasebi:3000/api/public/card/0589dff1-f792-41b4-9a1c-e13306013a94/query/json?parameters=%5B%7B%22type%22%3A%22category%22%2C%22value%22%3A%22" + applicationName + "%22%2C%22target%22%3A%5B%22variable%22%2C%5B%22template-tag%22%2C%22application_name%22%5D%5D%7D%5D"
        def data = new URL(urlSearch).text
        def json = new JsonSlurper().parseText(data)
        
        apollo11Json = json.toString()
        
        if ( apollo11Json == "[]" ) {
            utilsMessageLib.infoMsg("Projeto não pertence ao Apollo11. Setando como false.")
            madeByApollo11 = false
        } else {
            utilsMessageLib.infoMsg("Projeto pertence ao Apollo11. Setando como true.")
            madeByApollo11 = true
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Algum problema ocorreu ao validar o Apollo no projeto. Setando como false.")
        madeByApollo11 = false
    }

}

/**
 * cyberSecurityControls
 * Método retorna se a aplicação está com status blocked para o Cyber Scurity controls
 * @version 1.0.0  
 * @package DevOps
 * @author  Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
 * @return  !blocked | blocked
 **/
def cyberSecurityControls() {

    echo "Invoking function cyberSecurityControls"

    try {
        def urlSearch = "http://spobrmetabasebi:3000/api/public/card/137cae65-c28c-48c0-9ae9-997585d0d768/query/json?parameters=%5B%7B%22type%22%3A%22category%22%2C%22value%22%3A%22" + piaasMainInfo.gearr_id + "%22%2C%22target%22%3A%5B%22variable%22%2C%5B%22template-tag%22%2C%22gearr_id%22%5D%5D%7D%5D"
        def data = new URL(urlSearch).text
        def json = new JsonSlurperClassic().parseText(data)
        
        if ( !json.isEmpty() && piaasMainInfo.gearr_id != "" ) {
            def suggestionToPipeline = json[0].suggestion_to_pipeline
            if ( suggestionToPipeline == "blocked" ) {   
                utilsMessageLib.errorMsg("Esta aplicacao viola as regras de Cyber Security Controls (was/dast/pentest/log ), consulte seu ISP. Veja abaixo os detalhes:")
                
                println("+-----------------------+-----------------------------------+")
                println("|                   Resultados                              |")
                println("|-----------------------+-----------------------------------+")
                println("waf_status:             |         ${json[0].waf_status}")           
                println("pentest_status:         |         ${json[0].pentest_status}")           
                println("dast_status:            |         ${json[0].dast_status}")           
                println("app_log_status:         |         ${json[0].app_log_status}")           
                println("sugestion_to_pipeline:  |         ${json[0].suggestion_to_pipeline}")
                println("date_update:            |         ${json[0].date_update}")             
                println("+-----------------------+-----------------------------------+")

                piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_CYBERSECURITYCONTROLS_000'
                controllerNotifications.houstonWeHaveAProblem()

            } else {
                utilsMessageLib.infoMsg("Sem Pendencias nos controles de Cyber Security Controls para esta aplicacao")
            }    
        } else {
            utilsMessageLib.infoMsg("Ignorando consulta nos controles de Cyber Security Controls para esta aplicacao.")
        }    
    } catch (Exception e) {
        utilsMessageLib.warnMsg("Algum problema ocorreu na consulta dos controles do Cyber Security Controls $e")
    }

}

/**
 * pipelineValidation
 * Método execução da validação dos dados da Pipeline
 * @version 8.34.0
 * @package DevOps
 * @author  Fabio P. Zinato<fabio.zinato@experian.com>
 * @return  true | false
 **/
def pipelineValidation() {
    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_000'

    if ( gitBranch.contains("master") ) {
        if ( changeorderConfigItens == "" ) { 
            if ( ( language == "cobol" ) || ( language == "assembly" ) || ( language == "bms" ) || ( language == "c++" ) ) {
                echo "Ignore Gearr because is mainframe package"
            } else {
                utilsMessageLib.errorMsg("Gearr not informed on piaas.yml, please add a attribute in stage application")
                echo "Example of the using in piaas.yml:"
                echo ""
                echo "application:"
                echo "  name: experian-srv-gdn-brazil-orquestrador"
                echo "  gearr: 12345"
                currentBuild.description = "Not informed the gearr of the application. Impossible to proceed with the pipeline"
                errorPipeline = "Gearr not informed on piaas.yml, please add a attribute in stage application."
                helpPipeline = "Verifique se em seu piaas.yml existe as configurações de gearr caso não exista crie a entrada no stage application de seu respectivo gearr, exemplo gearr: 1234."
                piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_008'
                echo "Solucao: ${helpPipeline}"
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }
        }
    }

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_RUNPERMISSION_000'
    validateRunPermission()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSTYPE_000'
    serviceGovernanceItil.validateAssignmentGroup()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSGEARR_000'
    serviceGovernanceItil.setDetailsGearr()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSPROBLEM_000'
    serviceGovernanceItil.setDetailsProblems()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_VALIDATEEXCEPTIONLIST_000'
    controllerIntegrationsBitbucket.validateExceptionList()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_CYBERSECURITYCONTROLS_000'
    cyberSecurityControls()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSHANDOVER_000'
    setDetailsHandover()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSPENTEST_000'
    controllerTestsPentest.setDetailsPentest()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETDETAILSWAF_000'
    controllerTestsWaf.setDetailsWaf()  

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETAPPLICATIONDETAILS_000'
    serviceGovernanceApplication.setApplicationDetails()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_CHECKMADEBYAPOLLO11_000'
    checkMadeByApollo11()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETENVIRONMENT_000'
    serviceGovernanceApplication.setEnvironment()

    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETMAPCODEREUSE_000'
    serviceGovernanceMetrics.setMapCodeReuse()

    serviceGovernanceErrorBudget.getAppIdErrorBudgetData()

    currentBuild.displayName = "[${applicationName}-${versionApp}:${language}[${gitBranch}] (#${currentBuild.number})"

    echo "CI/CD running"

    echo ""
    echo "Definitions of the pipeline"

    def applicationYaml = readYaml file: fileName
    def parser = new Yaml()
    // Configurando opções de formatação YAML para tornar a saída mais legível
    def options = new DumperOptions()
    options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)
    options.setPrettyFlow(true)
    def dumper = new Yaml(options)
    
    if (applicationYaml.application.gearr_dependencies instanceof String) {
        applicationYaml.application.gearr_dependencies = applicationYaml.application.gearr_dependencies.replace(',', ';')
    }
    else if (applicationYaml.application.cmdb_dependencies instanceof String) {
        applicationYaml.application.cmdb_dependencies = applicationYaml.application.cmdb_dependencies.replace(',', ';')
    }

    def formattedYaml = parser.load(applicationYaml.toString())
    // Saída formatada em YAML
    println dumper.dump(formattedYaml)

    echo ""
    
    piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_000'
    
    echo "Workdir for this Job ${WORKSPACE}/${currentBuild.number}"
    echo "Pipeline implemented : piaas.yml by version of ${version}"
    echo "Name application : ${applicationName}"
    echo "Network type : " + piaasMainInfo.gearr_u_network_type
    echo "Gearr application name : " + piaasMainInfo.gearr_id + " - " + piaasMainInfo.name_application
    echo "Business service : ${changeorderBusinessService}"
    echo "Business criticality: " + piaasMainInfo.gearr_business_criticality
    echo "Deployment strategy: " + piaasMainInfo.deployment_strategy
    echo "Assignment group of the application: ${changeorderAssignmentGroup}"
    echo "Tribe : ${tribe}"
    echo "Squad : ${squad}"
    echo "Version application : ${versionApp}"
    echo "Environment for deploy : ${environmentName}"
    echo "Type application : ${type}"
    echo "Language used in the application : ${language}"
    echo "Mav room configured : ${changeorderMavRoom}"
    if (language.toLowerCase() == "java") {
        echo "Jdk using : ${jdk}"
    }
    if (language.toLowerCase() == ".net") {
        echo "ToolsVersion using : ${tv}"
    }
    if (typePackage == "") {
        echo "Type package : Not define"
    } else {
        echo "Type package : ${typePackage}"
    }
    echo "Artifact ID application: ${artifactId}"
    echo "Group ID application: ${groupId}"
    echo "The author : ${gitAuthor} - (${gitAuthorEmail})"
    echo "The author title: ${titleUser}"
    echo "The repository : ${gitRepo} at branch : ${gitBranch}"
}

/**
 * setDetailsHandover
 * Método pega detalhes do handover da aplicação no README
 * @version 8.29.0
 * @package DevOps
 * @author  felipe.olivotto@br.experian.com
 * @return  $versionApp
 **/
def setDetailsHandover() {

    echo "Invoking function setDetailsHandover"

    def result = 0.0
    def handoverScore = ""
    def flagHandoverNonCompliance = false
    def items = ""
    
    try {
        
        handover = sh(script:"/usr/bin/python3 ${packageBasePath}/controller/integrations/handover.py ${WORKSPACE}/${currentBuild.number}", returnStdout: true)

        jsonQuery =  utilsJsonLib.jsonParse(handover)

        for (Map.Entry<String,String> entry : jsonQuery.entrySet()) {
            items = items + "\nHandover: " + entry.getKey() + "\n"
            for (Map.Entry<String,String> handoverElement : entry.getValue()["elements"]){
                if ( handoverElement.getValue() == 0 ){
                    items = items + handoverElement.getKey() + " : NOK\n"
                    flagHandoverNonCompliance = true
                } else {
                    items = items + handoverElement.getKey() + " : OK\n"
                    result += handoverElement.getValue()
                }
            }
        }

        handoverScore = String.format("%.2f", result)

        println("Abaixo segue o resultado do itens validados..." + items)
        println("Handover score: " + handoverScore)

        if ( flagHandoverNonCompliance == true ){
            echo "Application ${piaasMainInfo.gearr_id} - ${changeorderConfigItens}: O arquivo README.md nao segue os padroes de Handover informados por EGOC."
            toolsScore.handover.analysis_performed = 'true'
            toolsScore.handover.score = Float.parseFloat(handoverScore)
            piaasMainInfo.handover_analysis_performed= 'true'
            piaasMainInfo.handover_score = handoverScore.toString()
            piaasMainInfo.handover_items = handover.replace('\n', '')
            // controllerNotifications.houstonWeHaveAProblem()
        } else {
            echo "Application ${piaasMainInfo.gearr_id} - ${changeorderConfigItens}: O arquivo README.md esta de acordo com os padroes informados por EGOC."
            toolsScore.handover.analysis_performed = 'true'
            toolsScore.handover.score = Float.parseFloat(handoverScore)
            piaasMainInfo.handover_analysis_performed= 'true'
            piaasMainInfo.handover_score = handoverScore.toString()
            piaasMainInfo.handover_items = handover.replace('\n', '')
        }

    } catch (err) {
        utilsMessageLib.errorMsg("Ocorreu um erro ao validarmos o Handover da aplicação.")
        toolsScore.handover.analysis_performed = 'true'
        toolsScore.handover.score = 0
        piaasMainInfo.handover_analysis_performed= 'true'
        piaasMainInfo.handover_score = 0
    }

    serviceGovernanceScore.scorePost(piaasMainInfo.handover_score, "HANDOVER", "score-handover")
}

/**
 * validateRunPermission
 * Método valida o bloqueio atual para executar o novo PiaaS. Método temporário até finalizar a migração
 * @version 8.29.0
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def validateRunPermission() {

    if ( piaasMainInfo.assignment_group_application != "DevSecOps PaaS Brazil" ) {
        utilsMessageLib.errorMsg("No roadmap atual somente são permitidas execuções pelo time DevSecOps Brasil.")  
        throw new Exception("Acesso negado. Consulte roadmap.")
    }

}

return this
