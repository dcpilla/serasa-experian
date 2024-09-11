def egocSendOmInfos() {
    def url = "https://prod-105.westus.logic.azure.com:443/workflows/cb194313d33e4abb8525fe410af7e870/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=tCdZ_by_fgrqvCzuqti5ABQ8fBqOiHo63fHSIAlX_NA"    
    def payload = """
    {
        "ChangeOrder": "${changeorderNumber}",
        "Status": "Sucesso",
        "Name": "${piaasMainInfo.name_application}",
        "ApplicationConfigItens": "${changeorderConfigItens}",
        "ApplicationVersion": "${piaasMainInfo.version_application}",
        "GearrID": "${piaasMainInfo.gearr_id}",
        "GearrAPname": "${piaasMainInfo.gearr_application_name}",
        "GearrScore": "${piaasMainInfo.gearr_score}",
        "ExecutionStart": "${changeorderWorkStart}",
        "ExecutionEnd": "${changeorderWorkEnd}",
        "Environment": "${environmentName}",
        "EnvironmentDeploy": "${piaasMainInfo.environment_deploy}",
        "Severity": "${piaasMainInfo.gearr_business_criticality}",
        "Type": "${piaasMainInfo.type_application}",
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
}