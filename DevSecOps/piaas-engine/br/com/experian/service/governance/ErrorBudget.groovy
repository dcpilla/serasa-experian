import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.DumperOptions
import java.nio.charset.StandardCharsets
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

/**
 * getAppIdErrorBudgetData
 * Método para verificar se GearrId esta em Error Budget Data
 * @version 8.36.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @param   
 * @return  true | false
 **/
def getAppIdErrorBudgetData() {

    echo "Invoking function getAppIdErrorBudgetData"

    try {
        def urlSearch = "http://spobrmetabasebi:3000/api/public/card/02f8105f-3ba1-4a6c-b4b9-6e3b238e3d50/query/json?parameters=%5B%7B%22type%22%3A%22category%22%2C%22value%22%3A%22" + piaasMainInfo.gearr_id + "%22%2C%22target%22%3A%5B%22variable%22%2C%5B%22template-tag%22%2C%22gearr_id%22%5D%5D%7D%5D"
        def data = new URL(urlSearch).text
        def json = new JsonSlurper().parseText(data)
        errorBudgetDataJson = json.toString()
        if ( errorBudgetDataJson == "[]" ) {
            utilsMessageLib.infoMsg("Application not found in Error Budget Data.")
            appErrorBudgetData = false
        } else {
            utilsMessageLib.infoMsg("Application found in Error Budget Data.")
            appErrorBudgetData = true
            piaasMainInfo.error_budget_configured = 'true'
        }
    } 
    catch (err) {
        utilsMessageLib.errorMsg("Unable to verify application in Error Budget Data. Contact the Platform Engineer team or try the execution again.")
        appErrorBudgetData = false
        echo ""
        currentBuild.description = "Unable to verify application in Error Budget Data. Impossible to proceed with the pipeline."
        errorPipeline = "Unable to verify application in Error Budget Data. Contact the Platform Engineer team or try the execution again."
        helpPipeline = "Não foi possível verificar a aplicação em Error Budget Data. Entre em contato com a equipe de Platform Engineer ou tente novamente a execução."
        piaasMainInfo.pipeline_code_error  = 'ERR_GET_APPID_ERROR_BUDGET_DATA_001'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw err
    }
}
return this