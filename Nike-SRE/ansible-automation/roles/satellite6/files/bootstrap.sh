#!/bin/bash
#
# Description: Get last bootstrap.py and register system
#
# Author: Unknown
#
# Version: 0.1 : start
# Version: 0.2 : New bootstrap.py to register in satellite1 - Diego Rodrigues

LOGIN=$1
PASSWORD=$2
ACTIVATIONKEY=$3
OS=$4
FQDN=$5
REPOS=$6
HOSTGROUP=$7

#rm -f /var/tmp/bootstrap.py

#/usr/bin/curl -s http://spobrbastion.br.experian.local/pub/bootstrap.py -o /var/tmp/bootstrap.py

/usr/bin/python /var/tmp/bootstrap.py --force \
    --login="$LOGIN" \
    --password="$PASSWORD" \
    --server spobrsatellite1.br.experian.local \
    --organization="Serasa_Experian" \
    --hostgroup="$HOSTGROUP" \
    --location="SP" \
    --activationkey="$ACTIVATIONKEY" \
    --fqdn="$FQDN" \
    --install-katello-agent \
    --skip puppet \
    --enablerepos=$REPOS


rm -f /var/tmp/bootstrap.py
