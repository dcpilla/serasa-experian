#!/bin/bash
cat <<EOF > /opt/post-scripts/custom_scripts/files/script.sh

#########################################
################ Ansible ################


useradd ansible
mkdir /home/ansible/.ssh/
echo """ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM9B0/6l/agAWZM07YlzbGAoy/E7OZj/q8c5mAMhftMCv0mWXFBin+gJApTp/Ix9DwbA8o97O1wUO7ssHXC/fMX7eqzdM5u+MxoF/ZyOCH1NKrhJlWm71wEtd4zffjDGZaIoZ173yMX95Rw+UXLhPk5+03sj8f+iRIq0hvcgERNIgg51t2dznkRMZEZYtIOK2pbxc5bk52nIASteeWYEumoV2hG6C/MTtcu4661pYTchGIVZ3zK7wObpaaqCciSiYkCl11M7UOp5raVKw1i0WJO4MsEs88bFOqjcUfykUPORciamBiuzCnVSvf92tG2jjrFXG2VVquFm4zeGu7xDsf c83457a@VDICTXFDRN003
""" >> /home/ansible/.ssh/authorized_keys
chown -R ansible.ansible /home/ansible/.ssh/
chmod 600 /home/ansible/.ssh/*

echo """
ansible  ALL=(ALL)  NOPASSWD: ALL
""" > /etc/sudoers.d/ansible

yum -y update

EOF