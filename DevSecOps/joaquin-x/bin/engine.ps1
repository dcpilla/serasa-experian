# /**
# *
# * Este arquivo é parte do projeto Service Catalog Infrastructure Serasa Experian 
# *
# * @package        Service Catalog Infrastructure
# * @name           engine.ps1
# * @version        2.0.0
# * @description    Script que controla o motor de execuções para windows
# * @copyright      2021 &copy Serasa Experian
# *
# * @version        2.0.0
# * @change         - [FEATURE] Metodo beforePlan com replace nos scripts;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Lucas Francoi<lucas.francoi@br.experian.com># * Joao Paulo Bastos L. <Joao.Leite2@br.experian.com># *
# * @dependencies   
# * @references     https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json?view=powershell-7.3
# * @date           06-Fev-2023
# *
# * @version        1.0.0
# * @change         - [BUG] Display de vault em modo debug;
# *                 - [FEATURE] Normalização dos logs, remoção da função sendLog;
# * @author         DevSecOps Architecture Brazil
# * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com># *Lucas Francoi<lucas.francoi@br.experian.com># * 
# * @dependencies   
# * @references     
# * @date           12-Ago-2021
# *
# **/  
# /**
# * Configurações iniciais
# */
# /**
# * Variaveis
# */
#/**
# * param
# * Define os parametros da chamada
# * @var repo         - Nome do repositório do script
# *      script       - Nome do script ps1
# *      branch       - Qual branch considerar na execução
# *      rolloutPlan  - Plano de rollout 
# **/

param($repo, $script, $branch, $rolloutPlan)
#/**
# * urlBitbucket
# * Define a url do bitbucket para buscar o script de execução 
# * @var string
# **/
$urlBitbucket = -join("https://code.experian.local/projects/SCIB/repos/", $repo, "/raw/", $script, "?at=refs%2Fheads%2F", $branch);
#/**
# * pathRun
# * Define o base path para rodar o script
# * @var string
# **/
$pathRun = pwd
#/**
# * ScriptToRun
# * Define o path completo do script
# * @var string
# **/
$ScriptToRun= -join( $pathRun , '\' , $script );
# /**
# * Funções
# */
# /**
# * LOG-MSG 
# * Método mensagens
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com># * @param   msg  - Define a menssagem
# *          type - Define o tipo
# * @return  
# **/
function LOG-MSG ($type , $msg) {
    $dateNow = date
    Write-Host (-join("[", $type, "] ", $dateNow ," - ", $msg))
}
# /**
# * beforePlan
# * Método para aplicar plano de rollout com replace
# * @version 1.0.0
# * @package Service Catalog Infrastructure
# * @author  
# * @param   
# * @return  
# **/
function beforePlan () {
    # Receiving changeParam from groovy     
    $data = $rolloutPlan | ConvertFrom-Json

    # Read content from the script file line by line with UTF-8 encoding
    $content = Get-Content -Path $script -Encoding UTF8

    # Iterate over each line and perform replacements
    foreach ($key in $data.PSObject.Properties) {    
        $keyName = "@@" + $key.Name + "@@"
        $value = $key.Value
        $content = $content -replace ($keyName), $value
    }

        # Write the updated content back to the script file with UTF-8 encoding
        $content | Set-Content -Path $script -Encoding UTF8

}

# /**
# * Start
# */
LOG-MSG "INFO" "engine.ps1 : Initializing Variables"
write-Host "Repository: $repo"
write-Host "Script: $script"
write-Host "ScriptToRun : $ScriptToRun"
write-Host "Branch: $branch"
write-Host "Workspace: $pathRun"
write-Host "Url Bitbucket: $urlBitbucket"
write-Host 
LOG-MSG "INFO" "engine.ps1 : Download script for execution"
pwd
curl.exe --insecure --fail --silent --show-error $urlBitbucket --output $script
ls
write-Host
LOG-MSG "INFO" "engine.ps1 : Show script download"
cat $script
write-Host
LOG-MSG "INFO" "engine.ps1 : Apply rollout plan"
beforePlan 
LOG-MSG "INFO" "engine.ps1 : Start script"
& $ScriptToRun
LOG-MSG "INFO" "engine.ps1 : End script"