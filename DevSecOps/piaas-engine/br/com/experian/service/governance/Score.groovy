/**
 * scorePost
 * Método envia o score para a API de Score
 * @version 8.2.0
 * @package DevOps
 * @author  andre.arioli@br.experian.com
 **/
def scorePost(def score, def tool, def operation) {
    def scoreApiUri = ""
    def jwtToken = ""
    def successMessage = "Sucesso ao enviar o Score para a API"
    def failMessage = "Falha ao enviar o Score para a API"
    scorePayload = """
    {   
        "score": "${score}",
        "tool": "${tool}"
    }
    """

    if ( ! gitBranch.contains("master") ) {
        if ( piaasEnv == "prod" ) {
            scoreApiUri = "https://piaas-score-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-score/v1/executions/${idPiaasEntityExec}/${operation}"
        } else {
            scoreApiUri = "https://piaas-score-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-score/v1/executions/${idPiaasEntityExec}/${operation}"
        }

        jwtToken = utilsIamLib.getJwtToken()

        returnPostExec = utilsRestLib.httpPostBearer(scoreApiUri, jwtToken, 201, scorePayload, successMessage, failMessage)
        
        if ( returnPostExec == null) {
            utilsMessageLib.errorMsg("${failMessage}. Tente novamente mais tarde!")
        } else {
            jsonResponse = utilsJsonLib.jsonParse(returnPostExec)

            if ( jsonResponse.containsKey("id") ) {
                utilsMessageLib.infoMsg("Score ${score} da ferramenta ${tool} registrado com sucesso!")
            } else {
                println(jsonResponse)
                utilsMessageLib.errorMsg("${failMessage}. Tente novamente mais tarde!")
            }
        }
    } else {
        utilsMessageLib.infoMsg("Envio do Score ignorado para branch produtiva.")
    }

}

return this