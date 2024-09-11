** Slave linux **
----
> Normalização de um slave linux para suprote o lançamento de recursos


## Como Equalizar o slave

------

1. Cópia de todos os binários de infra, jenkins e os de terraform de /usr/local/bin (não copiar os de ansible) do servidor do Jenkins master.

2. Instalação do pythonrh:
```shell
	$yum install centos-release-scl-rh
	$yum install rh-python38-python
```

** Realizar steps abaixo com sudo **

3. Acessar o diretório do python38 (/opt/rh/rh-python38/root/bin) e instalar o module de pip a partir do python3.8 deste diretório.

4. Acessar o diretório do module do pip instalado (/opt/rh/rh-python38/root/usr/local/bin/) e instalar através do pip o ansible e demais módulos python que já existem no server de catálogo (usar mesma versão) – exemplo: /opt/rh/rh-python38/root/usr/local/bin/pip3.8 install ansible==2.9.10
`Obs: verificar os módulos instalados no server de catálogo usando: pip3.8 list`

5. Realizar cópia dos binários ansibles criados pelo pip para o dir /usr/local/bin.

6. Aplicar permissão 755 recursiva no diretório /opt/rh/rh-python38/root/usr/local/lib e /opt/rh/rh-python38/root/usr/local/lib64

8. Copiar o arquivo vault no diretório `~/.ansible/` do user jenkins, com permissão 664 e definir o owner e group para jenkins.

9. Clonar repo joaquin-X para a pasta /opt/deploy.


## Author

* **DevSecOps PaaS** - (devsecops-architecture-brazil@br.experian.com)