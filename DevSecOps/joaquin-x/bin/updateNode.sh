#!/usr/bin/env bash

# /**
# *
# * Este arquivo é parte do projeto Service Catalog Infrastructure Serasa Experian 
# *
# * @package        Service Catalog Infrastructure
# * @name           updateNode.sh
# * @version        $VERSION
# * @description    Script que realiza o update do Joaquin-X
# * @copyright      2023 &copy Serasa Experian
# *
# **/  

# Desliga debug #
set +x

echo "Update do Catálogo iniciado - $(date)"
echo "Sincronizando commit $GIT_COMMIT - $(date)"
rsync -avz --progress --delete --exclude '.git' --recursive $WORKSPACE/ $JOAQUINX_PATH

echo "Aplicando permissoes - $(date)"
chmod 770 $JOAQUINX_PATH -Rf