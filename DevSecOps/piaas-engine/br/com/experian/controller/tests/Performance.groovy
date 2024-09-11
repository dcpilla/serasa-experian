/**
 * jmeter
 * Método faz chamadas ao jmeter
 * @version 8.3.0
 * @package DevSecOps
 * @author  Douglas Pereira <douglas.pereira@br.experian.com>
 * @return  true | false
 **/
def jmeter(def cmdJmeter) {
    def versionAppJmeter = ''
	def jsDir = ''
    jmeterUrlReports = ''

	if ((gitBranch.contains("feature/")) || (gitBranch == "develop")) {
        jsDir = new File('jmeter/dev')
    }
    else if ((gitBranch == "qa") || (gitBranch == "uat")) {
        jsDir = new File('jmeter/qa')
    }
    else if (gitBranch == "master") {
        jsDir = new File('jmeter/prod')
    }

    versionAppJmeter = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")

    echo "Invoking test jmeter"
    if (!cmdJmeter) {
        echo "Details test 'No parameters reported'"
    } else {
        echo "Details test '${cmdJmeter}'"
    }
	
	try {
		sh(script: "#!/bin/sh -e\n ${packageBasePath}/controller/tests/jmeter.sh --path-test=${jsDir} --version-app=${versionAppJmeter} --application-name=${artifactId} --environment=${environmentName} --piaasEnv=${piaasEnv} ${cmdJmeter}", returnStdout: false)
	
		jmeterUrlReports = sh(script: "${packageBasePath}/controller/tests/jmeter.sh --geturl=true --version-app=${versionAppJmeter} --application-name=${artifactId} --environment=${environmentName} --build-number=${currentBuild.number}", returnStdout: true)
		jmeterUrlReports = jmeterUrlReports.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
		echo "${jmeterUrlReports}"
		
		toolsScore.performance.analysis_performed = 'true'
		toolsScore.performance.score              = 100
	
		piaasMainInfo.performace_analysis_performed= 'true'
		piaasMainInfo.performace_score             = toolsScore.performance.score
		piaasMainInfo.performace_url               = jmeterUrlReports
	
		if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master") || (madeByApollo11)) {
			changeorderTestResult = changeorderTestResult +
									"**** Jmeter - [ Score: 100 ]{/n}" +
									"${jmeterUrlReports}{/n}{/n}";
		}
		echo "Score jmeter '100' for execution in version ${versionAppJmeter}"
	} catch (err) {
		if (err.toString().contains("code 99")) {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_JMETER_000'
			utilsMessageLib.warnMsg("Failed to run jmeter test, not find file *.jmx, score jmeter '0'")
			piaasMainInfo.performace_analysis_performed = 'false'
			piaasMainInfo.performace_score              = 0
		} else {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_JMETER_001'
			utilsMessageLib.warnMsg("Failed to run jmeter test, score jmeter '0'")
			piaasMainInfo.performace_analysis_performed = 'false'
			piaasMainInfo.performace_score              = 0
		}
	}

	serviceGovernanceScore.scorePost(piaasMainInfo.performace_score, "JMETER", "score-performance")
}

/**
 * k6
 * Método faz chamadas a integração de testes de carga
 * @version 8.27.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @return  true | false
 **/
def k6(def cmdK6) {
    def versionAppK6 = ''

    def jsDir = ''
    def jsFiles = ''
    def outputStringFiles = ''
    def writerFile = ''
    def resultListFiles = ''

    if ((gitBranch.contains("feature/")) || (gitBranch == "develop")) {
        jsDir = new File('k6/dev')
    }
    else if ((gitBranch == "qa") || (gitBranch == "uat")) {
        jsDir = new File('k6/qa')
    }
    else if (gitBranch == "master") {
        jsDir = new File('k6/prod')
    }

    versionAppK6 = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")

    echo "Invoking load test k6"
    if (!cmdK6) {
        echo "Details load test 'No parameters reported'"
    } else {
        echo "Details load test '${cmdK6}'"
    }

    try {
        sh(script: "#!/bin/sh -e\n ${packageBasePath}/controller/tests/k6.sh --js-test-path=${jsDir} --version=${versionAppK6} --image=${ecrRegistry}piaas-k6:latest ${cmdK6}", returnStdout: false)
                
        utilsMessageLib.infoMsg("Score k6 '100' for execution in version ${versionAppK6}")

        toolsScore.performance.analysis_performed = 'true'
        toolsScore.performance.score              = 100
        piaasMainInfo.performace_analysis_performed = 'true'
        piaasMainInfo.performace_score              = toolsScore.performance.score
	} catch (err) {
		if (err.toString().contains("code 99")) {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_K6_000'
			utilsMessageLib.warnMsg("Failed to run k6 test, not find file *.js, score k6 '0'")
			piaasMainInfo.performace_analysis_performed = 'false'
			piaasMainInfo.performace_score              = 0
		} else {
			piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_K6_001'
			utilsMessageLib.warnMsg("Failed to run k6 test, score k6 '0'")
			piaasMainInfo.performace_analysis_performed = 'false'
			piaasMainInfo.performace_score              = 0
		}
	}

	serviceGovernanceScore.scorePost(piaasMainInfo.performace_score, "K6", "score-performance")
}

return this