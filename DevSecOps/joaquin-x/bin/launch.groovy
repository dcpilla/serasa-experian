#!/usr/bin/env groovy

/**
 *
 * Este arquivo é parte do projeto Service Catalog Infrastructure Serasa Experian 
  *
 * @package        Service Catalog Infrastructure
 * @name           launch.groovy
 * @version        2.10.0
 * @description    Script que controla o launch das solicitações de infra
 * @copyright      2020 &copy Serasa Experian
 *
 *
 * @version        2.10.0
 * @change         NIKEDEVSEC-2988 - Garantir a rastreabibilidade à diretoría dos launchers cockpit.
 * @author         DevSecOps Architecture Brazil
 * @contribution   Felipe Olivotto <felipe.olivotto@br.experian.com>    
 * @references     https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.3
 *
 * @date           09-Fev-2023
 *
 * @version        2.9.0
 * @change         - [UPD] - Alteração da chamada de autoamcoes Windows;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Lucas Francoi <lucas.francoi@br.experian.com>
 * @dependencies   engine1.ps1 - Para windows     
 * @references     https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.3
 *
 * @date           06-Fev-2023
 *
 *
 * @version        2.8.0
 * @change         - [UPD] - Alteração dos valores de custos por automação;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh       
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           11-Jan-2023
 *
 * @version        2.7.0
 * @change         - [FEATURE] envio de card de status via teams;
 * @change         - [FEATURE] envio de card para pesquisa de satisfacao via teams;
 * @author         DevSecOps Architecture Brazil
 * @package        Service Catalog Infrastructure
 * @name           launch.groovy
 * @version        2.6.0
 * @description    Script que controla o launch das solicitações de infra
 * @copyright      2020 &copy Serasa Experian
 *
 * @version        2.6.0
 * @change         - [FEATURE] Logs title and department;
 * @author         DevSecOps Architecture Brazil
 * @package        Service Catalog Infrastructure
 * @name           launch.groovy
 *
 * @version        2.5.0
 * @change         - [FEATURE] Suporte a passar o usuário como parâmetro da execução;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Thiago José de Campos <Thiago.Campos@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh   
 *                 engine.sh - Para linux
 *                 engine1.ps1 - Para windows 
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           08-Out-2021

 * @package        Service Catalog Infrastructure
 * @name           launch.groovy
 * @version        2.4.0
 * @description    Script que controla o launch das solicitações de infra
 * @copyright      2020 &copy Serasa Experian
 *
 * @version        2.4.0
 * @change         - [FEATURE] Suporte a slave windows;
 *                 - [FEATURE] Suporte a slave linux;
 *                 - [BUG] Erro no link de e-mail para launch;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh   
 *                 engine.sh - Para linux
 *                 engine1.ps1 - Para windows   
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           12-Ago-2021
 *
 * @version        2.3.0
 * @change         - [BUG] Display de vault em modo debug;
 *                 - [FEATURE] Schedulação para os RPA;
 *                 - [BUG] Bloqueio de execuções de usuários comum diretamente pelo jenkins, forçando sempre o uso da interface do catalogo;
 *                 - [FEATURE] Normalização dos logs;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh       
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           20-Julho-2021
 *
 * @version        2.1.0
 * @change         - [FEATURE] - Atributo onwer com o email do dono da automação para receber email em caso de falhas;
 *                 - [UPDATE]  - Ajustes do type do jenkins.yml para abertura de change dos SRE.
 *                 - [FEATURE] - Criação da branch de homolog para realizar homologações diretamente por ela;
 *                 - [FEATURE] - Integração com snow leitura e execuções automática a partir de request aprovadas, sem a necessidade do dono da mesma ter que realizar o launch;
 *                 - [UPDATE]  - Não fechar request em execuções de homologação;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh       
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           25-Jan-2021
 *
 * @version        2.0.0
 * @change         - [FEATURE] Implementações de processos ITIL
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh       
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           14-Jan-2021
 *
 * @version        1.0.0
 * @change         - [FEATURE] Implementação inicial de conceito
 * @author         DevSecOps Architecture Brazil
 * @contribution   Marcelo Oliveira <Marcelo.Oliveira@br.experian.com>
 *                 Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
 * @dependencies   /opt/DevOps/bin/snow.sh       
 * @references     https://medium.com/@timhberry/terraform-pipelines-in-gitlab-415b9d842596
 *                 http://afonsof.com/jenkins-material-theme/ 
 * @date           07-07-2020
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
import groovy.time.TimeCategory 
import groovy.time.TimeDuration

/**
 * Declaração Variaveis 
 **/

/**
 * inDebug
 * Define launch debug
 * @var boolean
 **/
inDebug = false

/**
 * iamRpa
 * Define o nome do RPA ativar o modo de execução de RPA
 * @var boolean
 **/
def iamRpa = ''

/**
 * engineCmd
 * Define o comando da engine para execução
 * @var string
 **/
def engineCmd = '/opt/deploy/joaquin-x/bin/engine.sh'

/**
 * pathWorkspace
 * Define o caminho da workspace
 * @var string
 **/
def pathWorkspace = '/opt/jenkins/.joaquin/workspace'

/**
 * template
 * Define o template para launch
 * @var string
 **/
def template = ''

/**
 * branch
 * Define a branch da automação
 * @var string
 **/
def branch = ''

/**
 * launchCanceled
 * Define o abort do job
 * @var boolean
 **/
def launchCanceled = ''

/**
 * groupOwner
 * Define o grupo dono da ferramenta
 * @var boolean
 **/
groupOwner = 'Br_Aws_DevOpsPaas_Adm'

/**
 * joaquinXTemplate
 * Define o layout do template
 * @var string
 **/
joaquinXTemplate = ''

/**
 * urlBaseJenkins
 * Define a url base do job no jenkins do catalogo
 * @var string
 **/
urlBaseJenkins=''

/**
 * respInput
 * Recebe resposta de input de usuário
 * @var string
 **/
respInput = ''

/**
 * teamsNotificationsEnabled
 * Ativa ou desativa as notificacoes do Teams
 * @var boolean
 **/
teamsNotificationsEnabled = true

/**
 * itil variables
 * Define as variaveis utilizadas para itil
 **/
flagChangeOrderCreated = 0
changeorderAuthorized = 0 
changeorderNumber = ''
changeorderJustification = ''
changeorderTemplate = ''
changeorderCreatedState = '-5'
changeorderBusinessService = 'Other'
changeorderCategory = 'Applications Software'
changeorderAssignmentGroup = ''
changeorderAssignedTo = ''
changeorderSummary = ''
changeorderDescription = ''
changeorderTestResult = ''
changeorderUEnvironment = ''
changeorderUSysOutage = 'no'
changeorderStartDate= '' 
changeorderEndDate=''
changeorderRiskImpactAnalysis = ''
changeorderRollout = 'N/S'
changeorderRollback = 'N/S'
changeorderConfigItens = 'Other'
changeorderState = ''
changeorderRequirements = ''
changeorderCloseCode='successful'
changeorderCloseNotes=''
changeorderWorkStart=''
changeorderWorkEnd=''
changeorderClient = '/opt/DevOps/bin/snow.sh'
numberRitm = ''
jsonRitm = ''
thereRitm = false

/**
 * queue variables
 * Define as variaveis de filas
 **/
workSpaceQueueIn = ''
workSpaceQueueProcessing = ''
workSpaceQueueDone = ''
workSpaceQueueError = ''
workSpaceQueueEtl = ''

/**
 * Log variables
 * Define as variaveis para o log normalizado
 **/
log = [ launch : "",
        description : "",
        type : "",
        id_execution : "",
        url_execution: "",
        debug : "",
        itil_process : [ change_order : "" , request : "" ],
        parameters:[ example : "null", ],
        execution_result : "",
        message : "",
        who_executed : "",
        email : "",
        legacy_logon : "",
        title : "",
        department : "",
        date_start : "",
        date_end : "",
        joaquinx_environment : "" ,
        team_owner : "",
        manual_time : "",
        analyst_cost_minutes : "2.12",
	    infrastructure_cost_minutes : "3.32",
        running_in: "", 
        bu: "" ]

/**
 * Funções
 **/

/**
 * launch
 * Método faz o launch das solicitações
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def launch( ) {
    try {
        dir(currentBuild.number.toString()) {
            stage('checkout') {
                checkout()
            }

            stage('load') {
                loadTemplate()
            }

            if ( ( changeorderAssignedTo != "by_magic" ) && ( joaquinXTemplate.itil != null ) ) {
                if ( joaquinXTemplate.itil.request ) {
                    logMsg("Read RITM of the request for execution template ${template}", "INFO")
                    stage('get_request') {
                        getRequest()
                    }
                } else {
                    logMsg("Ignore integration ITIL for reading request in template ${template} ", "WARN")
                }
            }

            stage('setup') {
                if ( changeorderParam != '' ) {
                    setupTemplateFront()
                } else {
                    setupTemplate()
                }
            }

            stage('apply') {
                apply()
            }

            if ( joaquinXTemplate.itil != null ) {
                if ( joaquinXTemplate.itil.request ) {
                    logMsg("Close request for execution template ${template}", "INFO")
                    stage('close_request') {
                        closeRequest()
                    }
                } else {
                    logMsg("Ignore integration ITIL for close request in template ${template} ", "WARN")
                }
            }

            if ( joaquinXTemplate.itil != null ) {
                if ( joaquinXTemplate.itil.changeorder ) {
                    logMsg("Open change order for template ${template}", "INFO")
                    stage('open_change_order') {
                        openChangeOrder()
                    }
                } else {
                    logMsg("Ignore integration ITIL for open change order in template ${template} ", "WARN")
                }
            }

            
            if ( joaquinXTemplate.notification != null ) {
                if ( joaquinXTemplate.notification.containsKey("disable_in_qa") && (branch == "homolog") ) {
                    logMsg("Ignore send notification, because disable_in_qa is activated.", "INFO")
                } else {
                    if ( joaquinXTemplate.notification.onsuccess != null ) {
                        if ( joaquinXTemplate.notification.onsuccess.email != null ) {
                            email(joaquinXTemplate.notification.onsuccess.email.recipients, joaquinXTemplate.notification.onsuccess.email.subject, 'onsuccess')
                        } else if ( joaquinXTemplate.notification.onsuccess.teams != null ) {
                            teamsNotifications("SUCESSO")
                        }
                    } else {
                        logMsg("Ignore send notification onsuccess in template ${template} ", "WARN")
                    }
                }
            }

            if ( ( changeorderAssignedTo == "by_magic" ) && ( iamRpa == "" ) ) {
                logMsg("Move item ${numberRitm} to queue done", "INFO")
                changeQueue(workSpaceQueueProcessing, workSpaceQueueDone, numberRitm)
            }

            log['execution_result'] = "SUCCESS"
            log['message'] = "Success launch of the ${template} by ${changeorderAssignedTo}"
            log['date_end'] = new Date().format("yyyy-MM-dd HH:mm:ss")

            etl()

            // Calling serasa legends
            if ( cockpit_env == "prod" ) {
                
                questName = "Execute uma automação no Cockpit de produção"
                serasaLegends(questName)

            }
          
        
            /**
            * Chama metodo Card de status SUCESSO da automacao
            * Bloco faz chamada API para o PowerAutomate disparar card de status
            **/
            if ( teamsNotificationsEnabled == true && email != ''  &&  legacy_logon != '' ) {
            
                cardStatus('SUCCESS')
                cardStatus('NPS')

            }                

            logMsg("Success launch of the ${template} by ${changeorderAssignedTo}", "INFO")
            currentBuild.description = "Success launch of the ${template} by ${changeorderAssignedTo}"

        }
    } catch (err) {
        log['date_end'] = new Date().format("yyyy-MM-dd HH:mm:ss")

        etl()

            /**
            * Chama metodo Card de status erro da automacao
            * Bloco faz chamada API para o PowerAutomate disparar card de status
            **/
            if ( teamsNotificationsEnabled == true && email != ''  &&  legacy_logon != '' ) {
            
                cardStatus('ERROR')

            } 

        if ( !launchCanceled ) {
            logMsg("Opssss, error in execution joaquinX launch for template ${template} by ${changeorderAssignedTo}", "ERROR")

            // EDPB-627 - Houston, we have a problem on cockpit.
            houstonWeHaveAProblem()

            currentBuild.description = "Error in launch " + template + " by " + changeorderAssignedTo

            if ( joaquinXTemplate.notification != null ) {
                if ( joaquinXTemplate.notification.containsKey("disable_in_qa") && (branch == "homolog") ) {
                    logMsg("Ignore send notification, because disable_in_qa is activated.", "INFO")
                } else {
                    if ( joaquinXTemplate.notification.onfailure != null ) {
                        if ( joaquinXTemplate.notification.onfailure.email != null ) {
                            email(joaquinXTemplate.notification.onfailure.email.recipients, joaquinXTemplate.notification.onfailure.email.subject, 'onfailure')
                        } else if ( joaquinXTemplate.notification.onfailure.teams != null ) {
                            teamsNotifications("FALHA")
                        }
                    } else {
                        logMsg("Ignore send notification onfailure in template ${template} ", "WARN")
                    }
                }
            }

            if ( ( changeorderAssignedTo == "by_magic" ) && ( iamRpa == "" ) ) {
                logMsg("Move item ${numberRitm} to queue error", "ERROR")
                changeQueue(workSpaceQueueProcessing, workSpaceQueueError, numberRitm)
            }

            throw err
        }
    }
}

/**
 * checkout
 * Método faz o checkout do template de infra
 * @version 2.4.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def checkout() {
    def fileTemplate = ''
    def jsonTemp = ''
    launchCanceled = false
    template = "null"
    urlBaseJenkins = BUILD_URL + 'console'
    log['launch'] = template
    log['debug'] = false
    log['id_execution'] = currentBuild.number
    log['url_execution'] = urlBaseJenkins
    log['date_start'] = new Date().format("yyyy-MM-dd HH:mm:ss")

    changeorderAssignedTo = getCurrentUser()

    if ( isAllowed(changeorderAssignedTo,groupOwner) ) {
        selectedProperty("Want to run in debug mode?", "no;yes", "debug_mode", 600, "true")
        if ( respInput == "yes" ) {
            inDebug = true
            log['debug'] = true
        }  
    } else if ( changeorderAssignedTo != "by_magic" ) {
        if ( engineCmd == "/opt/deploy/joaquin-x/bin/engine.sh" ) {
            if ( token_for_run == "" ) {
                logMsg("Token for execution in production not informed", "ERROR")
                log['execution_result'] = "ERROR"
                log['message'] = "Token for execution in production not informed"
                throw err
            }
            withCredentials([usernamePassword(credentialsId: 'token.for.run.prod', passwordVariable: 'pass', usernameVariable: 'user')]) {
                if ( token_for_run != pass ) {
                    logMsg("Token for execution in production not correct", "ERROR")
                    log['execution_result'] = "ERROR"
                    log['message'] = "Token for execution in production not correct"
                    throw err
                }
            }
        }
    }

    if ( changeorderAssignedTo == "by_magic" ) {
        if ( iamRpa != "" ) {
            logMsg("Starting a run of Robotic Process Automation", "INFO")
            logMsg("I'm the RPA ${iamRpa}, let's get down to work", "INFO")
            template = iamRpa  
            log['launch'] = template   
            log['type'] = "RPA"       
            thereRitm = true
            teamsNotificationsEnabled = false
        } else {
            workSpaceQueueIn = pathWorkspace + '/queue/input'
            workSpaceQueueProcessing = pathWorkspace + '/queue/processing'
            workSpaceQueueDone = pathWorkspace + '/queue/done'
            workSpaceQueueError = pathWorkspace + '/queue/error'

            logMsg("Start auto apply request using magic method", "INFO")

            numberRitm = getQueue() 
            changeQueue(workSpaceQueueIn, workSpaceQueueProcessing, numberRitm)

            logMsg("Reading fields from ${numberRitm}", "INFO")

            jsonRitm = ''
            jsonTemp = sh(script: "#!/bin/sh -e\n ${changeorderClient}  --action=status-request --number-ritm=${numberRitm}", returnStdout: true)
            jsonTemp = jsonTemp.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
            echo "Details ${numberRitm} found By Schedule: " + jsonTemp

            jsonRitm =  jsonParse(jsonTemp)

            if ( jsonRitm.state != "approved" ) {
                logMsg("${numberRitm} not authorized", "ERROR")
                log['execution_result'] = "ERROR"
                log['message'] = "${numberRitm} not authorized"
                throw err
            } else {
                logMsg("${numberRitm} authorized execution", "INFO")
                thereRitm = true
            }

            template = jsonRitm.u_template
            log['launch'] = template
            log['type'] = "schedule" 
            log['itil_process']['request'] = numberRitm      
        } 
    } else {
        logMsg("Start execution by user " + changeorderAssignedTo, "INFO")

        template = browse_catalog
        log['launch'] = template
        log['type'] = "normal"       
    } 

    currentBuild.description = "Requesting launch of the ${template} by ${changeorderAssignedTo}"

    if ( engineCmd == "/opt/deploy/hom-joaquin-x/bin/engine.sh" ) {
        logMsg("Choice branch homolog for execution", "INFO")
        log['joaquinx_environment'] = "homolog"
        branch = "homolog"
        fileTemplate = 'https://code.experian.local/projects/SCIB/repos/' + template + '/raw/joaquin-infra.yml?at=refs%2Fheads%2Fhomolog'
    } else {
        log['joaquinx_environment'] = "production"
        branch = "master"
        fileTemplate = 'https://code.experian.local/projects/SCIB/repos/' + template + '/raw/joaquin-infra.yml?at=refs%2Fheads%2Fmaster'
    }

    logMsg("Get template " + template + " in repository", "INFO")

    sh "#!/bin/sh -e\n curl --insecure --fail --silent --show-error ${fileTemplate} --output joaquin-infra.yml && \
                       ls -lha && \
                       if ! [[ -f joaquin-infra.yml ]]; then echo 'Ops, joaquin-infra.yml not found'; exit 1; else cat  joaquin-infra.yml; fi"

    /**
    * Chama metodo Card de status inicio da automacao
    * Bloco faz chamada API para o PowerAutomate disparar card de status
    **/
    if ( teamsNotificationsEnabled == true && email != ''  &&  legacy_logon != '' ) {
    
        cardStatus('START')

    }

}

/**
 * loadTemplate
 * Método faz o load do template
 * @version 1.0.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def loadTemplate() {
    def fileName = ''

    logMsg("Load template joaquin-infra.yml", "INFO")

    Yaml yaml = new Yaml()

    try {
        fileName = WORKSPACE + '/' + currentBuild.number + '/joaquin-infra.yml'
        InputStream ios = new FileInputStream(new File(fileName))
        Map < String, Object > result = (Map < String, Object > ) yaml.load(ios)
        joaquinXTemplate = result
        logMsg("Definitions of the joaquinX in ${fileName} loaded successfully", "INFO")
    } catch (err) {
        logMsg("Could not load data map. Does this file '${fileName}' exist? Or is correct?", "ERROR")
        logMsg("Or this file '${fileName}' is correct sintaxe yaml? To valide file http://www.yamllint.com/", "ERROR")
        log['execution_result'] = "ERROR"
        log['message'] = "Could not load data map. Does this file '${fileName}' exist? Or is correct?"
        throw err
    }

    // NIKEDEVSEC-2988 - Validação novo campo bu e ajustes nas condicionais.
    if ( ! joaquinXTemplate.containsKey("manual_time") ) {
        error('Error loading joaquin-infra.yml: field manual_time not informed.')
    }
    if ( ! joaquinXTemplate.containsKey("team_owner") ) {
        error('Error loading joaquin-infra.yml: field team_owner not informed.')
    }
    if ( joaquinXTemplate.bu == null ) {
        logMsg('Error loading joaquin-infra.yml: field bu not informed.', "WARN")
        log['bu'] = "Nao informado"
    } else {
        logMsg("Field BU was found. Value is ${joaquinXTemplate.bu}", "INFO")
        log['bu'] = joaquinXTemplate.bu
    }
}

/**
 * setupTemplate
 * Método faz o setup do template
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def setupTemplate() {
    def answerTemp = ''
    changeorderParam = '{'

    logMsg("Definition launch: ${joaquinXTemplate.definition}", "INFO")
    log['description'] = joaquinXTemplate.definition
    log['team_owner'] = joaquinXTemplate.team_owner
    log['manual_time'] = joaquinXTemplate.manual_time

    if ( ! thereRitm ) {
        selectedProperty("Hello ${changeorderAssignedTo} this launch ${template} will create for you: ${joaquinXTemplate.definition}. We can continue?", "no;yes", "continue", 600, "true")
        if ( respInput == "no" ) {
            echo "Launch canceled by ${changeorderAssignedTo}"
            currentBuild.description = "Launch canceled by ${changeorderAssignedTo}"
            currentBuild.result == 'ABORTED'
            launchCanceled = true
            log['execution_result'] = "CANCELED"
            log['message'] = "Launch canceled by ${changeorderAssignedTo}"
            error('Launch canceled by ${changeorderAssignedTo}')
        }
    }

    logMsg("Apply environments in template joaquin-infra.yml", "INFO")
    joaquinXTemplate.global.each{ key, value ->
        switch( value.type ) {
            case "text":
                logMsg("Inform the field ${key}", "INFO")
                if ( value.answer == null ) {
                    inputUser("Define the ${key}", "", "${value.description} ** REQUIRED ${value.required} ** ", "${key}", 600, "${value.pattern}", "${value.required}", "${value.type}")
                    value.answer = respInput
                } else if ( value.answer == "START_EXECUTION_BY" ) {
                    value.answer = changeorderAssignedTo
                } else {
                    answerTemp = value.answer
                    answerTemp = answerTemp.replaceAll("ritm.", "")
                    value.answer = jsonRitm[answerTemp]
                    if ( value.reference != null ) {
                        if ( ( value.reference.table_name != null ) && ( value.reference.field_name != null ) ) {
                            logMsg("Field ${key} using table reference SNOW get field ${value.reference.field_name} in ${value.reference.table_name}", "INFO")
                            answerTemp = ''
                            answerTemp = sh(script: "#!/bin/sh -e\n ${changeorderClient} --action=get-field-reference \
                                                                                         --table-name=${value.reference.table_name} \
                                                                                         --field-id=${value.answer} \
                                                                                         --field-name=${value.reference.field_name}", returnStdout: true)
                            answerTemp = answerTemp.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
                            value.answer = answerTemp
                        }
                    }
                    echo "Answer informed: ${key}=${value.answer}"
                }
                changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer + "\","
                log['parameters'][key] = value.answer
                break;
            case "password":
                logMsg("Inform the field ${key}", "INFO")
                inputUser("Define the ${key}", "", "${value.description} ** REQUIRED ${value.required} ** ", "${key}", 600, "${value.pattern}", "${value.required}", "${value.type}")
                value.answer = respInput
                changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer + "\","
                log['parameters'][key] = "password" 
                break;
            case "options":
                logMsg("Inform the field ${key}", "INFO")
                selectedProperty("Choose the ${key} - ${value.description}", "${value.options}", "${key}", 600, "${value.required}")
                value.answer = respInput
                changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer + "\","
                log['parameters'][key] = value.answer
                break;
            case "vault":
                log['parameters'][key] = "chosen vault ${value.answer}" 
                if ( value.answer == null ) {
                    logMsg("Inform the field ${key}", "INFO")
                    inputUser("Choose the ${key} in vault", "", "${value.description} ** REQUIRED ${value.required} ** ", "${key}", 600, "", "${value.required}", "${value.type}")
                    value.answer = respInput
                    changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer  + "\","
                } else {
                    logMsg("Get secret for vault ${value.answer} informed", "INFO")
                    validateSecrets(value.answer)
                    withCredentials([usernamePassword(credentialsId: value.answer.toString(), passwordVariable: 'pass', usernameVariable: 'user')]) {
                        value.answer = "id=" + value.answer + " user=" + user + " password=" + pass
                        changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer  + "\","
                    }
                }
                break;
//              NIKEDEVSEC-2600            
            case "cyberark":
                log['parameters'][key] = "chosen Cyberark ${value.answer}" 
                logMsg("Get secret from Cyberark for ${value.answer}", "INFO")
                
                if (cockpit_env == "prod") {
                    logMsg("Setting Prod cyberArkDapAutomation", "INFO")
                    cyberArkDapAutomation_app = "/opt/deploy/joaquin-x/bin/cyberArkDapAutomation.py"
                }
                if (cockpit_env == "homolog") {
                    logMsg("Setting Homolog cyberArkDapAutomation", "INFO")
                    cyberArkDapAutomation_app = "/opt/deploy/hom-joaquin-x/bin/cyberArkDapAutomation.py" 
                }

                validateSecrets(value.safe)

                if ( value.answer == "static" ) {
                    withCredentials([usernamePassword(credentialsId: 'CyberArk-DAP-Authentication', passwordVariable: 'token', usernameVariable: 'user')]){
                    cyberArkPasswordTmp = sh(script: "'${cyberArkDapAutomation_app}' -r static -t '${token}' -s '${value.safe}' -c '${value.account}'", returnStdout: true)
                    if ( value.containsKey("onlysecret") ) {
                        value.answer = cyberArkPasswordTmp.split(" ")[1]
                    } else {
                        value.answer = cyberArkPasswordTmp
                    }
                    changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer  + "\","
                        }
                } else if ( value.answer == "aws" ) {
                    withCredentials([usernamePassword(credentialsId: 'CyberArk-DAP-Authentication', passwordVariable: 'token', usernameVariable: 'user')]){
                    cyberArkPasswordTmp = sh(script: "'${cyberArkDapAutomation_app}' -r aws -t '${token}' -s '${value.safe}' -c '${value.account}' -a '${value.awsaccount}'", returnStdout: true)
                    value.answer = cyberArkPasswordTmp
                    changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + value.answer  + "\","
                        }
                }else {
                    logMsg("Please inform a type of Cyberark account in ANSWER option. AWS or Static!", "INFO")
                    }
                break;
            case "sef":
                log['parameters'][key] = value.answer
                ffValue = sef(value.answer)
                changeorderParam = changeorderParam +  "\"" + key + "\""  + ":" + "\"" + ffValue + "\","
            default:
                logMsg("Type ${value.type} for field not exist!", "ERROR")
        }
    }

    changeorderParam = changeorderParam + '}'
    changeorderParam = changeorderParam.replaceAll(",}", "}")
}

/**
 * setupTemplateFront
 * Método faz o setup do template para chamadas feitas pelo Front
 * @version 1.0.0
 * @package Service Catalog Infrastructure
 * @author  André Luís Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/

 def setupTemplateFront() {

    logMsg("Using JSON informed by CockPit DevSecOps", "INFO")
    logMsg("Definition launch: ${joaquinXTemplate.definition}", "INFO")
    log['description'] = joaquinXTemplate.definition
    log['team_owner'] = joaquinXTemplate.team_owner
    log['manual_time'] = joaquinXTemplate.manual_time

    logMsg("Apply environments in template joaquin-infra.yml", "INFO")
    joaquinXTemplate.global.each{ key, value ->
        switch( value.type ) {
            case "text":
                if ( value.answer == "START_EXECUTION_BY" ) {
                    value.answer = changeorderAssignedTo
                    changeorderParam = changeorderParam.replaceAll("}", "")
                    changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + value.answer  + "\"" + "}"
                    log['parameters'][key] = value.answer
//              NIKEDEVSEC-2200       
                } else if ((value.answer != null) && ( value.answer.contains("ritm." ))) {
                    answerTemp = value.answer
                    answerTemp = answerTemp.replaceAll("ritm.", "")
                    value.answer = jsonRitm[answerTemp]
                    changeorderParam = changeorderParam.replaceAll("}", "")
                    changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + value.answer  + "\"" + "}"
                    log['parameters'][key] = value.answer
                } 
                else {
                    valueLog = jsonParse(changeorderParam)
                    valueLog = valueLog[key]
                    log['parameters'][key] = valueLog
                }
                break;
            case "password":
                log['parameters'][key] = "password" 
                break;
            case "options":
                valueLog = jsonParse(changeorderParam)
                valueLog = valueLog[key]
                log['parameters'][key] = valueLog
                break;
            case "vault":
                log['parameters'][key] = "chosen vault ${value.answer}" 
                    logMsg("Get secret for vault ${value.answer} informed", "INFO")
                    validateSecrets(value.answer)
                    withCredentials([usernamePassword(credentialsId: value.answer.toString(), passwordVariable: 'pass', usernameVariable: 'user')]) {
                        value.answer = "id=" + value.answer + " user=" + user + " password=" + pass
                        changeorderParam = changeorderParam.replaceAll("}", "")
                        changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + value.answer  + "\"" + "}"
                    }
                break;
 //              NIKEDEVSEC-2600            
            case "cyberark":
                log['parameters'][key] = "chosen Cyberark ${value.answer}" 
                logMsg("Get secret from Cyberark for ${value.answer}", "INFO")

                if (cockpit_env == "prod") {
                    logMsg("Setting Prod cyberArkDapAutomation", "INFO")
                    cyberArkDapAutomation_app = "/opt/deploy/joaquin-x/bin/cyberArkDapAutomation.py"
                }
                if (cockpit_env == "homolog") {
                    logMsg("Setting Homolog cyberArkDapAutomation", "INFO")                    
                    cyberArkDapAutomation_app = "/opt/deploy/hom-joaquin-x/bin/cyberArkDapAutomation.py" 
                }

                validateSecrets(value.safe)

                if ( value.answer == "static" ) {
                    withCredentials([usernamePassword(credentialsId: 'CyberArk-DAP-Authentication', passwordVariable: 'token', usernameVariable: 'user')]){
                    cyberArkPasswordTmp = sh(script: "'${cyberArkDapAutomation_app}' -r static -t '${token}' -s '${value.safe}' -c '${value.account}'", returnStdout: true)
                    if ( value.containsKey("onlysecret") ) {
                        value.answer = cyberArkPasswordTmp.split(" ")[1]
                    } else {
                        value.answer = cyberArkPasswordTmp
                    }
                    changeorderParam = changeorderParam.replaceAll("}", "")
                    changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + value.answer  + "\"" + "}"
                        }
                } else if ( value.answer == "aws" ) {
                    withCredentials([usernamePassword(credentialsId: 'CyberArk-DAP-Authentication', passwordVariable: 'token', usernameVariable: 'user')]){
                    cyberArkPasswordTmp = sh(script: "'${cyberArkDapAutomation_app}' -r aws -t '${token}' -s '${value.safe}' -c '${value.account}' -a '${value.awsaccount}'", returnStdout: true)
                    value.answer = cyberArkPasswordTmp
                    changeorderParam = changeorderParam.replaceAll("}", "")
                    changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + value.answer  + "\"" + "}"
                        }
                }else {
                    logMsg("Please inform a type of Cyberark account in ANSWER option. AWS or Static!", "INFO")
                    }
                break;
            case "sef":
                log['parameters'][key] = value.answer
                ffValue = sef(value.answer)
                changeorderParam = changeorderParam.replaceAll("}", "")
                changeorderParam = changeorderParam +  "," + "\"" + key + "\""  + ":" + "\"" + ffValue  + "\"" + "}"
                break;
            case "checkbox":
                valueLog = jsonParse(changeorderParam)
                valueLog = valueLog[key]
                log['parameters'][key] = valueLog
                break;
            default:
                logMsg("Type ${value.type} for field not exist!", "ERROR")
        }
             }

 }

/**
 * openChangeOrder
 * Método faz a abertura de change order
 * @version 2.4.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def openChangeOrder() {
    def keepGoing = true
    def numberAttempts = 1
    def closeChange = true

    logMsg("Definition change order" , "INFO")

    if ( ! joaquinXTemplate.itil.containsKey("changeorder_rules") ) {
        logMsg("To use Change Order, automation needs to set change order rules.", "ERROR")
        throw err
    }

    if ( ( joaquinXTemplate.itil.changeorder_rules.template == null ) && ( joaquinXTemplate.itil.changeorder_rules.group == null ) ) {
        logMsg("To use change order, automations needs to fill template and group field in change order rules.", "ERROR")
        throw err
    } else {
        changeorderAssignmentGroup = joaquinXTemplate.itil.changeorder_rules.group
        changeorderTemplate = joaquinXTemplate.itil.changeorder_rules.template
    }

    if ( joaquinXTemplate.itil.changeorder_rules.open_and_close == false ) {
        logMsg("This automation doesn't needs to close OM. Skipping...", "INFO")
        closeChange = false
    }

    changeorderSummary = "[Infrastructure Service Catalog] Create resource " + template + " by " + changeorderAssignedTo

    if ( numberRitm != "" ) {
        changeorderJustification = "Solicitação realizada a partir do RITM " + numberRitm + " de forma automatizada pelo catalogo de servicos " + urlBaseJenkins 
    } else {
        changeorderJustification = "Solicitação realizada de forma automatizada pelo catalogo de servicos " + urlBaseJenkins 
    }
    changeorderStartDate = new Date().format("yyyy-MM-dd HH:mm:ss")
    changeorderEndDate = new Date().format("yyyy-MM-dd HH:mm:ss")
    changeorderUEnvironment = ""
    changeorderRollout = "Implantação realizada de forma automatizada pelo catalogo de servicos: " + urlBaseJenkins 
    changeorderCreatedState = '-5'
    changeorderDescription = changeorderDescription + 
                             "**** Catalago de Serviço de TI ***\\n\\n" + 
                             "Executor : " + changeorderAssignedTo + "\\n" + 
                             "Template : " + template + "\\n" + 
                             "Descrição : " + joaquinXTemplate.definition + "\\n";;
    if ( numberRitm != "" ) { 
        changeorderDescription = changeorderDescription + 
                                 "Numero do RITM : " + numberRitm + "\\n";;
    }

    logMsg("Open change order" , "INFO") 
    while (keepGoing) {
        try {
            changeorderNumber = sh(script: "#!/bin/sh -e\n ${changeorderClient}  --action=create-change \
                                                                                 --state=${changeorderCreatedState} \
                                                                                 --template='${changeorderTemplate}' \
                                                                                 --business-service='${changeorderBusinessService}' \
                                                                                 --category='${changeorderCategory}' \
                                                                                 --cmdb-ci='${changeorderConfigItens}' \
                                                                                 --justification='${changeorderJustification}' \
                                                                                 --risk-impact-analysis='${changeorderRiskImpactAnalysis}' \
                                                                                 --assignment-group='${changeorderAssignmentGroup}' \
                                                                                 --assigned-to='' \
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
            logMsg("Success in create Change Order " + changeorderNumber, "INFO") 
            log['itil_process']['change_order'] = changeorderNumber
            keepGoing = false
        } catch (err) {
            logMsg("Service desk is not available for integration try ${numberAttempts}, trying again in 60 seconds", "WARN")
            sleep(60)
            numberAttempts = numberAttempts + 1
        }
        if (numberAttempts == 10) {
            logMsg("Service desk is not available for integration", "WARN")
        }
    }

    if ( closeChange ) {
        echo "End implantation in ${changeorderEndDate}"
        echo "Close change order ${changeorderNumber}"
        sh(script: "${changeorderClient} --action=close-change \
                                            --number-change=${changeorderNumber} \
                                            --close-code='successful' \
                                            --close-notes='${changeorderRollout}' \
                                            --work-start='${changeorderStartDate}' \
                                            --work-end='${changeorderEndDate}'", returnStdout: false)
    }
}

/**
 * getRitm
 * Método faz a leitura da request da solicitação
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def getRequest() {
    def keepGoing = true
    def numberAttempts = 1
    def jsonTemp = ""
    numberRitm = ''
    jsonRitm = ''
    
    if ( changeorderParam != '' ) {
        numberRitm = jsonParse(changeorderParam)
        numberRitm = numberRitm['ritm']
    } else {
        inputUser("What is the RITM number for implementation ?", "", "Example: RITM1265110 ** REQUIRED ** ", "ritm", 600, "", "true", "text")
        numberRitm = respInput
    }

    log['itil_process']['request'] = numberRitm

    if ((numberRitm.length() != 11)) {
        logMsg("RITM ${numberRitm} number invalid", "ERROR")
        log['execution_result'] = "ERROR"
        log['message'] = "RITM ${numberRitm} number invalid"
        throw err
    }

    logMsg("Reading fields from ${numberRitm} ", "INFO")
    jsonTemp = sh(script: "#!/bin/sh -e\n ${changeorderClient}  --action=status-request --number-ritm=${numberRitm}", returnStdout: true)
    jsonTemp = jsonTemp.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
    echo "Details ${numberRitm} found: " + jsonTemp

    jsonRitm =  jsonParse(jsonTemp)

    logMsg("Cheking state request from ${numberRitm} ", "INFO")
    if ( jsonRitm.state != "approved" ) {
        logMsg("RITM ${numberRitm} not authorized", "ERROR")
        log['execution_result'] = "ERROR"
        log['message'] = "RITM ${numberRitm} not authorized"
        throw err
    } else {
        logMsg("RITM ${numberRitm} authorized execution", "INFO")
        thereRitm = true
    }
}

/**
 * closeRequest
 * Método fecha a request da solicitação
 * @version 2.4.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def closeRequest() {
    def keepGoing = true
    def numberAttempts = 1
    def requestRules = false
    changeorderCloseNotes = ''
    changeorderCloseNotes = "Implantação realizada de forma automatizada pelo catalogo de servicos:" + urlBaseJenkins

    if ( ! joaquinXTemplate.itil.containsKey("request_rules") ) {
        logMsg("This automation doesn't use request rules. Ignoring...", "INFO")
        requestRules = false
    } else {
        logMsg("This automation use request rules. Analyzing if automation needs RITM close...", "INFO")
        requestRules = true
    }

    if ( engineCmd == "/opt/deploy/hom-joaquin-x/bin/engine.sh" ) {
        logMsg("Skip close RITM from ${numberRitm} because its execution is homologation", "INFO")
    } else if ( ( requestRules ) && ( joaquinXTemplate.itil.request_rules.read_and_close == false ) )  {
        logMsg("Automation doesn't needs RITM close. Skipping...", "INFO")
    } else {
        logMsg("Close RITM from ${numberRitm} ", "INFO")
        logMsg("Notes: ${changeorderCloseNotes} ", "INFO")
        sh(script: "#!/bin/sh -e\n ${changeorderClient}  --action=close-request --number-ritm=${numberRitm} --close-notes='${changeorderCloseNotes}'", returnStdout: false)
        logMsg("Success, Close RITM from ${numberRitm} ", "INFO")
    }
}

/**
 * apply
 * Método faz a aplicação do launch
 * @version 2.4.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def apply() {
    def implementationNumber = 'DEVSECOPS' + UUID.randomUUID().toString() 
    def engineModeDebug = 'false'

    logMsg("Apply launch with parameters", "INFO")
    echo "Engine commnand for using: ${engineCmd}"
    log['execution_result'] = "ERROR"
    log['message'] = "Error in execution launch"

    if ( inDebug ) {
       engineModeDebug = 'true'
       echo "Debug Active: " + engineModeDebug
       logMsg("Using values", "DEBUG")
       echo "implementationNumber: " + implementationNumber
       echo "template: " + template
    } 

    if ( joaquinXTemplate.running_in != null ) {
        logMsg("Execution plan of launch in slave ${joaquinXTemplate.running_in}", "INFO")
        log['running_in'] = joaquinXTemplate.running_in

        if ( joaquinXTemplate.running_in.contains("windows") ) {
            joaquinXTemplate.plan.each { script ->
                logMsg("Using powershell for execution ${script}", "INFO")
                node( joaquinXTemplate.running_in ) {
                    dir(env.BUILD_NUMBER) {
                        //Tratativas da string changeorderParam para Windows
                        changeorderParam = changeorderParam.replaceAll("\"", "'")
                        changeorderParam = changeorderParam.replaceAll("\n'}", "'}")
                        changeorderParam = changeorderParam.replaceAll("\n", "")
                        bat "@powershell.exe -Executionpolicy bypass -file C:\\Jenkins\\scripts\\engine.ps1 \"${template}\" \"${script}\" \"${branch}\" \"${changeorderParam}\""            

                    }
                }
            }
        } else {
            node( joaquinXTemplate.running_in ) {
                sh(script: "#!/bin/sh -e\n export PATH=$PATH:/usr/local/bin/ && \
                            ${engineCmd} ${implementationNumber} ${template} '\\${changeorderParam}\\' ${engineModeDebug} ${currentBuild.number} ${changeorderNumber}", , returnStdout: false)
            }
        }
    } else {
        logMsg("Execution plan of launch in onpremises", "INFO")
        log['running_in'] = "onpremises"
        sh(script: "#!/bin/sh -e\n export PATH=$PATH:/usr/local/bin/ && \
                    ${engineCmd} ${implementationNumber} ${template} '\\${changeorderParam}\\' ${engineModeDebug} ${currentBuild.number} ${changeorderNumber}", , returnStdout: false)
    } 
}

/**
 * inputUser
 * Método recebe interação de usuário 
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          defaultValue   - Valor default do campo
 *          description    - Decrição da pergunta
 *          field          - Nome do campo
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 *          timeoutExit    - Parametros para tratar tipo de saida do timeout
 *          pattern        - Define o padrao para o campo
 *          required       - Define se é obrigatorio 
 *          type           - Define tipo de pergunta
 * @return  respInput
 **/
def inputUser(def question, def defaultValue, def description, def field, def inputTimeout, def timeoutExit='error', def pattern, def required, def type) {
    respInput = ""

    try {
        timeout(time: inputTimeout, unit: 'SECONDS') {
            if ( type == "text" ) {
                userInput = input(
                    id: 'userInput', message: "${question}", parameters: [
                        [$class: 'TextParameterDefinition', defaultValue: "${defaultValue}", description: "${description}", name: "${field}"]
                ])
                echo "Answer informed: ${field}=${userInput}"
            } else if ( type == "password" ) {
                userInput = input(
                    id: 'userInput', message: "${question}", parameters: [ password(defaultValue: '', description: "${description}", name: "${field}")]
                )
            } else if ( type == "vault" ) {
                userInput = input(
                    id: 'userInput', message: "${question}", parameters: [ credentials(credentialType: 'com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl',defaultValue: '', description: "${description}", name: "${field}",required: true, )]
                )
                logMsg("Get secret for vault ${userInput}", "INFO")
                withCredentials([usernamePassword(credentialsId: userInput, passwordVariable: 'pass', usernameVariable: 'user')]) {
                    userInput = "id=" + userInput + " user=" + user + " password=" + pass
                }
            } 
            respInput = userInput
        }
    } catch (err) {
        if ( timeoutExit == 'error' ){
            log['execution_result'] = "ERROR"
            log['message'] = "Error in read parameters for launch"
            throw err
        }
    }

    if ( required == "true" ) {
        if ( respInput == "" ) {
            logMsg("Field ${field} not informed and is mandatory", "ERROR")
            log['execution_result'] = "ERROR"
            log['message'] = "Field ${field} not informed and is mandatory"
            throw err
        }
    } else {
        logMsg("Field ${field} is not mandatory", "INFO")
    }
}

/**
 * selectedProperty
 * Método recebe interação de usuário via select box
 * @version 1.0.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          choices        - Valores do select box
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 *          required       - Define se é obrigatorio 
 * @return  respInput
 **/
def selectedProperty(def question, def choices, def field, def inputTimeout, def required) {
    choices   =  choices.replaceAll(";", "\n")
    respInput = ""

    timeout(time: inputTimeout, unit: 'SECONDS') {
        userInput = input(
            message: "${question}", parameters: [choice(name: "${field}", choices: "${choices}")]
        )
    }

    respInput = userInput
    echo "Answer informed: ${field}=${respInput}"
}

/**
 * getCurrentUser
 * Método retorna o usuário que disparou o job
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def getCurrentUser(){
    wrap([$class: 'BuildUser']){
	if ( params.who_executed != null && who_executed !=  "" ) {
            logMsg("Custom user specified: " + who_executed, "INFO")
            log['who_executed'] = who_executed
            log['legacy_logon'] = legacy_logon
            log['email'] = email
            log['title'] = title
            log['department'] = department
            return who_executed
        } else if ( env.BUILD_USER_ID == "timer" ) {
           logMsg("Execution by schedule this is magic", "INFO")
           log['who_executed'] = "by_magic"
           return "by_magic"
        } else {
            log['who_executed'] = env.BUILD_USER_ID
            return env.BUILD_USER_ID
        }
        
    }
}

/**
 * getQueue
 * Método que pega um item da fila de entrada de request
 * @version 2.1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  item
 **/
def getQueue() { 
    def item = ''

    item = sh(script: "#!/bin/sh -e\n ls -h ${workSpaceQueueIn} | head -1 | sed -e 's/.queue//g'", returnStdout: true)
    item = item.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

    if ( item != "" ) {
        logMsg("Item found to processing ${item}", "INFO")
        return item
    } else {
        echo "Launch canceled by ${changeorderAssignedTo}"
        logMsg("Item not found in ${workSpaceQueueIn} to processing, skip this execution", "INFO")
        currentBuild.description = "Item not found to processing, skip this execution by ${changeorderAssignedTo}"
        currentBuild.result == 'ABORTED'
        launchCanceled = true
        log['execution_result'] = "CANCELED"
        log['message'] = "Launch canceled by ${changeorderAssignedTo}"
        error('Launch canceled by ${changeorderAssignedTo}')
    }
}

/**
 * changeQueue
 * Método que move um item de fila
 * @version 2.1.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   orig - Fila de origem 
 *          dst  - Fila de destino 
 *          item - Nome do item
 * @return  true | false
 **/
def changeQueue(def orig, def dst, def item) { 
    logMsg("Change item ${item} from ${orig} to ${dst}", "INFO")
    sh(script: "#!/bin/sh -e\n mv -f ${orig}/${item}.queue ${dst}/${item}.queue", returnStdout: false)
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
 * logMsg
 * Método loga as msg de construções
 * @version 2.1.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   msg  - Mensagem a ser exibida 
 *          type - Tipo de msg
 * @return  true | false
 **/
def logMsg(def msg, def type) {
    def dtLog = new Date().format(" dd-MM-yyyy HH:mm:ss")

    if ( changeorderAssignedTo == "by_magic" ) {
        echo "[ By Magic " + type + " ] " + dtLog + " - " + msg
    } else {
        echo "[ " + type + " ] " + dtLog + " - " + msg 
    }
}

/**
 * etl
 * Método que cria a string de log para etl
 * @version 2.3.0
 * @package Service Catalog Infrastructure
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   
 * @return  true | false
 **/
def etl() {
    workSpaceQueueEtl = pathWorkspace + '/queue/etl/'
    log['parameters'].remove("example")
    def logJsonStr = JsonOutput.toJson( log )
    def etlFile  = workSpaceQueueEtl + UUID.randomUUID().toString() + '.etl'
    def jsonBeauty = JsonOutput.prettyPrint( logJsonStr )
    
    logMsg("Write string log for ETL in " + etlFile , "INFO")
    writeFile file: etlFile , text: """${jsonBeauty}"""
}

/**
 * jsonParse
 * Faz parse para leitura json
 * @version 2.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  jsonParse
 **/
@NonCPS
def jsonParse(def json) {
    new groovy.json.JsonSlurperClassic().parseText(json)
}

/**
 * email
 * Faz envio de notificações
 * @version 2.4.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def email(def destEmail, def emailSubject,  def typeEmail) {
    def emailMsg = ''

    logMsg("Send email ${typeEmail} to team ${destEmail}", "INFO")

    try {
        switch (typeEmail) {
            case "onsuccess":
                emailMsg = "<p>Olá ${destEmail}</p>" +
                           "<p>Seu launch de ${template} acabou de ser executado com <b>SUCESSO</b> e você estava tomando um café :) </p>" +
                           "<p><b>Detalhes</b><br />" +
                           "Template : ${template}<br />" +
                           "Usuário  : ${changeorderAssignedTo}<br />" +
                           "Link     : " + urlBaseJenkins + "</p><br /><br />" +
                           "<p>by <b>DevSecOps Architecture Team</b></p>";
                break
            case "onfailure":
                emailMsg = "<p>Olá ${destEmail}</p>" +
                           "<p>Seu launch de ${template} acabou de ser executado com <b>FALHA</b> não deixe de dar uma analisada para um suporte ou correção com o usuário</p>" +
                           "<p><b>Detalhes</b><br />" +
                           "Template : ${template}<br />" +
                           "Usuário  : ${changeorderAssignedTo}<br />" +
                           "Link     : " + urlBaseJenkins + "</p><br /><br />" +
                           "<p>by <b>DevSecOps Architecture Team</b></p>";
                break
        }

        mail from: "devsecops-architecture-brazil@br.experian.com",
             to: "${destEmail}",
             subject: "${emailSubject}",
             body: "${emailMsg}",
             charset: 'UTF-8', mimeType: 'text/html'
    } catch (err) {
        logMsg("Erro in send email ${typeEmail} to team ${destEmail}", "WARN")
    }

}


    /**
    * Metodo de envio de car de status via PowerAutomate
    * Bloco faz chamada API para o PowerAutomate disparar card de status
    **/
def cardStatus(def status) {

       
    PowerAutomateURL='https://prod-39.westus.logic.azure.com:443/workflows/51ce2e8a698645a0b9c623837e8f54ee/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=VTocvW8PHqIIcfrsqIIvfM50fKtWixPowN9XO2jKbL0'
    
    if ( status == "START" ){
    
            PowerAutomateData=''
            PowerAutomateData="{ \"email\":\"${email}\", \"logon\":\"${legacy_logon}\", \"launch\":\"${template}\", \"date_start\":\"${log['date_start']}\", \"status\":\"${status}\" }"
        
            sh(script: "set +x; if ! curl -m 20 --location --request POST '${PowerAutomateURL}' --header 'Content-Type: application/json' --data '${PowerAutomateData}' 2> /dev/null; then echo 'OPS, não foi possível enviar o card de status';fi", returnStdout: false)
    } else if (status == "ERROR") {

                PowerAutomateData=''
                PowerAutomateData="{ \"email\":\"${email}\", \"logon\":\"${legacy_logon}\", \"launch\":\"${template}\", \"date_start\":\"${log['date_start']}\", \"date_end\":\"${log['date_end']}\", \"status\":\"${status}\", \"team_owner\":\"${log['team_owner']}\" }"
        
                sh(script: "set +x; if ! curl -m 20 --location --request POST '${PowerAutomateURL}' --header 'Content-Type: application/json' --data '${PowerAutomateData}' 2> /dev/null; then echo 'OPS, não foi possível enviar o card de status';fi", returnStdout: false)
    } else if (status == "SUCCESS") {

                PowerAutomateData=''
                PowerAutomateData="{ \"email\":\"${email}\", \"logon\":\"${legacy_logon}\", \"launch\":\"${template}\", \"date_start\":\"${log['date_start']}\", \"date_end\":\"${log['date_end']}\", \"status\":\"${status}\", \"team_owner\":\"${log['team_owner']}\" }"
        
                sh(script: "set +x; if ! curl -m 20 --location --request POST '${PowerAutomateURL}' --header 'Content-Type: application/json' --data '${PowerAutomateData}' 2> /dev/null; then echo 'OPS, não foi possível enviar o card de status';fi", returnStdout: false)

    } else if ( status == "NPS"){
                
                PowerAutomateData=''
                PowerAutomateURL=''
                PowerAutomateData="{ \"email\":\"${email}\", \"logon\":\"${legacy_logon}\", \"launch\":\"${template}\", \"date_start\":\"${log['date_start']}\", \"date_end\":\"${log['date_end']}\", \"team_owner\":\"${log['team_owner']}\" }"
                if ( engineCmd == "/opt/deploy/joaquin-x/bin/engine.sh" ) {
                    PowerAutomateURL='https://prod-56.westus.logic.azure.com:443/workflows/8a7ffc10bf074ed88eea6bd815a1cce3/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zyVb6GyE79O5sZZYGCFQ87jzfZloGnZoelWUWANo8Qs'
                } else {
                    PowerAutomateURL='https://prod-76.westus.logic.azure.com:443/workflows/c19047aaed4c4380977fd4b9a1ac8c66/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=qjrkCxDPBz4kECaYpof09nW_2zOYAKpwDQzJyeACnuI'
                }
                sh(script: "set +x; if ! curl -m 20 --location --request POST '${PowerAutomateURL}' --header 'Content-Type: application/json' --data '${PowerAutomateData}' 2> /dev/null; then echo 'OPS, não foi possivel enviar a pesquisa de satisfacao!';fi", returnStdout: false)
    }
    
}

/**
 * teamsNotifications
 * Faz envio de notificações via Teams
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def teamsNotifications(def status) {

    def teamId = ''
    def channelId = ''

    if ( status == "FALHA" ) {
        teamId = joaquinXTemplate.notification.onfailure.teams.team_id
        channelId = joaquinXTemplate.notification.onfailure.teams.channel_id
    } else {
        teamId = joaquinXTemplate.notification.onsuccess.teams.team_id
        channelId = joaquinXTemplate.notification.onsuccess.teams.channel_id
    }

    logMsg("Sending notifications to Teams automation owner", "INFO")

    powerAutomateEndpoint = "https://prod-155.westus.logic.azure.com:443/workflows/1561d30721f24f889ad4fbbaf4577940/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=5BzwqgtTRs2V9g7dl2GdqYXMGcB_82pgJUAPiCO79E4"
    postData = "{ \"launcher\":\"${template}\", \"email\":\"${email}\", \"status\":\"${status}\", \"date_start\":\"${log['date_start']}\", \"team_id\":\"${teamId}\", \"channel_id\":\"${channelId}\" }"

    sh(script: "set +x; curl -m 20 --location --request POST '${powerAutomateEndpoint}' --header 'Content-Type: application/json' --data '${postData}' 2> /dev/null", returnStdout: false)

}

/**
 * sef
 * Realiza as validações SEF para a automação
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def sef(def ffName) {

    apiToken = ''
    sefEnvironment = ''

    withCredentials([usernamePassword(credentialsId: 'CyberArk-DAP-Authentication', passwordVariable: 'token', usernameVariable: 'user')]){
        cyberArkPasswordTmp = sh(script: "/opt/deploy/joaquin-x/bin/cyberArkDapAutomation.py -r static -t '${token}' -s 'BR_PAPP_EITS_DSECOPS_STATIC' -c 'sef-api-key'", returnStdout: true)
        apiToken = cyberArkPasswordTmp.split(" ")[1]
        apiToken = apiToken.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
    }

    if ( engineCmd == '/opt/deploy/joaquin-x/bin/engine.sh' ) {
        sefEnvironment = "prod"
    } else {
        sefEnvironment = "stg"
    }

    response = sh(script: "set +x; curl 'https://app.harness.io/cf/admin/features?accountIdentifier=89jpOP9RQu22FwOOh_Zpmg&orgIdentifier=default&projectIdentifier=Serasa_Experian_Flags&identifier=${ffName}&environmentIdentifier=${sefEnvironment}' --header 'x-api-key: ${apiToken}' -x 'http://spobrproxy.serasa.intranet:3128' 2> /dev/null", returnStdout: true)
    response = response.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
    jsonSef = jsonParse(response)

    if ( jsonSef.features.toString() == "[]" ) {
        logMsg("Opssss, Feature Flag ${ffName} not found in SEF.", "ERROR")
        throw err
    }

/**
 * value[1] retorna o valor da FF quando seu state é igual a on.
 * value[0] retorna o valor da FF quando seu state é igual a off.
**/
    if ( jsonSef.features.envProperties.state.toString() == "[on]" ) {
        return jsonSef.features.variations[0].value[1].toString()
    } else {
        return jsonSef.features.variations[0].value[0].toString()
    }

}

/**
 * houstonWeHaveAProblem
 * Realiza as validações SEF para a automação
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def houstonWeHaveAProblem(){

    if ( cockpit_env == "prod" ){
        houstonInstalledPath = "/opt/infratransac/houston-we-have-a-problem"
    } else {
        houstonInstalledPath = "/opt/infratransac/houston-we-have-a-problem-homolog"
    }
    
    logMsg("Invoking function houstonWeHaveAProblem", "INFO")
    
    logFilePath = "/opt/infratransac/jenkins/jobs/${env.JOB_NAME}/builds/${currentBuild.number.toString()}/log"
    if ( houstonAlive == "true" ) {
        if ( email != "" ){
            sh(script: "/usr/bin/python3 ${houstonInstalledPath}/search.py ${cockpit_env} ${email} ${template} ${logFilePath} ${env.BUILD_URL} ${houstonInstalledPath}", returnStdout: false)
        } else {
            logMsg("Email não encontrado. Impossível enviar notificação.", "ERROR")
        }
    } else {
        logMsg("Houston, We Have a Problem! desligado, skip...", "INFO")
    }
}

/**
 * validateSecrets
 * Realiza a validação dos segredos
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def validateSecrets(vault) {

    def vaultsList = ['BitbucketGlobal.DevSecOps-2', 'BR_PAPP_EITS_DSECOPS_STATIC', 'USCLD_PAWS_707064604759', 'USCLD_PAWS_559037194348']

    vaultsList.each { item ->
        if ( item == vault ) {
            if ( joaquinXTemplate.team_owner == "DevSecOps PaaS Brazil" ) {
                logMsg("Automação criada pelo time DevSecOps. Liberada a utilização de vault restrito.", "INFO")
            } else {
                logMsg("O vault ${vault} é de uso restrito para automações do time DevSecOps.", "ERROR")
                throw new Exception("O vault ${vault} é de uso restrito para automações do time DevSecOps.")
            }
        } 
    }
}


def serasaLegends(questName) {

    questId = 0

    try {

        if ( cockpit_env != 'prod' ) {
            urlLegends = "https://serasa-legends-domain-api-sand.sandbox-devsecops-paas.br.experian.eeca"
        } else {
            urlLegends = "https://serasa-legends-domain-api-prod.devsecops-paas-prd.br.experian.eeca"
        }

        logMsg("Serasa Legends - Olá meu obtuso amigo, sou o C3-PO. Vejo que você fez jus a pontuar no Serasa Legends.", "INFO")
        logMsg("Serasa Legends - Objetivo atingido: ${questName}", "INFO")

        response = "curl --location ${urlLegends}/serasa-legends/v1/players?page=0&size=1000".execute().text
        json = new JsonSlurperClassic().parseText(response)
        players = json.content
        
        registered_email = ""
        prefixEmail = ""
        prefixEmail = email.split("@")[0]

        for ( i = 0; i < players.size(); i++ ){
            prefixEmailPlayers = players[i].email.split("@")[0]
            if ( prefixEmailPlayers == prefixEmail ){
                if ( email != players[i].email ){
                    logMsg("Serasa Legends - Ora ora, seu email mudou de dominio, não é mesmo? Ainda bem que meus processadores detectaram essa mudança...", "INFO")
                    registered_email = players[i].email
                    break
                } else {
                    registered_email = email
                }
            }
        }

        response = ""
        response = "curl --location ${urlLegends}/serasa-legends/v1/quests?page=0&size=1000".execute().text

        json = new JsonSlurperClassic().parseText(response)

        quests = json.content

        for ( i = 0; i < quests.size(); i++ ) {
            if ( quests[i].name == questName ){
                questId = quests[i].id
                break
            }
        }

        sh(script: """ set +x; curl -k -s -X POST '${urlLegends}/serasa-legends/v1/playerQuests/done' -H 'Content-Type: application/json' -d '{ "email": "${registered_email}", "questId": ${questId}, "description": "automation=${template}, buildId=${currentBuild.number}" }' > /dev/null""", returnStdout: false)

    } catch (Exception e) {
        logMsg("Oh céus, por algum motivo meu processador falhou...", "ERROR")
        logMsg(e, "ERROR")
    }
}


return this