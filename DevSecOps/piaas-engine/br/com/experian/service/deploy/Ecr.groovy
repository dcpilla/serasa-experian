/**
 * cmdEcr
 * Método faz chamadas ao ecr
 * @version 1.0.0  
 * @package DevOps
 * @author  André Arioli <felipe.olivotto@br.experian.com>
 * @return  true | false
 **/
def ecr(def cmdEcr) {
    def scriptExecOut = ''
    echo "Invoking push image in ECR."

    if (!cmdEcr) {
        utilsMessageLib.infoMsg("ecr() ->Nenhum parametro definido")
    } else {
        utilsMessageLib.infoMsg("ecr() ->Parametros: ${cmdEcr}")
    }
    
    scriptExecOut = sh(script: "${packageBasePath}/service/deploy/ecr.sh --application-name=${artifactId} --version=${versionApp} ${cmdEcr}", returnStdout: false)

}

return this