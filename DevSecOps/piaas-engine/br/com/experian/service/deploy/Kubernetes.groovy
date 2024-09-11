/**
 * eks
 * Método faz chamadas ao deploy eks
 * @version 8.5.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def eks(def cmdEks) {
    scriptExecOut = ''

    echo "Invoking deploy aws eks"
    echo "Details deploy '${cmdEks}'"

    if ( cmdEks != null ) {
        def positionOne = cmdEks.split(" ")
        def initialParam = positionOne.find { it.startsWith("--cluster-name=") }
        clusterName << initialParam.split("=")[1]

        if ( ! cmdEks.toLowerCase().contains("--environment") ) {
           cmdEks = cmdEks + ' --environment=' + environmentName
        } 
    } 

    scriptExecOut = sh(script: "${packageBasePath}/service/deploy/deployEks.sh --application-name=${artifactId} --version=${versionApp} --tribe=${piaasMainInfo.tribe} --squad=${piaasMainInfo.squad} ${cmdEks}", returnStdout: false)   

}

/**
 * helm
 * Método faz chamadas ao helm
 * @version 1.0.0  
 * @package DevOps
 * @author  Diego Alves Dias <diego.adias@br.experian.com>
 * @return  true | false
 **/
def helm(def cmdHelm) {
    def scriptExecOut = ''
    def flagEksScore = ''
    def flagEksScoreInt = 0
    def tokenHelm = '--application-name='
    def applicationHelm = ''

    echo "Invoking send package helm"

    if ( cmdHelm != null ) {
        if ( ! cmdHelm.toLowerCase().contains("--environment") ) {
           cmdHelm = cmdHelm + ' --environment=' + environmentName
        }
    }

    if ( cmdHelm.indexOf(tokenHelm) != -1) {
        def start = cmdHelm.indexOf(tokenHelm) + tokenHelm.size()
        def end = cmdHelm.indexOf(" ", start)
        applicationHelm = cmdHelm[start..end]
        applicationHelm = applicationHelm.replaceAll(" ", "")
    }
    else {
        applicationHelm = artifactId
    }

    scriptExecOut = sh(script: "${packageBasePath}/service/deploy/helm.sh --target=s3 --project=${applicationName} --application-name=${artifactId} --version=${versionApp} --gearr-id=${piaasMainInfo.gearr_id} --tribe=${piaasMainInfo.tribe} --squad=${piaasMainInfo.squad} ${cmdHelm}", returnStdout: false)
    
    try {
        flagEksScore = sh(script: "#!/bin/sh -e\n cat ${WORKSPACE}/${currentBuild.number}/conftest/${applicationHelm}/${applicationHelm}.conftest | grep eks_policy_score: | cut -d':' -f2", returnStdout: true)
        flagEksScore = flagEksScore.replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        
        //piaasMainInfo.eks_policy_score = flagEksScore
        flagEksScoreInt = Integer.parseInt(flagEksScore)

        utilsMessageLib.infoMsg("Score Eks Policy '${flagEksScore}' for execution in version ${versionApp}")
        if (flagEksScoreInt < 80) {
            utilsMessageLib.warnMsg("EKS Policy Score below 80, see documentation sent by Teams")
            piaasMainInfo.pipeline_code_error  = 'ERR_EKS_SCORE_000'
            controllerNotifications.houstonWeHaveAProblem()
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Error get score Eks Policy '0' for execution in version ${versionApp}")

        piaasMainInfo.eks_policy_score = 0
    }
    return flagEksScoreInt
}

return this