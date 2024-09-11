#!/usr/bin/env groovy

/**
*
* Este arquivo é parte do projeto DevOps Serasa Experian 
*
* @package        DevOps
* @name           pipeline-script-banco.groovy
* @version        2.0.0
* @copyright      2017 &copy Serasa Experian
* @author         Alexandre Frankiw <alexandre.frankiw@br.experian.com>
* @date           08-Nov-2017
* @description    Script que controla os stages do fluxo para banco*   
* @change         Melhorias na criação da OM
* @author         Alexandre Frankiw <alexandre.frankiw@br.experian.com>
* @date           26-Abr-2018
*
**/  

import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL
import jenkins.util.*
import jenkins.model.*
import hudson.FilePath 
import hudson.model.AbstractProject
import hudson.tasks.Mailer
import hudson.model.User 



//variáveis de ambiente
def svn_credencial = ""
def url_svn = ""
def pctPath = ""
def pctName = ""
def pctUrl  = ""
def appNome = ""
def emailDestino = ""
def emailOrigem = ""
def pathDevOps = ""
def versao = ""
def mavenPath = ""
def nexusURL = ""
def nexusGroup = ""
def nexusRepository = ""
def msg_erro = ""
def email_assunto = ""
def email_msg = ""
def om_categoria = ""
def om_ambiente = ""
def om_config_items = ""
def tipomsg = ""
def ra_nome_app = ""
def ra_nome_projeto = ""
def des_ServerName = ""
def des_Database = ""
def hom_ServerName = ""
def hom_Database = ""
def prd_ServerName = ""
def prd_Database = ""
def tipo_build = ""
def tipo_banco = ""
def jobra = ""
def serverName_script = ""
def path_script = ""
//def arq_script = ""

/**
* changeorder variables
* Define as variaveis utilizadas para changeorder
**/
def changeorderSummary            = ""
def changeorderDescription        = ""
def changeorderRollout            = ""
def changeorderRollback           = ""
def logExecucaoMensagem 		  = ""
def urlMensagem					  = ""


//inicializando variáveis
this.svn_credencial = "9c7e2313-e0b9-4796-b79d-aa64daca65da"  //usuário de sistema utilizado para integração entre ferramentas
this.pctPath = pwd() + "\\release"
this.pathDevOps = "E:\\DevOps\\"//onde esta instalado os scripts
this.mavenPath = "E:\\Maven\\apache-maven-3.1.1\\bin\\" 
this.nexusURL = "http://spobrnxs01-pi:8081/nexus/content/repositories"
this.nexusGroup = "banco"
this.nexusRepository = "releases"  //releases ou snapshots 

//OM NORMAL HNORM78
//OM UNIFICADA OMUNH
this.om_categoria ="OMUNH"; 
this.ra_nome_projeto="Continuous_Integration" //valor fixo utilizada no ra
this.om_ambiente = "Para o ambiente de homologacao usar o ambiente 'HI' para Producao usar 'PI'" 
this.om_rollout_complemento = ""
this.om_config_items = ""
this.tipo_banco = ""
this.jobra = ""

this.serverName_script = "SPOBRCCM04-PI"
this.path_script = "E:\\DevOps\\BlackList\\"
this.arq_blackList = "BlackListScript.csv"



def pipeline(){
	try {

		this.msg_erro = ""
		envioEmail("inicio")

		stage 'Checkout'
			msg_erro = "de checkout";	
			this.checkout()

		stage 'Validar'
			msg_erro = "de valida&ccedil;&atilde;o";
			this.validar()

		stage 'Package'
			msg_erro = "na gera&ccedil;&atilde;o do pacote";
			this.pacote()

		stage 'Deploy'
			msg_erro="no deploy do pacote pelo RA";
			this.deploy()

		stage 'Chage Order'
			if (tipo_build=="release") {
				msg_erro="na cria&ccedil;&atilde;o do change order"
				//this.createChangeOrder()
				this.om()
			} else {
				println "Versão SNAPSHOT não é criada OM"
			}				
		envioEmail("fim")	
	} catch(err) {
		envioEmail("erro")
		throw err;		
	}
}



//********************************************************************************************************************** STAGE - INICIO
def envioEmail(def tipomsg) {
	mensagem("${tipomsg}")
	def emailDest=getMailUser("${login}")
	def emailOrig="srebrazilteam@br.experian.com"

	println emailDest

	mail from: "${emailOrig}", 
		to: "${emailDest}",
		bcc: "alexandre.frankiw@br.experian.com",
		subject: "${email_assunto}",
		body: "${email_msg}",
		charset: 'UTF-8', mimeType: 'text/html'
}

def mensagem(def tipomsg) {
    switch ("${tipomsg}") {
        case "inicio": 
				this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
				this.email_msg = "<p>Analista ${login}</p>" + "<p>Pipeline de <b>${tipo_build}</b> iniciado conforme commit da revision ${revision}<br />" +
					"<b>Dica:</b>&nbsp;Para gera&ccedil;&atilde;o da vers&atilde;o de release, escreva <b>release</b> como primeira palavra no log do seu commit.</p>";
				break;
        case "fim": 
				this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
				this.email_msg = "<p>Analista ${login}</p>" + "<p>Pipeline de <b>${tipo_build}</b> finalizado com sucesso!</p>";
				break;
        case "erro":
				this.email_assunto = "[DevOps Atenção] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
				this.email_msg = "<p>Analista ${login}</p>" + "<p>Pipeline de <b>${tipo_build}</b> identificou uma inconsistencia ${msg_erro}.</p>";
				break;
        default: 
				this.email_assunto = "[DevOps Atenção] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
				this.email_msg = "<p>Analista ${login}</p>" + "<p>Pipeline de <b>${tipo_build}</b></p>";
				break;   
    }
	//adicionar o rodape padrão da mensagem de e-mail
	this.email_msg = this.email_msg + "<p>Job: ${env.JOB_NAME} - Build: ${env.BUILD_NUMBER}<br />" +
		"${url_svn}</p>" + "<p>Visualize o seu build atrav&eacute;s do link:<br /><a href='${env.BUILD_URL}console'>${env.BUILD_URL}console</a></p>" +
		"<a href='http://spobrccm02-pi:8080/job/${env.JOB_NAME}/'><img src='http://spobrccm02-pi:8080/job/${env.JOB_NAME}badge/icon'></a>"

	urlMensagem = "Visualize o seu build atraves do link:{/n} ${env.BUILD_URL}console"

}


//********************************************************************************************************************** STAGE - CHECKOUT
def checkout() {	
	//baixa script do SVN para o Jenkins
	echo "[Info] Iniciando Pipeline - Script de banco"
	checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', 
			excludedRegions: '', excludedRevprop: '', filterChangelog: false, 
			ignoreDirPropChanges: false, includedRegions: '', locations: [[credentialsId: "${svn_credencial}",
			depthOption: 'infinity', ignoreExternalsOption: true, local: '.', 
			remote: "${this.url_svn}"]], workspaceUpdater: [$class: 'CheckoutUpdater']])
			//opções do workspaceUpdater			
}



//********************************************************************************************************************** STAGE - VALIDAR
def validar(){
	//valida diretorios e script
	if (!identificarTipoBanco()) {
		//verifico se a url do svn é do tipo SQL ou Oracle
		println "[Atenção] Nao identificado o tipo do banco de dados - SQL-Server ou Oracle";
		msg_erro = " que nao foi identificado o tipo do banco de dados - SQL-Server ou Oracle";
		throw new Exception("");
	}

	//retorna hora minuto e segundo para ser utilizado como versão no pacote
	createNumeroVersao();
	
	//diretório da variavel pctPath que retorna o caminho do workspae dentro do jenkins
	//verica retorno da função validarDiretorio	
	if (!validarDiretorio(createFilePath(pctPath + "\\rollout"))){
		println "[Atenção] Nenhum Script encontrado no diretório de rollout";
		msg_erro = " que nenhum Script encontrado no diretório de rollout";
		throw new Exception("");		
 	} 
}




def identificarTipoBanco(){
	//Verifica atraves da string se a OM é Sql ou Oracel
	//println this.url_svn + " - STAGE VALIDAR"

	//nr:BCC02528E6F0784A9E8C828B9B51DC91 = .net
	//nr:11D6250193DED64F91D662D2ABC25228 = Ambiente BD Oracle
	//nr:73AB8A25F756124BA8547ED8F052832A = Ambiente BD MySQL
	//nr:4FCF3F1D1EF00244BF4DF6C575566006 = Ambiente BD SQL / GOS 

	if(this.url_svn.contains("/Desenvolvimento/SQLServer/"))
	{
		this.tipo_banco = "SQLServer";
		this.om_config_items = "nr:4FCF3F1D1EF00244BF4DF6C575566006" // Config Itens Aba 4 OM				
	} 
	else if(this.url_svn.contains("/Desenvolvimento/Oracle/"))
	{
		this.tipo_banco = "Oracle";
		this.om_config_items = "nr:11D6250193DED64F91D662D2ABC25228" // Config Itens Aba 4 OM			
	} 
	else if(this.url_svn.contains("/Desenvolvimento/MySql/"))
	{
		this.tipo_banco = "MySql";
		this.om_config_items = "nr:73AB8A25F756124BA8547ED8F052832A" // Config Itens Aba 4 OM				
	}
	else 
	{
		this.tipo_banco = "";
		this.ra_nome_app ="";
		this.jobra = ""; 
		return false;
	}

	this.ra_nome_app ="DataBaseSoftware" // nome do script do ra
	this.jobra = "Database-ra" // job que chama o script do ra no jenkins

	return true;
}


def createNumeroVersao() {
	//retorna hora minuto e segundo para ser utilizado como versão no pacote
	def today= new Date();
	this.versao = today.format('yy.MM.dd.hhmmss');
	currentBuild.displayName = "#" + currentBuild.getNumber() + " ${this.versao}";	

	this.appNome = "${env.JOB_NAME}";
	this.appNome = this.appNome.replace("-pipeline", "");
	this.pctName = this.appNome + "-" + this.versao + ".zip"; 
} 

@NonCPS
def validarDiretorio(rootDir) {

	//echo "FRANKIW 01 - " + rootDir;

	//verifica se existe os arquivos dentro dos diretórios
    for (subPath in rootDir.list()) {
    	if (subPath.getName().endsWith('.sql')){
        	return true;
        	break;
        } 
        else if (subPath.getName().endsWith('.SQL')){
        	return true;
        	break;
        }
    }
    return false;
} 



//********************************************************************************************************************** STAGE - PACKAGE
def pacote(){
	//compactar .zip e mover para nexus
	def fp = createFilePath(pctPath);

	//echo "FRANKIW 02 - " + pctPath;

	if(fp != null)
	{
		if(fp.exists()) { 
			println "[Info] Validando diretórios " + pctPath;	

			dir("${pctPath}") {
		
				//caminho de criação pacote
				bat this.pathDevOps + 'bin\\zip.exe -r ..\\' + this.pctName + ' * ';
				
				//comandos do maven	//VERFICAR *****
				bat mavenPath + "mvn deploy:deploy-file " +
				" -DgroupId=" + this.nexusGroup + 
				" -DartifactId=" + appNome +
				" -Dfile=..\\" + pctName +
				" -Dversion=" + this.versao +
				" -DrepositoryId=" + this.nexusRepository + 
				" -Durl=" + this.nexusURL + '/' + this.nexusRepository + 
				" -Dpackaging=zip"; 

	  		}
		}
	}
}

def createFilePath(pathArquivo) {
	//metodo para ler diretórios e arquivos
    if (env['NODE_NAME'] == null) {
        error "envvar NODE_NAME is not set, probably not inside an node {} or running an older version of Jenkins!";
    } else if (env['NODE_NAME'].equals("master")) {
        return new FilePath(pathArquivo);
    } else {
        return new FilePath(Jenkins.getInstance().getComputer(env['NODE_NAME']).getChannel(), pathArquivo);
    }
} 


//********************************************************************************************************************** STAGE - DEPLOY
def deploy(){
	//rodar RA criando deployment_plan passando como parametro url nexus
	this.pctUrl = this.nexusURL + "/" + this.nexusRepository + "/" + this.nexusGroup + "/" + this.appNome  + "/" + this.versao + "/" + this.pctName; 
	
	
	//chama job do ra passando os paramentros abaixo
	build job: "${this.jobra}",
	parameters: 
		[[$class: 'StringParameterValue', name: 'url_pacote', value: "${this.pctUrl}"], 
		[$class: 'StringParameterValue', name: 'nome_pacote', value: "${this.pctName}"], 
		[$class: 'StringParameterValue', name: 'versao', value: "${this.versao}"], 
		[$class: 'StringParameterValue', name: 'nome_app_ra', value: "${this.ra_nome_app}"],
		[$class: 'StringParameterValue', name: 'des_ServerName', value: "${this.des_ServerName}"],
		[$class: 'StringParameterValue', name: 'des_Database', value: "${this.des_Database}"],
		[$class: 'StringParameterValue', name: 'hom_ServerName', value: "${this.hom_ServerName}"],
		[$class: 'StringParameterValue', name: 'hom_Database', value: "${this.hom_Database}"],
		[$class: 'StringParameterValue', name: 'prd_ServerName', value: "${this.prd_ServerName}"],
		[$class: 'StringParameterValue', name: 'prd_Database', value: "${this.prd_Database}"],
		[$class: 'StringParameterValue', name: 'tipo_banco', value: "${tipo_banco}"]]		
}



//********************************************************************************************************************** STAGE - CHANGE ORDER

def om(){
		
	def demanda = this.url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1"); //retorna nome da demanda	
    def raNomeProjeto = "Continuous_Integration";
    def raNomeApp = this.ra_nome_app;
	def raNomePct = this.pctName;
	def omAmbiente = this.om_ambiente;
	def loginRequester = this.login.toString();
	

	changeorderSummary = "[Criacao Automatica] ${demanda} ${raNomePct}    ${loginRequester}";

	changeorderDescription = "Ordem de mudanca criada automaticamente{/n}" + 
						 	 "Demanda: ${demanda}{/n}" + 
						     "Pacote: ${raNomePct}{/n}";						 

	changeorderDescription = changeorderDescription.toString().replace("{/n}", "\\n").replace("\n", "\\n")

	changeorderRollout = "::: OPERACAO TI :::{/n}" + 
					     "Realizar o deploy com Release Automation{/n}" +
					     "{/n}" + 
					     "Tipo da Aplicacao: DatabaseSoftware{/n}" + 
					     "Tipo Banco: " + this.tipo_banco + "{/n}" +
					     "Projeto: ${raNomeProjeto}{/n}" + 
					     "Nome do Deploy: ${raNomePct}{/n}" + 
					     "Ambiente: ${omAmbiente}";

	changeorderRollout = changeorderRollout.toString().replace("{/n}", "\\n").replace("\n", "\\n")

	changeorderRollback = "::: OPERACAO TI :::{/n}" + 
						  "Realizar o Rollback com Release Automation{/n}" +
						  "{/n}" + 
						  "Tipo da Aplicacao: ${raNomeApp}{/n}" +
						  "Tipo Banco: " + this.tipo_banco + "{/n}" +
						  //"Nome do Deploy: ${raNomePct}{/n}" +
						  "{/n}" +
						  "::: HOMOLOGACAO :::{/n}" +
						  "Nome Servidor Homologacao: " + this.hom_ServerName + "{/n}" +
						  "Nome Banco Homologacao: " + this.hom_Database + "{/n}" +
						  //"{/n}" +
						  //"::: PRODUCAO :::{/n}" +
						  //"Nome Servidor Producao: " + this.prd_ServerName + "{/n}" +
						  //"Nome Banco Producao: " + this.prd_Database + "{/n}" +
						  //"{/n}" +					  
						  "URL NEXUS : {/n}" + this.pctUrl;

	changeorderRollback = changeorderRollback.toString().replace("{/n}", "\\n").replace("\n", "\\n")


	logExecucaoMensagem =  	"::: TESTE DE EXECUÇÃO SCRIPT DE DADOS :::{/n}" +
							"{/n}" +
							"Teste de execução em ambiente de Desenvolvimento com sucesso {/n}" +
							"Analista: ${login} {/n}" + 
							//"Nome Servidor Homologacao: " + this.hom_ServerName + "{/n}" +
						  	//"Nome Banco Homologacao: " + this.hom_Database + "{/n}" +
							"Pipeline de ${tipo_build} para ambiente de homologação realizado com sucesso! {/n}" +
							"{/n}" + this.urlMensagem;   

	logExecucaoMensagem = logExecucaoMensagem.toString().replace("{/n}", "\\n").replace("\n", "\\n")

			
	//build job: "Create.Change.Snow",
    build job: "Create.Change.Snow.Database",
			    	parameters: 
						[
							[$class: 'StringParameterValue', name: 'changeorderSummary', value: "${changeorderSummary}"],
						    [$class: 'StringParameterValue', name: 'changeorderDescription', value: "${changeorderDescription}"],
						    [$class: 'StringParameterValue', name: 'changeorderRollout', value: "${changeorderRollout}"],
						    [$class: 'StringParameterValue', name: 'changeorderRollback', value: "${changeorderRollback}"],
						    [$class: 'StringParameterValue', name: 'logExecucaoMensagem', value: "${logExecucaoMensagem}"]
						]
							
}



/*
def createChangeOrder(String summary, String description, String rollout, String rollback){
	//criar Ordem de Mudança de homologação
	if (om_categoria != "")
		{	
			 
			def demanda = this.url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1"); //retorna nome da demanda	
			def path_app = "java -jar " + this.pathDevOps + "\\bin\\experian_client_sdm.jar "; 
			def loginRequester = this.login.toString();
			def loginAffected = this.login.toString();
			
			String cmd = path_app.toString() + '"C2" "' + loginRequester.toString() + '" "' + loginAffected.toString() + '" "' + 
			om_categoria.toString() + '" "' + demanda.toString() + '" "' + summary.toString() + '" "' + 
			description.toString() + '" "' + this.url_svn.toString() + '" "' + rollout.toString() + '" "' + 
			rollback.toString() + '" "' + this.om_config_items.toString() + '"';

			bat cmd.toString();					

		}
}*/


def getUserBuild() {
        def item = hudson.model.Hudson.instance.getItem(env.JOB_NAME);
        def build = item.getLastBuild();
        def cause = build.getCause(hudson.model.Cause.UserIdCause.class);
        return cause.getUserId();
}

def getMailUser(login) {
        User u = User.get(login);
        //retorna os grupos do usuário
        //println u.getAuthorities();
        //retorna o nome dos usuários 
        //println u.getDisplayName();
        def umail = u.getProperty(Mailer.UserProperty.class);
        return umail.getAddress();
}

return this

