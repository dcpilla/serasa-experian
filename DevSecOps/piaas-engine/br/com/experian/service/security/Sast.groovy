/**
 * veracode
 * Método faz chamadas ao veracode
 * @version 8.16.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def veracode(def cmdVeracode, def funcOrigin) {
    def versionAppVeracode = ''
    def stringCmdVeracode = ''
    versionAppVeracode = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    veracodeUrlReports = ''

    echo "Invoking test veracode"
    echo "Details test '${cmdVeracode}'"

    if (!cmdVeracode.toLowerCase().contains("--application-name")) {
        stringCmdVeracode = stringCmdVeracode + " --application-name=${artifactId}"
    }

    if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
        changeorderTestResult = changeorderTestResult +
                                "**** VeraCode - Métricas de vulnerabilidade{/n}" +
                                "${veracodeUrlReports}{/n}";
    }

    try {
        sh(script: "${packageBasePath}/service/security/veracode.sh ${cmdVeracode} --upload-dir=${WORKSPACE}/${currentBuild.number} --application-name=${artifactId} --application-type=${piaasMainInfo.gearr_u_network_type} --version-app=${versionAppVeracode} --piaas-entity-id=${idPiaasEntityExec}", returnStdout: false)
        utilsMessageLib.infoMsg("Seu processo do Veracode foi iniciado. Para mais detalhes verfique o console do PiaaS.")
    } catch (err) {
        utilsMessageLib.warnMsg("Ocorreu um erro ao iniciar o Veracode. Confira o log acima e faça as correções necessárias em sua próxima execução.")
    }

    toolsScore.veracode.analysis_performed= 'true' 

    piaasMainInfo.veracode_analysis_performed= 'true'

    cmdVeracode.split().each {
        if (it.toLowerCase().contains("--veracode-id")) {
            piaasMainInfo.veracode_id = it.split('=')[1]
        }
    }
}

/**
 * getVeracodeId
 * Método busca veracode id na definiçao do pipeline e salva no dashBoardCore
 * @version 8.4.0
 * @package DevOps
 * @author  Renato Thomazine <renato.thomazine@br.experian.com>
 * @return  true | false
 **/
def getVeracodeId() {
    def found = null
    echo "Invoking function getVeracodeId"

    ['develop','qa','uat', 'hotfix'].any { b ->
        def branch = mapResult[b];
        if (branch) {
            ['before_build','after_build'].any { s ->
                def step = branch[s];
                if (step) {
                    def res = step.find { it.key == "veracode" }?.value
                    if (res) {
                        res.split().each {
                            if (it.toLowerCase().contains("--veracode-id")) {
                                found = it.split('=')[1]
                            }
                        }
                    }
                }
                if (found) return true;
            }
        }
        if (found) return true;
    }

    if (found)
        piaasMainInfo.veracode_id = found

}

return this