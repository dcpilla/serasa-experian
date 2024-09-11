#!/usr/bin/env groovy

/**
*
* Este arquivo é parte do projeto DevOps Serasa Experian 
*
* @package        DevOps
* @name           pipeline-script-net.groovy
* @version        1.0.0
* @copyright      2017 &copy Serasa Experian
* @author         Andre Luiz Colavite <Andre.Colavite@br.experian.com>
* @date           06-Fev-2017
* @description    Script que controla os stages do fluxo CI
*
**/  

import groovy.json.JsonSlurperClassic
import java.util.Calendar;
import java.io.File;
import hudson.FilePath;
import jenkins.model.Jenkins
import hudson.model.User
import hudson.security.Permission
import hudson.EnvVars
import hudson.model.*
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL
import hudson.model.*
import java.lang.Thread
import static groovy.io.FileType.FILES
import hudson.FilePath;
import jenkins.model.Jenkins;
import groovy.io.FileType;
import hudson.tasks.MailAddressResolver;
import hudson.model.AbstractProject
import hudson.tasks.Mailer
import hudson.model.User

/////Variaveis de ambiente 
def url_svn = ""
def tipo = ""
def urls = ""

def pathDevOps = ""
def svnPath = ""
def mavenPath = ""

def svn_credencial = ""

def appSolution = ""
def appName = ""
def projName = ""

def ra_sn = "n"
def ra_job = ""
def ra_nome_app = ""
def ra_nome_projeto = "Continuous_Integration"  //valor fixo
   
def url_pacote = ""
def nome_pacote = ""
def versao = ""
	
def veracode_ext ='**/**.zip'

def om_rollout_complemento = ""
def om_config_items = ""

////Variáveis de uso
def msg_erro = ""
def email_assunto = ""
def email_msg = ""

def nuget = ""

def msBuildVersaoFixa = ""

List<String> listaBuild;
List<String> listaNexus;
List<String> listaApp;
List<String> listaVersao;
List<String> listaVeracode;
List<String> listaRA;
List<String> listaOM;

//inicializando variavel
this.svn_credencial = "9c7e2313-e0b9-4796-b79d-aa64daca65da"

this.pathDevOps = "E:\\DevOps\\"

this.msbuildVer = "3.5"

this.msbuildPath = "C:\\WINDOWS\\Microsoft.NET\\Framework\\v3.5\\"

this.svnPath = '"E:\\Program Files (x86)\\SlikSvn\\bin\\"'
//this.svnPath = '"C:\\Program Files (x86)\\SlikSvn\\bin\\"'

this.mavenPath = "E:\\Maven\\apache-maven-3.1.1\\bin\\"
//this.mavenPath = "C:\\apache-maven-3.1.1\\bin\\";

this.pctPath = pwd() + "\\pct\\"
this.pctPathDll = this.pctPath + "dll\\"
this.pctPathDeploy = this.pctPath + "dpl\\"
this.pctPathVeracode = this.pctPath + "veracode\\"

this.nexusURL = "http://spobrnxs01-pi:8081/nexus/content/repositories"
this.nexusGroup = "br.com.serasaexperian"
this.nexusRepository = "releases"  //releases ou snapshots

this.projName = "";
this.veracode_ext ='**/**.zip';

this.ra_nome_projeto = "Continuous_Integration";  //valor fixo
this.om_rollout_complemento = ""
this.om_config_items = "nr:BCC02528E6F0784A9E8C828B9B51DC91"  //java ou net para c criação do Config Items na om

this.listaVeracode = null;
this.listaRA = null;
this.listaApp = null;
this.listaVersao = null;
this.listaOM = null;

this.nuget = ""
this.msBuildVersaoFixa = ""

def pipeline() {
  	try {
  		this.msg_erro = ""
		envioEmail("inicio")
		stage 'Checkout'
			msg_erro = "de checkout";
			this.checkout();			
		stage 'Validação'
			msg_erro = "de valida&ccedil;&atilde;o";
			this.configValida();
		stage 'Build'
			msg_erro = "de build";
			this.buildLista() 
		stage 'Package'
			msg_erro = "na gera&ccedil;&atilde;o do pacote";
			this.packageLista();
		stage 'Deploy'
			msg_erro="no deploy do pacote pelo RA";
			if("${tipo}" == 'release')
				this.deployLista();
		stage 'Veracode'
			msg_erro="na valida&ccedil;&atilde;o do veracode";
			if("${tipo}" == 'release')
				this.veracode();
		stage 'Change Order'
			msg_erro="na cria&ccedil;&atilde;o do change order"
			if("${tipo}" == 'release')
				this.changeOrderLista();
		envioEmail("fim")	
  	} catch(err) {
       	envioEmail("erro")
    	throw err;
  	}
}

def checkout() {
	println "[Info] Iniciando Pipeline - ${msg}";
	checkout([$class: 'SubversionSCM',
		additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', 
		filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '', 
		locations: [[credentialsId: "${this.svn_credencial}",
		depthOption: 'infinity', ignoreExternalsOption: true, local: '.', 
		remote: "${this.url_svn}"]], workspaceUpdater: [$class: 'CheckoutUpdater']]);
			
	/*opções do workspaceUpdater
	CheckoutUpdater - WorkspaceUpdater that does a fresh check out.
	UpdateUpdater - WorkspaceUpdater that uses "svn update" as much as possible.
	UpdateWithCleanUpdater - WorkspaceUpdater that removes all the untracked files before "svn update"
	UpdateWithRevertUpdater - WorkspaceUpdater that performs "svn revert" + "svn update"
	*/
}

def configValida() {
 	this.projPathName = "";

 	getListaDiretoriosCommit();

 	if (this.listaBuild.size == 0)
 	{
 		println "[Atenção] Nenhum projeto encontrado para build";
 		println "Verifique se os diretórios de controle são:" + System.getProperty("line.separator") +
 			"/aplicacoes web/" + System.getProperty("line.separator") +
 			"/programas/" + System.getProperty("line.separator") + 
 			"/servicos/";
 		msg_erro = " que nenhum projeto foi encontrado para build. <br />"  + 
 			"Verifique se os diretórios de controle são: <br />" + 
 			"/aplicacoes web/ <br />" + 
 			"/programas/ <br />" +
 			"/servicos/";
 		throw new Exception("");
 	}
 	
 	createNumeroVersao();

 	createListas();

 	println "[Info] " + listarInfoApp(System.getProperty("line.separator"));
}

def validarDiretorio(diretorio) {
	def dir = diretorio.toLowerCase();
	return (dir.contains("/aplicacoes web/") || 
 		dir.contains("/programas/") ||
 		dir.contains("/servicos/"));
}

def getListaDiretoriosCommit() {
 	println "url_svn " + url_svn;
 	println "urls " + urls;
	//urls = urls.replace("?\\195?\\167","ç").replace("?\\195?\\181","õ");
	//println "urls replace " + urls;
 	info = url_svn.split("Desenvolvimento/")[1];
 	println info;
 	//ler cada linha de commit verificando se é uma pasta de compilação
 	List<String> lista = urls.split("Desenvolvimento/");
 	this.listaBuild = new ArrayList<String>();
 	this.listaNexus = new ArrayList<String>();
	// 	this.listaPathBuild = new ArrayList<String>();
	def pathBuild = "";
 	for (int i=1; i<lista.length; i++)
 	{
 		println lista[i];
 		//verificar se é uma pasta para compilação e geração de pacote
 		if (validarDiretorio(lista[i]))
 		{
 			//retornar a path de build da pasta de commit
 			pathBuild=getPathBuild(lista[i]);

 			println "projBuild " + pwd() + "/" + pathBuild;
 			//pesquisa o nome do csproj ou vbproj dentro da pasta de build
 			def projBuild = getArquivoProjeto(createFilePath(pwd() + "/" + pathBuild));
 			if (projBuild != null) {
 				println "projBuild: " + projBuild;
 				if (!listaBuild.toString().contains(pathBuild + projBuild)) {
 					//adicionar a path na lista de aplicações para build.					
 					this.listaBuild.add(pathBuild + projBuild);
 					this.listaNexus.add("s");
 				}
 			} else {
 				println "Não encontrado o arquivo de projeto desta aplicação.";
 			}
 		}
 	}
}

def getPathBuild(path) {
	//limpa o início do texto da pasta
	path = path.replace(info, "");
	println "Item: " + path;

	//le as informações da string de diretório até chegar no nome da pasta da aplicação
	//excluindo as informações após o nome da aplicação
	caminho=""
	List<String> listaparts = path.split("/");
	for (int y=1; y<listaparts.length; y++)
	{
		caminho=caminho+listaparts[y]+"/";
		if (validarDiretorio("/" + listaparts[y].toLowerCase() + "/"))
		{
			//verifica se já chegou ao final ou se ainda tem valor para montar
			if (listaparts.length == y+1)
				caminho = "";
			else
				caminho=caminho+listaparts[y+1]+"/";
			break;
		}
	}
	println "Caminho: " + caminho;
	return caminho;
}

@NonCPS
def getArquivoProjeto(rootDir) {
    for (subPath in rootDir.list()) {
    	if (subPath.getName().endsWith('.vbproj') || subPath.getName().endsWith('.csproj'))
        	return "${subPath.getName()}";
    }
}

def createNumeroVersao() {
	this.today= new Date();
	if("${this.tipo}"=='release') {
		this.versao = today.format('yy.MM.dd.hhmmss');
		currentBuild.displayName = "#" + currentBuild.getNumber() + " ${this.versao}";
		this.nexusRepository = "releases";
	} else {
		this.versao = today.format('yy.MM.dd') + "-SNAPSHOT";
		currentBuild.displayName = "#" + currentBuild.getNumber() + " ${this.versao}";
		this.nexusRepository = "snapshots";
	}	
}

def createListas() {
 	this.listaVeracode = new ArrayList<String>();
  	this.listaRA = new ArrayList<String>();
 	this.listaApp = new ArrayList<String>();
 	this.listaVersao = new ArrayList<String>();
 	this.listaOM = new ArrayList<String>();

 	//ler as configurações das aplicações de build
 	//configurar Veracode e RA para as apps de commit
 	def total = this.listaBuild.size;
 	for (int i=0; i < total; i++) {
 		println "item build: " + listaBuild[i];
 		findXmlConfig(listaBuild[i]);
 	}

 	//procurar no xml todas as aplicações configuradas para o mesmo veracode
 	//adiciona à lista de build
 	total = this.listaBuild.size;
 	for (int i=0; i < total; i++) {
 		//verificar se a aplicação tem veracode mapeado
 		if (this.listaVeracode[i] != "") {
 			readXMLConfigVeracode(this.listaVeracode[i]);
 		}
 	}

 	//ler o arquivo de csproj ou vbproj para buscar o appName e msBuildVer
 	for (String item : this.listaBuild) {
 		readArquivoProjeto(item);
 	}
}

def findXmlConfig(aplicacaoBuild) {
 	//Adiciona o dependente do veracode na lista de build, caso ainda não esteja
 	println "findXmlConfig: " + aplicacaoBuild;
 	def veracode = "";
 	def ra = "";
 	def om_ambiente = "";
 	def	om_categoria = "";

 	def nodeApp = readXMLConfigAplicacao(aplicacaoBuild);
 	if (nodeApp != null) {
 		veracode = nodeApp.veracode.toString();
 		ra = nodeApp.ra.toString();
 		om_ambiente = nodeApp.om_ambiente.toString();
 		om_categoria = nodeApp.om_categoria.toString();
 	}
 	this.listaVeracode.add(veracode);
 	this.listaRA.add(ra);
 	this.listaOM.add(om_ambiente + ";" + om_categoria);
}

def readXMLConfigAplicacao(nomeAplicacao) {
	def node = null;
	try {
		def nomePipeline = "${env.JOB_NAME}";
		msg_erro = "que não foi possível ler o arquivo de configuracao" 
		def arquivoProjeto = this.pathDevOps + "config\\pipeline_net_config_apps.xml";
		echo "${arquivoProjeto}"
		def fpXml = createFilePath(arquivoProjeto);
		if(fpXml != null)
		{
			def xml = new XmlSlurper().parseText(fpXml.readToString());
			node = findXmlNodeIgual(xml.pipeline, nomePipeline);
			if (node != null)
				node = findXmlNodeContain(node.aplicacao, nomeAplicacao);
			else
				println "Não encontrada a configuração do ${nomePipeline} no xml."	
		}
	} catch(err) {
		echo "Não foi possível ler o xml de configuração da aplicação"
		echo "${err}"
		node = null;
	}
	return node;
}

def readXMLConfigVeracode(nomeVeracode) {
	//pesquisa todas as aplicações que estão configuradas para o mesmo omeVeracode da aplicação de commit
 	println "Pesquisa veracode " + nomeVeracode;
 	msg_erro = "que não foi possível ler o arquivo de configuracao";
 	def node = null;
 	try {
 		def nomePipeline = "${env.JOB_NAME}";
 		def arquivoProjeto = this.pathDevOps + "config\\pipeline_net_config_apps.xml";
 		def fpXml = createFilePath(arquivoProjeto);
 		if(fpXml != null)
 		{
 			def xml = new XmlSlurper().parseText(fpXml.readToString());
 			node = findXmlNodeIgual(xml.pipeline, nomePipeline);
 			for(int i=0;i<node.aplicacao.size();i++) {
 				if (node.aplicacao[i].veracode.toString().contains(nomeVeracode)) {
 					println "xml.aplicacao " + node.aplicacao[i].'@nome'.toString();
 					pathProjeto = getPathArquivo(node.aplicacao[i].'@nome'.toString()).replace(pwd()+"/","");
 					println pathProjeto;
 					if (pathProjeto != "") {
 						if (!listaBuild.toString().toLowerCase().contains(pathProjeto.toLowerCase())) {
 							this.listaBuild.add(pathProjeto);
 							this.listaVeracode.add(nomeVeracode);
 							this.listaRA.add("");
 							this.listaNexus.add("");
 							this.listaOM.add("");
 						}
 					}
 				}
 			}
 		}
 	} catch(err) {
 		echo "erro: ${err}"
 		throw err
 	}
}

def getPathArquivo(arquivo) {
	def dirApp = arquivo.replace(".csproj", "").replace(".vbproj", "");
	def path = "";
	def dirs = "aplicacoes web/aplica?\195?\167?\195?\181es web/servicos/servi?\195?\167o/programas";
	List<String> listaparts = dirs.split("/");
	def pathRetorno = "";
	for (int y=1; y<listaparts.length; y++) {
		path = pwd() + "/" + listaparts[y] + "/" + dirApp + "/" + arquivo;
		println  "getPathArquivo " + path;
		if (createFilePath(path).exists()) {
			pathRetorno = path;
			break;
		}
	}
	return pathRetorno;
}

//descontinuado em teste
def getPathArquivo2(arquivo) {
 	dirApp = arquivo.replace(".csproj", "").replace(".vbproj", "");
 	path = pwd() + "/aplicacoes web/" + dirApp + "/" + arquivo
  	if (createFilePath(path).exists())
 		return path;
 	else {
 		path = pwd() + "/servicos/" + dirApp + "/" + arquivo
  		if (createFilePath(path).exists())
 			return path;
 		else {
 			path = pwd() + "/programas/" + dirApp + "/" + arquivo
 			if (createFilePath(path).exists())
 				return path;

 		}
 	}
 	return "";
}

def findXmlNodeIgual(node, valor) {
	for(int i=0;i<node.size();i++) {
		if (node[i].'@nome'.toString().toLowerCase() == valor.toLowerCase()) {
			return node[i];
		}
	}
}

def findXmlNodeContain(node, valor) {
	for(int i=0;i<node.size();i++) {
		if (valor.toLowerCase().contains(node[i].'@nome'.toString().toLowerCase())) {
			return node[i];
		}
	}
}

def readArquivoProjeto(item) {
	try {
		msg_erro = "que não foi possível ler o arquivo .csproj ou .vbproj" 
		println "Arquivo projeto: " + item
		def fp = createFilePath(pwd() + "/" + item);
		this.appName = "";
		this.msbuildVer = "";
		if(fp != null)
		{
			def project = new XmlSlurper().parseText(fp.readToString().substring(1));
			this.appName = project.PropertyGroup[0].AssemblyName.toString();
			this.msbuildVer = project.@ToolsVersion.text();
			//this.msbuildVer = project.PropertyGroup[0].TargetFrameworkVersion.toString();			
		
			if (this.msBuildVersaoFixa != "")
				this.msbuildVer = this.msBuildVersaoFixa;

			println "Aplicacao: " + this.appName;
			println "ToolsVersion: " + this.msbuildVer;
		} 

		//criar lista para empacotamento
		listaApp.add(this.appName);
		listaVersao.add(this.msbuildVer);
	} catch(err) {
		echo "erro: ${err}"
		throw err
	}
}

def createFilePath(pathArquivo) {
    if (env['NODE_NAME'] == null) {
        error "envvar NODE_NAME is not set, probably not inside an node {} or running an older version of Jenkins!";
    } else if (env['NODE_NAME'].equals("master")) {
        return new FilePath(pathArquivo);
    } else {
        return new FilePath(Jenkins.getInstance().getComputer(env['NODE_NAME']).getChannel(), pathArquivo);
    }
}

def buildLista() {
 	//ler lista de aplicações para esteira
	if (this.listaBuild != null)
	 	for (int id = 0; id < this.listaBuild.size; id++)
 			buildItem(id);
}

def buildItem(id) {
	println "Building: " + this.listaBuild[id];
	def msbuildParam = "";

//MSBuild.exe PATH_TO_PROJ.csproj /p:DeployOnBuild=true /p:PublishProfile=PUBLISH_TARGET /p:Configuration=Release
//ToolsVersion 2.0	Caminho de instalação do Windows\Microsoft.Net\Framework\v2.0.50727\
//ToolsVersion 3.5	Caminho de instalação do Windows\Microsoft.NET\Framework\v3.5\
//ToolsVersion 4.0	Caminho de instalação do Windows\Microsoft.NET\Framework\v4.0.30319\
//ToolsVersion 15.0	Caminho de instalação do Visual Studio\MSBuild\15.0\bin

	msbuildParam = 	' /p:WebProjectOutputDir=' + this.pctPathDeploy + id + '\\PackageTmp\\' +
					' /p:DebugSymbols=false /p:DebugType=None ' +   //Não gerar os arquivos .PDB
					' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';

	if(this.listaVersao[id].substring(0,1) == '2') {
		this.msbuildPath = "C:\\Windows\\Microsoft.NET\\Framework\\v2.0.50727\\MSBuild.exe";
	} else if(this.listaVersao[id].substring(0,1) == '3') {
		this.msbuildPath = "C:\\WINDOWS\\Microsoft.NET\\Framework\\v3.5\\MSBuild.exe";
	} else if(this.listaVersao[id].substring(0,1) == '4') {
		this.msbuildPath = "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\MSBuild.exe";
	} else {
		this.msbuildPath = '"C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"';
		msbuildParam = 	' /p:PackageTempRootDir=' + this.pctPathDeploy + id + '\\' + 
						' /p:DebugSymbols=false /p:DebugType=None ' +   //Não gerar os arquivos .PDB
						' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	}

	if (this.listaBuild[id].split("/")[0].toLowerCase() == "programas") {
		msbuildParam = ' /p:OutDir=' + this.pctPathDeploy + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	}

	def linhaBuild = 'cmd.exe /C " ' + this.msbuildPath + 
		' /t:Clean /t:Build /p:Configuration=Release /p:DeployOnBuild=true ' +
		' /p:DeployTarget=PipelinePreDeployCopyAllFilesToOneFolder ';

	def linhaBuildVeracode = linhaBuild;

	linhaBuild = linhaBuild + msbuildParam;

	if (this.nuget != "") {
		bat "E:\\Jenkins\\nuget\\nuget restore " + this.nuget;
	}

	bat "${linhaBuild}"

	//verifica se vai gerar veracode para fazer o build como debug
	if (this.listaVeracode[id] != "") {
		if (this.listaBuild[id].split("/")[0].toLowerCase() == "programas") {
			linhaBuildVeracode = linhaBuildVeracode + ' /p:OutDir=' + this.pctPathVeracode + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
		} else {	
			linhaBuildVeracode = linhaBuildVeracode + ' /p:WebProjectOutputDir=' + this.pctPathVeracode + id + '\\' +
									  				  ' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
		}

		bat "${linhaBuildVeracode}"
	}
}


def buildItem_old(id) {
	println "Building: " + this.listaBuild[id];
	def msbuildParam = "";

//MSBuild.exe PATH_TO_PROJ.csproj /p:DeployOnBuild=true /p:PublishProfile=PUBLISH_TARGET /p:Configuration=Release
//ToolsVersion 2.0	Caminho de instalação do Windows\Microsoft.Net\Framework\v2.0.50727\
//ToolsVersion 3.5	Caminho de instalação do Windows\Microsoft.NET\Framework\v3.5\
//ToolsVersion 4.0	Caminho de instalação do Windows\Microsoft.NET\Framework\v4.0.30319\
//ToolsVersion 15.0	Caminho de instalação do Visual Studio\MSBuild\15.0\bin

	if(this.listaVersao[id].substring(0,2)=='v2') { //v2	
		this.msbuildPath = "C:\\WINDOWS\\Microsoft.NET\\Framework\\v3.5\\MSBuild.exe";
		msbuildParam = 	//' /p:WebProjectOutputDir=' + this.pctPathDeploy + this.listaApp[id] + '\\PackageTmp\\' +
						' /p:WebProjectOutputDir=' + this.pctPathDeploy + id + '\\PackageTmp\\' +
						' /p:DebugSymbols=false /p:DebugType=None ' +   //Não gerar os arquivos .PDB
						' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	} else if(this.listaVersao[id].substring(0,2)=='v3') { //v3.0
		this.msbuildPath = "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\MSBuild.exe";
		msbuildParam = 	//' /p:WebProjectOutputDir=' + this.pctPathDeploy + this.listaApp[id] + '\\PackageTmp\\' +
						' /p:WebProjectOutputDir=' + this.pctPathDeploy + id + '\\PackageTmp\\' +
						' /p:DebugSymbols=false /p:DebugType=None ' +   //Não gerar os arquivos .PDB
						' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	} else {
		this.msbuildPath = '"C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe"';
		msbuildParam = 	//' /p:PackageTempRootDir=' + this.pctPathDeploy + this.listaApp[id] + '\\' + 
						' /p:PackageTempRootDir=' + this.pctPathDeploy + id + '\\' + 
						' /p:DebugSymbols=false /p:DebugType=None ' +   //Não gerar os arquivos .PDB
						' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	}

	if (this.listaBuild[id].split("/")[0].toLowerCase() == "programas") {
		msbuildParam = ' /p:OutDir=' + this.pctPathDeploy + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
	}

	def linhaBuild = 'cmd.exe /C " ' + this.msbuildPath + 
		' /t:Clean /t:Build /p:Configuration=Release /p:DeployOnBuild=true ' +
		' /p:DeployTarget=PipelinePreDeployCopyAllFilesToOneFolder ';

	def linhaBuildVeracode = linhaBuild;

	linhaBuild = linhaBuild + msbuildParam;

	if (this.nuget != "") {
		bat "E:\\Jenkins\\nuget\\nuget restore " + this.nuget;
	}

	bat "${linhaBuild}"

	//verifica se vai gerar veracode para fazer o build como debug
	if (this.listaVeracode[id] != "") {
		if (this.listaBuild[id].split("/")[0].toLowerCase() == "programas") {
			linhaBuildVeracode = linhaBuildVeracode + ' /p:OutDir=' + this.pctPathVeracode + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
		} else {	
			linhaBuildVeracode = linhaBuildVeracode + ' /p:WebProjectOutputDir=' + this.pctPathVeracode + id + '\\' +
									  				  ' /p:OutDir=' + this.pctPathDll + id + '\\  /v:m "' + this.listaBuild[id] + '" "';
		}

		bat "${linhaBuildVeracode}"
	}
}

def packageLista() {
	//ler lista de aplicações para empacotamento .zip
	if (this.listaApp != null) {
		for (int id = 0; id < this.listaApp.size; id++)
		{
			packageItem(id);
			//if("${tipo}" == 'release')
			//	createTagSVN();
		}
	}	
}

def createTagSVN() {
	createNumeroVersao();
	def url_tag = url_svn.split("/branches/")[0] + "/tags/" + this.versao;
	//ajustar para o main caso seja Sistemas Captacao
	url_tag = url_tag.replaceAll("SistemasCaptacao/Desenvolvimento", "SistemasCaptacao/Main/Sistemas");
	def msg = "Criação automática da tag via pipeline ${env.JOB_NAME}";
	println url_svn;
	println url_tag
	withCredentials([[$class: 'UsernamePasswordMultiBinding', 
			credentialsId: "${svn_credencial}", 
			passwordVariable: 'svn_password', 
			usernameVariable: 'svn_username']]) {
		def linhaSVN = 'cmd.exe /C " ' + this.svnPath + 
			'svn copy ' + url_svn + ' ' + url_tag + ' -m "' + msg + 
			'" --username ' + env.svn_username + ' --password ' + env.svn_password + ' --non-interactive ';
		bat "${linhaSVN}";
	}
}

def packageName(id) {
	//retorna o nome do pacote
	return this.listaApp[id] + '-' + this.versao + ".zip";
}

def packageItem(id) {
    def pctName = "";
    def pctDir = "";

	if (this.listaBuild[id].split("/")[0].toLowerCase() == "programas") {
		pctName = '..\\..\\' + packageName(id);
		//pctDir = this.pctPathDeploy + this.listaApp[id];
		pctDir = this.pctPathDeploy + id;
	} else {
		pctName = '..\\..\\..\\' + packageName(id);
		//pctDir = this.pctPathDeploy + this.listaApp[id] + "\\PackageTmp";
		pctDir = this.pctPathDeploy + id + "\\PackageTmp";
	}

    println "[Info] Validando diretório: " + pctDir;
    def fp = createFilePath(pctDir);
	if(fp != null)
	{
		if(fp.exists()) {
			println "[Info] Criando pacote: " + pctName;
			dir("${pctDir}") {
  				if (listaNexus[id] == "s") {
  					bat this.pathDevOps + 'bin\\zip.exe -r ' + pctName + ' * ';
					
	  				bat mavenPath + "mvn deploy:deploy-file " +
	  					" -DgroupId=" + this.nexusGroup + 
	  					" -DartifactId=" + this.listaApp[id] +
	  					" -Dfile=" + pctName +
	  					" -Dversion=" + this.versao +
	  					" -DrepositoryId=" + this.nexusRepository + 
	  					" -Durl=" + this.nexusURL + '/' + this.nexusRepository + 
	  					" -Dpackaging=zip";
  				}	
  			}
  		} else {
  			println "[Atenção] Diretório não encontrado.";
  			throw new Exception("");
  		}
  	}
}

def deployLista() {
	//if("${tipo}"!='release') return;
	//ler lista de aplicações para empacotamento .zip
	if (this.listaRA != null)
		for (int id = 0; id < this.listaRA.size; id++) {
			deployItem(id);
		}
}

def urlPacoteNexus(id) {
	return this.nexusURL.toString() + "/" + this.nexusRepository.toString() + "/" + this.nexusGroup.toString().replace(".", "/") + "/" + 
		this.listaApp[id].toString() + "/" + this.versao.toString() + "/" + packageName(id);
}

def deployItem(id) {
	if (this.listaRA[id] != "") {
	    def ra_nome_app = this.listaRA[id].toString();
	    def pctName = packageName(id);
		//def pctUrl = this.nexusURL.toString() + "/" + this.nexusRepository.toString() + "/" + this.nexusGroup.toString().replace(".", "/") + "/" + this.listaApp[id].toString() + "/" + this.versao.toString() + "/" + pctName.toString();
		def pctUrl = urlPacoteNexus(id);
		def jobra = "${env.JOB_NAME}";
		jobra = jobra.replace("pipeline", "ra");
		println "Job do RA: " + jobra.toString();		
		println "Aplicacao: " + this.listaApp[id];
		println "RA: " + ra_nome_app;
		println pctUrl;
		
		build job: "${jobra}",
			parameters: 
				[[$class: 'StringParameterValue', name: 'url_pacote', value: "${pctUrl}"], 
				[$class: 'StringParameterValue', name: 'nome_pacote', value: "${pctName}"], 
				[$class: 'StringParameterValue', name: 'versao', value: "${this.versao}"], 
				[$class: 'StringParameterValue', name: 'nome_app_ra', value: "${ra_nome_app}"]]	

	}
}

def veracode() {
	if (this.listaVeracode != null && this.listaVeracode.size > 0) {
		this.veracodePacote();
		this.veracodeLista();
	}
}

def veracodePacote() {
	//criar o pacote zip para o veracode, contendo a aplicação principal e seus dependentes
    //def pctDir = this.pctPathDeploy;
    def pctDir = this.pctPathVeracode;
    def fp = createFilePath(pctDir);
	if(fp != null)
	{
		if(fp.exists()) {			
			dir("${pctDir}") {
				def pctName = "";
				for (int id = 0; id < this.listaVeracode.size; id++) {
					if (this.listaVeracode[id] != "") {
						pctName = veracodeNomePacote(id);
						println "[Info] Veracode Pacote: " + this.listaVeracode[id];
						println "[Info] Aplicação: " + this.listaApp[id];
						println "[Info] Criando pacote: " + pctName;
						//bat this.pathDevOps + 'bin\\zip.exe -r ..\\' + pctName + ' ' + this.listaApp[id] + '\\* ';
						bat this.pathDevOps + 'bin\\zip.exe -r ..\\' + pctName + ' ' + id + '\\* ';
					}
				}
  			}
  		} else {
  			println pctDir
  			println "[Atenção] Diretório não encontrado.";
  		}
  	}
}

def veracodeLista() {
	//ler lista de aplicações para empacotamento .zip
	println " Lista do Veracode unica "
	List<String> lista = this.listaVeracode.unique( false )
	def pctDir = this.pctPath;
	def fp = createFilePath(pctDir);
	if(fp != null)
	{
		if(fp.exists()) {			
			dir("${pctDir}") {
				for (int id = 0; id < lista.size; id++) {
					this.veracodeEnvio(id);					
				}
			}
		} else {
  			println pctDir
  			println "[Atenção] Diretório não encontrado.";
  		}
	}
}

def veracodeNomePacote(id) {
	//retorna o nome do pacote para o veracode
	def nome = ""
	if (this.listaVeracode[id] != ""	)
		nome = this.listaVeracode[id] + '-veracode-' + this.versao + ".zip";
	return nome.replaceAll(" ", "_").replaceAll("/", "_");
}

def veracodeEnvio(id) {
	if (this.listaVeracode[id] != "") {
		def	pctName = veracodeNomePacote(id);
		def veracodeNome = this.listaVeracode[id];
		veracode_ext ='**//**.zip'
		println "[Info] Veracode: " + veracodeNome;
		println "[Info] Veracode Pacote: " + pctName;
		
		withCredentials([[$class: 'UsernamePasswordMultiBinding', 
			credentialsId: "f1330f81-5edd-4021-8422-06cdbd99bd46", 
			passwordVariable: 'password_veracode', 
			usernameVariable: 'username_veracode']]) {
				step([$class: 'VeracodePipelineRecorder', 
					applicationName: "${veracodeNome}", canFailJob: true, copyRemoteFiles: true,
					criticality: 'VeryHigh', fileNamePattern: '', useProxy: true, 
					pHost: 'spobrproxy.serasa.intranet', pPassword: '', pPort: 3128, pUser: '', 
					replacementPattern: '', sandboxName: '', scanExcludesPattern: '', 
					scanIncludesPattern: '', scanName: "${pctName}", uploadExcludesPattern: '', 
					uploadIncludesPattern: "${veracode_ext}", useIDkey: true, 
					vid: "${env.username_veracode}",
					vkey: "${env.password_veracode}"])
		}
	}
	//vid e vkey criado no site do veracode como chave de intergação de api
}

def changeOrderLista() {
	//if("${tipo}"!='release') return;
	//ler lista de aplicações para empacotamento .zip
	if (this.listaRA != null) {
		for (int id = 0; id < this.listaRA.size; id++) {
			changeOrderItem2(id);
		}
	}	
}

def changeOrderItem(id) {
	if (this.listaRA[id] != "") {
		def path_app = "java -jar " + this.pathDevOps + "\\bin\\experian_client_sdm.jar ";
		def demanda = this.url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1");
	    def ra_nome_app = this.listaRA[id].toString();
		def pctName = packageName(id);

		def om_ambiente = this.listaOM[id].split(";")[0];
		def om_categoria = this.listaOM[id].split(";")[1];

		if (om_ambiente == "") om_ambiente = "HI";
		
		if (om_categoria != "")
		{
			def cmd = path_app.toString() + 
				'"C" "' + this.login.toString() + '" "' + om_categoria.toString() + '" "' +
				demanda.toString() + '" "' + this.url_svn.toString() + '" "' + 
				ra_nome_app.toString() + '" "' + ra_nome_projeto.toString() + '" "' + 
				pctName.toString() + '" "' + om_ambiente.toString() + '" "' + 
				this.om_rollout_complemento.toString() + '" "' + 
				this.om_config_items.toString() + '"';
			
			bat cmd.toString();
		} else {
			println "[Info] Não configurado a categoria da OM";
		}
	}
}

def changeOrderItem2(id) {
	if (this.listaRA[id] != "") {
		def demanda = url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1");

		def omCategoria = this.listaOM[id].split(";")[1];
		def omAmbiente = this.listaOM[id].split(";")[0];
		if (omAmbiente == "") omAmbiente = "HI";

	    def raNomeProjeto = "Continuous_Integration";
	    def raNomeApp = listaRA[id].toString();
		def raNomePct = packageName(id);

		def loginRequester = this.login;

		def veracodeNome = listaVeracode[id];
		if (veracodeNome == "") veracodeNome = "n/a";

		String summary = "[Criação Automática] ${demanda} ${raNomePct}   ${loginRequester}";
		
		String description = "Ordem de mudança criada automaticamente{/n}" + 
							 "Demanda: ${demanda}{/n}" + 
							 "Pacote: ${raNomePct}{/n}" + 
							 "Veracode: ${veracodeNome}";
		description = description.toString().replace("{/n}", "\\n").replace("\n", "\\n")

		String rollout = "::: OPERAÇÃO TI :::{/n}" + 
						 "Realizar o deploy com Release Automation{/n}" + 
						 "Nome da Aplicação: ${raNomeApp}{/n}" + 
						 "Projects: ${raNomeProjeto}{/n}" + 
						 "Nome do Deploy: ${raNomePct}{/n}" + 
						 "URL do Nexus já está fixa no Deployment Plan no RA{/n}" + 
						 "Ambiente: ${omAmbiente}";
		rollout = rollout.toString().replace("{/n}", "\\n").replace("\n", "\\n")

   		String rollback = "Voltar versão";

	    def changeNumber=build job: "Create.Change.Snow",
					     parameters: 
						 [
						    [$class: 'StringParameterValue', name: 'changeorderSummary', value: "${summary}"],
						    [$class: 'StringParameterValue', name: 'changeorderDescription', value: "${description}"],
						    [$class: 'StringParameterValue', name: 'changeorderRollout', value: "${rollout}"],
						    [$class: 'StringParameterValue', name: 'changeorderRollback', value: "${rollback}"]
						 ]	
		echo "${changeNumber.getClass()}"	
	}
}





def om() {
	def path_app = "java -jar " + this.pathDevOps + "\\bin\\experian_client_sdm2.jar ";
	url_svn = "http://spobrccm01-pi/svn/SistemasCaptacao/Desenvolvimento/GestaoAnalise/branches/PRJ-2016-0000820";
	login = "skh1116";

	def demanda = url_svn.toString().replaceAll("^.*branches/(.*?)\$","\$1").replaceAll("^(.*?)/.*\$","\$1");

    def raNomeProjeto = "Continuous_Integration";
    def raNomeApp = "GestaoAnalise";
	def raNomePct = "GestaoAnalise-1.0.0.zip";

	def veracodeNome = "GestaoAnalise";
	if (veracodeNome == "") veracodeNome = "n/a";

	def omAmbiente = "HI";
	if (omAmbiente == "") omAmbiente = "HI";

	def omCategoria = "HNORCTIISNET";
	om_config_items = "nr:BCC02528E6F0784A9E8C828B9B51DC91";

	String summary = "[Criação Automática] ${demanda} ${raNomePct}";

	String description = "Ordem de mudança criada automaticamente\n\r" + 
						 "Demanda: ${demanda}\n\r" + 
					 	 "Pacote: ${raNomePct}\n\r" + 
					 	 "Veracode: ${veracodeNome}";

	String rollout = "::: OPERAÇÃO TI :::\n\r" + 
					 "Realizar o deploy com Release Automation\n\r" + 
					 "Nome da Aplicação: ${raNomeApp}\n\r" + 
					 "Projects: ${raNomeProjeto}\n\r" + 
					 "Nome do Deploy: ${raNomePct}\n\r" + 
					 "URL do Nexus já está fixa no Deployment Plan no RA\n\r" + 
					 "Ambiente: ${omAmbiente}";

	String rollback = "Voltar versão";

	changeOrderCreate(this.login.toString(), this.login.toString(), demanda, omCategoria, this.om_config_items.toString(), 
						this.url_svn.toString(), summary, description, rollout, rollback);
}


def changeOrderCreate(String loginRequester, String loginAffected, String demanda, String omCategoria, String omConfigItems, 
					String urlSVN, String summary, String description, String rollout, String rollback) {

	def path_app = "java -jar " + this.pathDevOps + "\\bin\\experian_client_sdm.jar ";

	if (omCategoria != "")
	{		
		String cmd = path_app.toString() + '"C2" "' + loginRequester.toString() + '" "' + loginAffected.toString() + '" "' + 
			omCategoria.toString() + '" "' + demanda.toString() + '" "' + summary.toString() + '" "' + 
			description.toString() + '" "' + urlSVN.toString() + '" "' + rollout.toString() + '" "' + 
			rollback.toString() + '" "' + omConfigItems.toString() + '"';

		bat '''chcp 65001
			''' + cmd.toString();
	} else {
		println "[Info] Não configurado a categoria da OM";
	}
}

def envioEmail(def tipomsg) {
 	mensagem("${tipomsg}")
 	def emailDest = getMailUser(login);
 	def emailOrig="srebrazilteam@br.experian.com"
 	
 	println emailDest;
 	println this.email_assunto;

 	mail from: "${emailOrig}", 
 		to: "${emailDest}",
 		subject: "${email_assunto}",
 		body: "${email_msg}",
 		charset: 'UTF-8', mimeType: 'text/html'
}

def mensagem(def tipomsg) {
    switch ("${tipomsg}") {
    	case "inicio": 
    		this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
    		this.email_msg = "<p>Analista ${login}</p>" +
    			"<p>Pipeline de <b>${tipo}</b> iniciado conforme commit da revision ${revision}<br />" +
				"<b>Dica:</b>&nbsp;Para gera&ccedil;&atilde;o da vers&atilde;o de release, escreva <b>release</b> como primeira palavra no log do seu commit.</p>";
			break;
        case "fim": 
        	this.email_assunto = "[DevOps Info] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
  			this.email_msg = "<p>Analista ${login}</p>" +
  				"<p>Pipeline de <b>${tipo}</b> finalizado com sucesso!</p>";
			break;
        case "erro":
        	this.email_assunto = "[DevOps Atenção] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
        	this.email_msg = "<p>Analista ${login}</p>" +
        		"<p>Pipeline de <b>${tipo}</b> identificou uma inconsistencia ${msg_erro}.</p>";
			break;
        default: 
        	this.email_assunto = "[DevOps Atenção] ${env.JOB_NAME} - build ${env.BUILD_NUMBER}";
        	this.email_msg = "<p>Analista ${login}</p>" +
        		"<p>Pipeline de <b>${tipo}</b></p>";
			break;	
  	}
  	//adicionar o rodape padrão da mensagem de e-mail
  	this.email_msg = this.email_msg + 
  		"<p>Job: ${env.JOB_NAME} - Build: ${env.BUILD_NUMBER}<br />" +
  		"${url_svn}</p>" +
		"<p>Visualize o seu build atrav&eacute;s do link:<br /><a href='${env.BUILD_URL}console'>${env.BUILD_URL}console</a></p>" +
		"<a href='http://spobrccm02-pi:8080/job/${env.JOB_NAME}/'><img src='http://spobrccm02-pi:8080/job/${env.JOB_NAME}badge/icon'></a>";

	if (tipomsg != "inicio")
		this.email_msg = this.email_msg + "<p>" + listarInfoApp("<br />") + "</p>"; 
}

def listarInfoApp(lineSeparator) {	
	def msgRetorno = ""
	try {
		if (this.listaBuild.size > 0)
			msgRetorno = "Informacoes dos builds " + lineSeparator;

	 	for (int i=0; i<this.listaBuild.size; i++){
	 		msgRetorno = msgRetorno + 
	 			"Build : " + this.listaBuild[i] + lineSeparator +
	 			"App : " + this.listaApp[i] + lineSeparator +
	 			"Versao Build : " + this.listaVersao[i] + lineSeparator +
	 			"Veracode : " + this.listaVeracode[i] + lineSeparator +
	 			"RA : " + this.listaRA[i] + lineSeparator;
	 		
	 		if (this.listaOM[i].contains(";")) {
	 			msgRetorno = msgRetorno + 
					"OM Ambiente : " + this.listaOM[i].split(";")[0] + lineSeparator +
	 				"OM Categoria : " + this.listaOM[i].split(";")[1] + lineSeparator;
	 		} else {
	 			msgRetorno = msgRetorno + 
	 				"OM Ambiente : " + lineSeparator +
	 				"OM Categoria : " + lineSeparator;
	 		}
	 		if("${tipo}" == 'release') {
	 			msgRetorno = msgRetorno + "Nexus: ";
				if (listaNexus[i] == "s")
	 		  		msgRetorno = msgRetorno + urlPacoteNexus(i);
	 		}
	 		msgRetorno = msgRetorno + lineSeparator + "=================" + lineSeparator;
	 	}
 	} catch(err) {
 		//msgRetorno = "";
 	};
 	return msgRetorno;
}

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

def ListarArquivosSVN() {
	println url_svn;
	withCredentials([[$class: 'UsernamePasswordMultiBinding', 
			credentialsId: "${svn_credencial}", 
			passwordVariable: 'svn_password', 
			usernameVariable: 'svn_username']]) {
		def linhaSVN = 'cmd.exe /C " ' + this.svnPath + 
			"svn ls -R ${url_svn} --username ${env.svn_username} --password ${env.svn_password} --non-interactive";
		bat "${linhaSVN}";
	}

}

def listarArquivos() {
	//this.checkout();
	getArquivos(createFilePath(pwd()));
}

@NonCPS
def getArquivos(rootDir) {
    for (subPath in rootDir.list()) {
    	//if (subPath.getName().endsWith('.vbproj') || subPath.getName().endsWith('.csproj'))
        //	return "${subPath.getName()}";
        if (subPath.isDirectory()) {
        	if (subPath.getName() != ".svn") {
        		println "Diretorio " + subPath.getRemote();
        		getArquivos(subPath);
        	}
        } else {
        	println subPath.getRemote();
    	}
    }
}


def converterAcentosToHtml(def texto) {
	String[] params = [ "&", "&amp;", "\"", "&quot;", 
		"á", "&aacute;", "Â", "&Acirc;", "â", "&acirc;", "À", "&Agrave;", "à", "&agrave;", "Å", "&Aring;", "å", "&aring;", "Ã", "&Atilde;",	"ã", "&atilde;",
		"Ä", "&Auml;", "ä", "&auml;", "Æ", "&AElig;", "æ", "&aelig;", "É", "&Eacute;", "é", "&eacute;", "Ê", "&Ecirc;", "ê", "&ecirc;", "È", "&Egrave;",
		"è", "&egrave;", "Ë", "&Euml;", "ë", "&euml;", "Ð", "&ETH;",  "ð", "&eth;",	"Í", "&Iacute;", "í", "&iacute;", "Î", "&Icirc;", "î", "&icirc;",
		"Ì", "&Igrave;", "ì", "&igrave;", "Ï", "&Iuml;", "ï", "&iuml;", "Ó", "&Oacute;", "ó", "&oacute;", "Ô", "&Ocirc;", "ô", "&ocirc;", "Ò", "&Ograve;",
		"ò", "&ograve;", "Ø", "&Oslash;", "ø", "&oslash;", "Õ", "&Otilde;", "õ", "&otilde;", "Ö", "&Ouml;", "ö", "&ouml;", "Ú", "&Uacute;", "ú", "&uacute;",
		"Û", "&Ucirc;", "û", "&ucirc;", "Ù", "&Ugrave;", "ù", "&ugrave;", "Ü", "&Uuml;", "ü", "&uuml;", "Ç", "&Ccedil;", "ç", "&ccedil;", "Ñ", "&Ntilde;",
		"ñ", "&ntilde;", "<", "&lt;", ">", "&gt;", "®", "&reg;", "©", "&copy;", "Ý", "&Yacute;", "ý", "&yacute;", "Þ", "&THORN;", 
		"þ", "&thorn;", "ß", "&szlig;" ]

	def retorno = texto;	
	for (int i=0;i<params.size();i=i+2) {
		retorno = retorno.replaceAll(params[i], params[i+1]);
	}	
	return retorno;
}

return this