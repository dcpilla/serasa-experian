/**
 * cucumber
 * Método faz chamadas ao cucumber
 * @version 8.4.0
 * @package DevSecOps
 * @author  Felipe Moura <felipe.moura@br.experian.com>
 * @return  true | false
 **/
def cucumber(def cmdCucumber) {
    utilsMessageLib.infoMsg("cucumber() ->Iniciando Testes...")

    def versionAppCucumber = ''
    def cucumberScore = ''
    versionAppCucumber = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    def bitbucketProjectCucumber = controllerIntegrationsBitbucket.getBitbucketProject()
    def branchCucumberTest = 'master'
    def cucumberJdkVersion = ''

    if ( (cmdCucumber == null) || (! cmdCucumber.contains("--jdk")) ) {
        utilsMessageLib.errorMsg("cucumber() -> É obrigatório informar a JDK para execução dos testes.")
        throw new Exception("Informe a JDK para realizar a execução de testes com Cucumber.")
    }

    cmdCucumber.split().each {
        if (it.contains("--branch") ) {
            branchCucumberTest         = it.split('=')[1]
        }

        if (it.contains("--project-repo") ) {
            bitbucketProjectCucumber   = it.split('=')[1]
        }

        if (it.contains("--jdk") ) {
            cucumberJdkVersion         = it.split('=')[1]
        }
    }

    if ( cmdCucumber.contains("--external-repo") ) {
        sh(script: "mkdir quality_tests && mkdir quality_tests/cucumber", returnStdout: false)
        sh(script: "git clone -b ${branchCucumberTest} ssh://git@code.br.experian.local/${bitbucketProjectCucumber}/${applicationName}-test.git quality_tests/cucumber", returnStdout: false)
    }

    utilsMessageLib.infoMsg("cucumber() ->Parametros informados: ${cmdCucumber}")

    dir = "${WORKSPACE}/${currentBuild.number}/quality_tests/cucumber"
    fileName = "pom.xml"
    if (fileExists("${dir}/${fileName}")) {
        utilsMessageLib.infoMsg("cucumber() ->$fileName encontrado em $dir")
    } else {
        utilsMessageLib.warnMsg("$fileName não encontrado em $dir")
        utilsMessageLib.warnMsg("Crie o diretorio 'quality_tests/cucumber' e adicione os códigos para execução dos testes e geração dos relatórios.")
        return
    }

    try {
        utilsMessageLib.infoMsg("cucumber() ->Executando cucumber.sh ...")
        sh(script: "${packageBasePath}/controller/tests/cucumber.sh ${cmdCucumber} \
                    --piaasEnv=${piaasEnv} \
                    --application-name=${applicationName} \
                    --version=${versionAppCucumber} \
                    --build-number=${currentBuild.number} \
                    --jdk=${cucumberJdkVersion}", returnStdout: false)
    } catch (err) {
        utilsMessageLib.warnMsg("cucumber() ->Erro na execução do Cucumber.")
        cucumberScore = "0"
    }

    try {
        utilsMessageLib.infoMsg("cucumber() ->Obtendo Cucumber Score...")
        cucumberScore = sh(script: "${packageBasePath}/controller/tests/cucumber.sh --score=true --version=${versionAppCucumber}", returnStdout: true)
        cucumberScore = cucumberScore.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

        toolsScore.qs_test.analysis_performed   = 'true' 
        toolsScore.qs_test.score                = cucumberScore.toInteger()

        piaasMainInfo.qs_test_analysis_performed    = 'true'
        piaasMainInfo.qs_test_score                 = toolsScore.qs_test.score

        if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
            changeorderTestResult = changeorderTestResult + "**** Cucumber - [ Score: ${cucumberScore} ]{/n}"
        }

    } catch (err) {
        utilsMessageLib.warnMsg("cucumber() ->Cucumber Score nao pode ser obtido")
        piaasMainInfo.qs_test_analysis_performed = 'false'
		piaasMainInfo.qs_test_score              = 0

    }

    utilsMessageLib.infoMsg("cucumber() ->Score Cucumber '${cucumberScore}' para execução na versão ${versionAppCucumber}")
    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "CUCUMBER", "score-quality")
}

/**
 * qsTest
 * Método faz chamadas a qualquer framework de teste
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def qsTest(def cmdQsTest) {
    def versionAppQsTest = ''
    qsTestUrlReports     = ''
    def qsTestScore      = ''
    def qsTestMethod     = ''
    def qsTestRunner     = ''
    def qsTestScript     = ''
    def qsTestExtraVars  = ''

    versionAppQsTest = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")

    echo "Invoking Qs Test"
    echo "Details test '${cmdQsTest}'"

    cmdQsTest.split().each {
        if (it.toLowerCase().contains("--method")) {
            qsTestMethod   = it.split('=')[1]
        }
        if (it.toLowerCase().contains("--runner")) {
            qsTestRunner   = it.split('=')[1]
        }
        if (it.toLowerCase().contains("--script")) {
            qsTestScript   = it.split('=')[1]
        }
    }

    if ( ( qsTestMethod == "" ) || ( qsTestScript == "" ) || ( qsTestRunner == "" ) ) {
        utilsMessageLib.errorMsg("Opss, Parameters for Qs Test not informed")
        echo "Example for using: qs-test: --method=protractor --runner=experian-polis-web-test --script=WORKSPACE/protractor-automate.sh --extra-vars='esteira2 VERSION'"
        currentBuild.description = "Parameters for Qs Test not informed"
        errorPipeline = "Parameters for Qs Test not informed"
        helpPipeline = "Corriga em seu piaas.yml os parametros para o uso do qs-test."
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }

    echo "Using method ${qsTestMethod} customized for running Qs Test"
    echo "Script for running ${qsTestScript}"
    sh(script: "chmod a+x ${qsTestScript}", returnStdout: false)
    sh(script: qsTestScript, returnStdout: false)

    // NIKEDEVSEC-2462 - Melhoria na validação de relatorios de testes de qualidade Cucumber/Cypress
    try{
        qsTestUrlReports = sh(script: "${packageBasePath}/controller/tests/qsTest.sh --geturl=true  ${cmdQsTest} --version=${versionAppQsTest}", returnStdout: true)
        qsTestUrlReports = qsTestUrlReports.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        echo "Url report: ${qsTestUrlReports}"
    }catch (err){
        utilsMessageLib.warnMsg("Get url QS Test is was not possible")
    }

    try {
        qsTestScore = sh(script: "${packageBasePath}/controller/tests/qsTest.sh --score=true --geturl=true ${cmdQsTest} --version=${versionAppQsTest}", returnStdout: true)
        qsTestScore = qsTestScore.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        echo "Your score: ${qsTestScore}"
    } catch (err) {
        if (err.toString().contains("code 99")) {
            piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_QS-TEST_000'
            qsTestScore = "0"
            throw err    
        } else {
            utilsMessageLib.warnMsg("Get score QS Test is was not possible")
            qsTestScore = "0"
        }
    }

    if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
        changeorderTestResult = changeorderTestResult +
                                "**** Qs Test - [ Score: ${qsTestScore} ]{/n}" +
                                "${qsTestUrlReports}{/n}{/n}";
    }

    echo "Score Qs Test '${qsTestScore}' for execution in version ${versionAppQsTest}"

    toolsScore.qs_test.analysis_performed    = 'true'
    toolsScore.qs_test.score                 = qsTestScore.toFloat()

    piaasMainInfo.qs_test_analysis_performed = 'true'
    piaasMainInfo.qs_test_score              = qsTestScore
    piaasMainInfo.qs_test_url                = qsTestUrlReports

    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "CYPRESS", "score-quality")

}

/**
 * cypress
 * Método faz chamadas ao cypress
 * @version 1.0.0
 * @package DevOps
 * @author  Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
 def cypress(def cmdCypress) {

    utilsMessageLib.infoMsg("cypress() ->Iniciando Testes...")
    
    def versionAppCypress = ''
    def cypressScore      = ''
    versionAppCypress = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    def bitbucketProjectCypress = controllerIntegrationsBitbucket.getBitbucketProject()
    def branchCypressTest = 'master'

    cmdCypress.split().each {
        if (it.contains("--branch") ) {
            branchCypressTest         = it.split('=')[1]
        }

        if (it.contains("--project-repo") ) {
            bitbucketProjectCypress   = it.split('=')[1]
        }
    }

    if ( cmdCypress.contains("--external-repo") ) {
        sh(script: "mkdir quality_tests && mkdir quality_tests/cypress", returnStdout: false)
        sh(script: "git clone -b ${branchCypressTest} ssh://git@code.br.experian.local/${bitbucketProjectCypress}/${applicationName}-test.git quality_tests/cypress", returnStdout: false)
    }

    utilsMessageLib.infoMsg("cypress() ->Parametros: ${cmdCypress}")

    dir = "${WORKSPACE}/${currentBuild.number}/quality_tests/cypress"
    if (fileExists("${dir}")) {
        utilsMessageLib.infoMsg("cypress() ->Diretorio 'quality_tests/cypress' encontrado")
    } else {
        utilsMessageLib.warnMsg("Diretorio 'quality_tests/cypress' nao encontrado")
        utilsMessageLib.warnMsg("Crie o diretorio 'quality_tests/cypress' e adicione os códigos para execução dos testes e geração dos relatórios.")
        return
    }
             
    try {
        utilsMessageLib.infoMsg("cypress() ->Executando cypress.sh ...")
        sh(script: "/opt/infratransac/core/br/com/experian/controller/tests/cypress.sh ${cmdCypress} \
                    --piaasEnv=${piaasEnv} \
                    --application-name=${applicationName} \
                    --version=${versionAppCypress} \
                    --build-number=${currentBuild.number}", returnStdout: false)
    } catch (err) {
        utilsMessageLib.warnMsg("cypress() ->Erro na execução do Cypress.")
        cypressScore = "0"
    }

    try {
        utilsMessageLib.infoMsg("cypress() ->Obtendo Cypress Score...")
        cypressScore = sh(script: "/opt/infratransac/core/br/com/experian/controller/tests/cypress.sh ${cmdCypress} --score=true --application-name=${applicationName} --version=${versionAppCypress}", returnStdout: true)
        cypressScore = cypressScore.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        
        toolsScore.qs_test.analysis_performed    = 'true' 
        toolsScore.qs_test.score                 = cypressScore.toInteger()

        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = toolsScore.qs_test.score

        if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
            changeorderTestResult = changeorderTestResult + "**** Cypress - [ Score: ${cypressScore} ]{/n}"
        }

    } catch (err) {
        utilsMessageLib.warnMsg("cypress() ->Cypress Score nao pode ser obtido")
        piaasMainInfo.qs_test_analysis_performed = 'false'
		piaasMainInfo.qs_test_score              = 0
    }

    utilsMessageLib.infoMsg("cypress() ->Score Cypress '${cypressScore}' para execução na versão ${versionAppCypress}") 

    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "CYPRESS", "score-quality")
}

/**
 * newman
 * Método faz chamadas a integração de testes com postman+newman
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def newman(def cmdNewman) {

    versionAppNewman = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    jsDir = ''

    echo "Invoking Newman Test"

    if ( (gitBranch.contains("feature")) || (gitBranch.contains("develop")) ) {
        jsDir = new File('newman/dev')
    } 
    else if ( (gitBranch.contains("qa")) || (gitBranch.contains("hotfix")) || (gitBranch.contains("uat")) ) {
        jsDir = new File('newman/qa')
    }
    else if ( gitBranch.contains("master") ) {
        jsDir = new File('newman/prod')
    }
    
    if (!cmdNewman) {
        echo "Details load test 'No parameters reported'"
    } else {
        echo "Details load test '${cmdNewman}'"
    }

    try {
        sh(script: "${packageBasePath}/controller/tests/newman.sh --workspace=${WORKSPACE}/${currentBuild.number} --js-test-path=${jsDir} --image=${ecrRegistry}piaas-newman:latest ${cmdNewman}", returnStdout: false)
        
        utilsMessageLib.infoMsg("Score Newman '100' for execution in version ${versionAppNewman}")

        toolsScore.qs_test.analysis_performed    = 'true'
        toolsScore.qs_test.score                 = 100
        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = 100
    	} catch (err) {
		if (err.toString().contains("code 99")) {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_NEWMAN_000'
			utilsMessageLib.warnMsg("Failed to run newman test, not find file *.js, score newman '0'")
            piaasMainInfo.qs_test_analysis_performed = 'false'
            piaasMainInfo.qs_test_score              = 0
		} else {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_NEWMAN_001'
			utilsMessageLib.warnMsg("Failed to run newman test, score newman '0'")
            piaasMainInfo.qs_test_analysis_performed = 'false'
            piaasMainInfo.qs_test_score              = 0
		}
	}

    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "NEWMAN", "score-quality")
}

/**
 * bruno-api
 * Método faz chamadas a integração de testes com bruno-api
 * @version 8.32.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @return  true | false
 **/
def brunoApi(def cmdBrunoApi) {

    versionAppQsTest = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    environmentBrunoApi = ''

    echo "Invoking BrunoApi Test"

    if ( (gitBranch.contains("feature")) || (gitBranch.contains("develop")) ) {
        environmentBrunoApi = "dev"
    } else if ( (gitBranch.contains("qa")) || (gitBranch.contains("hotfix")) || (gitBranch.contains("uat")) ) {
        environmentBrunoApi = "qa"
    } else if ( gitBranch.contains("master") ) {
        environmentBrunoApi = "prod"
    } else {
        environmentBrunoApi = "dev"
    }
    
    try {
        sh(script: "${packageBasePath}/controller/tests/brunoApi.sh --workspace=${WORKSPACE}/${currentBuild.number} --environment=${environmentBrunoApi} --image=${ecrRegistry}piaas-bruno-api", returnStdout: false)
        
        toolsScore.qs_test.analysis_performed    = 'true'
        toolsScore.qs_test.score                 = 100

        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = 100   

        utilsMessageLib.infoMsg("Score Qs Test '100' for execution in version ${versionAppQsTest}")
    } catch (err) {
        utilsMessageLib.warnMsg("Score Qs Test '0' for execution in version ${versionAppQsTest}")

        toolsScore.qs_test.analysis_performed    = 'true'
        toolsScore.qs_test.score                 = 0

        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = 0      
    }

    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "BRUNO_API", "score-quality")

}

/**
 * selenium
 * Método faz chamadas ao selenium
 * @version 8.3.0
 * @package DevSecOps
 * @author  Felipe Moura <felipe.moura@br.experian.com>
 * @return  true | false
 **/
def selenium(def cmdSelenium) {
    utilsMessageLib.infoMsg("selenium() ->Iniciando Testes...")
    
    def versionAppSelenium = ''
    def seleniumScore      = ''
    versionAppSelenium = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")
    def bitbucketProjectSelenium = controllerIntegrationsBitbucket.getBitbucketProject()
    def branchSeleniumTest = 'master'
    def seleniumJdkVersion = ''

    if ( (cmdSelenium == null) || (! cmdSelenium.contains("--jdk")) || (! cmdSelenium.contains("--browser")) ) {
        utilsMessageLib.errorMsg("selenium() -> É obrigatório informar a JDK e o browser para execução dos testes.")
        throw new Exception("Informe a JDK para realizar a execução de testes com Selenium.")
    }

    cmdSelenium.split().each {
        if (it.contains("--branch") ) {
            branchSeleniumTest         = it.split('=')[1]
        }

        if (it.contains("--project-repo") ) {
            bitbucketProjectSelenium   = it.split('=')[1]
        }

        if (it.contains("--jdk") ) {
            seleniumJdkVersion         = it.split('=')[1]
        }
    }

    if ( cmdSelenium.contains("--external-repo") ) {
        sh(script: "mkdir quality_tests && mkdir quality_tests/selenium", returnStdout: false)
        sh(script: "git clone -b ${branchSeleniumTest} ssh://git@code.br.experian.local/${bitbucketProjectSelenium}/${applicationName}-test.git quality_tests/selenium", returnStdout: false)
    }

    dir = "${WORKSPACE}/${currentBuild.number}/quality_tests/selenium"
    fileName = "pom.xml"
    if (fileExists("${dir}/${fileName}")) {
        utilsMessageLib.infoMsg("selenium() ->$fileName encontrado em $dir")
    } else {
        utilsMessageLib.warnMsg("$fileName não encontrado em $dir")
        utilsMessageLib.warnMsg("Crie o diretorio 'quality_tests/selenium' e adicione os códigos para execução dos testes e geração dos relatórios.")
        return
    }

    try {
        utilsMessageLib.infoMsg("selenium() ->Executando selenium.sh ...")
        sh(script: "${packageBasePath}/controller/tests/selenium.sh ${cmdSelenium} \
                    --piaasEnv=${piaasEnv} \
                    --application-name=${applicationName} \
                    --version=${versionAppSelenium} \
                    --build-number=${currentBuild.number} \
                    --jdk=${seleniumJdkVersion}", returnStdout: false)
    } catch (err) {
        utilsMessageLib.warnMsg("selenium() ->Erro na execução do selenium.sh")
        seleniumScore = "0"
    }

    try {
        utilsMessageLib.infoMsg("selenium() ->Obtendo Selenium Score...")
        seleniumScore = sh(script: "${packageBasePath}/controller/tests/selenium.sh --score=true --version=${versionAppSelenium}", returnStdout: true)
        seleniumScore = seleniumScore.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

        toolsScore.qs_test.analysis_performed= 'true' 
        toolsScore.qs_test.score             = seleniumScore.toInteger()

        piaasMainInfo.qs_test_analysis_performed = 'true'
        piaasMainInfo.qs_test_score              = toolsScore.qs_test.score

        if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
            changeorderTestResult = changeorderTestResult + "**** Selenium - [ Score: ${seleniumScore} ]{/n}"
        }

    } catch (err) {
        utilsMessageLib.warnMsg("selenium() ->Selenium Score nao pode ser obtido")
        piaasMainInfo.qs_test_analysis_performed = 'false'
		piaasMainInfo.qs_test_score              = 0
    }
    
    utilsMessageLib.infoMsg("selenium() ->Score Selenium '${seleniumScore}' para execução na versão ${versionAppSelenium}")

    serviceGovernanceScore.scorePost(piaasMainInfo.qs_test_score, "SELENIUM", "score-quality")


}

return this