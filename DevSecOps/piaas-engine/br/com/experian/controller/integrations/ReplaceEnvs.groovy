/**
 * setenv
 * Método seta environment no build da aplicação
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def setenv(def cmdEnv) {
    def envReplace = environmentName
    def key = cmdEnv.split()[0].toLowerCase()
  
    echo "Invoking function setenv"
    echo "Type to set environment '${cmdEnv}'"

    cmdEnv.split().each {
        if (it.toLowerCase().contains("--environment")) {
            envReplace = it.split('=')[1]
        }
    }

    switch (key) {
        case "docker":
            try {
                sh(script: "sed -i 's#@@BUILD_ENV@@#${envReplace}#' Dockerfile", returnStdout: false)
                echo "Environment set to Dockerfile ${envReplace}"
            } catch (err) {
                utilsMessageLib.errorMsg("Could not set environment variable in dockerfile. Does the implementation exist in dockerfile? Example below.")
                echo "ENV environment @@BUILD_ENV@@"
                echo "RUN echo 'Environment for execution' $environment"
                currentBuild.description = "Could not set environment variable in dockerfile"
                errorPipeline = "Could not set environment variable in dockerfile. Does the implementation exist in dockerfile?"
                helpPipeline = "Em seu Dockerfile não foi setado as configurações de entrada da environment, sete em seu Dockerfile a entrada: ENV environment @@BUILD_ENV@@"
                echo "Solucao: ${helpPipeline}"

                controllerNotifications.cardStatus('helpPipeline')
            }
            sh(script: "sed -i 's#@@PROJECT_KEY@@#${artifactId}#' Dockerfile", returnStdout: false)
            sh(script: "sed -i 's#@@PROJECT_NAME@@#${applicationName}#' Dockerfile", returnStdout: false)
            sh(script: "sed -i 's#@@PROJECT_VERSION@@#${versionApp}#' Dockerfile", returnStdout: false)
            sh(script: "sed -i 's#@@GIT_REPO@@#${gitRepo}#' Dockerfile", returnStdout: false)
            break
        default:
            utilsMessageLib.errorMsg("Implementation '${cmdEnv}' in setenv stage not implemented :(")
    }
}

/**
 * setTemplateEngines
 * Método engines template
 * @version 6.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  templateEngines
 **/
def setTemplateEngines(def templateEngines) {
    def flagTemplateEngines = 0
    def templateEnginesOrig = templateEngines

    if (templateEngines != null) {
        try {
            if (templateEngines.contains("WORKSPACE/")) {
                templateEngines = templateEngines.replaceAll("WORKSPACE/", WORKSPACE + '/' + currentBuild.number + '/')
                flagTemplateEngines = 1
            }
            if (templateEngines.contains("WORKSPACE")) {
                templateEngines = templateEngines.replaceAll("WORKSPACE", WORKSPACE + '/' + currentBuild.number + '/')
                flagTemplateEngines = 1
            }
            if (templateEngines.contains("VERSION")) {
                templateEngines = templateEngines.replaceAll("VERSION", versionApp)
                flagTemplateEngines = 1
            }
            if (templateEngines.contains("GITAUTHOREMAIL")) {
                templateEngines = templateEngines.replaceAll("GITAUTHOREMAIL", gitAuthorEmail)
                flagTemplateEngines = 1
            }
            if (templateEngines.contains("GITBRANCH")) {
                templateEngines = templateEngines.replaceAll("GITBRANCH", gitBranch)
                templateEngines = templateEngines.replaceAll("feature/", "feature_")
                flagTemplateEngines = 1
            }
            if (templateEngines.contains("ENVIRONMENT")) {
                templateEngines = templateEngines.replaceAll("ENVIRONMENT", environmentName)
                flagTemplateEngines = 1
            }
        } catch (err) {
            utilsMessageLib.warnMsg("Erro in replace values reserved in function setTemplateEngines for this pipeline")
            println(err)
        }
    }

    if (flagTemplateEngines == 1) {
        echo "Invoking function setTemplateEngines"
        echo "Details apply reserved names ${templateEnginesOrig}"
        echo "Applied reserved names ${templateEngines}"
    }

    return templateEngines
}

return this