/**
 * compilationLanguage
 * Método faz chamadas as compilação de linguagens especificas
 * @version 8.5.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def compilationMvn(def compilationCmd) {
    packageArtifact = ''

    echo "Invoking compilation language '${languageName}' in version ${jdk}"
    echo "Details compilation '${compilationCmd}'"

    switch (languageName.toLowerCase()) {
        case ["java", "scala"]:
            if (gitBranch == "master") {
                sh(script: "find ${WORKSPACE}/${currentBuild.number} -type f -name pom.xml | xargs sed -i 's/-SNAPSHOT//g' ", returnStdout: false)
            }

            piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_JAVA_SCALA_000'

            validateNexus = sh(script: "cat pom.xml", returnStdout: true)

            if ( ( validateNexus.toString().contains("spobrnxs01") ) || ( validateNexus.toString().contains("spobrccm02") )  ) {
                utilsMessageLib.errorMsg("O uso do Nexus 2 não é permitido no PiaaS. Prossiga utilizando o Nexus 3 em seu pom. Saiba mais: https://code.experian.local/projects/PDPB/repos/piaas-engine/browse/docs/pipelines.md")
                throw new Exception("O uso do Nexus 2 não é permitido.")
            }
            
            sh(script: "docker run --rm -e JDK='${jdk}' -e MVNCMD='${compilationCmd}' -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)

            if ((typePackage.toLowerCase() == "jar") || (typePackage.toLowerCase() == "war") || (typePackage.toLowerCase() == "")) {
                packageArtifact = sh(script: "if [[ -d target ]];then ls target/${artifactId}*.???; fi", returnStdout: true)
            } else if (typePackage.toLowerCase() == "ear") {
                packageArtifact = sh(script: "if [[ -d ear/target ]];then ls ear/target/${artifactId}*.???; fi", returnStdout: true)
            }

            packageArtifact = packageArtifact.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
            break
        default:
            utilsMessageLib.errorMsg("Implementation '${language}' in not compilation stage compilationLanguage not implemented :(")
    }
}

return this