#!/usr/bin/env bash

# /**
# *
# * Este arquivo éarte do projeto DevOps Serasa Experian
# *
# * @package        DevOps
# * @name           databaseLib.sh
# * @version        $VERSION
# * @description    Biblioteca com as chamadas para deploy para databases
# * @copyright      2022 &copy Serasa Experian
# *
# * @version        1.1.0
# * @change         [UPD] Metodos de validação de arquivos;
# *                 [UPD] Deploy
# * @copyright      2023 &copy Serasa Experian
# * @author         JoãLeite <joao.leite2@br.experian.com>
# * @dependencies   common.sh              
# * @date           30-Maio-2023
# *
# * @version        1.0.0
# * @change         Biblioteca com as chamadas para deploy para databases
# * @copyright      2022 &copy Serasa Experian
# * @author         JoãLeite <joao.leite2@br.experian.com>
# * @dependencies   common.sh              
# * @date           16-Set-2022
# *
# **/

# /**
# * Configuraçs iniciais
# */

# Exit se erros
#set -eu   # Liga Debug

# Diretorio base
baseDir="/opt/infratransac/core"

# Carrega commons
test -e "$baseDir"/br/com/experian/utils/common.sh || echo 'Ops, biblioteca common nao encontrada'
source "$baseDir"/br/com/experian/utils/common.sh

# /**
# * Variaveis
# */

# /**
# * VERSION
# * Versãdo script
# */
VERSION='1.1.0'

# /**
# * dbMethod
# * Define metodo de deploy
# * @var string
# */
dbMethod=''

# /**
# * dbPathPackage
# * Caminho do pacote para o deploy
# * @var string
# */
dbPathPackage=''

# /**
# * dbProject
# * Define o projeto de deploy
# * @var string
# */
dbProject=''

# /**
# * dbClusterName
# * Define o nome do Cluster 
# * @var string
# */
dbClusterName=''

# /**
# * dbEnvironment
# * Define o ambiente do Cluster 
# * @var string
# */
dbEnvironment=''

# /**
# * dbBranchName
# * Define o nome da branch
# * @var string
# */
dbBranchName=''

# /**
# * dictionaryNotAllowed
# * Define o dicionario de palavras não permitidas
# * @var file
# */
dictionaryNotAllowed="/opt/infratransac/core/db-dictionary-not-allowed/words.list"

# /**
# * dbDeploymentFiles
# * Define os arquivos para deploy
# * @var string
# */
dbDeploymentFiles=''

# /**
# * safe
# * Nome do cofre
# * @var string
# */
dbSafe='BR_PMSS_EITS_DBOPENDEV'

# /**
# * dbUserCyberArk
# * Nome cyberark usuário de integração
# * @var string
# */
dbUserCyberArk='sqldb_cockpit_piaas'

# /**
# * dbUserName
# * User do usuário de integração
# * @var string
# */
dbUserName=''

# /**
# * dbUserPassword
# * Senha do usuário de integração
# * @var string
# */
dbUserPassword=''

# /**
# * Funções
# */

# /**
# * getDeploymentFiles
# * Médo que carrega arquivos .sql alterados no commit para deploy
# * @version VERSION
# * @package DevOps
# * @author  João Leite <joao.leite2@br.experian.com>
# * @param  
# * @return  true / false
# */
getDeploymentFiles (){
    local listFilesError=()
    local qtdFiles=1

    if [ "$dbEnvironment" == "prod" ]; then
        dbDeploymentFiles=$(git log --reverse -m -1 --name-only --pretty=format:"" | grep .sql | while read -r file; do echo "$(git log -1 --format="%at" -- "$file") $file";  done | sort -n | cut -d' ' -f2-)
        #dbDeploymentFiles=$( git log -m -1 --name-only --pretty=format:""| grep .sql | while read -r file; do echo "$(git log -1 --format="%at" -- "$file") $file";  done | sort -n | cut -d' ' -f2-)

    else
        dbDeploymentFiles=$(git diff --name-only origin/master..origin/"$dbBranchName" | grep .sql | while read -r file; do echo "$(git log -1 --format="%at %H" -- "$file") $file"; done | sort -n | cut -d' ' -f3-)

    fi

    if [ "$dbDeploymentFiles" == "" ]; then
        errorMsg 'databaseLib.sh->getDeploymentFiles : Algo de errado aconteceu em obter lista de arquivos SQL para deploy. Impossivel prosseguir!'
        exit 1
    fi

    for file in $dbDeploymentFiles; do
        if file $file | grep -iqw 'CR line terminators'; then
            errorMsg 'databaseLib.sh->getDeploymentFiles : O arquivo '${file}' contem encode indevido para o SO linux. Impossivel prosseguir!'
            file $file
            exit 1 
        fi

        while read -r line; do
            if [[ "$line" =~ ^[[:space:]]*$ ]]; then continue; fi # Ignora linhas em branco e espaços
            if [[ "$line" =~ ^[[:space:]]*- ]]; then continue; fi # Ignora linhas de comentário
            if echo "$line" | grep -iqP "DROP TABLE #"; then continue; fi # Ignora linhas de DROP TABLE temporário

            while read cmd; do
                    if echo $line | grep -iqw "$cmd"; then
                        listFilesError+=("Arquivo $file contem $cmd\n")
                    fi
            done < $dictionaryNotAllowed
        done < $file
    done

    if [ ${#listFilesError[@]} -gt 0 ]; then
        errorMsg 'databaseLib.sh->getDeploymentFiles : Comandos nao permitidos foram encontrados em arquivos. Impossivel prosseguir!'
        echo -e "\nRemova os comandos abaixos dos respectivos arquivos para prosseguir com o deploy
 ${listFilesError[*]}\n"
        exit 1
    fi

    infoMsg 'databaseLib.sh->getDeploymentFiles : Lista de arquivos SQL para deploy'
    for file in $dbDeploymentFiles; do
        if [ $qtdFiles -gt 10 ]; then
            errorMsg 'databaseLib.sh->getDeploymentFiles : Ops, este deploy ultrapassou o limite de 5 arquivos, isso é suspeito. Impossivel prosseguir!'
            exit 1
        else
            echo "Arquivo adicionado->$file"
        fi
        ((qtdFiles++))
    done
}

# /**
# * startDeploySqlServer
# * Médo de deploy sqlserver
# * @version VERSION
# * @package DevOps
# * @author  João Leite <joao.leite2@br.experian.com>
# * @param  
# * @return  true / false
# */
startDeploySqlServer (){
    local dbStr=''
    dbUserName=''
    dbUserPassword=''

    infoMsg 'databaseLib.sh->startDeploySqlServer : Start deploy sqlserver'

    dbStr=$(cyberArkDap --safe $dbSafe -c "$dbUserCyberArk@$dbClusterName")
    if [ "$dbStr" = "" ]; then 
        errorMsg 'databaseLib.sh->startDeploySqlServer : Ops, erro em resgatar credenciais cyberark. Impossivel prosseguir!'
        exit 1
    fi
    if echo "$dbStr" | grep -iqw "error"; then 
       errorMsg 'databaseLib.sh->startDeploySqlServer : Ops, erro na consulta no cyberark. Impossivel prosseguir!'
       errorMsg 'databaseLib.sh->startDeploySqlServer : Verifique os parametros passados no piaas.yml de --cluster-name'
       exit 1
    fi

    dbUserName=$(echo $dbStr| jq -r '.username')
    dbUserPassword=$(echo $dbStr| jq -r '.password')

    for file in $dbDeploymentFiles; do
        echo "Deploy $file"
        if ! /opt/mssql-tools/bin/sqlcmd -S $dbClusterName -d $dbProject -U $dbUserName -P "$dbUserPassword" -i $file -o $file.log; then
            errorMsg 'databaseLib.sh->startDeploySqlServer : Ops, erro na conexao com database para deploy '${file}'. Impossivel prosseguir!' 
            exit 1
        fi

        if grep -q 'Msg ' $file.log; then 
           errorMsg 'databaseLib.sh->startDeploySqlServer : Ops, erro na sintaxe do arquivo '${file}'. Impossivel prosseguir!' 
           exit 1
        else 
            infoMsg 'databaseLib.sh->startDeploySqlServer : Deploy '${file}' realizado com sucesso'
        fi
    done
}

# /**
# * startDeployOracle
# * Médo de deploy oracle
# * @version VERSION
# * @package DevOps
# * @author  João Leite <joao.leite2@br.experian.com>
# * @param  
# * @return  true / false
# */
startDeployOracle (){
    infoMsg 'databaseLib.sh->startDeployOracle : Start deploy oracle'
    for file in $dbDeploymentFiles; do
        echo "Deploy $file"
    done
}

# /**
# * deploymentsDatabases
# * Médo faz chamadas a deploy nos databases
# * @version VERSION
# * @package DevOps
# * @author  João Leite <joao.leite2@br.experian.com>
# * @param   $dbMethod
# *          $dbPathPackage
# *          $dbProject
# *          $dbClusterName
# *          $dbEnvironment
# * @return  true / false
# */
deploymentsDatabases (){
    dbMethod=''
    dbPathPackage=''
    dbProject=''
    dbClusterName=''
    dbEnvironment=''

    test ! -z $1 || { errorMsg 'databaseLib.sh->deploymentsDatabases : Method nao informado' ; exit 1; }
    test ! -z $2 || { errorMsg 'databaseLib.sh->deploymentsDatabases : Path Package nao informado' ; exit 1; }
    test ! -z $3 || { errorMsg 'databaseLib.sh->deploymentsDatabases : Project nao informado' ; exit 1; }
    test ! -z $4 || { errorMsg 'databaseLib.sh->deploymentsDatabases : Cluster name nao informado' ; exit 1; }
    test ! -z $5 || { errorMsg 'databaseLib.sh->deploymentsDatabases : Environment nao informado' ; exit 1; }

    dbMethod="$1"
    dbPathPackage="$2"
    dbProject="$3"
    dbClusterName="$4"
    dbEnvironment="$5"
    dbBranchName=$(git branch| tail -1| awk '{print $1}')

    infoMsg 'databaseLib.sh->deploymentsDatabases : Method '${dbMethod}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Environment '${dbEnvironment}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Branch name '${dbBranchName}''
    infoMsg 'databaseLib.sh->deploymentsDatabases : Project '${dbProject}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Cluster '${dbClusterName}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Path package '${dbPathPackage}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Safe '${dbSafe}'' 
    infoMsg 'databaseLib.sh->deploymentsDatabases : Cyberark user integration '${dbUserCyberArk}''

    getDeploymentFiles

    case $dbMethod in
        sqlserver) startDeploySqlServer;;
        oracle) startDeployOracle;;
        *) errorMsg 'databaseLib.sh->deploymentsDatabases : Method '${dbMethod}' nao implementado ' ; exit 1;;
    esac
}
