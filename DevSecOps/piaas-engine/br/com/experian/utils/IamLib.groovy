/**
 * getJwtToken
 * Método retorna o token JWT
 * @version 8.27.0
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  token
 **/
def getJwtToken() {
    def authApiUri = ""
    def successMessage = "Sucesso ao recuperar token JWT"
    def failMessage = "Falha ao recuperar token JWT"
    postPayLoad = """
    {
        "clientId": "${clientId}",
        "clientSecret": "${clientSecret}"
    }
    """

    if ( piaasEnv == "prod" ) {
        authApiUri = "https://devsecops-authentication-api-prod.devsecops-paas-prd.br.experian.eeca/devsecops-authentication/v1/orgs/login"
    } else {
        authApiUri = "https://devsecops-authentication-api-sand.sandbox-devsecops-paas.br.experian.eeca/devsecops-authentication/v1/orgs/login"
    }

    returnPostExec = utilsRestLib.httpPost(authApiUri, "", "", 200, postPayLoad, successMessage, failMessage)

    if ( returnPostExec == null) {
        throw new Exception(utilsMessageLib.errorMsg("Falha ao resgatar o token JWT. Impossível prosseguir."))
    }

    jsonResponse = utilsJsonLib.jsonParse(returnPostExec)

    if ( jsonResponse.containsKey("accessToken") ) {
        return jsonResponse.accessToken
    } else {
        println(jsonResponse)
        throw new Exception(utilsMessageLib.errorMsg("Falha ao resgatar o token JWT. Impossível prosseguir."))
    }

}

return this