/**
 * was
 * Método faz chamadas ao deploy was
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def was(def cmdWas){

    def gitBranchValidate = ''
    urlPackageNexus = ''

    utilsMessageLib.infoMsg("Invoking deploy was")

    if (gitBranch.contains("feature")) {
        gitBranchValidate = 'feature'
    }
    else {
        gitBranchValidate = gitBranch
    }

    switch (gitBranchValidate) {
        case ["feature", "develop", "qa", "hotfix"]:
            if (!(cmdWas.toLowerCase().contains("--environment=de") || cmdWas.toLowerCase().contains("--environment=deeid") || cmdWas.toLowerCase().contains("--environment=hi") || cmdWas.toLowerCase().contains("--environment=he") || cmdWas.toLowerCase().contains("--environment=hieid"))) {
                imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                utilsMessageLib.errorMsg("Check environment informed for branch in playbook")
                currentBuild.description = "Check environment informed to deploy WAS for branch in piaas.yml"
                errorPipeline = "Check environment informed to deploy WAS for branch in piaas.yml."
                helpPipeline = "Você está tentando fazer um deploy indevido em ambientes WAS, para develop, feature*, qa e hotfix os ambientes permitidos são de|deeid|hi|he|hieid."
                if ((gitBranchValidate == "feature") || (gitBranchValidate == "develop")) {
                    piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_WAS_001'
                }
                else if ((gitBranchValidate == "qa") || (gitBranchValidate == "hotfix")) {
                    piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_WAS_002'
                }
                echo "Solucao: ${helpPipeline}"
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }
            break
        case "master":
            if (!(cmdWas.toLowerCase().contains("--environment=pe") || cmdWas.toLowerCase().contains("--environment=pi") || cmdWas.toLowerCase().contains("--environment=peeid") || cmdWas.toLowerCase().contains("--environment=pefree"))) {
                imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                utilsMessageLib.errorMsg("Check environment informed for branch in playbook")
                currentBuild.description = "Check environment informed to deploy WAS for branch in piaas.yml"
                errorPipeline = "Check environment informed to deploy WAS for branch in piaas.yml."
                helpPipeline = "Você está tentando fazer um deploy indevido em ambientes WAS, para master os ambientes permitidos são pe|pi|peeid|pefree."
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_WAS_003'
                utilsMessageLib.infoMsg("Solucao: ${helpPipeline}")
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }
            break
    }

    echo "Details deploy '${cmdWas}'"

    def urlPackageArtifactId = artifactId
    cmdWas.split().each {
        if (it.toLowerCase().contains("--application-name")) {
            urlPackageArtifactId = it.split('=')[1]
        }
    }

    if (gitBranch == "master") {
        urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/service/rest/v1/search/assets/download?sort=version&repository=releases&maven.groupId=" + "${groupId}" + "&maven.artifactId=" + "${urlPackageArtifactId}" + "&maven.baseVersion=" + "${versionApp}" + "&maven.extension=" + "${typePackage}"
    } else {
        urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/service/rest/v1/search/assets/download?sort=version&repository=snapshots&maven.groupId=" + "${groupId}" + "&maven.artifactId=" + "${urlPackageArtifactId}" + "&maven.baseVersion=" + "${versionApp}" + "&maven.extension=" + "${typePackage}"
    }

    utilsMessageLib.infoMsg("The url redirect nexus ${urlPackageNexus}")
    urlPackageNexus = sh(script: "curl -I -k \"${urlPackageNexus}\" | grep Location | cut -d ' ' -f 2", returnStdout: true)
    urlPackageNexus = urlPackageNexus.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
    utilsMessageLib.infoMsg("The url nexus to deploy ${urlPackageNexus}")
    piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_WAS_004'

    sh(script: "/opt/infratransac/core/br/com/experian/service/deploy/deployWas.sh --target=was --url-package=${urlPackageNexus} ${cmdWas}", returnStdout: false)

    if ((gitBranch == "qa") || (gitBranch == "hotfix")) {
        urlPackageNexus = ''

        urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/service/rest/v1/search/assets/download?sort=version&repository=releases&maven.groupId=" + "${groupId}" + "&maven.artifactId=" + "${urlPackageArtifactId}" + "&maven.baseVersion=" + "${versionApp}" + "&maven.extension=" + "${typePackage}"

        changeorderDescription = changeorderDescription +
                                 "*** Nexus{/n}" +
                                 "Url pacote: ${urlPackageNexus}{/n}" +
                                 "{/n}";

        changeorderRollback = "Realizar o deploy com Release Automation{/n}" +
                              "Nome da Aplicação: was_deploy{/n}" +
                              "Projects: Rollback{/n}" +
                              "Nome do app no websphere:{/n}" +
                              "Cluster:{/n}" +
                              "Ambiente:{/n}";
    }
}

return this