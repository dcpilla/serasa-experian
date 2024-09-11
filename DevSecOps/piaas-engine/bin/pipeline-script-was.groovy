#!/usr/bin/env groovy

/**
*
* Este arquivo é parte do projeto DevOps Serasa Experian 

* @package        Snow
* @name           pipeline-script-was.groovy
* @version        1.1.2
* @description    Script que controla a abertura do change order ServiceNow
* @copyright      2017 &copy Serasa Experian

* @package        DevOps
* @name           pipeline-script-was.groovy
* @version        3.3.0
* @description    Script que controla os stages do fluxo CI
* @copyright      2017 &copy Serasa Experian
* 
* @version        3.3.0
* @change         Migração de service desk para compatibilidade com service now                                                                                   *                 Essa alteração é para usar a nova forma de rollout que foi modificado no artefato experian_client_sdm
* @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
* @date           04-Set-2018
*
* @version        3.2.0
* @change         Altereção na função chanche order para aplicações com jobs do ra específicos e was_deploy                                                                                     *                 Essa alteração é para usar a nova forma de rollout que foi modificado no artefato experian_client_sdm
*		  Com isso pipelines que estiver realizando deploy com was_deploy, na OM vai ter as informações necessárias no Rollout/Rollback
* @author         João Aloia. <Joao.Aloia@br.experian.com>
* @date           21-Mai-2018
*
* @version        3.1.0
* @change         Implementação de processo blue&green
* @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
* @dependencies   searchEmail.sh 
*                 deploy.sh
* @date           15-Mar-2017
*
* @version        3.0.0
* @change         Migração de modo de deploy no RA via api , eliminando plugin e melhorando o processo
* @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
* @dependencies   searchEmail.sh 
*                 deploy.sh
* @date           24-Jan-2017
*
* @version        2.1.0
* @change         Implementação do stage de Deploy Menu Produtos -> Stage que implementa o menu de produtos para ambientes provisionados
* @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
* @dependencies   searchEmail.sh 
*                 provisionar.sh
* @date           14-Nov-2017
*
* @version        2.0.0
* @change         Implementação do stage de provisionamento para WAS
*                 Implementação/Melhoria do stage de deploy para realização de auto deploy
*                 Melhoria no e-mail de start pipeline contendo as configurações do mesmo para trace DEV
* @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
* @dependencies   searchEmail.sh 
*                 provisionar.sh
* @date           08-Ago-2017
*
* @version        1.1.0
* @change         Integração via email com os DEV 
* @author         Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @dependencies   searchEmail.sh 
* @date           01-Ago-2017
* 
* @version        1.0.0
* @description    Script que controla os stages do fluxo CI
* @author         Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @date           27-Jul-2017
*
**/  

import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL
import jenkins.util.*;
import jenkins.model.*;

/**
* Configurações Variaveis 
**/
def url_svn               = ""
def tipo                  = ""
def app_name_svn          = ""
def auto_deploy           = ""
def provisionamento       = ""
def deploy_blue_green     = ""
def deploy_menu_produtos  = ""
def target                = ""
def demanda               = ""
def endereco_provisionado = ""
def jdk_version           = ""
def maven_version         = ""
def svn_credencial        = ""
def maven_argumento       = ""
def maven_parametros      = ""
def path_pom              = ""
def path_pom_ear          = ""
def environmentDe         = ""
def environmentHi         = ""

def url_nexus             = ""
def repositorio           = ""
def repositorioSnapshot   = ""
def nome_pacote           = ""
def tipoPacote            = ""
    
def ra_job                = ""
def ra_nome_app           = ""
def ra_especifico         = ""
def ra_nome_projeto       = "Continuous_Integration"  //valor fixo

def path_app              = ""

def path_workspace        = ""
    
def veracode_sn           = "s"
def veracode_nome_app     = ""
def veracode_ext          = ""

    
def om_categoria          = ""
def om_ambiente           = ""
def om_rollout_complemento= ""
def om_config_items       = "nr:2E39DBBCB1EF314C9AC0461C824A65D0"  //java Config Items na om
def om_app_name			  = ""
def om_cluster_name       = ""
def loginAffected		  = ""

//pwd() retorna a workspace
def sonar_obrigatorio_sn  = "s"
def sonar_workspace       = pwd() + "/target/checkout/*/"  //valor recomendado
def sonar_versao          = "sonar2.6"

////Variáveis de uso
def versao                = ""
def contextRoot           = ""
def url_pacote            = ""
def msg_erro              = ""
def email_assunto         = ""
def email_msg             = ""

/**
* changeorder variables
* Define as variaveis utilizadas para changeorder
**/
flagChangeOrderCreated        = 0
changeorderNumber             = ''
changeorderJustification      = ''//*
changeorderTemplate           = 'Brazil UAT Jenkins COO Integration'//*
changeorderBusinessService    = ''//*
changeorderCategory           = ''//*
changeorderAssignmentGroup    = ''//*
changeorderAssignedTo         = ''//*
changeorderSummary            = ''
changeorderDescription        = ''
changeorderTestResult         = ''//* 
changeorderUEnvironment       = 'UAT'//*UAT 
changeorderUSysOutage         = ''//*no
changeorderRiskImpactAnalysis = ''
changeorderRollout            = ''
changeorderRollback           = ''
changeorderConfigItens        = ''
changeorderState              = ''
changeorderRequirements       = ''
changeorderClient             = '/opt/infratransac/core/br/com/experian/service/governance/snow.sh'

/**
* Inicializando variáveis
**/
this.sonar_obrigatorio_sn   = "s"
this.maven_argumento        = ""
this.maven_parametros       = ""
this.path_pom               = ""
this.path_pom_ear           = ""
this.om_ambiente            = "HI"
this.om_rollout_complemento = ""
this.om_config_items        = "nr:2E39DBBCB1EF314C9AC0461C824A65D0"
this.om_app_name            = ""
this.om_cluster_name        = ""
this.app_name_svn           = ""
this.auto_deploy            = "n"
this.provisionamento        = "n"
this.deploy_blue_green      = "n"
this.deploy_menu_produtos   = "n"
this.target                 = ""
this.endereco_provisionado  = ""
this.environmentDe          = "de"
this.environmentHi          = "hi"
this.jdk_version            = ""
this.maven_version          = ""
this.svn_credencial         = "9c7e2313-e0b9-4796-b79d-aa64daca65da"  //usuário de sistema utilizado para integração entre ferramentas
this.msg_erro               = ""
this.tipo_PipeLine          = "Aplicação"
this.repositorio            = ""
this.repositorioSnapshot    = ""
this.nome_pacote            = ""
this.tipoPacote             = "ear"
this.ra_especifico          = "n"
this.contextRoot            = ""
this.path_workspace         = pwd()
this.path_app               = "java -jar /opt/infratransac/core/bin/experian_client_sdm.jar"


/**
* pipeline
* Método faz o controle dos stage's de fluxo
* @version 2.0.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def pipeline() {
  	try {
  		this.tipo_PipeLine = "Aplica&ccedil;&atilde;o"
		envioEmail("inicio")
		stage 'Checkout'
			msg_erro = "de checkout"
			this.checkout()
		stage 'Build'
			msg_erro = "de build"
			this.build_snapshot()
		stage 'Package'
			if("${tipo}"=='release')
			{
				msg_erro = "na gera&ccedil;&atilde;o do pacote"
				this.build_release()
			}
		stage 'Sonar'
			msg_erro = "na gera&ccedil;&atilde;o do sonar"
			//chama o sonar para snapshot e para release
			if("${this.sonar_obrigatorio_sn}"=='s') {
				this.sonar()
			} else {
				//try catch - tira a obrigatoriedade de ter sucesso no teste de sonar
				try {
					this.sonar()
				} catch(err) {
			        echo "${err}"
				}
			}
		stage 'Deploy'
			if("${auto_deploy}"=='s')
			{
				msg_erro="no deploy do pacote pelo RA"
			    this.deployRA()
			}
        stage 'Deploy Menu Produtos'
		    msg_erro = "no deploy do menu de produtos"
		    if ( ("${this.provisionamento}"=='s') && ("${this.ra_especifico}"=='n') )
		    {
		    	if("${this.deploy_menu_produtos}"=='s') 
		    	    this.deployMenuProdutos()
		    }
		stage 'Veracode'
			if("${veracode_sn}"=='s')
			{
				msg_erro="na valida&ccedil;&atilde;o do veracode"
				if("${tipo}"=='release')
					this.veracode()
			}
		stage 'Deploy Blue & Green'
		    msg_erro = "no deploy de blue e green"
		    if ( ("${this.auto_deploy}"=='s') && ("${tipo}"=='release') && ("${this.ra_especifico}"=='n') )
		    {
		    	if("${this.deploy_blue_green}"=='s') 
		    	    this.deployBlueGreen()
		    }
		stage 'Change Order'
			if("${tipo}"=='release') 
			{
			    if ("${auto_deploy}"=='s') 
			    {
				    msg_erro="na cria&ccedil;&atilde;o do change order"
				    this.createChangeOrder()
			    }else{
				    echo "[Alerta] Abertura de change order nao permitida quando aplicacao nao tem deploy automatizado."
				}
			}
		envioEmail("fim")	
  	} catch(err) {
       	envioEmail("erro")
    	throw err
  	}
}

/**
* executeShell
* Método faz chamadas ao sistema operacional
* @version 2.0.0
* @package DevOps
* @author  joao paulo bastos <jpbl.bastos at gmail dot com>
* @param   command  - comando a ser executado
* @return  sout     - retorno do SO
**/
def executeShell(def command) {
	def sout = new StringBuffer(), serr = new StringBuffer()
	def proc = "${command}".execute()
	proc.consumeProcessOutput(sout, serr)
	proc.waitForOrKill(150000)
	return sout
}


/**
* checkout
* Método faz o checkout da branch para workspace do jenkins
* @version 1.0.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def checkout() {
	echo "[Info] Iniciando Pipeline - ${msg}"	
	
	checkout([$class: 'SubversionSCM',
		additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', 
		filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', 
		locations: [[credentialsId: "${svn_credencial}",
		depthOption: 'infinity', ignoreExternalsOption: true, local: '.', 
		remote: "${this.url_svn}"]], workspaceUpdater: [$class: 'CheckoutUpdater']])
		
		//opções do workspaceUpdater
		//CheckoutUpdater - WorkspaceUpdater that does a fresh check out.
		//UpdateUpdater - WorkspaceUpdater that uses "svn update" as much as possible.
		//UpdateWithCleanUpdater - WorkspaceUpdater that removes all the untracked files before "svn update"
		//UpdateWithRevertUpdater - WorkspaceUpdater that performs "svn revert" + "svn update"

	this.getPomVersion()
}

/**
* getPomVersion
* Método que faz a leitura do pom.xml principal da aplicação para pegar tag necessárias 
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def getPomVersion() {
	try {
		msg_erro = "que não foi possível encontrar o arquivo POM" 
		this.path_pom = pwd() + "/pom.xml"
		//verifica se contem o nome do app_name_svn
		if("${this.app_name_svn}" != "") {
			//incrementa a path do pom pai
			this.path_pom = pwd() + "/${this.app_name_svn}/pom.xml"
		}
		def project              = new XmlSlurper().parse(new File("${this.path_pom}"))
		this.versao              = project.version.toString().replace("-SNAPSHOT", "")
		this.repositorioSnapshot = this.repositorio.toString().replace("/substversao/", "")
        this.repositorio         = this.repositorio.toString().replace("substversao", this.versao.toString())
        this.nome_pacote         = this.nome_pacote.toString().replace("substversao", this.versao.toString())

		if("${this.tipo}"=='snapshot')
			currentBuild.displayName = "#" + currentBuild.getNumber() + " ${this.versao} snapshot"
        else
			currentBuild.displayName = "#" + currentBuild.getNumber() + " ${this.versao}"
	} catch(err) {
		echo "${this.app_name_svn}"
		echo "${err}"
		throw err
	}
}

/**
* build_snapshot
* Método que faz o build tipo snapshot
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def build_snapshot() {
	sh "mvn -f '${this.path_pom}' -s ${env.MAVENSETTINGS} -B ${this.maven_argumento} --batch-mode -V -U -e -Dsurefire.useFile=false clean deploy ${this.maven_parametros}"
}

/**
* build_release
* Método que faz o build tipo release
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def build_release() {		
	withCredentials([[$class: 'UsernamePasswordMultiBinding', 
		credentialsId: "${svn_credencial}", 
		passwordVariable: 'password', 
		usernameVariable: 'username']]) {
		sh "mvn -f '${this.path_pom}' -s ${env.MAVENSETTINGS} -B --batch-mode -V -U -e -Darguments='${this.maven_argumento}' -DreleaseVersion=${this.versao} -Dtag=${this.versao} -Dsurefire.useFile=false -Dresume=false release:prepare release:perform -Dusername=${env.username} -Dpassword=${env.password} ${this.maven_parametros}"
	}
}

/**
* sonar
* Método que faz o envio do pacote para analise de qualidade de código
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def sonar() {
	this.sonar_workspace = pwd()
	if("${this.app_name_svn}" != "")
		this.sonar_workspace = pwd() + "/${this.app_name_svn}"
	if("${tipo}"=='release')
	{
		this.sonar_workspace = pwd() + "/target/checkout"
		if("${this.app_name_svn}" != "")
			this.sonar_workspace = pwd() + "/${this.app_name_svn}/target/checkout/${this.app_name_svn}"
	}

	if("${this.sonar_versao}"=='sonar2.6') {
		withCredentials([[$class: 'UsernamePasswordMultiBinding', 
			credentialsId: "0997f8c5-504e-437b-89c4-ac1819868cee", 
			passwordVariable: 'password_sonar', 
			usernameVariable: 'username_sonar']]) {
				sh "mvn -f '${sonar_workspace}/pom.xml' -e -B ${this.maven_argumento} org.codehaus.mojo:sonar-maven-plugin:2.6:sonar -Dsonar.jdbc.driver=net.sourceforge.jtds.jdbc.Driver -Dsonar.jdbc.username=${env.username_sonar} -Dsonar.jdbc.password='${env.password_sonar}' -Dsonar.host.url=http://spobrsonar1-pi:9000/ -Dsonar.jdbc.url='jdbc:jtds:sqlserver://Sede12;databaseName=Sonar;SelectMethod=Cursor;create=true'"
		}
	}
}

/**
* deployRA
* Método que faz o deploy da aplicação usando o RA
* @version 3.1.0
* @package DevOps
* @author  João Paulo Bastos <Joao.Leite2 at br.experian.com>
* @return  true | false
**/
def deployRA() {
    if ( ("${tipo}"=='snapshot') && (this.ra_especifico=='n') ) {
    	if (this.tipoPacote == "ear") {
    		echo "[Info] Tipo de deploy snapshot" 
    	    echo "[Info] Buscando snapshot ${this.tipoPacote} em ${this.repositorioSnapshot} build ${this.versao}"            
        	this.url_pacote= "http://spobrnxs01-pi:8081/nexus/service/local/artifact/maven/redirect?r=snapshots&g=br.com.experian&a=" + this.repositorioSnapshot.toString() + "&v=" + this.versao.toString() + "-SNAPSHOT&e=" + this.tipoPacote.toString()
        	echo "[Info] Url de snapshot ${this.url_pacote}"
            this.url_pacote=executeShell("/opt/infratransac/core/bin/getUrlNexus.sh ${this.url_pacote}")
            this.url_pacote=this.url_pacote.replaceAll(" ","").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
	        echo "[Info] Atualizando aplicação no ambiente de ${environmentDe} aplicando pacote ${this.url_pacote}"
	        sh "/opt/infratransac/core/bin/deploy.sh --target='${this.target}' --method=normal --ra-job=was_deploy --url-package='${this.url_pacote}' --environment='${environmentDe}'"
        } 
	} else if ( ("${tipo}"=='snapshot') && (this.ra_especifico=='s') ) {
		echo "[Info] Aplicacao usa um job de RA especifico ${this.ra_nome_app}"
	    echo "[Info] Nada a fazer para deploy tipo SNAPSHOT quando se tem job especifico"
	} else if ("${tipo}"=='release') {
		this.url_pacote = this.url_nexus.toString() + this.repositorio.toString() + this.nome_pacote.toString()
        if ( ( this.provisionamento == "s" ) && (this.ra_especifico=='n') ) {
        	echo "[Info] Deploy em HI provisionado ativado"
        	echo "[Info] Realizando o deploy em  ${this.target} no ambiente ${environmentHi} em uma JVM provisionada."
	        sh "/opt/infratransac/core/bin/deploy.sh --target='${this.target}' --url-package='${this.url_pacote}' --environment='${environmentHi}' --method=provisioning --instance-name='${login}'_'${demanda}'"
	    } else if ( ( this.provisionamento == "n" ) || ( this.provisionamento == "" ) ) {
	    	echo "[Info] Deploy em DE sem provisionamento"
	    	if ( (this.tipoPacote == "ear") && (this.ra_especifico=='n') ){
	    		echo "[Info] Executando deploy via api"
	            sh "/opt/infratransac/core/bin/deploy.sh --target='${this.target}' --method=normal --ra-job=was_deploy --url-package='${this.url_pacote}' --environment='${environmentDe}'"
	        } else {
	            echo "[Info] Executando deploy via plugin"
	            echo "[Info] Aplicacao usa um job de RA especifico ${this.ra_nome_app}"
	        	echo "[Info] Executando deploy sem enriquecimento"
	            build job: "${this.ra_job}",  
		            parameters: 
			            [[$class: 'StringParameterValue', name: 'url_pacote', value: "${this.url_pacote}"], 
			            [$class: 'StringParameterValue', name: 'nome_pacote', value: "${this.nome_pacote}"], 
			            [$class: 'StringParameterValue', name: 'versao', value: "${this.versao}"], 
			            [$class: 'StringParameterValue', name: 'nome_app_ra', value: "${this.ra_nome_app}"]]
	        }    
	    }
    }
}

/**
* deployMenuProdutos
* Método que faz o deploy da aplicação do menu de produtos
* @version 2.1.0
* @package DevOps
* @author  joao paulo bastos <jpbl.bastos at gmail dot com>
* @return  true | false
**/
def deployMenuProdutos() {
	if("${tipo}"=='release') {
		echo "[Info] Realizando o deploy do menu de produtos small em  ${this.target} no ambiente ${environmentHi} em uma JVM provisionada."
	    sh "/opt/infratransac/core/bin/deploy.sh --target='${this.target}' --url-package=http://spobrnxs01-pi:8081/nexus/service/local/repositories/ReleasesManuais/content/DEVOPSCORE/experian-auth-ear/1.0.0.0/experian-auth-ear-1.0.0.0.ear --environment='${environmentHi}' --method=provisioning --instance-name='${login}'_'${demanda}'"		
	}    
}

/**
* deployBlueGreen
* Método que faz o plano de deploy da aplicação modo blue e green
* @version 3.1.0
* @package DevOps
* @author  joao paulo bastos <jpbl.bastos at gmail dot com>
* @return  true | false
**/
def deployBlueGreen() {
    echo "[Info] Realizando criação de planos de deploy para Blue & Green."
	sh "/opt/infratransac/core/bin/deploy.sh --target='${this.target}' --url-package='${this.url_pacote}' --method=bluegreen"		   
}

/**
* veracode
* Método que envia a aplicação para veracode analise de vulnerabilidades 
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @return  true | false
**/
def veracode() {
	if("${tipo}"=='release') {
		withCredentials([[$class: 'UsernamePasswordMultiBinding', 
			credentialsId: "f1330f81-5edd-4021-8422-06cdbd99bd46", 
			passwordVariable: 'password_veracode', 
			usernameVariable: 'username_veracode']]) {
				step([$class: 'VeracodePipelineRecorder', 
					applicationName: "${this.veracode_nome_app}", canFailJob: true, 
					criticality: 'VeryHigh', fileNamePattern: '', useProxy: true, 
					pHost: 'spobrproxy.serasa.intranet', pPassword: '', pPort: 3128, pUser: '', 
					replacementPattern: '', sandboxName: '', scanExcludesPattern: '', 
					scanIncludesPattern: '', scanName: "${this.nome_pacote}", uploadExcludesPattern: '', 
					uploadIncludesPattern: "${this.veracode_ext}", vid: '', vkey: '', 
					vpassword: "${env.password_veracode}", vuser: "${env.username_veracode}"])
			}
	}
}

/**
* OM
* Método que preenche as informações na OM 
* @version 1.0.0
* @package DevOps
* @author  João Aloia <Joao.Aloia@br.experian.com>
* @return  true | false
**/


/**
* createChangeOrder
* Método que abre OM no SDM
* @version 3.3.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @author  João Aloia <Joao.Aloia@br.experian.com>
* @author  João Leite <Joao.Leite2@br.experian.com>
* @return  true | false
**/
def createChangeOrder() {
	if  (this.ra_especifico=='s')  {
		def relatorioVeracode = "N/A"
		def demanda = this.url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1"); //retorna nome da demanda
		def loginRequester = this.login;
        def loginAffected  = this.login;

    	if("${veracode_sn}"=='s'){
	    	relatorioVeracode = "${this.veracode_nome_app}"
	    }

		def summary = "[Criacao Automatica] ${demanda} ${nome_pacote}   ${loginRequester}";

		def description = "Ordem de mudanca criada automaticamente{/n}" + 
						 "Demanda: ${demanda}{/n}" + 
						 "Pacote: ${nome_pacote}{/n}" +
						 "Veracode: ${relatorioVeracode}";
		description     = description.toString().replace("{/n}", "\\n").replace("\n", "\\n")

		def rollout = "::: OPERACAO TI :::{/n}" + 
					 "Realizar o deploy com Release Automation{/n}" +
					 "{/n}" + 
					 "Nome da Aplicacao: ${ra_nome_app}{/n}" + 
					 "Projeto: ${ra_nome_projeto}{/n}" + 
					 "Nome do Deploy: ${nome_pacote}{/n}" + 
					 "Ambiente: ${om_ambiente}";
		rollout = rollout.toString().replace("{/n}", "\\n").replace("\n", "\\n")			

		def rollback = "Voltar Versão";

		sh(script: "${changeorderClient}  --action=create-change \
                                          --state=-5 \
                                          --template='${changeorderTemplate}' \
                                          --business-service='${changeorderBusinessService}' \
                                          --category='${changeorderCategory}' \
                                          --cmdb-ci='${changeorderConfigItens}' \
                                          --justification='${changeorderJustification}' \
                                          --risk-impact-analysis='${changeorderRiskImpactAnalysis}' \
                                          --assignment-group='${changeorderAssignmentGroup}' \
                                          --assigned-to='${changeorderAssignedTo}' \
                                          --short-description='${summary}' \
                                          --description='${description}' \
                                          --backout-plan='${rollback}' \
                                          --implementation-plan='${rollout}' \
                                          --u-environment='${changeorderUEnvironment}' \
                                          --u-test-results='${changeorderTestResult}' \
                                          --u-sys-outage='${changeorderUSysOutage}' ", returnStdout: false)
	} else {
		def demanda = this.url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1"); //retorna nome da demanda	
    	def ra_nome_projeto = "Continuous_Integration";
     	def ra_nome_projeto_rollbaback = "Rollback";
     	def veracodeNome = "N/A"
        def raNomeApp = "was_deploy";
        def loginRequester = this.login;
        def loginAffected  = this.login;

	    this.om_app_name=executeShell("/opt/infratransac/core/bin/getRolloutRollback.sh appName ${this.url_pacote}")
	    this.om_app_name = this.om_app_name.replaceAll(" ","").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
		this.om_cluster_name=executeShell("/opt/infratransac/core/bin/getRolloutRollback.sh clusterName ${this.url_pacote}")
		this.om_cluster_name = this.om_cluster_name.replaceAll(" ","").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

		if("${veracode_sn}"=='s'){
			 veracodeNome = "${this.veracode_nome_app}"
		}


			def summary = "[Criacao Automatica] ${demanda} ${nome_pacote}   ${loginRequester}"; 


			def description = "Ordem de mudanca criada automaticamente{/n}" + 
							  "Demanda: ${demanda}{/n}" + 
							  "Pacote: ${nome_pacote}{/n}" +
							  "Veracode: ${veracodeNome}";
			description     = description.toString().replace("{/n}", "\\n").replace("\n", "\\n")				 

			def rollout = "::: OPERACAO TI :::{/n}" + 
					      "Realizar o deploy com Release Automation{/n}" +
					      "{/n}" + 
					      "Nome da Aplicacao: ${raNomeApp}{/n}" + 
					      "Projeto: ${ra_nome_projeto}{/n}" + 
					      "Nome do Deploy: ${nome_pacote}{/n}" + 
					      "Ambiente: ${om_ambiente}";
		    rollout = rollout.toString().replace("{/n}", "\\n").replace("\n", "\\n")			

			def rollback = "::: OPERACAO TI :::{/n}" + 
						  "Realizar o Rollback com Release Automation{/n}" +
						  "Nome da Aplicacao: ${raNomeApp}{/n}" +
						  "Projeto: ${ra_nome_projeto_rollbaback}{/n}" + 
						  "Nome do app no Websphere: ${om_app_name}{/n}" + 
						  "Nome do cluster: ${om_cluster_name}{/n}" + 
						  "Ambiente: ${om_ambiente}";
			rollback    = rollback.toString().replace("{/n}", "\\n").replace("\n", "\\n")	
	
			sh(script: "${changeorderClient}  --action=create-change \
	                                          --state=-5 \
	                                          --template='${changeorderTemplate}' \
	                                          --business-service='${changeorderBusinessService}' \
	                                          --category='${changeorderCategory}' \
	                                          --cmdb-ci='${changeorderConfigItens}' \
	                                          --justification='${changeorderJustification}' \
	                                          --risk-impact-analysis='${changeorderRiskImpactAnalysis}' \
	                                          --assignment-group='${changeorderAssignmentGroup}' \
	                                          --assigned-to='${changeorderAssignedTo}' \
	                                          --short-description='${summary}' \
	                                          --description='${description}' \
	                                          --backout-plan='${rollback}' \
	                                          --implementation-plan='${rollout}' \
	                                          --u-environment='${changeorderUEnvironment}' \
	                                          --u-test-results='${changeorderTestResult}' \
	                                          --u-sys-outage='${changeorderUSysOutage}' ", returnStdout: false)
	}

}


/**
* envioEmail
* Método que faz o envio de email para interações
* @version 1.1.0
* @package DevOps
* @author  Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @param   tipomsg
* @return  true | false
**/
def envioEmail(def tipomsg) {
	mensagem("${tipomsg}")
	def emailDest=executeShell("/opt/infratransac/core/bin/searchEmail.sh ${login}")
	def emailOrig="srebrazilteam@br.experian.com"
	mail from: "${emailOrig}", 
		to: "${emailDest}",
		subject: "${email_assunto}",
		body: "${email_msg}",
		charset: 'UTF-8', mimeType: 'text/html'
}

/**
* mensagem
* Método que monta a mensagem do email
* @version 2.0.0
* @package DevOps
* @author  joao paulo bastos <jpbl.bastos at gmail dot com>
* @param   tipomsg
* @return  true | false
**/
def mensagem(def tipomsg) {
    switch ("${tipomsg}") {
    	case "inicio": 
    		this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
    		this.email_msg = "<p>Analista ${login}</p>" +
    			"<p>Pipeline de <b>${tipo}</b> iniciado conforme commit da revision ${revision}<br />" +
				"<b>Dica:</b>&nbsp;Para gera&ccedil;&atilde;o da vers&atilde;o de release, escreva <b>release</b> como primeira palavra no log do seu commit.</p>" +
				"<p><b>Configurações do Pipeline</b><br />" + 
				"Demanda                 : ${demanda}<br />" +
				"Tipo                    : ${this.tipo_PipeLine}<br />" +
				"Build                   : ${this.tipo}<br />" + 
				"Versão do JDK           : ${this.jdk_version}<br />" +
				"Versão do Maven         : ${this.maven_version}<br />" +
				"Analise Sonar           : ${this.sonar_obrigatorio_sn}<br />" +
				"Analise VeraCode        : ${this.veracode_sn}<br />" +
				"Provisiona Ambiente Novo: ${this.provisionamento}<br />" +
				"Realiza Auto Deploy     : ${this.auto_deploy}</p>" ;
			break;
        case "fim": 
            this.url_pacote = this.url_nexus.toString() + this.repositorio.toString() + this.nome_pacote.toString()
        	this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
  			this.email_msg = "<p>Analista ${login}</p>" +
  				"<p>Pipeline de <b>${tipo}</b> foi finalizado com sucesso!</p>" +
  				"<p><b>Informações de Execução do Pipeline</b><br />" + 
  				"Demanda                 : ${demanda}<br />" +
				"Tipo                    : ${this.tipo_PipeLine}<br />" +
				"Build                   : ${this.tipo}<br />" + 
  				"Endereço da Aplicação   : ${this.endereco_provisionado}<br />" + 
  				"Url Nexus               : ${this.url_pacote}</p>";
			break;
        case "erro":
        	this.email_assunto = "[DevOps Alerta] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
        	this.email_msg = "<p>Analista ${login}</p>" +
        		"<p>Pipeline de <b>${tipo}</b> identificou um erro ${msg_erro}.</p>" +
        		"<p>Favor consultar nossa wiki para checar se este erro já possui uma solução mapeada.</p>" +
        		"<p>Wiki: https://bitbucketglobal.experian.local/projects/EDVP/repos/manifestos/browse/conhecimentos/jenkins</p>";
			break;
        default: 
        	this.email_assunto = "[DevOps Alerta] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
        	this.email_msg = "<p>Analista ${login}</p>" +
        		"<p>Pipeline de <b>${tipo}</b></p>";
			break;	
  	}
  	//adicionar o rodape padrão da mensagem de e-mail
  	this.email_msg = this.email_msg + 
  		"<p>Job: ${env.JOB_NAME} - Build: ${env.BUILD_NUMBER} - Tipo: ${tipo_PipeLine}<br />${url_svn}</p>" +
		"<p>Visualize o seu build atrav&eacute;s do link:<br /><a href='${env.BUILD_URL}console'>${env.BUILD_URL}console</a></p>" +
		"<a href='http://spobrccm02-pi:8080/job/${env.JOB_NAME}/'><img src='http://spobrccm02-pi:8080/job/${env.JOB_NAME}badge/icon'></a>"
}
return this
