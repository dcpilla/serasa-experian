/**
 * createPayload
 * Método monta os payloads de acordo com o status"
 * @version 1.0.0
 * @package DevOps
 * @author  Paulo Ricassio Costa dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def createPayload(def status) {

    def url = ""
    def payload = ""
    def payloadPost = ""

    if ( status == "startPipeline" ){
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "tribe": "${tribe}",
            "versionApp": "${versionApp}",
            "urlPipeline": "${urlPipeline}",
            "gitBranch": "${gitBranch}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "helpPipeline" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "gitRepo": "${gitRepo}",
            "gitMsgCommit": "${gitMsgCommit}",
            "errorPipeline": "${errorPipeline}",
            "helpPipeline": "${helpPipeline}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "endPipeline" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "tribe": "${tribe}",
            "versionApp": "${versionApp}",
            "urlPipeline": "${urlPipeline}",
            "language": "${language}",
            "sonarUrl": "${sonarUrl}",
            "artifactId": "${artifactId}",
            "veracodeUrlReports": "${veracodeUrlReports}",
            "jmeterUrlReports": "${jmeterUrlReports}",
            "cucumberUrlReports": "${cucumberUrlReports}",
            "qsTestUrlReports": "${qsTestUrlReports}",
            "gitBranch": "${gitBranch}",
            "status": "${status}" 
        }
        """
        return payload
    } else if ( status == "sonarQualityGatesAlert" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "sonarQualityGatesDescription": "${sonarQualityGatesDescription}",
            "language": "${language}",
            "sonarUrl": "${sonarUrl}",
            "artifactId": "${artifactId}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "requestPullRequest" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "language": "${language}",
            "urlPipeline": "${urlPipeline}",
            "gitBranch": "${gitBranch}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "sendPullRequest" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "language": "${language}",
            "gitUrlPullRequest": "${gitUrlPullRequest}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "requestChangeOrder" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "gitBranch": "${gitBranch}",
            "urlPipeline": "${urlPipeline}",
            "changeorderNumber": "${changeorderNumber}",
            "changeorderTemplate": "${changeorderTemplate}",
            "changeorderHowto": "${changeorderHowto}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "createChangeOrder" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "language": "${language}",
            "gitBranch": "${gitBranch}",
            "urlPipeline": "${urlPipeline}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "alertaGovernancaDados" ) {
        payload = """
        {
            "email": "governancadeDados@br.experian.com",
            "tribe": "${tribe}",
            "applicationName": "${applicationName}",
            "versionApp": "${versionApp}",
            "language": "${language}",
            "gitRepo": "${gitRepo}",
            "gitCommit": "${gitCommit}",
            "gitBranch": "${gitBranch}",
            "urlPipeline": "${urlPipeline}",
            "hadoopDirPath": "${hadoopDirPath}",
            "status": "${status}"
        }
        """
        return payload
    } else if ( status == "hadolintCheck" ) {
        payload = """
        {
            "email": "${gitAuthorEmail}",
            "applicationName": "${applicationName}",
            "tribe": "${tribe}",
            "versionApp": "${versionApp}",
            "gitBranch": "${gitBranch}",
            "codigosDL": "${codigosDL}",
            "status": "${status}"
        }
        """
        return payload
    }
}

/**
 * cardStatus
 * Método envia card do PA via teams
 * @version 2.0.0
 * @package DevOps
 * @author  Paulo Ricassio Costa dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def cardStatus(def status) {

    url = "https://prod-167.westus.logic.azure.com:443/workflows/7e74220982934ebb9adb739097e64137/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=kfxC3GhT_tehXm4m6DO4sHew6HV5iMSijioJjWIjWJc"
    payloadPost = createPayload(status)

    if (payloadPost != "") {
        utilsRestLib.httpPostPA(url, payloadPost)
    }        
}

/**
 * houstonWeHaveAProblem
 * Método realiza analise dos erros e disponibilização de documentação
 * @version 2.0.0
 * @package DevOps
 * @author  Paulo Ricassio Costa dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def houstonWeHaveAProblem() {
    
    echo "Invoking function houstonWeHaveAProblem"

    def logFilePath = "/opt/infratransac/piaas-build-logs/${currentBuild.number.toString()}"
    def repoPath = "${env.WORKSPACE}/${env.BUILD_NUMBER}/houston-we-have-a-problem"

    try {
        if (houstonAlive == "true") {
            sh "git clone ssh://git@code.experian.local/dedeex/houston-we-have-a-problem.git ${repoPath}"
            if (gitAuthorEmail != "") {
                sh(script: "docker run --rm \
                        -e piaasEnv=${piaasEnv}  \
                        -e gitAuthorEmail=${gitAuthorEmail} \
                        -e codeError=${piaasMainInfo.pipeline_code_error} \
                        -e buildUrl=${BUILD_URL} \
                        -v ${logFilePath}:/log  \
                        -v ${repoPath}:/houston-we-have-a-problem \
                        ${ecrRegistry}piaas-houstonwehaveaproblem:houston-1.0.0", returnStdout: false)        
            } else {
                utilsMessageLib.errorMsg("Email não encontrado. Impossível enviar notificação.")
            }                      
        } else {
            utilsMessageLib.infoMsg("Houston, We Have a Problem! desligado, skip...")
        }
    } catch (Exception e) {
        utilsMessageLib.warnMsg("Erro durante a execução da função do houstonWeHaveAProblem: ${e.message}")
    }    
}

return this