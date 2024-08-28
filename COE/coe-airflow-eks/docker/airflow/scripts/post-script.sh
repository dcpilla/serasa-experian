#!/usr/bin/env bash
# Description: Run post-scripts in Dockerfile
# Author:  Diego Rodrigues <sre.mlops@br.experian.com>
#                   2023-11-7
# version: 0.1 : start
set -euo pipefail

funList="" # List

#*/
#* CPE vulnerabilities:
#*  Name: cpe:2.3:a:apache:zookeeper, Version: 3.6.3, Path: /home/airflow/.local/lib/python3.11/site-packages/pyspark/jars/zookeeper-3.6.3.jar
#*      Failed policy: Default vulnerabilities policy
#*      CVE-2023-44981, Severity: CRITICAL, Source: https://nvd.nist.gov/vuln/detail/CVE-2023-44981
#*          CVSS score: 9.1, CVSS exploitability score: 3.9
#*          Fixed version: 3.7.2
#*/
function fix_zookeeper(){

if [[ -d "/home/airflow/.local/lib/python3.11/site-packages/pyspark/jars/" ]];then
    wget -O zookeeper.tar https://dlcdn.apache.org/zookeeper/zookeeper-3.7.2/apache-zookeeper-3.7.2-bin.tar.gz
    tar -zxvf zookeeper.tar apache-zookeeper-3.7.2-bin/lib/zookeeper-3.7.2.jar
    tar -zxvf zookeeper.tar apache-zookeeper-3.7.2-bin/lib/zookeeper-jute-3.7.2.jar
    mv apache-zookeeper-3.7.2-bin/lib/* /home/airflow/.local/lib/python3.11/site-packages/pyspark/jars/
    rm -f /home/airflow/.local/lib/python3.11/site-packages/pyspark/jars/zookeeper-3.6*.jar 2>&1 >> /dev/null
    rm -f /home/airflow/.local/lib/python3.11/site-packages/pyspark/jars/zookeeper-jute-3.6.*.jar 2>&1 >> /dev/null
fi

if [[ -d "/home/airflow/.local/lib/python3.8/site-packages/pyspark/jars/" ]];then
    wget -O zookeeper.tar https://dlcdn.apache.org/zookeeper/zookeeper-3.7.2/apache-zookeeper-3.7.2-bin.tar.gz
    tar -zxvf zookeeper.tar apache-zookeeper-3.7.2-bin/lib/zookeeper-3.7.2.jar
    tar -zxvf zookeeper.tar apache-zookeeper-3.7.2-bin/lib/zookeeper-jute-3.7.2.jar
    mv apache-zookeeper-3.7.2-bin/lib/* /home/airflow/.local/lib/python3.8/site-packages/pyspark/jars/
    rm -f /home/airflow/.local/lib/python3.8/site-packages/pyspark/jars/zookeeper-3.6*.jar 2>&1 >> /dev/null
    rm -f /home/airflow/.local/lib/python3.8/site-packages/pyspark/jars/zookeeper-jute-3.6.*.jar 2>&1 >> /dev/null
fi

}

#*/
#* For each new function add a entry here, this is one safe way to let uset call internal funcations
#*/
function call_functions(){
    if [ ! -z "${funList}" ];then
        case $funList in
            fix_zookeeper) 
                fix_zookeeper
            ;;
            *)
                echo "Function does not exist"
            ;;
        esac
    else
        echo "Nothing to call"
    fi
}

function help_usage(){

echo -e"
Usage: $0  -f Function list to call ...
"
}

while getopts f: opts
do      case "$opts" in
        f) funList="$OPTARG";;
        *)  help_usage
                exit 1;;
        esac
done 

call_functions

    