#!/bin/bash

# /**
# *
# * Script recupera o nome da queue SQS criada
# *
# * @package        Service Catalog - Launch AWS Service SQS
# * @name           get-tfstate.sh
# * @version        0.1.0
# * @description    Script recupera o nome da queue SQS e cria o arquivo queue-name.info com o nome
# * @copyright      2020 &copy Serasa Experian
# *
# * @version        0.1.0
# * @change         - [ADD] Script recupera o nome da queue SQS e cria o arquivo queue-name.info com o nome
# * @author         DevSecOps Architecture Brazil
# * @contribution   
# * @dependencies   /usr/local/bin/terraform
# *                 python38-python
# *                 pip
# * @date           04-Fev-2022
# **/  

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Functions
#~=~=~=~=
error_exit()
{
    echo "Error: $1"
    exit 1
}

#~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Main
#~=~=~=~=
set -e

TERRAFORM="/usr/local/bin/terraform"
JQ="/usr/local/bin/jq"

# processing config file
ACTION=$(cat upstate.json | $JQ -r '.action')
SAVE=$(cat upstate.json | $JQ -r '.save')


if [[ $SAVE == "yes" ]] && [[ $ACTION == "plan" ]]; then
    # it was not created a resource
    exit 0
fi

echo "[$0] Getting the queue name ..."
$TERRAFORM output -raw simple_queue_sqs_queue_name > queue-name.info || error_exit "[ERROR] Error getting the terraform output"

echo "[$0] The queue name is: $( cat queue-name.info )"

echo "[$0] Configuring the queue"
python3 kms-config.py
