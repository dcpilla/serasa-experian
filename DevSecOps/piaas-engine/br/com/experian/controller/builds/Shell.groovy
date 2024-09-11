/**
 * script
 * Método faz chamadas a scripts ou comandos para execução
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def script(def cmdExec, def funcScript) {
    scriptExecOut = ''

    if ( (type == "lib") || (type == "test") || (type == "parent") ) {
        utilsMessageLib.warnMsg("It is not allowed to invoke a function script for libraries and test")
    } else {
        echo "Invoking command script"
        echo "Details command execution '${cmdExec}'"

        scriptExecOut = sh(script: "#!/bin/sh -e\n ${cmdExec}", returnStdout: false)
    }
}

/**
 * tar
 * Método que zipa arquivos para geração de pacotes quando não se tem compilação
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def tar(def cmdTar) {
    echo "Invoking tar for create package"
    echo "Details for tar '${cmdTar}' the application '${applicationName}' "

    if (cmdTar != null) {
        scriptExecOut = sh(script: "tar ${cmdTar}", returnStdout: false)
    } else {
        scriptExecOut = sh(script: "rm -rf /tmp/${applicationName}-${versionApp}.* && tar --exclude='.git' -zcvf /tmp/${applicationName}-${versionApp}.tar .", returnStdout: false)
    }

    packageArtifact = applicationName
}

/**
 * zip
 * Método que zipa arquivos para geração de pacotes quando não se tem compilação
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def zip(def cmdZip) {
    echo "Invoking zip for create package"
    echo "Details for zip '${cmdZip}' the application '${applicationName}' "

    if (cmdZip != null) {
        scriptExecOut = sh(script: "zip ${cmdZip}", returnStdout: false)
    } else {
        scriptExecOut = sh(script: "rm -rf /tmp/${applicationName}-${versionApp}.zip && zip -r /tmp/${applicationName}-${versionApp}.zip .", returnStdout: false)
    }

    packageArtifact = applicationName

}

return this