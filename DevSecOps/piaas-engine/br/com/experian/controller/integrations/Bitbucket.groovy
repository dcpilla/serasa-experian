/**
 * validateReviewers
 * Método retorna se a PR foi feita sem reviewers
 * @version 1.0.0  
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def validateReviewers(def userNameApprovedPR, def userEmailApprovedPR, def userDateApprovedPR) {

    if ( userNameApprovedPR == '' || userEmailApprovedPR == '' || userDateApprovedPR == '' ) {
        utilsMessageLib.errorMsg("Você está seguindo com uma PR sem aprovadores, o que não é permitido. Abortando execução.")
        piaasMainInfo.pipeline_code_error = "ERR_GETPRDETAILS_10"
        throw err
    }

}


/**
 * validateExceptionList
 * Método valida se a aplicação está cadastrada na ExceptionList de arquitetura
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def validateExceptionList() {

    utilsMessageLib.infoMsg("Resgatando Exception List e iniciando validação...")

    try {
        sh(script: "git clone -b master ssh://git@code.br.experian.local/ab/process-deploy-exception-list.git", returnStdout: false)
        exceptionListFlag = sh(script: "grep -w \"${piaasMainInfo.gearr_id}\" process-deploy-exception-list/whitelist-aplicacoes-ncompliance.csv", returnStdout: true)
        exceptionListFlag = true
        utilsMessageLib.infoMsg("Aplicação está cadastrada na Exception List.")
    } catch (err) {
        utilsMessageLib.infoMsg("Aplicação não está cadastrada na Exception List.")
        exceptionListFlag = false
    }

    //implantar chamada do piaas entity api, quando pronto

}

/**
 * pullRequest
 * Método abre pull request 
 * @version 8.1.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def pullRequest(def msgPullRequest) {
    def projectRepository = ''
    def projectKey = ''
    gitUrlPullRequest = ''

    echo "Invoking function pullrequest"

    projectRepository = gitRepo
    projectRepository = projectRepository.toString().replace("ssh://git@code.experian.local/", "").replace("ssh://git@code.br.experian.local/code/", "")
    projectRepository = projectRepository.toString().replace(".git", "")

    projectRepository = projectRepository.split("/")
    projectKey = projectRepository[0]
    projectRepository = projectRepository[1]

    echo "Details of open pull request in project key '${projectKey}' repository '${projectRepository}' branch oring '${gitBranch}'"

    try {
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('requestPullRequest')
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Email not sent in function requestPullRequest")
    }

    if (gitBranch == "develop") {
        utilsMessageLib.infoMsg("Ignoring create pullrequest for branch develop")
        /*echo "Question for user: Do you want to open a pull request?"
        utilsUserInputLib.inputUser("Do you want to open a pull request?", "yes", "Create pull request for the next deploy step", "pullrequest", 60, "success")
        echo "Answer informed: '${respInput}'"
        if (respInput.toLowerCase() == "yes") {
            try {
                sh(script: "git branch -r|grep origin/qa", returnStdout: false)
                echo "Using qa to target pull request"
                gitUrlPullRequest = "https://code.experian.local/projects/" + projectKey + "/repos/" + projectRepository + "/pull-requests?create&targetBranch=refs%2Fheads%2Fqa&sourceBranch=refs%2Fheads%2F" + gitBranch
            } catch (err) {
                utilsMessageLib.warnMsg("Not define branch qa, using master to target pull request")
                gitUrlPullRequest = "https://code.experian.local/projects/" + projectKey + "/repos/" + projectRepository + "/pull-requests?create&targetBranch=refs%2Fheads%2Fmaster&sourceBranch=refs%2Fheads%2F" + gitBranch
            }
            echo "Link to pull request: '${gitUrlPullRequest}'"
            try {
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('sendPullRequest')
                }
            } catch (err) {
                utilsMessageLib.warnMsg("Email not sent in function sendPullRequest")
            }
        }*/
    } else if ((gitBranch == "qa") || (gitBranch == "hotfix") || (madeByApollo11) ) {
        echo "Question for user: Do you want to open a pull request?"
        utilsUserInputLib.inputUser("Do you want to open a pull request to master?", "yes", "Create pull request for next deploy step in production", "pullrequest", 300, "success")
        echo "Answer informed: '${respInput}'"
        if (respInput.toLowerCase() == "yes") {
            flagChangeOrder = true
            gitUrlPullRequest = "https://code.experian.local/projects/" + projectKey + "/repos/" + projectRepository + "/pull-requests?create&targetBranch=refs%2Fheads%2Fmaster&sourceBranch=refs%2Fheads%2F" + gitBranch
            echo "Link to pull request: '${gitUrlPullRequest}'"
            try {
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('sendPullRequest')
                }
            } catch (err) {
                utilsMessageLib.warnMsg("Email not sent in function sendPullRequest")
            }
            echo "Starting creation normal change order"
            flagPullRequestCreated = 1
            serviceGovernanceItil.changeOrder('normal')
        } else {
            utilsMessageLib.warnMsg("Pull Request was not accepted for creation, it should be created manually.")
        }
    } else {
        echo "Nothing to do for function pullrequest for branch '${gitBranch}'"
    }
}

/** getPullRequestID
 * Método adquiri a PR ID
 * @version 1.0.0  
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def getPullRequestID() {

    echo "Invoking function getPullRequestID"

    gitPullRequestID = sh(script: "git reset --hard", returnStdout: true)
    gitPullRequestID = gitPullRequestID.replace("'", "")
    gitPullRequestID = sh(script: "echo '${gitPullRequestID}' | cut -d '#' -f2 | cut -d ':' -f1", returnStdout: true)
    gitPullRequestID = gitPullRequestID.replaceAll("\n", "")
     
}

/**
 * getPRDetails
 * Método retorna o usuário que abriaram a PR e seus aprovadores
 * @version 1.0.0  
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @return  true | false
 **/
def getPRDetails(def idPullRequest) {
    def bitbucketURI = ""
    userNameApprovedPR = ''
    userEmailApprovedPR = ''
    def response = ''

    echo "Invoking function getPRDetails"

    bitbucketRepository = getBitbucketRepository()
    bitbucketProjectKey = getBitbucketProject()

    bitbucketURI = "https://code.experian.local/rest/api/1.0/projects/$bitbucketProjectKey/repos/$bitbucketRepository/pull-requests/$idPullRequest/"
    failMessage = "PR details from ${bitbucketRepository} application"

    withCredentials([usernamePassword(credentialsId: 'BitbucketGlobal.DevSecOps', passwordVariable: 'pass', usernameVariable: 'user')]) {
        response = utilsRestLib.httpGet(bitbucketURI, user, pass, failMessage)
    }

    try {
        jsonPRDetails = utilsJsonLib.jsonParse(response)
            
        userNameOpenedPR = jsonPRDetails.author.user.displayName
        piaasMainInfo.author_opened = userNameOpenedPR
        userEmailOpenedPR = jsonPRDetails.author.user.emailAddress
        piaasMainInfo.author_email_opened = userEmailOpenedPR    
        userDateOpenedPR = jsonPRDetails.createdDate
        piaasMainInfo.author_data_opened = userDateOpenedPR
                
        jsonPRDetails.reviewers.each {
            if ( it.approved == true ) {
                userNameApprovedPR = userNameApprovedPR.concat(it.user.displayName + ', ')
                userEmailApprovedPR = userEmailApprovedPR.concat(it.user.emailAddress + ', ')
            }
        }
            
        piaasMainInfo.author_approved = userNameApprovedPR        
        piaasMainInfo.author_email_approved = userEmailApprovedPR
                
        userDateApprovedPR = jsonPRDetails.closedDate
        piaasMainInfo.author_data_approved = userDateApprovedPR

    } catch (Exception e) {
        utilsMessageLib.errorMsg("Impossible to parse PR details. Contact DevSecOps Brazil Team. Error: " + e)
        piaasMainInfo.pipeline_code_error = "ERR_GETPRDETAILS_00"
        throw err
    }

    validateReviewers(userNameApprovedPR, userEmailApprovedPR, userDateApprovedPR)
    
}

/**
 * getBitbucketRepository
 * Método retorna o repositorio do bitbucket
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def getBitbucketRepository() {

    projectRepository = gitRepo
    projectRepository = projectRepository.toString().replace("ssh://git@code.experian.local/", "").replace("ssh://git@code.br.experian.local/", "")
    projectRepository = projectRepository.toString().replace(".git", "")

    projectRepository = projectRepository.split("/")
    projectRepository = projectRepository[1]

    return projectRepository
}

 /**
 * getBitbucketProject
 * Método retorna o projeto do bitbucket
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 **/
def getBitbucketProject() {

    projectRepository = gitRepo
    projectRepository = projectRepository.toString().replace("ssh://git@code.experian.local/", "").replace("ssh://git@code.br.experian.local/", "")
    projectRepository = projectRepository.toString().replace(".git", "")

    projectRepository = projectRepository.split("/")
    projectKey = projectRepository[0]

    return projectKey
}

/**
 * setBitbucketStatus
 * Método realiza o POST dos status do Jenkins no Bitbucket
 * @package DevOps
 * @author  André Arioli <andre.arioli@br.experian.com>
 * @param status FAILED | INPROGRESS | SUCCESSFUL
 **/
def setBitbucketStatus (def status) {
    def buildNumber = currentBuild.number
    def errorCode = piaasMainInfo.pipeline_code_error
    def data = ''
    def bitbucketRepository = ''
    def bitbucketProjectKey = ''
    def informationSummary = ''

    if ( status == "FAILED" ) {
        informationSummary = "[Error Code: $errorCode]"
    } else {
        informationSummary = "[Score: $score]"
    }

    echo "Invoking function setBitbucketStatus"

    bitbucketRepository = getBitbucketRepository()
    bitbucketProjectKey = getBitbucketProject()

    data = """{
     "description":"CICD Process",
     "name":"$bitbucketRepository-$buildNumber $informationSummary",
     "state":"$status",
     "key":"$buildNumber",
     "url":"$urlBaseJenkins/$buildNumber"
     }"""

    bitbucketURI = "https://code.experian.local/rest/api/1.0/projects/$bitbucketProjectKey/repos/$bitbucketRepository/commits/$gitCommit/builds"
    successMessage = "Bitbucket status ${status} to ${bitbucketRepository} application!"
    failMessage = "Bitbucket status! Ignoring."

    withCredentials([usernamePassword(credentialsId: 'BitbucketGlobal.DevSecOps', passwordVariable: 'pass', usernameVariable: 'user')]) {
        utilsRestLib.httpPost(bitbucketURI, user, pass, 204, data, successMessage, failMessage)
    }

}

return this