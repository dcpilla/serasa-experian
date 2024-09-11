def batch(def cmdBatch) {
    scriptExecOut = ''

    echo "batch() ->Invoking execution batch..."
    echo "batch() ->Details execution '${cmdBatch}'"

    if (!cmdBatch) {
        utilsMessageLib.infoMsg("batch() ->Nenhum parametro definido")
    } else {
        utilsMessageLib.infoMsg("batch() ->Parametros: $cmdBatch")
    }

    def urlPackageArtifactId = artifactId
    def classifier = ''
    cmdBatch.split().each {
        if (it.toLowerCase().contains("--application-name")) {
            urlPackageArtifactId = it.split('=')[1]
        } else if (it.toLowerCase().contains("--classifier")) {
            classifier = it.split('=')[1]
        }
    }

    if ((gitBranch == "develop") || (gitBranch == "qa") || (gitBranch == "hotfix") || gitBranch.contains("feature")) {
        if (cmdBatch.toLowerCase().contains("--classifier")) {
            urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/repository/snapshots/" + groupId + "/" + urlPackageArtifactId + "/" + versionApp + "/" + urlPackageArtifactId + "-" + versionApp + "-" + classifier + "." + typePackage
        } else {
            urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/repository/snapshots/" + groupId + "/" + urlPackageArtifactId + "/" + versionApp + "/" + urlPackageArtifactId + "-" + versionApp + "." + typePackage
        }
    } else if (gitBranch == "master") {
        if (cmdBatch.toLowerCase().contains("--classifier")) {
            urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/repository/releases/" + groupId + "/" + urlPackageArtifactId + "/" + versionApp + "/" + urlPackageArtifactId + "-" + versionApp + "-" + classifier + "." + typePackage
        } else {
            urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/repository/releases/" + groupId + "/" + urlPackageArtifactId + "/" + versionApp + "/" + urlPackageArtifactId + "-" + versionApp + "." + typePackage
        }
    }

    echo "batch() ->The url nexus to deploy ${urlPackageNexus}"
    scriptExecOut = sh(script: "${packageBasePath}/service/deploy/deployBatch.sh --method=ansible --url-package=${urlPackageNexus} ${cmdBatch}", returnStdout: false)

    if ((gitBranch == "qa") || (gitBranch == "hotfix") || (madeByApollo11)) {
        urlPackageNexus = ''
        urlPackageNexus = "https://nexus.devsecops-paas-prd.br.experian.eeca/repository/releases/" + groupId + "/" + urlPackageArtifactId + "/" + versionApp + "/" + urlPackageArtifactId + "-" + versionApp + "." + typePackage

        changeorderDescription = changeorderDescription +
            "*** Nexus{/n}" +
            "Url pacote: ${urlPackageNexus}{/n}" +
            "{/n}";
    }
}

return this