/**
 * compilationDocker
 * Método faz chamadas as compilação docker
 * @version 8.29.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def compilationDocker(def compilationCmd) {
    echo "Invoking docker image build"

    validateNexusNpm = sh(script: "cat Dockerfile", returnStdout: true)

    if ( validateNexusNpm.toString().contains("spobrnexusregistry") )  {
        utilsMessageLib.errorMsg("O uso registry de cache NPM do spobrnexusregistry não é permitido. Prossiga utilizando o registry https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-central/")
        throw new Exception("O uso registry de cache NPM do spobrnexusregistry não é permitido.")
    }

    try {   

        def dockerfilePath = "${WORKSPACE}/${currentBuild.number}/Dockerfile"
        def dockerfileContent = readFile file: dockerfilePath
        def newLine = "\nENV DT_CUSTOM_PROP=\"PIAAS_GEARRID: ${piaasMainInfo.gearr_id}, PIAAS_GEARR_DEPENDENCIES: ${gearrDependencies}, PIAAS_CMDB_DEPENDENCIES: ${cmdbDependencies}, VERSION: ${piaasMainInfo.version_application}\""

        def modifiedContent = dockerfileContent.split('\n').collect { line ->
            if (line.contains("FROM")) {
                line + "\n" + newLine
            } else {
                line
            }
        }.join('\n')

        writeFile file: dockerfilePath, text: modifiedContent
              
        if (compilationCmd != null) {

            if (compilationCmd.toLowerCase().contains("--dir")) {
                echo "Building docker values default '${artifactId}:${versionApp}' with Docker extract condition"
                sh(script: "${packageBasePath}/controller/builds/docker.sh --application-name=${artifactId} --docker-tag=${versionApp} --environment=${gitBranch} ${compilationCmd}", returnStdout: false)
            } else {
                echo "Details docker build customized '${compilationCmd}'"
                withCredentials([string(credentialsId: 'sonar.token', variable: 'SONAR_TOKENINJECTED')]) {
                    compilationCmd = compilationCmd.replaceAll("SONAR_TOKEN=SONAR_TOKEN", "SONAR_TOKEN=${SONAR_TOKENINJECTED}")
                    sh(script: "${packageBasePath}/controller/builds/docker.sh --customized-build='${compilationCmd}'", returnStdout: false)
                }
            }
        } else {
            echo "Build docker values default '${artifactId}:${versionApp}'"
            sh(script: "${packageBasePath}/controller/builds/docker.sh --application-name=${artifactId} --docker-tag=${versionApp}", returnStdout: false)
        }

        utilsMessageLib.infoMsg("Your container has no vulnerabilities")
        piaasMainInfo.container_vulnerability = 'false'
        piaasMainInfo.container_vulnerability_analysis_performed = 'true'
    } catch (err) {
        if (err.toString().contains("code 99")) {
            piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_DOCKER_001'
            utilsMessageLib.warnMsg("Your container have vulnerability")
            piaasMainInfo.container_vulnerability = 'true'
            piaasMainInfo.container_vulnerability_analysis_performed = 'true'
            throw err
        } else if (err.toString().contains("code 148")) {
            piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_DOCKER_002'
            utilsMessageLib.warnMsg("Failed to scan your container")
            piaasMainInfo.container_vulnerability = '148'
            piaasMainInfo.container_vulnerability_analysis_performed = 'true'
        } else {
            piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_DOCKER_000'
            throw err           
        }
    }
}

/**
 * compilationDockerZ
 * Método faz chamadas as compilação docker no zlinux
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def compilationDockerZ(def compilationCmd) {
    urlPackageNexus = ''
    def args = utilsMapLib.parseArguments(compilationCmd)

    echo "compilationCmd: $compilationCmd, $args"
    echo "Invoking docker image build in zlinux"

    if (!(args.containsKey("url-package") || args.containsKey("workspace"))){
        echo "Create URL Nexus for deploy"
        def urlPackageArtifactId = args.containsKey('application-name')? args['application-name']: artifactId

        urlPackageNexus = "http://spobrnxs01-pi:8081/nexus/service/local/artifact/maven/redirect?r=${gitBranch == 'master'?'releases':'snapshots'}&g=${groupId}&a=${urlPackageArtifactId}&v=${versionApp.toString().replace('-RC', '-SNAPSHOT')}&e=${typePackage}"

        echo "The url redirect nexus ${urlPackageNexus}"
        urlPackageNexus = sh(script: "curl -I '${urlPackageNexus}' |grep Location|cut -d' ' -f 2", returnStdout: true)
        urlPackageNexus = urlPackageNexus.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        echo "The url nexus to deploy ${urlPackageNexus}"

        args['url-package'] = urlPackageNexus
        args['version'] = versionApp
    }

    withCredentials([usernamePassword(credentialsId: 'zlinux', passwordVariable: 'pass', usernameVariable: 'user')]) {
        if(args.containsKey("workspace")){
            
            if(!args.containsKey("version")){
                args['version'] = versionApp
            }

            def workspace = sh(script: "mktemp -u", returnStdout: true).trim()+".tar.gz"
            //Cria TGZ 
            sh(script: "tar -czf ${workspace} ${args['workspace']}")
            //Transfere via SCP
            sh(script: "sshpass -p '${pass}' scp ${workspace} ${user}@10.52.18.21:${workspace}")
            //Remove workspace temporario
            sh(script:"rm -f ${workspace}")

            args['workspace'] = workspace
        }

        def commandArguments = args.collect{ "--${it.key}=${it.value}" }.join(' ')

        sh(script: "sshpass -p '${pass}' ssh ${user}@10.52.18.21 ${packageBasePath}/controller/builds/dockerBuildZLinux.sh ${commandArguments}", returnStdout: false)
    }

    echo "Success docker image build in zlinux"

}

return this