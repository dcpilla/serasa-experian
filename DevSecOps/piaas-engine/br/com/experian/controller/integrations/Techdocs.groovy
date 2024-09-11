/**
 * techdocs
 * Método para geracao de techdocs
 * @version 8.15.0
 * @package DevOps
 * @author  Thiago José de Campos <Thiago.Campos@br.experian.com>
 * @return  true | false
 **/
def techdocs() {
    echo "Start stage : [TECHDOCS]"

    try {
        
        def checkIfImageExists = sh(script: "docker images | grep techdocs | wc -l", returnStdout: true)

        if (checkIfImageExists.toInteger() == 0 || checkIfImageExists == null) {
            echo "pull devhub-techdocs image"
            devhubECRSecret = sh(script: "cyberArkDap -s USCLD_PAWS_562223391796 -c BUUserForDevSecOpsPiaaS -a 562223391796", returnStdout: true)

            jsonECRSecret = utilsJsonLib.jsonParse(devhubECRSecret)
            
            env.AWS_ACCESS_KEY_ID = jsonECRSecret.accessKey
            env.AWS_SECRET_ACCESS_KEY = jsonECRSecret.accessSecret
            env.AWS_DEFAULT_REGION = "sa-east-1"

            sh(script: "aws ecr get-login-password | docker login --username AWS --password-stdin 562223391796.dkr.ecr.sa-east-1.amazonaws.com; \
                        docker pull 562223391796.dkr.ecr.sa-east-1.amazonaws.com/devhub-techdocs:latest; \
                        docker tag 562223391796.dkr.ecr.sa-east-1.amazonaws.com/devhub-techdocs:latest devhub-techdocs:latest; \
                        docker rmi 562223391796.dkr.ecr.sa-east-1.amazonaws.com/devhub-techdocs:latest", returnStdout: true)
        } else {
            println("Image devhub-techdocs already exists.")
        }

        devhubS3Secret = sh(script: "cyberArkDap -s USCLD_PAWS_562223391796 -c BUUserForDevSecOpsPiaaS -a 562223391796", returnStdout: true)
        
        if (devhubS3Secret == null || devhubS3Secret.contains("error")) {
            echo "Failed retrieving techdocs credentials, skipping..."
            return
        }

        splitDevhubS3Secret = utilsJsonLib.jsonParse(devhubS3Secret)

        sh(script: "set +x; docker run --rm \
                        -v ${WORKSPACE}/${currentBuild.number}:/app -e AWS_ACCESS_KEY_ID=\"${splitDevhubS3Secret.accessKey}\" \
                        -e AWS_SECRET_ACCESS_KEY=\"${splitDevhubS3Secret.accessSecret}\" devhub-techdocs --env ${environmentName} \
                        --gearr ${piaasMainInfo.gearr_id} --name ${applicationName}", returnStdout: true)
    
    }
    catch (Exception e) {
        echo "Failed executing techdocs stage, skipping this step..."
        println("CATCH message: ${e.message}")
        e.printStackTrace()
    }
}

return this