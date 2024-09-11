#!/usr/bin/env bash

# /**
# * Configurações iniciais
# */

# Exit on errors
#set -eu # Liga Debug

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
# * Versão do script
# */
VERSION='1.0.0'

# /**
# * usage
# * Método help do script
# */
usage () {
    echo "osgi.sh version $VERSION"
    echo "Copyright (C) 2024 Serasa Experian"
    echo ""
    echo -e "osgi.sh script que manipula deploy OSGi.\n"

    echo "usage: $0 [host] [cics region] [bundle name] [bundle folder] [bundle file] [user] [pass]"

    exit 1
}

ftp_script(){
  local host=$1
  local user=$2
  local pass=$3
  local script=$4

  echo -e "\nComando de deploy para sftp"
  echo -n "$script"
  echo -e "\n"

lftp<<END_SCRIPT
open sftp://$host
user $user $pass
$script
bye
END_SCRIPT
}

manage_bundle(){
  local bundle_name=$1
  local action=$2

  curl -s -X PUT "${smhost}/CICSSystemManagement/CICSBundle/${cics_region}/${cics_region}?CRITERIA=(((NAME=='${bundle_name}')))" \
    -u $user:$pass \
    -d "<request><action name=\"${action}\"/></request>" | grep $action > /dev/null
}

discard_bundle(){
  local bundle_name=$1

  curl -s -X DELETE "${smhost}/CICSSystemManagement/CICSBundle/${cics_region}/${cics_region}?CRITERIA=(((NAME=='${bundle_name}')))" \
     -u $user:$pass | grep OK > /dev/null
}

manage_bundle_definition(){
  local bundle_name=$1
  local action=$2

  curl -s -X PUT "${smhost}/CICSSystemManagement/CICSDefinitionBundle/${cics_region}/${cics_region}?CRITERIA=((CSDGROUP=='JVMBDL')%20AND%20(DEFVER=='0')%20AND%20(NAME=='${bundle_name}'))&PARAMETER=CSDGROUP(JVMBDL)" \
     -u $user:$pass \
     -d "<request><action name=\"${action}\"/></request>" | grep OK > /dev/null
}

get_files(){
  local bundle=$1
  ftp_script $host $user $pass "cd /work/JavaApps/$bundle
ls" | grep ^- | awk '{print $9}'
}

download_bundle(){
  local bundle=$1
  local destination=$2
  local files=$(get_files $bundle)
  local download=

  for file in $(echo -n "$files" | grep -e \.jar$ -e \.osgibundle$) 
  do
    download="$download
    get /work/JavaApps/$bundle/$file $destination/$file"
  done

  ftp_script $host $user $pass "$download
  get /work/JavaApps/$bundle/META-INF/cics.xml $destination/META-INF/cics.xml"
}

# /**
# * Start
# */

# Valida passagem de parametros
if [ $# -eq 1 ];then
    usage
    exit 1
fi

if [ "$1" == "EXT" ] || [ "$1" == "ext" ]; then
   infoMsg "Deploy OSGI em EXT"
   host="EXT"
else
   host=`echo "$1" |cut -d':' -f1`
fi

smhost="http://${1}"
cics_region=$2
bundle_name=$3
bundle_folder=$4
bundle_path=$5
bundle_file=$6
user=$7
pass=$8
bundle_dir=bundle

test ! -z $host || usage
test ! -z $cics_region || usage
test ! -z $bundle_name || usage
test ! -z $bundle_folder || usage
test ! -z $bundle_file || usage
test ! -z $user || usage
test ! -z $pass || usage

echo "Parametros:
Host: $host
CICS SM: $smhost
Bundle name: $bundle_name
Bundle dir: $bundle_folder
Bundle file: $bundle_file
User: $user
"

deploy=

if [ "$host" == "PROD" ] || [ "$host" == "prod" ] || [ "$host" == "EXT" ] || [ "$host" == "ext" ]; then
   infoMsg "Ignorando backup do bundle para $host"
else
   infoMsg "Fazendo backup do bundle..."
   mkdir -p backup/META-INF
   download_bundle $bundle_folder backup
fi

infoMsg "Descompactando bundle..."
unzip -o $bundle_file -d $bundle_dir
cp bundle/META-INF/cics.xml bundle/cics.xml
cd $bundle_dir

deploy=
for file in $(ls | grep -v cics.xml |grep -e \.jar$ -e \.osgibundle$ -e \.conf$ -e \.xml$ -e \.keytab$)
do
  deploy="$deploy
put $file $file"
done

deploy="$deploy
ls
cd META-INF
put cics.xml cics.xml
ls"

echo -e "\nArquivos extraidos de $bundle_file para envio"
pwd
ls -lf | grep -v "META-INF"

if [ "$host" == "PROD" ] || [ "$host" == "PROD" ]; then
   infoMsg "Transferindo bundle para o host: $host para $bundle_path"
   ftp_script 10.52.11.103 $user $pass "cd ${bundle_path}
   mkdir PROD
   cd PROD
   mkdir $bundle_folder
   mkdir $bundle_folder/META-INF
   cd $bundle_folder
   $deploy"
elif [ "$host" == "EXT" ] || [ "$host" == "ext" ]; then
   infoMsg "Transferindo bundle para o host: $host para $bundle_path"
   ftp_script 10.52.11.103 $user $pass "cd ${bundle_path}
   mkdir EXT
   cd EXT
   mkdir $bundle_folder
   mkdir $bundle_folder/META-INF
   cd $bundle_folder
   $deploy"
else
   infoMsg "Transferindo bundle para o host: $host para $bundle_path"
   ftp_script $host $user $pass "cd ${bundle_path}
   mkdir $bundle_folder
   mkdir $bundle_folder/META-INF
   cd $bundle_folder
   $deploy"
fi

if [ "$host" == "PROD" ] || [ "$host" == "prod" ] || [ "$host" == "EXT" ] || [ "$host" == "ext" ]; then
    infoMsg "Ignorando start CICS para $host"
else
    infoMsg "Disable bundle $bundle_name"
    manage_bundle $bundle_name DISABLE
    echo $?
    infoMsg "Discarding bundle $bundle_name"
    discard_bundle $bundle_name
    echo $?
    infoMsg "Installing bundle $bundle_name"
    manage_bundle_definition $bundle_name CSDINSTALL
    echo $?
    #Removendo pastas auxiliares
    rm -rf bundle backup
fi