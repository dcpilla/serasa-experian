/**
 * application
 * Método execução de stage application
 * @version 8.27.0
 * @package DevOps
 * @author  Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def application() {
    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_000'

    controllerIntegrationsBitbucket.setBitbucketStatus("INPROGRESS")

    echo "Start stage : [APPLICATION]"
    version = mapResult.version
    mapResult.application.each { key, value ->
        switch (key.toLowerCase()) {
            case "name":
                pipeline                               = value
                piaasMainInfo.name_application         = pipeline
                break
            case "product":
                if (value != null) {
                    product                            = value.toLowerCase()
                    piaasMainInfo.product              = product
                } else {
                    product = null
                }
                break       
            case "type":
                if (value != null) {
                    type                               = value.toLowerCase()
                    piaasMainInfo.type_application     = type
                }    
                break
            case "gearr":
                gearr                                  = value
                changeorderConfigItens                 = gearr
                piaasMainInfo.gearr_id                 = gearr
                break
            case "package":
                typePackage                            = value
                break
            case "framework":
                if (value != null) {
                    framework                          = value.toUpperCase()
                    piaasMainInfo.framework            = framework
                }    
                break
            case "language":
                if (value != null) {
                    language                           = value.name.toLowerCase()
                    piaasMainInfo.language_application = language
                }    
                break
            case "jira_key":
                jiraKey                                = value.toString().trim()
                piaasMainInfo.jira_key                 = jiraKey
                break
            case "gearr_dependencies":
                gearrDependencies                      = value.toString().trim()
                piaasMainInfo.gearr_dependencies       = gearrDependencies
                break
            case "cmdb_dependencies":
                cmdbDependencies                       = value.toString().trim()
                piaasMainInfo.cmdb_dependencies        = cmdbDependencies
                break
            case "dependguard":
                dependGuard                            = value
                piaasMainInfo.dependguard              = dependGuard
                break   
            default:
                utilsMessageLib.errorMsg("Implementation '${key}' in application stage not performed :(")  
        }
    }

    serviceGovernanceApplication.getDeploymentStrategy()

    if ( ( pipeline == null ) || ( pipeline.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Name not informed on piaas.yml, please add a attribute in stage application")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  name: experian-srv-gdn-brazil-orquestrador"
        echo ""
        currentBuild.description = "Not informed the name of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Name not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe o nome da sua aplicação, caso não exista, crie a entrada no stage application."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_009'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
        controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline) 
    }

    if ( ( product == null ) || ( product.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Product not informed on piaas.yml, please add a attribute in stage application")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  product: Cockpit DevSecOps"
        echo ""
        currentBuild.description = "Not informed the product of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Product not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de product da sua aplicação, caso não exista, crie a entrada no stage application."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_010'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline) 
    }

    if ( ( framework == null ) || ( framework.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Framework not informed on piaas.yml, please add a attribute in stage application")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  framework: Other"
        echo ""
        currentBuild.description = "Not informed the framework of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Framework not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de framework da sua aplicação, caso não exista, crie a entrada no stage application."
        piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_010'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline) 
    }

    if ( ( type == null ) || ( type.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Type not informed on piaas.yml, please add a attribute in stage application")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  type: rest"
        echo ""
        currentBuild.description = "Not informed the type of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Type not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações do type da sua aplicação, caso não exista, crie a entrada no stage application."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_011'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline) 
    }

    if ( ( language == null ) || ( language.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Language not informed on piaas.yml, please add a attribute in stage application")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  language:"
        echo "    name: java-17"
        echo ""
        currentBuild.description = "Not informed the language of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Language not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de language da sua aplicação, caso não exista, crie a entrada no stage application."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_013'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline) 
    }    
    
    if ( ( jiraKey == "null" ) || ( jiraKey.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Jira_key not informed on piaas.yml, please add a attribute in stage application.")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "application:"
        echo "  jira_key: ABCDE"
        echo ""
        currentBuild.description = "Jira_key not informed of the application. Impossible to proceed with the pipeline."
        errorPipeline = "Jira_key not informed on piaas.yml, please add a tag in stage application."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de jira_key caso não exista crie a entrada no stage application, conforme exemplo do pipeline."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_024'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }
    else {
        checkJiraKey()
    }

    if ( ( language != "cobol" ) && ( language != "assembly" ) && ( language != "bms" ) && ( language != "c++" ) && ( type != "lib" ) && ( type != "test" ) && ( type != "parent" ) ) {
        if ( ( ( gearrDependencies == "null" ) || ( gearrDependencies.isEmpty() ) || ( gearrDependencies.toUpperCase() == "NULO" ) ) ) {
            utilsMessageLib.errorMsg("Gearr_dependencies not informed or value is NULO on piaas.yml, please add a attribute in stage application.")
            echo "Example of the using in piaas.yml:"
            echo ""
            echo "application:"
            echo "  gearr_dependencies: 16755, 8279, 16781, 7767"
            echo ""
            currentBuild.description = "Gearr_dependencies not informed or value is NULO of the application. Impossible to proceed with the pipeline."
            errorPipeline = "Gearr_dependencies not informed or value is NULO on piaas.yml, please add a tag in stage application."
            helpPipeline = "Verifique se em seu piaas.yml existem as configurações de gearr_dependencies ou está com valor NULO, caso não exista crie a entrada no stage application ou corrija pelo valor correto, conforme exemplo do pipeline."
            piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_025'
            echo "Solucao: ${helpPipeline}"
            if (gitAuthorEmail != "") {
                controllerNotifications.cardStatus('helpPipeline')
            }
            throw new Exception(errorPipeline)
        }

        if ( ( ( cmdbDependencies == "null" ) || ( cmdbDependencies.isEmpty() ) || ( cmdbDependencies.toUpperCase() == "NULO" ) ) ) {
            utilsMessageLib.errorMsg("Cmdb_dependencies not informed or value is NULO on piaas.yml, please add a attribute in stage application.")
            echo "Example of the using in piaas.yml:"
            echo ""
            echo "application:"
            echo "  cmdb_dependencies: spobrjenkins:8080,spobrmetabasebi:3000"
            echo ""
            currentBuild.description = "Cmdb_dependencies not informed or value is NULO of the application. Impossible to proceed with the pipeline."
            errorPipeline = "Cmdb_dependencies not informed or value is NULO on piaas.yml, please add a tag in stage application."
            helpPipeline = "Verifique se em seu piaas.yml existem as configurações de cmdb_dependencies ou está com valor NULO, caso não exista crie a entrada no stage application ou corrija pelo valor correto, conforme exemplo do pipeline."
            piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_026'
            echo "Solucao: ${helpPipeline}"
            if (gitAuthorEmail != "") {
                controllerNotifications.cardStatus('helpPipeline')
            }
            throw new Exception(errorPipeline)
        }
        else {
            def arrayCmdbDep = cmdbDependencies.split(",")
            def containsSpobrjnks = arrayCmdbDep.any { it.contains("spobrjenkins") }
            def containsCode = arrayCmdbDep.any { it.contains("code.experian") }
            def blockCmdbContent = false

            if (containsSpobrjnks && containsCode) {
                def result = arrayCmdbDep.findAll { !it.contains("spobrjenkins") && !it.contains("code.experian") }
                if (result.size() == 0) {
                    blockCmdbContent = true
                }
            }
            else if (containsSpobrjnks || containsCode) {
                def result = arrayCmdbDep.findAll { !it.contains("spobrjenkins") && !it.contains("code.experian") }
                if (result.size() == 0) {
                    blockCmdbContent = true
                }
            }

            if (blockCmdbContent) {
                utilsMessageLib.errorMsg("Cmdb_dependencies informed in piaas.yml, is not valid.")
                echo "Example of the using in piaas.yml:"
                echo ""
                echo "application:"
                echo "  cmdb_dependencies: spobrjenkins:8080,spobrmetabasebi:3000,teste-eks-prod"
                echo ""
                currentBuild.description = "Cmdb_dependencies informed in piaas.yml, is not valid. Impossible to proceed with the pipeline."
                errorPipeline = "Cmdb_dependencies informed in piaas.yml, is not valid."
                helpPipeline = "O cmdb_dependencies informado é invalido, você deve estar inserindo somente SPOBRJENKINS e/ou CODE.EXPERIAN, por favor, inserir mais informações, como por exemplo, nome_cluster_eks, nome_banco_de_dados, nome_s3, etc."
                piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_027'
                echo "Solucao: ${helpPipeline}"
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }
        }
    }

    utilsMessageLib.infoMsg("Tudo certo com o preencimento do piaas.yaml no campo application! Seguindo com a execução...")

}

/**
 * setApplicationDetails
 * Método pega detalhes da aplicação 
 * @version 8.24.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  $versionApp
 **/
def setApplicationDetails() {
    def flagTestTag = ''
    def customTypeScore = ''
    fileDetailsApp = ''
    versionApp = ''
    applicationName = ''
    artifactId = ''
    groupId = ''

    echo "Invoking function setApplicationDetails"

    languageName = utilsLanguageLib.extractLanguageName(language)  
    languageVersion = utilsLanguageLib.extractLanguageVersion(language)
    jdk = languageVersion  

    switch ( languageName.toLowerCase() ) {
        case "java":
            try {
                fileDetailsApp          = readMavenPom file: 'pom.xml'
                versionApp              = fileDetailsApp.version
                versionApp              = versionApp.toString().replace("-SNAPSHOT", "").replace('${label}',"")
                applicationName         = fileDetailsApp.name
                artifactId              = fileDetailsApp.artifactId
                groupId                 = fileDetailsApp.groupId
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Sim] | Teste de vulnerabilidade - Veracode [Sim]"
            if (jdk == "") {
                echo "Jdk not define, using default"
                jdk = "8"
            } else {
                jdk = jdk
            }
            if ( groupId == null ) {
                    utilsMessageLib.errorMsg("Grupoid not informed on main pom.xml, please add a tag") 
                    echo "Example: <groupId>br.com.experian</groupId>"
                    currentBuild.description = "Grupoid not informed on main pom.xml"
                    errorPipeline            = "Grupoid not informed on main pom.xml."
                    helpPipeline             = "Verifique se em seu pom.xml existe a tag groupId, caso não exista faça a adição, exemplo: <groupId>br.com.experian</groupId>."
                    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETAPPLICATIONDETAILS_JAVA_000'
                    echo "Solucao: ${helpPipeline}"
                    
                    controllerNotifications.cardStatus('helpPipeline')
              }
            break
        case "scala":
            try {
                fileDetailsApp          = readMavenPom file: 'pom.xml'
                versionApp              = fileDetailsApp.version
                versionApp              = versionApp.toString().replace("-SNAPSHOT", "").replace('${label}',"")
                applicationName         = fileDetailsApp.name
                artifactId              = fileDetailsApp.artifactId
                groupId                 = fileDetailsApp.groupId
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Sim] | Teste de vulnerabilidade - Veracode [Sim]"
            if (jdk == "") {
                echo "Jdk not define, using default"
                jdk = "8"
            } else {
                jdk = jdk
            }
            if ( groupId == null ) {
                    utilsMessageLib.errorMsg("Grupoid not informed on main pom.xml, please add a tag") 
                    echo "Example: <groupId>br.com.experian</groupId>"
                    currentBuild.description = "Grupoid not informed on main pom.xml"
                    errorPipeline            = "Grupoid not informed on main pom.xml."
                    helpPipeline             = "Verifique se em seu pom.xml existe a tag groupId, caso não exista faça a adição, exemplo: <groupId>br.com.experian</groupId>."
                    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETAPPLICATIONDETAILS_SCALA_000'
                    echo "Solucao: ${helpPipeline}"

                    controllerNotifications.cardStatus('helpPipeline')
              }
            break
        case "node":
            fileDetailsApp          = readJSON file: 'package.json'
            versionApp              = fileDetailsApp.version
            applicationName         = fileDetailsApp.name
            artifactId              = applicationName
            groupId                 = "br.com.experian"
            changeorderRequirements = "Teste de cobertura - Sonarqube [Sim] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case ["php", "php8.2"]:
            fileDetailsApp          = readProperties file: 'settings.conf'
            versionApp              = fileDetailsApp['VERSION']
            versionApp              = versionApp.replaceAll("\"", "").replaceAll("'", "");
            applicationName         = fileDetailsApp['PROJECT']
            applicationName         = applicationName.replaceAll("\"", "").replaceAll("'", "");
            artifactId              = applicationName
            groupId                 = "br.com.experian"
            changeorderRequirements = "Teste de cobertura - Sonarqube [Sim] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case [ "python", "python3.6", "python3.8", "python3.9", "python3.10", "python3.11", "python3.12"]:
            fileDetailsApp          = readProperties file: 'settings.py'
            versionApp              = fileDetailsApp['VERSION']
            versionApp              = versionApp.replaceAll("\"", "").replaceAll("'", "");
            applicationName         = fileDetailsApp['PROJECT']
            applicationName         = applicationName.replaceAll("\"", "").replaceAll("'", "");
            artifactId              = applicationName
            groupId                 = "br.com.experian"
            changeorderRequirements = "Teste de cobertura - Sonarqube [Sim] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case "shellscript":
            try {
                fileDetailsApp          = readProperties file: 'settings.conf'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "").replaceAll("'", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "").replaceAll("'", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case "ruby":
            try {
                fileDetailsApp          = readProperties file: 'settings.rb'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case "c#":
            try {
                fileDetailsApp          = readProperties file: 'web.config'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case ".net":
            try {
                fileDetailsApp          = readProperties file: 'web.config'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break    
        case "outsystem":
            try {
                fileDetailsApp          = readProperties file: 'web.config'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = outsystemApplicationName
                gitRepo                 = outsystemApplicationName
                artifactId              = outsystemApplicationName
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        case "dart":
            try {
                fileDetailsApp          = readYaml file: 'pubspec.yaml'
                versionApp              = fileDetailsApp.version
                applicationName         = pipeline
                artifactId              = pipeline
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(") 
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
            break
        default:
            try {
                echo "Using settings default in setApplicationDetails"
                fileDetailsApp          = readProperties file: 'settings.conf'
                versionApp              = fileDetailsApp['VERSION']
                versionApp              = versionApp.replaceAll("\"", "");
                applicationName         = fileDetailsApp['PROJECT']
                applicationName         = applicationName.replaceAll("\"", "");
                artifactId              = applicationName
                groupId                 = "br.com.experian"
            } catch (err) {
                applicationName         = pipeline
                artifactId              = pipeline
                versionApp              = "0.1.0"
                groupId                 = "br.com.experian"
                utilsMessageLib.warnMsg("Implementation '${language}' in not setApplicationDetails stage not performed, using values default :(")
            }
            changeorderRequirements = "Teste de cobertura - Sonarqube [Não] | Teste de vulnerabilidade - Veracode [Sim]"
    }

    try {
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('startPipeline')
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Card not sent in function startPipeline")
    }        


    if (type != "outsystem") {
        echo "Checking if version '${versionApp}' has already been deployed"
        echo "Listing existing versions"
        sh(script: "git tag", returnStdout: false)
        flagTestTag = sh(script: "test ! `git tag|grep v${versionApp}` || { echo '1'; }", returnStdout: true)
        flagTestTag = flagTestTag.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        if (flagTestTag == "1") {
            utilsMessageLib.errorMsg("Sorry, this version '${versionApp}' has already been deployed, and we can not continue :(")
            echo "Make the adjustment in your deployment version, and do it a new commit"
            echo "Here is a version control help for you https://semver.org/lang/pt-BR/"
            currentBuild.description = "This version ${versionApp} has already been deployed"
            errorPipeline = "This version ${versionApp} has already been deployed."
            helpPipeline = "A versão ${versionApp} da sua aplicação já foi deployada na master e gerada uma tag, favor faça o upgrade da versão nos devidos arquivos de configuração de controle."
            piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_SETAPPLICATIONDETAILS_VERSION_000'
            echo "Solucao: ${helpPipeline}"
            if (gitAuthorEmail != "") { 
                controllerNotifications.cardStatus('helpPipeline')
                throw new Exception("O erro ocorreu porque a versão da aplicação já foi deployada em master")
            } else {
                utilsMessageLib.warnMsg("Card not sent in function helpPipeline") 
            } 
        } else {
            if (gitBranch == "develop") {
                versionApp = versionApp + '-SNAPSHOT'
                echo "Commit in '${gitBranch}' setting label SNAPSHOT in version"
            } else if ((gitBranch == "qa") || (gitBranch == "hotfix")) {
                versionApp = versionApp + '-SNAPSHOT'
                echo "Commit in '${gitBranch}' setting label SNAPSHOT in version"
            } else if (gitBranch == "master") {
                echo "Commit in '${gitBranch}' setting release version"
            } else {
                versionApp = versionApp + '-SNAPSHOT'
                echo "Commit in '${gitBranch}' setting label default SNAPSHOT in version"
            }

            utilsMessageLib.infoMsg("Version '${versionApp}' available for deployment, continuing with pipeline execution")
        }
    }

    if ( (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "hotfix") ) {
        flowDevelopment = "Gitflow"
    } else {
        flowDevelopment = "Trunk Based Development"
    }

    changeorderDescription = changeorderDescription +
                             "*** Esteira Continuous Integration / Continuous Deployment ***{/n}" +
                             "{/n}" +
                             "*** Detalhes da Aplicação{/n}" +
                             "Score DevSecOps: @@SCORE@@{/n}" +
                             "Nome da aplicação : ${applicationName}{/n}" + 
                             "Network type: " + piaasMainInfo.gearr_u_network_type + "{/n}" +
                             "Detalhes Gearr da aplicação : " + piaasMainInfo.gearr_id + " - " + changeorderConfigItens + "{/n}" +
                             "Branch: " + gitBranch + "{/n}" +
                             "Fluxo de desenvolvimento: ${flowDevelopment} {/n}"; 

    if ( apigeeProxy != '' ) {
        changeorderDescription = changeorderDescription +
                                 "Proxy: ${apigeeProxy}{/n}";
    }

    changeorderDescription = changeorderDescription +
                             "Tribe : ${tribe}{/n}" +
                             "Tipo aplicação : ${type}{/n}";

    if ( type == 'package_mainframe' ) {
        changeorderDescription = changeorderDescription +
                                 "Pacote : ${typePackage}{/n}";
    }

    if ( (type == "configs-arquitetura-de-dados") || (type == "apache-camel") || (type == "helm") || (type == "sqlserver") || (type == "self-learning") || ( type == "serverless" ) || ( type == "devops-tool" ) ) {
        echo "This type ${type} of application is specific, We will test the contents of the repository"

        customTypeScore = sh(script: "${packageBasePath}/service/governance/validateTypesApp.sh --type-application='${type}' --workspace='${WORKSPACE}/${currentBuild.number}'", returnStdout: true)
        customTypeScore = customTypeScore.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        if ( customTypeScore != "100" ) { 
            utilsMessageLib.errorMsg("Files found for the application type ${type} are not allowed")
            echo "$customTypeScore"

            if ( type == "apache-camel" ){
               helpPipeline = "Remova os arquivos diferentes de *.yml *.yaml e *.md de seu repositório"
            } else if ( type == "config-nike-reports" ) {
                helpPipeline = "Remova os arquivos diferentes de *.json *.cql *.sql *.yml *.yaml e *.md de seu repositório"
            } else if ( type == "helm" ) {
                helpPipeline = "Remova os arquivos diferentes de *.yml *.yaml *.md *.conf e *.sh de seu repositório"
            } else if ( type == "self-learning") {
                helpPipeline = "Remova os arquivos diferentes de *.yml *.yaml *.md *.png *.txt *.pdf *.ppt de seu repositório"
            } else if ( type == "eid-config") {
                helpPipeline = "Remova os arquivos diferentes de *.yml *.yaml *.md *.png *.txt *.pdf *.ppt *.nginx *.template"
            } else if ( type == "serverless" ) {
                helpPipeline = "Somente deploys na estratégia Lambda são permitidos para o tipo Serverless"
            } else if ( type == "devops-tool" ) {
                helpPipeline = "Somente aplicações Docker e membros do time DevSecOps podem utilizar esse tipo."
            }
         
            currentBuild.description = "Files found for the application ${type} are not allowed"
            errorPipeline = "Files found for the application type ${type} are not allowed."
            echo "Solucao: ${helpPipeline}"
            piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_VALIDATE_TYPE_001'

            controllerNotifications.cardStatus('helpPipeline') 

            throw new Exception(errorPipeline)
        } else {
            utilsMessageLib.infoMsg("The workspace for application type ${type} it's ok. Continue...")
        }

        if ( type == "serverless" ) {
            utilsMessageLib.warnMsg("For validate type '${type}' remove score sonarqube/performance/pentest/waf")
            toolsScore.remove('sonarqube')
            toolsScore.remove('performance')
            toolsScore.remove('pentest')
            toolsScore.remove('waf')
        } else {
            utilsMessageLib.warnMsg("For validate type '${type}' remove score sonarqube/veracode/performance/pentest/waf")
            toolsScore.remove('sonarqube')
            toolsScore.remove('veracode')
            toolsScore.remove('performance')
            toolsScore.remove('pentest')
            toolsScore.remove('waf')
        }


        toolsScore.qs_test.analysis_performed    = 'true'
        toolsScore.qs_test.score                 = customTypeScore.toFloat()

        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = customTypeScore
        piaasMainInfo.qs_test_url                = ''
    }

    changeorderDescription = changeorderDescription +
                             "Linguagem : ${language}{/n}" +
                             "Versão: ${versionApp}{/n}" +
                             "Repositorio : ${gitRepo}{/n}" +
                             "Obrigatoriedades: ${changeorderRequirements}{/n}" +
                             "{/n}";

    piaasMainInfo.name_application          = applicationName
    piaasMainInfo.version_application       = versionApp
    mapResult3rdParty['branch']             = gitBranch
    mapResult3rdParty['author']             = gitAuthor
    mapResult3rdParty['email']              = gitAuthorEmail
    mapResult3rdParty['workspace']          = WORKSPACE + '/' + currentBuild.number + '/'
    mapResult3rdParty['versionApp']         = versionApp

}

/**
 * setEnvironment
 * Método seta environmentName de deploy
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  $versionApp
 **/
def setEnvironment() {
    environmentName = ''

    echo "Invoking function setEnvironment"

    if (type == "outsystem") {
        environmentName = outsystemEnvironment
        piaasMainInfo.environment_deploy = environmentName
    } else {
        if (gitBranch == "develop") {
            environmentName = gitBranch
            piaasMainInfo.environment_deploy = 'dev'
        } else if ((gitBranch == "qa") || (gitBranch == "hotfix")) {
            environmentName = 'qa'
            piaasMainInfo.environment_deploy = 'uat-qa'
        } else if (gitBranch == "uat") {
            environmentName = 'uat'
            piaasMainInfo.environment_deploy = 'uat'
        } else if (gitBranch == "demo") {
            environmentName = 'demo'
            piaasMainInfo.environment_deploy = 'uat-demo'
        } else if (gitBranch == "master") {
            environmentName = 'prod'
            piaasMainInfo.environment_deploy = environmentName
        } else {
            environmentName = gitBranch
            piaasMainInfo.environment_deploy = 'stg'
        }
    }
}

/**
 * checkJiraKey
 * Método faz a validação do jiraKey informado no piaas.yml
 * @version 8.35.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@experian.com>
 **/
def checkJiraKey() {

    echo "Invoking function checkJiraKey"

    def patern = ~"[A-Z]+-\\d+"
    def url = ""
    def apiCall = ""
    projectRepository = gitRepo
    projectRepository = projectRepository.toString().replace("ssh://git@code.experian.local/", "").replace("ssh://git@code.br.experian.local/code/", "")
    projectRepository = projectRepository.toString().replace(".git", "")

    projectRepository = projectRepository.split("/")
    projectKey = projectRepository[0]
    projectRepository = projectRepository[1]

    gitPullRequestID = sh(script: "git reset --hard 2> /dev/null", returnStdout: true)
    gitPullRequestID = gitPullRequestID.replace("'", "")
    gitPullRequestID = sh(script: "echo '${gitPullRequestID}' | cut -d '#' -f2 | cut -d ':' -f1 2> /dev/null", returnStdout: true)
    gitPullRequestID = gitPullRequestID.replaceAll("\n", "")

    if (gitBranch.contains("feature/")) {
        def splitBranch = gitBranch.split("/")
        jiraKey = splitBranch[1].toUpperCase()
        piaasMainInfo.jira_key = jiraKey
    
        def validateJiraKey = patern.matcher(jiraKey).matches()

        if (!validateJiraKey) {
            utilsMessageLib.errorMsg("Branch name feature does not correspond a valid format for Jira issue code, please correct this.")
            echo "Example of the using in branch:"
            echo ""
            echo "  feature/ABCDE-1234"
            echo ""
            currentBuild.description = "Branch name feature does not correspond a valid format for Jira issue code. Impossible to proceed with the pipeline."
            errorPipeline = "Branch name feature does not correspond a valid format for Jira issue code, please correct this."
            helpPipeline = "Verifique se o nome de sua branch feature possui o formato correto do código da issue vinculada ao Jira, conforme exemplo."
            piaasMainInfo.pipeline_code_error  = 'ERR_CHECK_JIRA_KEY_000'
            echo "Solucao: ${helpPipeline}"
            if (gitAuthorEmail != "") {
               controllerNotifications.cardStatus('helpPipeline')
            }
            throw new Exception(errorPipeline)
        }
    }
    else {
        url = "https://code.experian.local/rest/jira/latest/projects/$projectKey/repos/$projectRepository/pull-requests/$gitPullRequestID/issues"
         
        failMessage = "checkJiraKey"

        withCredentials([usernamePassword(credentialsId: 'BitbucketGlobal.DevSecOps', passwordVariable: 'pass', usernameVariable: 'user')]) {
            try {
                apiCall = utilsRestLib.httpGet(url, user, pass, failMessage)
                jsonIssues = utilsJsonLib.jsonParse(apiCall)

                def issuesKeys = jsonIssues.collect { it.key }
                def jsonIssueJiraKey = issuesKeys.size() > 1 ? issuesKeys.join(", ") : issuesKeys[0]

                if( jsonIssueJiraKey.isEmpty() || apiCall.contains("404") ) {
                    throw new Exception("The API return is invalid or empty")
                }        
                jiraKey = jsonIssueJiraKey
                piaasMainInfo.jira_key = jiraKey
            } 
            catch (err) {
                utilsMessageLib.warnMsg("The Jira issue code on repository is invalid or does not exists, please verify this.")
               // Fazer bloqueio qdo jira_key não for localizado 
                jiraKey = "JIRA_KEY_NOT_FOUND"
                piaasMainInfo.jira_key = "JIRA_KEY_NOT_FOUND"
            }
        }

    }
}

/**
 * piaasEntityApi
 * Método integração com piaas-entity-api
 * @version 8.34.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @param   stepExecution  - success | failure | changeorder | aborted
 * @return  
 **/
def piaasEntityApi(def stepExecution) {

    echo "Invoking function piaasEntityApi"

    def userLogon = sh(script: "#!/bin/sh -e\n ${packageBasePath}/utils/getLogonUser.sh ${gitAuthorEmail}", returnStdout: true)
    userLogon     = userLogon.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

    def url;
    def postPayLoad;
    def putPayLoad;
    def successMessage;
    def failMessage = "PiaasEntityApi";
    def jsonResponse;
    def applicationVersion;

    if (piaasEnv == "prod") {
        url = "https://piaas-entity-api-prod.devsecops-paas-prd.br.experian.eeca/piaas-entity/v1"
    }
    else {
        url = "https://piaas-entity-api-sand.sandbox-devsecops-paas.br.experian.eeca/piaas-entity/v1"
    }
    
    def urlPut = "${url}/executions/${idPiaasEntityExec}"

    entityJwtToken = utilsIamLib.getJwtToken()

    try {
        if ( stepExecution == 'RUNNING' || stepExecution == 'ABORTED' ) {

                postPayLoad = """
                {
                    "coreId": "${currentBuild.number}",
                    "hashCommit": "${gitCommit}",
                    "branch": "${gitBranch}",
                    "changeOrder": "",
                    "statusExecution": "${stepExecution}",
                    "applicationVersion": "",
                    "user": {
                        "email": "${gitAuthorEmail}",
                        "logon": "${userLogon}",
                        "userTitle": "${titleUser}"
                    },
                    "application": {
                        "gearrId": ${piaasMainInfo.gearr_id},
                        "name": "",
                        "version": "",
                        "product": "${piaasMainInfo.product}",
                        "deploymentStrategy": "${piaasMainInfo.deployment_strategy}",
                        "packageApp": "${typePackage}",
                        "type": "${piaasMainInfo.type_application}",
                        "jiraKey": "${piaasMainInfo.jira_key}",
                        "gearrDependencies": "${piaasMainInfo.gearr_dependencies}",
                        "cmdbDependencies": "${piaasMainInfo.cmdb_dependencies}",
                        "dependGuard": ${piaasMainInfo.dependguard},
                        "framework": "${piaasMainInfo.framework}",
                        "git": {
                            "name": "",
                            "uri": "${gitRepo}"
                        },
                        "team": {
                            "tribe": "${piaasMainInfo.tribe}",
                            "squad": "${piaasMainInfo.squad}",
                            "businessService": "${piaasMainInfo.business_service}",
                            "assignmentGroup": "${piaasMainInfo.assignment_group_application}"
                        },
                        "language": {
                            "name": "${piaasMainInfo.language_application}"
                        }
                    }
                }
                """

            successMessage = "- PiaasEntityApi sended status RUNNING"
         
            returnPostExec = utilsRestLib.httpPostBearer("${url}/executions", entityJwtToken, 201, postPayLoad, successMessage, failMessage)
    
            if (returnPostExec != null) {
                jsonResponse = utilsJsonLib.jsonParse(returnPostExec)            
                idPiaasEntityExec = jsonResponse.id
                echo "Post id ${idPiaasEntityExec}"
            }

        } else if ( stepExecution == 'CHANGEORDER' ) {
            successMessage = "- PiaasEntityApi sended ChangeOrder Number"   
            putPayLoad = """
            {
                "changeOrder": "${changeorderNumber}"
            }
            """
            utilsRestLib.httpPutBearer(urlPut, entityJwtToken, 200, putPayLoad, successMessage, failMessage)
        } else if ( stepExecution == 'SUCCESS' ) {
            successMessage = "- PiaasEntityApi sended status SUCCESS"

            if ( (gitBranch.contains("master")) || (gitBranch.contains("main")) ) {
                putPayLoad = """
                {
                    "statusExecution": "${stepExecution}",
                    "applicationVersion": "${piaasMainInfo.version_application}",
                    "application": {
                        "version": "${piaasMainInfo.version_application}"
                    }
                }
                """
            } else {
                putPayLoad = """
                {
                    "statusExecution": "${stepExecution}",
                    "applicationVersion": "${piaasMainInfo.version_application}"
                }
                """
            }

            utilsRestLib.httpPutBearer(urlPut, entityJwtToken, 200, putPayLoad, successMessage, failMessage)
        } else if ( stepExecution == 'FAILURE' ) {
            successMessage = "- PiaasEntityApi sended sended status FAILURE"
            putPayLoad = """
            {
                "statusExecution": "${stepExecution}"
            }
            """

            utilsRestLib.httpPutBearer(urlPut, entityJwtToken, 200, putPayLoad, successMessage, failMessage)
        } else if ( stepExecution == 'GEARR' ) {
            successMessage = "- PiaasEntityApi sended sended Gearr informations"
            putPayLoad = """
            {
                "application": {
                    "networkType": "${piaasMainInfo.gearr_u_network_type}",
                    "gearrId": ${piaasMainInfo.gearr_id}
                }
            }
            """

            utilsRestLib.httpPutBearer(urlPut, entityJwtToken, 200, putPayLoad, successMessage, failMessage)
        } else if ( stepExecution == 'ABORTEDPut' ) {
            successMessage = "- PiaasEntityApi sended sended status ABORTED"
            putPayLoad = """
            {
                "statusExecution": "ABORTED"
            }
            """

            utilsRestLib.httpPutBearer(urlPut, entityJwtToken, 200, putPayLoad, successMessage, failMessage)
        }

    } catch (Exception e) {
        utilsMessageLib.infoMsg("PiaasEntityApi Failed: ${e}")
    }
}

/**
 * getDeploymentStrategy
 * Método para verificar se é a aplicação possui uma estratégia de deploy para o EKS
 * @version 8.37.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @param   
 * @return  true | false
 **/
def getDeploymentStrategy() {

    utilsMessageLib.infoMsg("Invoking function getDeploymentStrategy")

    def valuesPath = ""
    def deployTypeEks = false
    def strategyType = "not_implement"
    def mapResultDS = ""
    
    try {
        if (gitBranch.contains("feature/")) {
            mapResultDS = mapResult['branches']['feature*']
        } 
        else if (mapResult['branches'][gitBranch] != null) {
            mapResultDS = mapResult['branches'][gitBranch]
        }

        mapResultDS.deploy.each { key, value ->
            value = controllerIntegrationsEnvs.setTemplateEngines(value)
            switch (key.toLowerCase()) {
                case "eks":
                    deployTypeEks = true
                    break
            }
        }

        if (deployTypeEks) {
            if (gitBranch.contains("master") || gitBranch.contains("main")) {
                valuesPath = "${WORKSPACE}/${currentBuild.number}/kubernetes/helm/prod/values.yaml"
            }
            else if (gitBranch.contains("develop") || gitBranch.contains("qa")) {
                valuesPath = "${WORKSPACE}/${currentBuild.number}/kubernetes/helm/develop/values.yaml"
            }
            else if (gitBranch.contains("feature/")) {
                valuesPath = "${WORKSPACE}/${currentBuild.number}/kubernetes/helm/feature/values.yaml"
            }

            sh(script: "sed -i 's/\\t/    /g' ${valuesPath}", returnStdout: false)
            def valuesPathValid = readYaml file: valuesPath
            if (valuesPathValid.deployment.strategy.type) {
                strategyType = valuesPathValid.deployment.strategy.type
            }
            piaasMainInfo.deployment_strategy = strategyType
        }
    }
    catch (Exception e) {
        utilsMessageLib.errorMsg("GetDeploymentStrategy Failed: ${e.message}")
    }
}

return this
