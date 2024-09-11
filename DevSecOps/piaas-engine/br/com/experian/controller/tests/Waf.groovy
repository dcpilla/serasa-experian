/** 
 * setDetailsWaf
 * Método pega detalhes do WAF da aplicação 
 * @version 8.2.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  $versionApp
 **/
 def setDetailsWaf() {
    def dataQuery    = ''
    def fileSql      = "/tmp/" + UUID.randomUUID().toString() + ".sql"; 
    def queryWaf     = "SET NOCOUNT ON;SELECT '{\"Active\":\"' + REPLACE(CAST(tblWaf.Active AS NVARCHAR(MAX)),'\\\','\\\\\') + '\",'+'\"Status\":\"' + REPLACE(CAST(tblWaf.Status  AS NVARCHAR(MAX)),'\\\','\\\\') + '\",'+ +'\"StatusProdURL\":\"' + REPLACE(CAST(tblWaf.StatusProdURL AS NVARCHAR(MAX)),'\\\','\\\\') + '\"}' FROM VULNERABILITY_MANAGEMENT_TESTING.dbo.SecureCoreFullAppInventoryView tblWaf WHERE AppID = " + piaasMainInfo.gearr_id + " FOR XML PATH('');"
    def jsonQuery    = '' 

    echo "Invoking function setDetailsWaf"
    
    if ( ( piaasMainInfo.gearr_u_network_type == "INTERNET" ) || ( piaasMainInfo.gearr_u_network_type == "EXTRANET" ) ) { 
        echo "The application network type is " + piaasMainInfo.gearr_u_network_type + ", execution calculated score WAF"
        
        echo "Create file for query of the VMS(10.10.198.92) base WAF in " + fileSql 
        writeFile file: fileSql, text: """---
        ${queryWaf}"""

        echo "Running query in VMS(10.10.198.92)"
        try {
            withCredentials([usernamePassword(credentialsId: 'user_query_vms', passwordVariable: 'pass', usernameVariable: 'user')]) {
                dataQuery = sh(script: "#!/bin/sh -e\n /opt/mssql-tools/bin/sqlcmd -S 10.10.198.92 -U ${user} -P '${pass}' -i $fileSql -h -1", returnStdout: true)
                dataQuery = dataQuery.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
            }

            echo "Query success !!!"
            echo "Data returned " + dataQuery
            jsonQuery =  utilsJsonLib.jsonParse(dataQuery)
            wafStatus = jsonQuery.Status
            wafActive = jsonQuery.Active
            wafComplianceStatus = jsonQuery.StatusProdURL.replaceAll(" ", "_")
            
            echo "Execution analyze data query to score calculation for WAF"
            echo "WAF status read: " + wafStatus
            echo "WAF compliance status read: " + wafComplianceStatus
            if ( ( wafActive == "true" ) && ( wafStatus == "Production" ) && ( wafComplianceStatus == "Active_Blocking" ) ) {
                echo "Application passed in the WAF rules" 
                toolsScore.waf.analysis_performed = 'true'
                toolsScore.waf.score = 100
                piaasMainInfo.waf_analysis_performed= 'true'
                piaasMainInfo.waf_score = toolsScore.waf.score
                changeorderTestResult = changeorderTestResult +
                                        "**** WAF - [ Score: " + piaasMainInfo.waf_score + " ]{/n}"  +
                                        "Status: " + wafStatus + "{/n}" +
                                        "Active: " + wafActive + "{/n}" +
                                        "Compliance Status: " + wafComplianceStatus + "{/n}{/n}";
            } else if ( ( wafActive == "true" ) && ( wafStatus == "Production" ) ) {
                if ( ( wafComplianceStatus != "Active_Blocking" ) || ( wafComplianceStatus != "Control_Not_Applicable" ) || ( wafComplianceStatus != "Pending_Appliance" ) ) {
                    echo "Application not passed in the WAF rules" 
                    toolsScore.waf.analysis_performed = 'true'
                    toolsScore.waf.score = 0
                    piaasMainInfo.waf_analysis_performed= 'true'
                    piaasMainInfo.waf_score = toolsScore.waf.score
                    changeorderTestResult = changeorderTestResult +
                                            "**** WAF - [ Score: " + piaasMainInfo.waf_score + " ]{/n}"  +
                                            "Status: " + wafStatus + "{/n}" +
                                            "Active: " + wafActive + "{/n}" +
                                            "Compliance Status: " + wafComplianceStatus + "{/n}{/n}";
                }
            } else {
                echo "Application not found in the WAF rules" 
                toolsScore.waf.analysis_performed = 'true'
                toolsScore.waf.score = 0
                piaasMainInfo.waf_analysis_performed= 'true'
                piaasMainInfo.waf_score = toolsScore.waf.score
                changeorderTestResult = changeorderTestResult +
                                            "**** WAF - [ Score: " + piaasMainInfo.waf_score + " ]{/n}"  +
                                            "Status: " + wafStatus + "{/n}" +
                                            "Active: " + wafActive + "{/n}" +
                                            "Compliance Status: " + wafComplianceStatus + "{/n}{/n}";
            }
        } catch (err) {
            echo "Query error in VMS(10.10.198.92) base WAF, impossible to perform score calculation for WAF"
            println("Error: $err")
            echo "Apply zero for score WAF because query not success"
            toolsScore.waf.analysis_performed = 'true'
            toolsScore.waf.score = 0
            piaasMainInfo.waf_analysis_performed= 'true'
            piaasMainInfo.waf_score = toolsScore.waf.score
        }
    } else if ( piaasMainInfo.gearr_u_network_type == "INTRANET" ) {
        echo "The application network type is " + piaasMainInfo.gearr_u_network_type + ", not necessary execution calculated score WAF"
        toolsScore.remove('waf')
        piaasMainInfo.waf_analysis_performed= 'not_necessary'
        piaasMainInfo.waf_score = 0
    } else {
        echo "The application network type not found apply zero for score WAF"
        toolsScore.waf.analysis_performed = 'true'
        toolsScore.waf.score = 0
        piaasMainInfo.waf_analysis_performed= 'true'
        piaasMainInfo.waf_score = toolsScore.waf.score
    }

    serviceGovernanceScore.scorePost(piaasMainInfo.waf_score, "WAF", "score-waf")
}

return this