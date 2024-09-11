def ansible(def cmdAnsible, def funcAnsible) {
    scriptExecOut = ''

    echo "ansible() ->Invoking execution ansible"
    echo "ansible() ->Details deploy '${cmdAnsible}'"
    
    if ( !cmdAnsible && !funcAnsible ) {
        utilsMessageLib.infoMsg("ansible() ->Nenhum parametro definido")
    } else {
        utilsMessageLib.infoMsg("ansible() ->Parametros: ${cmdAnsible} e ${funcAnsible}")
    }

    if ( funcAnsible == 'deploy' ) {
        cmdAnsible = controllerIntegrationsEnvs.setTemplateEngines(cmdAnsible)
    }

    scriptExecOut = sh(script: "${packageBasePath}/service/deploy/deployAnsible.sh --piaasEnv=${piaasEnv} ${cmdAnsible}", returnStdout: false)
    
}

return this