/**
 * detectSecrets
 * Método que invoca detect secrets no código fonte
 * @version 8.5.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  $versionApp
 **/
def detectSecrets() {
    detectSecretsResp = ""

    detectSecretsResp = sh(script: "docker run --rm \
                                                -v ${WORKSPACE}/${currentBuild.number}:/scan \
                                                ${ecrRegistry}detect-secrets", returnStdout: true)
    detectSecretsResp = detectSecretsResp.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\"", "")

    if ( detectSecretsResp != "" ) {
        println(detectSecretsResp) 
        utilsMessageLib.errorMsg("We identified in its source code information from sensors of passwords committed together with the code, this is a serious problem that we cannot follow with its execution") 
        currentBuild.description = "Sensors of passwords committed together code"
        errorPipeline = "We identified in its source code information from sensors of passwords committed together with the code, this is a serious problem that we cannot follow with its execution."
        helpPipeline = "Remova arquivos com senhas de seu código fonte. Arquivos violados: ${detectSecretsResp}"
        piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_DETECT_SECRETS_001'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(helpPipeline)
    } else {
        utilsMessageLib.infoMsg("We are very proud that you didn't commit passwords in your source code o/")
    }    
}

return this