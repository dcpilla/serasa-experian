/**
 * getLeadTime
 * Método recupera valores de leadtime do bitbucket 
 * @version 8.28.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @return  $versionApp
 **/
 def getLeadTime() {

    echo "Invoking function getLeadTime"

    def url = ""
    def apiCall = ""
    def actualDate = new Date().format('yyyy-MM-dd')

    leadTimeCreated = ''
    leadTimeClosed = ''

    projectRepository = gitRepo
    projectRepository = projectRepository.toString().replace("ssh://git@code.experian.local/", "").replace("ssh://git@code.br.experian.local/code/", "")
    projectRepository = projectRepository.toString().replace(".git", "")

    projectRepository = projectRepository.split("/")
    projectKey = projectRepository[0]
    projectRepository = projectRepository[1]

    url = "https://code.experian.local/rest/awesome-graphs/latest/reports/resolution-histogram/projects/${projectKey}/repos/${projectRepository}?from=${actualDate}&to=${actualDate}&type=merged&branch=refs%2Fheads%2F${gitBranch}"
               
    withCredentials([string(credentialsId: 'BitbucketGlobal.DevSecOps.Secret', variable: 'SECRET')]) {
        try {
            apiCall = sh(script: "curl -s -L '${url}' --header 'Authorization: Basic ${SECRET}'", returnStdout: true)
            
            jsonPayloadDetails = utilsJsonLib.jsonParse(apiCall)

            leadTimeCreated = jsonPayloadDetails.payload.created
            leadTimeCreated = leadTimeCreated.join()
            piaasMainInfo.lead_time_created = leadTimeCreated
    
            leadTimeClosed = jsonPayloadDetails.payload.closed
            leadTimeClosed = leadTimeClosed.join()
            piaasMainInfo.lead_time_closed = leadTimeClosed
            
        } catch (err) {
            utilsMessageLib.errorMsg("Error in load LeadTime endpoint.")
        }
    }
}

/**
 * setMapCodeReuse
 * Método para mapear reuso de código
 * @version 8.24.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  $versionApp
 **/
def setMapCodeReuse() {
    def flagTestSeds1 = ''
    def flagTestSeds2 = ''
    def flagTestSeds3 = ''

    echo "Invoking function setMapCodeReuse"

    if ( language.toLowerCase().contains('node') ) {

        flagTestSeds1 = sh(script: "cat package.json | grep experian-design-system | egrep -i dsbr | grep experian-design-system > /dev/null && test \$? -eq 0 && echo 'true' || echo 'false'", returnStdout: true)
        flagTestSeds1 = flagTestSeds1.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

        if ( flagTestSeds1 == "true") {
            piaasMainInfo.seds_setup = 'true'
            utilsMessageLib.infoMsg("SEDS configuration founded!")
        } else {
            piaasMainInfo.seds_setup = 'false'
            utilsMessageLib.warnMsg("SEDS configuration not founded!")
        }

        if ( piaasMainInfo.seds_setup == 'true' ) {
            try {
                searchModulesTS()

            } catch (err) {
                utilsMessageLib.warnMsg("Error to read seds-map file")
                println(err)
            }

        } else {
            utilsMessageLib.warnMsg("Ignoring component check because application has no seds implement")
        }

        if ( piaasMainInfo.seds_setup == 'true' ) { 
            flagTestSeds1 = sh(script: "#!/bin/sh -e\n cat angular.json |grep experian-design-system | grep '/theme/' | head -1 |sed -e 's/ //g;s/\"//g;s/,//g' > /dev/null && test \$? -eq 0 && echo 'true' || echo 'false'", returnStdout: true)
            flagTestSeds1 = flagTestSeds1.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

            flagTestSeds2 = sh(script: "#!/bin/sh -e\n find ${WORKSPACE}/${currentBuild.number} -type f -iname *.html -o -iname *.scss | xargs grep 'class=' | grep 'seds' > /dev/null && test \$? -eq 0 && echo 'true' || echo 'false'", returnStdout: true)
            flagTestSeds2 = flagTestSeds2.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

            flagTestSeds3 = sh(script: "#!/bin/sh -e\n find ${WORKSPACE}/${currentBuild.number} -type f -iname *.html -o -iname *.scss | xargs egrep 'container|row|col-*' > /dev/null && test \$? -eq 0 && echo 'true' || echo 'false'", returnStdout: true)
            flagTestSeds3 = flagTestSeds3.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

            if ( flagTestSeds1 == "true" ) {
                utilsMessageLib.infoMsg("SEDS theme founded!")
                if  ( ( flagTestSeds2 == "true" ) || ( flagTestSeds3 == "true" ) ) { 
                    piaasMainInfo.seds_thema = 'true'
                    utilsMessageLib.infoMsg("SEDS item .scss founded!")
                } else {
                    piaasMainInfo.seds_thema_false_positive = 'true'
                    utilsMessageLib.warnMsg("SEDS item .scss not founded!")
                }
            } else {
                piaasMainInfo.seds_thema='false'
                utilsMessageLib.warnMsg("SEDS theme not founded!")
                if  ( flagTestSeds3 == "true" ) {
                    piaasMainInfo.seds_thema_false_positive = 'true'
                }
            }

            } else {
                echo "Ignoring thema check because application has no seds implement"
            }

    } else {
        utilsMessageLib.warnMsg("Ignoring map code reuse to language ${language}")
    }
}

/**
 * searchModulesTS
 * Método para buscar os modulos SEDS em arquivos de modulos.ts
 * @version 8.28.0
 * @package DevOps
 * @author  Fabio P. Zinato <fabio.zinato@br.experian.com>
 * @param   
 * @return  true | false
 **/
def searchModulesTS() {
    
    def fileMap = sh(script: "cat /opt/infratransac/core/conf/seds-map.conf", returnStdout: true).trim().split('\n')
    def files = findFiles(glob: "**/*module.ts")
    def modulesFound = []

    for (file in files) {
        def fileContent = readFile(file.path)

        for ( module in fileMap ) {

            if ( modulesFound.contains(module) ) {
                continue
            }

            if ( fileContent.contains(module) ) {
                piaasMainInfo.putAt(module, "true")
                utilsMessageLib.infoMsg(module+" founded!")
                modulesFound.add(module)
            }

        }

    }
}

return this
