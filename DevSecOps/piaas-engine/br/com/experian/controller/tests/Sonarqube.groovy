import groovy.json.JsonSlurper

/**
 * sonarqubeTest
 * Método faz os testes utilizando a ferramenta sonarqube
 * @version 8.24.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *          Yros Pereira Aguiar Batista <Yros.Aguiar@br.clara.net>
 * @return  true | false
 **/
def sonarqubeTest(def cmdSonar) {

    def sonarJdkRunner = jdk

    echo "Invoking test sonarqube"
    echo "Running sonarqube to language '${language}'"

    changeorderTestResult = changeorderTestResult +
        "**** SonarQube - Métricas de qualidade. Url projeto: ${sonarUrl}/dashboard/index/${artifactId}{/n}";

    if ( (cmdSonar != null) && (sonarOnlyScan == true) ) {
        if ( (cmdSonar.toLowerCase().contains("onlyscan")) ) {
            piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_ONLYSCAN_000'
            validateSonarScan()

            if ( sonarScanStatus == true ) {
                setSonarQualityGates()
            }
        } else {
            sonarOnlyScan = false
            sonarqubeTest(cmdSonar)
        }
    } else {
        switch (languageName.toLowerCase()) {
            case "java":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_JAVA_000'

                mvnCmdTestRun = "org.jacoco:jacoco-maven-plugin:prepare-agent test org.jacoco:jacoco-maven-plugin:report compile install"
                
                mvnCmdSonarRun = "org.sonarsource.scanner.maven:sonar-maven-plugin:3.5.0.1254:sonar \
                                                -Dsonar.profile=Serasa-Java \
                                                -Dsonar.log.level=INFO \
                                                -Dbranch=${gitBranch} \
                                                -Dsonar.projectKey=${artifactId} \
                                                -Dsonar.projectName='${applicationName}' \
                                                -Dsonar.host.url=${sonarUrl}"

                try {
                    utilsMessageLib.infoMsg("Running Unit Tests for Java application")

                    sh(script: "docker run --rm -e JDK='${sonarJdkRunner}' -e MVNCMD='${mvnCmdTestRun}' -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)

                    if ( sonarJdkRunner == "8" ) {
                        sonarJdkRunner = "11"
                    }

                    utilsMessageLib.infoMsg("Running Code Coverage for Java application")

                    withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                        sh(script: "docker run --rm -e JDK='${sonarJdkRunner}' -e MVNCMD='${mvnCmdSonarRun}' -e SONAR_TOKEN=${sonarToken} -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)
                    }
                } catch (Exception e) {
                    utilsMessageLib.errorMsg("Error in SonarQube execution. See logs and fix to continue.")
                    throw err
                }

                setSonarQualityGates()
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Message sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Card not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            case [ "python", "python3.6", "python3.8", "python3.9", "python3.10", "python3.11", "python3.12"]:
                echo "Running Unit tests and Code Coverage for '${language}' with values sonarURL=${sonarUrl}"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_PYTHON_000'

                if ( cmdSonar == "pytest" ) {
                    echo "Sonarqube python test using pytest"
                    withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                        sh(script: "docker run --rm \
                                                -v ${WORKSPACE}/${currentBuild.number}:/app \
                                                -e gitRepo=${gitRepo} \
                                                -e projectKey=${artifactId} \
                                                -e projectName=${applicationName} \
                                                -e SONAR_TOKEN=${sonarToken} \
                                                -e projectVersion=${versionApp} \
                                                ${ecrRegistry}sonar-scanner-python-pytest:${language}", returnStdout: false)
                    }
                } else {
                    echo "Sonarqube python test using nose"
                    withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                        sh(script: "docker run --rm \
                                                -v ${WORKSPACE}/${currentBuild.number}:/app \
                                                -e gitRepo=${gitRepo} \
                                                -e projectKey=${artifactId} \
                                                -e projectName=${applicationName} \
                                                -e SONAR_TOKEN=${sonarToken} \
                                                -e projectVersion=${versionApp} \
                                                ${ecrRegistry}sonar-scanner-python", returnStdout: false)
                    }
                }

                setSonarQualityGates()
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Email sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Email not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            case "node":
                dockerImageSonarRun = ""
                useYarnImage = "false"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_NODE_000'
                utilsMessageLib.infoMsg("Running Unit tests and Code Coverage for ${languageName}-${languageVersion} with values sonarURL=${sonarUrl}")

                if ( languageVersion == "16" ) {

                    if ( language.contains("yarn") ) {
                        dockerImageSonarRun = "${ecrRegistry}sonar-scanner-typescript-node16-with-yarn"
                    } else {
                        dockerImageSonarRun = "${ecrRegistry}sonar-scanner-typescript-node16"
                    }
                } else if ( languageVersion == "20" ) {
                    dockerImageSonarRun = "${ecrRegistry}sonar-scanner-typescript-node20"
                  
                    if ( language.contains("yarn") ) {
                        useYarnImage = "true"
                    }
                } else {
                    dockerImageSonarRun = "${ecrRegistry}sonar-scanner-typescript"
                }

                withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                    sh(script: "docker run --rm \
                                    -v ${WORKSPACE}/${currentBuild.number}:/app \
                                    -e gitRepo=${gitRepo} \
                                    -e projectKey=${artifactId} \
                                    -e projectName=${applicationName} \
                                    -e SONAR_TOKEN=${sonarToken} \
                                    -e use_yarn=${useYarnImage} \
                                    -e projectVersion=${versionApp} \
                                    ${dockerImageSonarRun}", returnStdout: false)
                }

                setSonarQualityGates()
                
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Email sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Email not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            case "scala":
                echo "Running Unit tests and Code Coverage for '${language}' with values sonarURL=${sonarUrl}"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_SCALA_000'

                mvnCmdTestRun = "clean org.jacoco:jacoco-maven-plugin:prepare-agent install"

                mvnCmdSonarRun = "-Dsonar.log.level=INFO \
                -Dmaven.test.failure.ignore=true sonar:sonar \
                -Dsonar.projectKey=${artifactId} \
                -Dsonar.jacoco.reportPaths=${WORKSPACE}/${currentBuild.number}/target/coverage-reports/jacoco-unit.exec \
                -Dsonar.host.url=${sonarUrl}"

                try {
                    utilsMessageLib.infoMsg("Running Unit Test for Scala application")

                    sh(script: "docker run --rm -e JDK='${sonarJdkRunner}' -e MVNCMD='${mvnCmdTestRun}' -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)

                    if ( sonarJdkRunner == "8" ) {
                        sonarJdkRunner = "11"
                    }

                    utilsMessageLib.infoMsg("Running Code Coverage for Scala application")

                    withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                        sh(script: "docker run --rm -e JDK='${sonarJdkRunner}' -e MVNCMD='${mvnCmdSonarRun}' -e SONAR_TOKEN=${sonarToken} -v ${WORKSPACE}/${currentBuild.number}:/app ${piaasMvnBuilderImage}", returnStdout: false)
                    }
                } catch (Exception e) {
                    utilsMessageLib.errorMsg("Error in SonarQube execution. See logs and fix to continue.")
                    throw err
                }

                setSonarQualityGates()
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Email sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Email not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            case "cobol":
                echo "Running Unit tests and Code Coverage for '${language}' with values sonarURL=${sonarUrl}"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_COBOL_000'
                echo "Sonarqube test default"
                echo "Seja bem vindo cobol ao teste de qualidade com sonarqube o/!!!!"

                break
            case "php":
                echo "Running Unit tests and Code Coverage for '${language}' with values sonarURL=${sonarUrl}"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_PHP_000'

                echo "Sonarqube PHP test default"
                withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                    sh(script: "docker run --rm \
                                            -v ${WORKSPACE}/${currentBuild.number}:/app \
                                            -e gitRepo=${gitRepo} \
                                            -e projectKey=${artifactId} \
                                            -e projectName=${applicationName} \
                                            -e SONAR_TOKEN=${sonarToken} \
                                            -e projectVersion=${versionApp} \
                                            ${ecrRegistry}sonar-scanner-php", returnStdout: false)
                }

                setSonarQualityGates()
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Email sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Email not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            case "php8.2":
                echo "Running Unit tests and Code Coverage for '${language}' with values sonarURL=${sonarUrl}"
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_PHP_000'

                echo "Sonarqube PHP test default"
                withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
                    sh(script: "docker run --rm \
                                            -v ${WORKSPACE}/${currentBuild.number}:/app \
                                            -e gitRepo=${gitRepo} \
                                            -e projectKey=${artifactId} \
                                            -e projectName=${applicationName} \
                                            -e SONAR_TOKEN=${sonarToken} \
                                            -e projectVersion=${versionApp} \
                                            ${ecrRegistry}sonar-scanner-php8.2", returnStdout: false)
                }

                setSonarQualityGates()
                if ( sonarProjectStatus == 'ERROR' ) {
                    utilsMessageLib.warnMsg("Email sent to developer ${gitAuthor} - ${gitAuthorEmail} with quality gates alert")

                    changeorderTestResult = changeorderTestResult +
                                            "- Justificativa de implantação sem métricas de qualidade atingidas{/n}" +
                                            "   Autorizado por: ${gitAuthor}{/n}{/n}";
                    
                    try {
                        if (gitAuthorEmail != "") {
                            controllerNotifications.cardStatus('sonarQualityGatesAlert')
                        }
                    } catch (err) {
                        utilsMessageLib.warnMsg("Email not sent in function sonarQualityGatesAlert")
                    }

                }
                break
            default:
                utilsMessageLib.errorMsg("Implementation '${language}' in not sonarqubeTest stage not performed :(")
        }
    }
}

/**
 * validateSonarScan
 * Método que faz a validaçao do onlyscan
 * @version 8.6.0
 * @package DevOps
 * @author Andre Arioli
 **/
def validateSonarScan() {
    def data = ""
    def jsonQualityGatesConditions = ''
    def sonarData = '' 
    
    echo "Invoking function validateSonarScan"
    
    todayDate = new Date().format("yyyy-MM-dd") 
    def urlSearch = sonarUrl + '/api/project_analyses/search?project=' + artifactId + '&&ps=1&&from=' + todayDate

    withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
        data = utilsRestLib.httpGet(urlSearch, sonarToken, "", "Sonarqube Metrics")
    }

    def json = new JsonSlurper().parseText(data)

    sonarValidate = json.analyses.date.toString()
    
    if ( sonarValidate == "[]" ) {
        utilsMessageLib.errorMsg("Seu scan de SonarQube nao existe na data atual. Seu score será zerado. Realize novo scan para atribuição do score.")
        sonarScanStatus = false
        sonarProjectStatus = "ERROR"

        toolsScore.sonarqube.analysis_performed = 'false' 
        toolsScore.sonarqube.score    = 0
    } else {
        utilsMessageLib.infoMsg("Scan encontrado. Seguindo com a atribuição de score.")
        sonarScanStatus = true
    }
}

/**
 * setSonarQualityGates
 * Método seta quality gates do sonar para o projeto
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def setSonarQualityGates() {
    sonarProjectStatus           = ''
    sonarQualityGatesThreshold   = 0
    sonarQualityGatesActualValue = 0
    sonarAllowedPercentage       = ''
    sonarQualityGatesDescription = ''
    def data = ""

    echo "Invoking function setSonarQualityGates"

    piaasMainInfo.sonarqube_url  = sonarUrl + '/dashboard?id=' + artifactId

    try {
        def jsonQualityGatesConditions = ''
        def urlSearch = sonarUrl + '/api/qualitygates/project_status?projectKey=' + artifactId

        withCredentials([string(credentialsId: 'sonar.token', variable: 'sonarToken')]) {
            data = utilsRestLib.httpGet(urlSearch, sonarToken, "", "Sonarqube Metrics")
        }

        def json = new JsonSlurper().parseText(data)

        sonarProjectStatus = json.projectStatus.status

        echo "Gates conditions details"
        sonarQualityGatesDescription = "<p><b></b><br />";

        List conditions = (List) json.projectStatus.get("conditions");
        for (i = 0; i < conditions.size(); i++) {
            jsonQualityGatesConditions = json.projectStatus.conditions.get(i)
            if (jsonQualityGatesConditions.status == 'ERROR') {
                utilsMessageLib.errorMsg("Failed for condition ${jsonQualityGatesConditions.metricKey}: Actual value: ${jsonQualityGatesConditions.actualValue} | Threshold: ${jsonQualityGatesConditions.errorThreshold}")
            } else if (jsonQualityGatesConditions.status == 'OK') {
                utilsMessageLib.infoMsg("Success for condition ${jsonQualityGatesConditions.metricKey}: Actual value: ${jsonQualityGatesConditions.actualValue} | Threshold: ${jsonQualityGatesConditions.errorThreshold}")
            } else {
                utilsMessageLib.warnMsg("Warning for condition ${jsonQualityGatesConditions.metricKey}: Actual value: ${jsonQualityGatesConditions.actualValue} | Threshold: ${jsonQualityGatesConditions.errorThreshold}")
            }
            if ( jsonQualityGatesConditions.metricKey == 'coverage' ) {
                sonarQualityGatesThreshold    = jsonQualityGatesConditions.errorThreshold
                sonarQualityGatesActualValue  = jsonQualityGatesConditions.actualValue
                toolsScore.sonarqube.analysis_performed = 'true'
                toolsScore.sonarqube.score    = sonarQualityGatesActualValue.toFloat()
                sonarAllowedPercentage        = (sonarQualityGatesThreshold.toInteger() * 1) / 100
                piaasMainInfo.sonarqube_analysis_performed = 'true'
                piaasMainInfo.sonarqube_score = toolsScore.sonarqube.score
                utilsMessageLib.warnMsg("Percentage of non-coverage allowed: ${sonarAllowedPercentage}")
            } else if ( jsonQualityGatesConditions.metricKey == 'new_security_rating' ) {
                piaasMainInfo.sonarqube_new_security_rating = jsonQualityGatesConditions.actualValue
            } else if ( jsonQualityGatesConditions.metricKey == 'new_reliability_rating' ) {
                piaasMainInfo.sonarqube_new_reliability_rating = jsonQualityGatesConditions.actualValue
            } else if ( jsonQualityGatesConditions.metricKey == 'new_maintainability_rating' ) {
                piaasMainInfo.sonarqube_new_maintainability_rating = jsonQualityGatesConditions.actualValue
            } else if ( jsonQualityGatesConditions.metricKey == 'critical_violations' ) {
                piaasMainInfo.sonarqube_critical_violations = jsonQualityGatesConditions.actualValue
            } else if ( jsonQualityGatesConditions.metricKey == 'blocker_violations' ) {
                piaasMainInfo.sonarqube_blocker_violations = jsonQualityGatesConditions.actualValue
            }
            sonarQualityGatesDescription = sonarQualityGatesDescription +
                                           "[${jsonQualityGatesConditions.status}] <b>${jsonQualityGatesConditions.metricKey}</b><br />" +
                                           "Valor atual: ${jsonQualityGatesConditions.actualValue} | Mínimo: ${jsonQualityGatesConditions.errorThreshold}<br /><br />";
            changeorderTestResult = changeorderTestResult +
                                     "[${jsonQualityGatesConditions.status}] - ${jsonQualityGatesConditions.metricKey}: Valor atual: ${jsonQualityGatesConditions.actualValue} | Mínimo: ${jsonQualityGatesConditions.errorThreshold}{/n}";
        }
        sonarQualityGatesDescription = sonarQualityGatesDescription +
            "</p>";
        changeorderTestResult = changeorderTestResult +
            "{/n}";
    } catch (err) {
        utilsMessageLib.warnMsg("First scan sonarqube for application, there are no metrics!")
    }

    serviceGovernanceScore.scorePost(piaasMainInfo.sonarqube_score, "SONARQUBE", "score-unit")

}

return this
