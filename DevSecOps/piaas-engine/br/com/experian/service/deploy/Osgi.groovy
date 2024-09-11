def osgi(def cmdOsgi) {
    scriptExecOut       = ''
    def osgiExtraVars   = ''
    
    if ( cmdOsgi != null ) {
        cmdOsgi.split().each {
            if (it.toLowerCase().contains("--extra-vars")) {
                osgiExtraVars = ''
                osgiExtraVars = cmdOsgi.replace("--extra-vars=", "")
            }
        }
    }
    
    utilsMessageLib.infoMsg("Invoking deploy OSGi...")
    utilsMessageLib.infoMsg("Details deploy '${osgiExtraVars}'")
    utilsMessageLib.infoMsg("Environment deploy '${environmentName}'")

    if (environmentName == "develop" || environmentName.contains("feature")) {
        withCredentials([usernamePassword(credentialsId: 'OSGI.Deployer.Dev', passwordVariable: 'pass', usernameVariable: 'user')]) {
            scriptExecOut = sh(script: "${packageBasePath}/service/deploy/osgi.sh 10.52.11.103:3491 SERATEST ${osgiExtraVars} \$(find . -name *.zip) ${user} ${pass}", returnStdout: false)
        }
    } else if (environmentName == "qa") {
        withCredentials([usernamePassword(credentialsId: 'OSGI.Deployer.Ext', passwordVariable: 'pass', usernameVariable: 'user')]) {
            scriptExecOut = sh(script: "${packageBasePath}/service/deploy/osgi.sh EXT SERATEST ${osgiExtraVars} \$(find . -name *.zip) ${user} ${pass}", returnStdout: false)
        }
    } else if (environmentName == "prod") {
        withCredentials([usernamePassword(credentialsId: 'OSGI.Deployer.Ext', passwordVariable: 'pass', usernameVariable: 'user')]) {
            scriptExecOut = sh(script: "${packageBasePath}/service/deploy/osgi.sh PROD SERATEST ${osgiExtraVars} \$(find . -name *.zip) ${user} ${pass}", returnStdout: false)
        }
    }
}

return this