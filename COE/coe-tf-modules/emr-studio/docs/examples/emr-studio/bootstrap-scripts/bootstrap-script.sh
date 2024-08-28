#!/bin/sh
#proxy configuration
sudo sed -i '14iproxy=http://spobrproxy.serasa.intranet:3128' /etc/yum.conf
export HTTP_PROXY=http://spobrproxy.serasa.intranet:3128
export HTTPS_PROXY=https://spobrproxy.serasa.intranet:3128
# YUM package installation
sudo amazon-linux-extras install epel -y
sudo yum install -y git s3fs-fuse awscli
