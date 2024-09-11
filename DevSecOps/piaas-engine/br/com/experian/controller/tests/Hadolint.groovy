/**
 * hadolintCheck
 * Método realiza analise com Hadolint no(s) arquivo(s) Dockerfile no Workspace da execução
 * @version 1.0.0
 * @package DevOps
 * @author  Paulo Ricassio Costa dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def hadolintCheck() {

    echo "Invoking function hadolintCheck"

    def repoPath = "${env.WORKSPACE}/${env.BUILD_NUMBER}"
    def fileExistes = sh(script: "ls ${repoPath}/Dockerfile*", returnStatus: true) == 0
    
    try {
        if (fileExistes) {
            def exitCode = sh(script: "docker run --rm \
                                       -v ${repoPath}:/lint \
                                       ${ecrRegistry}piaas-hadolint:hadolint-1.0.0", returnStatus: true)
            if (exitCode != 0) {
                utilsMessageLib.warnMsg("O Hadolint encontrou inconsistências no(s) seu(s) arquivo(s) Dockerfile :(")
                extractcodigosDL()
                try {
                    if (gitAuthorEmail != "") {
                        controllerNotifications.cardStatus('hadolintCheck')
                    }
                } catch (err) {
                    utilsMessageLib.warnMsg("Card not sent in function hadolintCheck")
                }
            } else {
                utilsMessageLib.infoMsg("O Hadolint não encontrou nenhum problema em seu(s) arquivos(s) Dockerfile 0/")
            }                           
        } else {
            utilsMessageLib.infoMsg("Não existem arquivo(s) Dockerfile no workspace. Ignorando execução do Hadolint.")
        }    
    } catch (Exception e) {
        utilsMessageLib.warnMsg("Erro durante a execução da função hadolintCheck: ${e.message}")
    }
}

/**
 * codigosDL
 * Método realiza a captura das DL's do log do Hadolint e salva em uma string
 * @version 1.0.0
 * @package DevOps
 * @author  Paulo Ricassio Costa dos Santos <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def extractcodigosDL() {

    println "Invoking function extractcodigosDL"

    def logFilePath = "/opt/infratransac/piaas-build-logs/${currentBuild.number.toString()}/log"
    
    try {

        def logContent = sh(script: "cat ${logFilePath}", returnStdout: true).trim()
        def pattern = ~/DL\d{4}/
        def matcher = pattern.matcher(logContent)
        
        while (matcher.find()){
            codigosDL << matcher.group()
        }

        return codigosDL.join(', ')

    } catch (Exception e) {
        println "Erro ao ler o arquivo de log: ${e.message}"
        return ''
    }

}

return this