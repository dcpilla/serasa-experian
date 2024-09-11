/**
 * nexus
 * Método faz chamadas ao nexus
 * @version 8.3.0  
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def nexus() {
    def versionAppNexus = ''
    def nexusUrl = 'https://nexus.devsecops-paas-prd.br.experian.eeca/repository/'

    utilsMessageLib.infoMsg("Iniciando estratégia de Deploy Nexus") 

    if ( typePackage != null ) {
        if ( ( typePackage == "tar" ) || ( typePackage == "zip" ) ){
            utilsMessageLib.infoMsg("Tipo de pacote ${typePackage} definido. Deploy iniciado para o repository do tipo raw")
            
            nexusRepositoryUri = "${nexusUrl}raw-snapshots/${applicationName}/${versionApp}/"

            if  (gitBranch.contains("master")) {
                nexusRepositoryUri = "${nexusUrl}raw-releases/${applicationName}/${versionApp}/"
            }  

            withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'pass', usernameVariable: 'user')]) {
                scriptExecOut = sh(script: "if ! curl --insecure --upload-file `ls -A /tmp/${applicationName}-${versionApp}.*` -u ${user}:${pass} -v ${nexusRepositoryUri} 2>/dev/null; then echo 'OPS, Erro in send package to nexus. Verify server ${nexusRepositoryUri}'; exit 1; fi", returnStdout: false)
                sh(script: "if rm -f /tmp/${applicationName}-${versionApp}.* ; then echo 'Cleaning package in /tmp'; fi", returnStdout: false)
            }

            return
        }
    }

    switch (language.toLowerCase()) {
        case ~/.*java.*/:
            utilsMessageLib.infoMsg("Iniciando processo de publicação de artefato utilizando Mvn")

	        if ((gitBranch == "develop") || (gitBranch == "qa") || (gitBranch == "hotfix") || (gitBranch.contains("feature")) ) {
	            nexusRepositoryUri = "${nexusUrl}snapshots/"
                versionAppNexus = versionApp.toString().replace("-RC", "-SNAPSHOT")
                sh(script: "docker run --rm -e JDK='${jdk}' -e MVNCMD='deploy:deploy-file -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${versionAppNexus} -DgeneratePom=true -DrepositoryId=snapshots -Durl=${nexusRepositoryUri} -Dfile=${packageArtifact}' -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)
	        } else if (gitBranch == "master") {
                nexusRepositoryUri = "${nexusUrl}releases/"
                sh(script: "docker run --rm -e JDK='${jdk}' -e MVNCMD='deploy:deploy-file -DgroupId=${groupId} -DartifactId=${artifactId} -Dversion=${versionApp} -DgeneratePom=true -DrepositoryId=releases -Durl=${nexusRepositoryUri} -Dfile=${packageArtifact}' -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)
	        }
            break
        case ~/.*node.*/:
            utilsMessageLib.infoMsg("Iniciando processo de publicação de artefato NPM")
            nexusRepositoryUri = "${nexusUrl}npm-snapshots/"

            if  (gitBranch.contains("master")) {
                nexusRepositoryUri = "${nexusUrl}npm-releases/"
            }
                
            try {
                withCredentials([string(credentialsId: 'nexus.token', variable: 'nexusToken')]) {
                    sh(script: "docker run --rm -v ${WORKSPACE}/${currentBuild.number}:/app -w /app node:${languageVersion} bash -c 'echo \"registry=${nexusRepositoryUri}\" >> ~/.npmrc && echo \"_auth=${nexusToken}\" >> ~/.npmrc && echo \"email=devsecops-paas-brazil@br.experian.com\" >> ~/.npmrc && echo \"always-auth=true\" >> ~/.npmrc && npm set strict-ssl false && npm publish --registry ${nexusRepositoryUri}'", returnStdout: false)
                }

            } catch (err) {
                utilsMessageLib.errorMsg("Falha ao realizar o deploy Nexus")
                throw new Exception("Falha ao realizar deploy Nexus")
            }
            break
        default:
            utilsMessageLib.warnMsg("Ainda não temos a publicação de artefatos para a linguagem ${languageName}")
    }
}

return this