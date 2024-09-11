# PiaaS - Pipeline as service  <!-- omit in toc -->

Antes de tudo defina um arquivo `piaas.yml` no repositório da aplicação, ele será o seu arquivo de configuração de execução da esteira. O `PiaaS` irá realizar toda a execução com as informações contidas nele.

Abaixo se encontra um exemplo de definição de um arquivo de configurção `piaas.yml`: 

```yaml
---
version: 6.0.0
application:
  name: piaas-fake-api
  product: Piaas DevSecOps
  type: rest
  gearr: 123456
  package: jar
  framework: Spring
  language:
    name: java-21
team:
  tribe: architecture
  squad: Esquadrao Galacticos DevSecOps
  business_service: TI
  assignment_group: DevSecOps Paas Brazil
branches:
  feature*:
    before_build:
      sonarqube:
      setenv: docker
    build:
      mvn: clean install package -Dmaven.test.skip=true
      docker:
    after_build:
      helm: --url-charts-repo= --safe= --iamUser= --awsAccount= --aws-region=sa-east-1 --environment=
    deploy:
      eks: --cluster-name= --project= --safe= --iamUser= --awsAccount=559037194348 --aws-region=sa-east-1 --environment=
    after_deploy:
      bruno-api:
      k6:
```

## Customizando Etapas de Construção

> O arquivo de configurção segue uma ordem de execução cronológica, e a sua construção tem as seguintes etapas:

1.  `version:` - <Obrigatório>
2.  `application:`  - <Obrigatório>
3.  `team:`  - <Obrigatório>
4.  `branches:` - <Obrigatório>
5.  `install:`
6.  `before_build:`
7.  `build:`
8.  `after_build:`
9.  `before_deploy:`
10.  `deploy:`
11. `after_deploy:`
12. `notifications:`

### Nomes reservados

> Usando os nomes reservados poderá setar genericamente em seu `piaas.yml` que o `PiaaS` irá de se encarregar de substituir por variáveis lidas no tempo de execução.

* [WORKSPACE] - Define a workspace de execução atual do pipeline
* [WORKSPACE/] - Define a workspace de execução atual do pipeline (Para compatiblidade de script)
* [VERSION] - Define a versão da aplicação lida do arquivo de configuração da aplicação (pom.xml, package.json, settings.py, etc)
* [GITAUTHOREMAIL] - Define o e-mail do autor do commit
* [GITBRANCH] - Define branch do commit
* [ENVIRONMENT] - Define environment 

### `version`

O bloco `version` é utilizado para definir a versão do seu arquivo de configurção.

Exemplo:

```yaml
version: 7.0.0
```

### `application` 

`application` é utilizado para definir as informações referentes a sua aplicação.  

`name:`

Tão simples quanto, o nome da sua aplicação.

Exemplo:
```yaml
name: piaas-fake-api
```

`product:`

Informe o nome do produto do qual pertence essa aplicação.

Exemplo:

```yaml
product: PiaaS
```

`type:`

Exemplo:

```yaml
type: [ test | rest | web | batch | script | playbook | service | lib | soap | oracle | sqlserver | hadoop | devops-tool | machine-learning-operations-coe | cobol2+cics | cobol2 | cobol2+cics+db2 | cobol2+db2 | easytrieve | easytrieve+db2 | assembly | assembly+cics | helm | self-learning ]
```

Tipos reservados:
* devops-tool : É reservado para o time DevSecOps PaaS Brazil para implantações de ferramentas que garantem a estabilidade de produtos
* machine-learning-operations-coe : É reservado para o time Machine Learning Operations CoE para implantações de Datapipelines

`gearr:`

Informe o número do seu bussiness application.

Exemplo:

```yaml
gearr: 123456
```

`package:`

A extensão do pacote final gerado na sua execução. Essa informação é útil em alguns cenários específicos que dependem desta informação.

Exemplo:
```yaml
package: jar
```

`framework:`

O framework utilizado por sua aplicação.

Exemplo:
```yaml
framework: Spring
```

`language:`

A linguagem utilizada por sua aplicação e a versão dela.

Exemplo:
```yaml
language: 
  name: java-21
```

### `team` 

`team` é utilizado para definir as informações referentes ao time dono da aplicação.

`tribe:`

A tribe da qual a aplicação pertence.

Exemplo:
```yaml
tribe: architecture
```

`squad:`

A squad da qual a aplicação pertence.

Exemplo:
```yaml
squad: Bonde da API
```

`business_service`

A business service da qual a aplicação pertence.

Exemplo:
```yaml
business_service: TI
```

`assignment_group`

Grupo do Service Now com os membros que cuidam da aplicação. A informação definida aqui também é responsável por definir o grupo que pode executar a aplicação através do PiaaS.

Exemplo:
```yaml
assignment_group: DevSecOps PaaS Brazil 
```

### `branches`

O bloco `branches` é usado para delimitar as ações a serem executadas especificamente nesta branch. Dessa forma, é possível habilitar comportamentos distintos por ambientes, por exemplo.

```yaml
branches:
  develop:
    before_build:
      sonarqube: 
    build: 
      docker: docker build -t="experian/hello-word-core" .
    after_build:
      veracode:
    before_deploy:
      script: echo "executa test yml"
    deploy:
      script: echo "deploy develop \o/"
    notifications: 
      pullrequest: 
  qa:
    deploy:
      script: echo "deploy qa \o/"
    after_deploy:
      script: ping localhost -c 3
      dynatrace:
      sql: SELECT *FROM DEVOPS
    notifications: 
      pullrequest: 
      changeorder: normal
```

### `install`

O bloco `install` é usado para configurar as dependências da sua esteira. Pode-se usar um playbook ansible para normalizar/instalar o ambiente ou invocar um comando específico para normalização. 

`ansible`

Permite a invocação de scripts no Tower.

Opções: 

```shell
--runin                Executor ansible que irá ser chamado para deploy
                       Executores: tower
                                   tower-experian
                                   awx-midd
--w, --workflow-id     Id do workflow no ansible tower
--j, --job-id          Id do job no ansible tower
     --extra-vars      Variaveis extras usadas para o deploy no ansible tower
```

Exemplo:
```yaml
ansible: --runin=awx-midd --workflow-id=51 --extra-vars='test_ci=bar'
ou
ansible: --runin=tower --job-id=50 --extra-vars='a=5 b=3'
```

`script`

Com ele é possível invocar comandos shell, ou até mesmo executar um script.

Exemplo:

```yaml
script: echo "ola mundo" && 
        ./script.sh
```

### `before_build`

O `before_build`, como o próprio nome sugere, são ações realizadas anteriormente ao seu build. Por exemplo, a execução do SonarQube.

`mvn`

É possível utilizar execuções Maven, se necessário.

Exemplo:

```yaml
mvn: parâmetros maven
```

`sonarqube`

O SonarQube é responsável por avaliar o coverage de testes da sua aplicação. Este coverage será atribuído ao pilar <b>sonarqube</b> de seu Score DevSecOps.

Você pode conferir [aqui](sonarqube.md) a documentação detalhada sobre Sonar.

Exemplo:
```yaml
sonarqube: 
ou
sonarqube: pytest
ou
sonarqube: --onlyscan
```

`veracode`

Ferramenta SAST utilizada para realizar análises de vulnerabilidade nas aplicações. Caso as políticas da empresa para ele sejam violadas, a aplicação não pode subir até produção.

Opções: 

```shell
--veracode-id        Id da aplicacao no veracode
--extensao           Extensao do arquivo para upload 
                        jar: Para linguagen java cujo gerar um artefato jar
                        ear: Para linguagen java cujo gerar um artefato ear
                        py: Para linguagen python
                        ts: Para linguagens typescript como angular, react , etc. Ou para aplicação somente com js. 
                            IMPORTANTE: Para aplicações type script use sempre o veracode antes do build para evitar o envio do node_modules
                        php: Para aplicação PHP
                        pl/sql: Oracle 18c and earlier
                        zip: Linguagem que usam esse envio. No piaas.yml a instrução de zip dos arquivos deve ser feita antes do step veracode
--force              Forcar criacao de veracode ignorando reports validos
--application-name   Nome da aplicacao
```

Exemplos:
```yaml
veracode: --veracode-id=2585 --extensao=ear
ou
veracode: --veracode-id=2585 --extensao=ear --force
ou
veracode: --veracode-id=2585 --extensao=ear --environment=develop --application-name=experian-aplicacao
```

`setenv`

Utilizado para definir seu ambiente, em tempo de execução, em seu Dockerfile. 
Além disso, pode ser utilizado para definir seu Project Key, Project Name, Project Version e Git Repo no Dockerfile, para aplicações que realizam o scan do SonarQube diretamente da imagem da aplicação.

Opções: 

```shell
docker       Define ENV na compilação do Dockerfile. Adicionar estas linhas abaixo no Dockerfile da aplicação:

             ENV environment @@BUILD_ENV@@
             ENV PROJECT_KEY @@PROJECT_KEY@@
             ENV PROJECT_NAME @@PROJECT_NAME@@
             ENV PROJECT_VERSION @@PROJECT_VERSION@@
             ENV GIT_REPO @@GIT_REPO@@
             RUN echo 'Environment for execution' $environment
```

Exemplo:
```yaml
setenv: docker
ou
setenv: docker --environment=develop (Este para poder setar ambiente 'develop' para branch 'feature*')
```

`script`

Permite a execução de comando Shell ou de um arquivo Shell.

Exemplo:
```yaml
script: echo "ola mundo" && 
        ./script.sh
```

### `build`

O bloco `build` realiza a compilação ou preparação do pacote para ser realizado o deploy. 

`mvn`

Executa comandos maven para realizar o build.

Exemplo:

```yaml
mvn: clean install
```

`docker`

Realiza builds utilizando o Docker. Caso você não defina parâmetros, automaticamente a esteira irá buildar a imagem como: <b>NOME_DA_APLICAÇÃO:VERSÃO_DA_APLICAÇÃO</b>

```yaml
docker:
ou
docker: docker build -t="experian-sme-credit-reports-domain-services:latest" .
```

`docker-z`

Realiza builds Docker para o Openshift no Mainframe.

Opções: 

```shell
--container-layer   Layer a seru usado no build para z-linux
--url-package       Pacote para deploy
--application-name  Nome da aplicacao
```

Exemplo:
```yaml
docker-z: --container-layer=websphere-liberty
ou
docker-z: --container-layer=websphere-liberty --application-name=experian-teste-ear
ou
docker-z: --container-layer=websphere-liberty --url-package=https://meu_pacote.tar
```

`hadouken`

Responsável por fazer a instalação da lib Hadouken para DataOps.

Opções: 

```shell
--path-package         Pacotes para ser feito o pacote de deploy
```

```yaml
hadouken: 
ou
hadouken: --path-package=target/*.jar *.sh keytabs/sist_servdevkafka_co.keytab
```

`slave`

Permite que um worker externo realize o processo de build. Exclusivo para uso de EID.

Opções: 

```shell
--target       Slave para execução
--command      Comando para execução no slave informado
```

Exemplo:
```yaml
slave: --target=aws_eid --command=build.sh
```

`tar`

Caso o processo de build da sua aplicação seja a geração de um pacote tar.
Se não for informado parâmetros, todo seu repositório será compatado e disponibilizado em `/tmp/<nome_da_aplicação>-<versão_da_aplicação>.tar`.

Exemplo:

```yaml
tar:
ou
tar: parâmetros tar
```

`zip`

Caso o processo de build da sua aplicação seja a geração de um pacote zip.
Se não for informado parâmetros, todo seu repositório será compatado e disponibilizado em `/tmp/<nome_da_aplicação>-<versão_da_aplicação>.zip`.

Exemplo:

```yaml
zip:
ou
zip: parâmetros zip
```

`script`

Permite a execução de comandos Shell ou arquivos Shell em seu processo de build.

```yaml
script: echo "olá mundo" && 
        ./script.sh
```

### `after_build`

O `after_build` pode ser usado para ações pós compilação, se necessário. 

`veracode`

Ferramenta SAST utilizada para realizar análises de vulnerabilidade nas aplicações. Caso as políticas da empresa para ele sejam violadas, a aplicação não pode subir até produção.

Opções: 

```shell
--veracode-id        Id da aplicacao no veracode
--extensao           Extensao do arquivo para upload 
                        jar: Para linguagen java cujo gerar um artefato jar
                        ear: Para linguagen java cujo gerar um artefato ear
                        py: Para linguagen python
                        ts: Para linguagens typescript como angular, react , etc 
--environment        Ambiente do commit [develop|qa|prod]
--force              Forcar criacao de veracode ignorando reports validos
--application-name   Nome da aplicacao
```

Exemplo:
```yaml
veracode: --veracode-id=2585 --extensao=ear 
ou
veracode: --veracode-id=2585 --extensao=ear --force
ou
veracode: --veracode-id=2585 --extensao=ear --environment=develop
ou
veracode: --veracode-id=2585 --extensao=ear --environment=develop --force
ou
veracode: --veracode-id=2585 --extensao=ear --environment=develop --application-name=experian-aplicacao
```

`nexus`

Invoque para publicar seu artefato em nosso [Nexus](https://nexus.devsecops-paas-prd.br.experian.eeca/).

Atualmente temos suporte para publicação de artefatos <b>nativos</b> para Java e Node. Para Scala, realize a publicação com parâmetros mvn em seu step de build.

Para os demais, você pode definir a chave ```package``` com o valor ```zip``` ou ```tar``` em seu piaas.yml, dentro de ```application```.

Note que para esse caso específico, você deverá compactar o conteúdo que deseja enviar para o Nexus, e mover ele para o /tmp, contendo o nome da aplicação e a versão atual (se você informar <b>VERSION</b> em seu .yml, automaticamente o PiaaS irá inserir essa informação).

Exemplo:
```
    after_build:
      script: zip -r piaas-fake-api-VERSION.zip target/*.jar &&
              mv piaas-fake-api-VERSION.zip /tmp
```

#### Java:

Os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/releases/
* Para configuração local em seu settings.xml: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/maven-group-repositories/

#### Node:

Os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-releases/
* Proxy (cache): https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-group-repository/

#### Zip e Tar

Os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/raw-snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/raw-releases/

```yaml
nexus:
```

### `sonarqube`

Informar o parâmetro angular-onlyscan para realizar o scan de sonarqube no after build.
Necessário seguir os pré-requisitos descritos aqui: https://pages.experian.com/pages/viewpage.action?pageId=1081224835

```yaml
sonarqube: angular-onlyscan
```

`script`

Permite a execução de comandos Shell ou arquivos Shell em seu processo de build.

```yaml
script: echo "olá mundo" && 
        ./script.sh
```

`helm`

Realiza o empacotamento Helm das definições de deploy do Kubernetes.

Pré-requisitos: 

- Ter o [onboarding do cofre CyberArk](cyberark_onboarding.md), com as credenciais do usuário IAM, realizado com o PiaaS:.

Opções:

```shell
    --application-name          Nome da aplicacao
    --safe                      Nome do safe do CyberArk
    --iamUser                   Nome do usuário IAM
    --awsAccount                ID da conta AWS
    --aws-region                Regiao AWS do repositorio ECR para registro da imagem para o EKS 
    --gearr-id                  Gearr ID da aplicacao
    --e, --environment          Ambiente para deploy utilizando o artefato [de|deeid|hi|hieid|he|pi|pe|peeid|develop|qa|master]
    --project                   Nome do projeto para ser realizado o deploy
    --t, --target               Destino para registro de charts. Disponiveis: s3
    --parameters                Parametros para configuracao do charts
    --version                   Versao da aplicacao
    --config-repo               Repositorio de configuracao de deploy da aplicacao
    --config-repo-version       Versao do repositorio de configuracao de deploy da aplicacao
    --url-charts-repo           URL do repositorio para o Helm Charts (S3, ECR) 
    --helm-template             Nome do template Helm Charts que serah utilizado [stateless]
    --helm-template-version     Versao do template Helm Charts que serah utilizado
    --h, --help                 Ajuda"
```

Exemplo:
```yaml
helm: --safe= --iamUser= --awsAccount= --aws-region=sa-east-1 --environment=
ou
helm:
  - --safe= --iamUser= --awsAccount= --aws-region=sa-east-1 --environment=
  - --safe= --iamUser= --awsAccount= --aws-region=sa-east-1 --environment=
```

### `before_deploy`

O `before_deploy` pode ser usado para preparar sua implementação antes deo deploy, se necessário.

`ansible`

Permite a invocação de scripts no Tower.

Opções: 

```shell
--runin                Executor ansible que irá ser chamado para deploy
                       Executores: tower
                                   tower-experian
                                   awx-midd
--w, --workflow-id     Id do workflow no ansible tower
--j, --job-id          Id do job no ansible tower
     --extra-vars      Variaveis extras usadas para o deploy no ansible tower
```

Exemplo:
```yaml
ansible: --runin=awx-midd --workflow-id=51 --extra-vars='test_ci=bar'
ou
ansible: --runin=tower --job-id=50 --extra-vars='a=5 b=3'
```

`minify`

Responsável por minificar arquivos .JS e .CSS.

Exemplo:
```yaml
minify:
```

`script`

Permite a execução de comandos Shell ou arquivos Shell em seu processo de build.

```yaml
script: echo "olá mundo" && 
        ./script.sh
```

### `deploy`

O `deploy` é usado para implantar os pacotes gerados nos ambientes selecionados.

`was`

Permite a implantação da aplicação no Web Sphere.

Opções: 

```shell
--environment      Ambiente para deploy [de|deeid|hi|hieid|he|he,hi|pi|pe|peeid]
--method           Metodo de deploy a ser usado [normal|provisioning|bluegreen|ansible]
--instance-name    Nome da instancia a ser provisionado LOGINREDE_DEMANDA (Ex.: sof5305_inc041290)
--ra-job           Nome do job do RA para executar
--application-name Nome da aplicacao
```

Exemplo:
```yaml
was: --environment=de
ou
was: --method=normal --ra-job=was_deploy --environment=de
ou
was: --method=normal --ra-job=was_deploy --environment=de --application-name=experian-aplicacao
ou
was: --method=normal --ra-job=was_deploy --environment=hi,he --application-name=experian-aplicacao
```

`airflow`

Realiza a implantação dos pacotes no Airflow.

Opções: 

```shell
--airflow-server  Servidor do airflow para deploy, ausencia do parametro os valores default serão considerados:
                  Prod    : spbrhdpcorp66,spbrhdpcorpdr66,airflow2-prod,airflow3-prod,airflow4-prod,airflow2-proddr
                  Homolog : spbrhdphm02,airflow2-uat,airflow3-uat,airflow4-uat
                  Develop : spbrhdpdev1,airflow2-dev,airflow3-dev,airflow4-dev
```

Exemplo:
```yaml
airflow: 
ou
airflow: --airflow-server=spobrpositivoairflow
ou
airflow: 
  - --airflow-server=spobrpositivoairflow
  - --airflow-server=spobrprod
```

`openshift-z`

Realiza a implantação dos pacotes no Openshift do MainFrame.

Opções: 

```shell
--method          Metodo de deploy a ser usado [package|container]
--extensao        Extensao do pacote para ser feito o deploy
--environment     Ambiente para o deploy [develop|qa|prod]
--project         Define o projeto de deploy
--no-route        Ignorar criacao de rotas no deploy no openshift
--region-latam    Regiao LATAM para DevSecOps [ colombia | brazil ]
```

Exemplo:
```yaml
openshift-z: --method=package --project=eauth-identific-develop --extensao=jar --image=eauth-identific-api-develop
ou
openshift-z: --method=container --project=sme-staging 
ou
openshift-z: --method=container --project=sme-staging --environment=develop
ou
openshift-z: --method=container --project=sme-staging --environment=develop --no-route
ou
openshift-z: --method=container --project=data-cash --environment=develop --region-latam=colombia
ou
openshift-z: 
  - --method=container --project=data-cash --environment=develop --region-latam=colombia
  - --method=container --project=data-cash-2 --environment=develop2 --region-latam=colombia
```

`hadoop`

Realiza a implantação dos pacotes no Hadoop.

Opções: 

```shell
--path-package         Caminho do pacote para ser feito o deploy
--url-package          Pacote para deploy
--no-service           Ignorar criacao de servico no deploy no hadoop
--only-hadouken        Realizar somente deploy da infra no hadoop pelo arquivo de configuração hadouken.yml
```

Exemplo:
```yaml
hadoop:
ou
hadoop: --path-package=/opt/deploy/test --url-package=http://spobrnxs01-pi:8081/nexus/content/repositories/snapshots/br/com/experian/experian-novajunta-hadoop/0.0.1-SNAPSHOT/experian-novajunta-hadoop-0.0.1-SNAPSHOT.tar
ou
hadoop: --no-service
ou
hadoop: --only-hadouken
```

`batch`

Realiza a implantação dos pacotes para deploys Batch.

Opções: 

```shell
--application-name Nome da aplicacao 
--instance-name    Nome da instancia a ser ser feito o deploy
--path-package     Caminho do pacote para ser feito o deploy
--parameters       Parametros para o deploy
--classifier       Classificador do artefato
--no-service       Ignorar criacao de servico no deploy
```

Exemplo:
```yaml
batch: --application-name=experian-test --classifier=onejar --instance-name=server --parameters=java -jar -Denvironment.name=DE app.jar
or
batch: --application-name=experian-test --instance-name=server --parameters=java -jar -Denvironment.name=DE app.jar
or
batch: --application-name=experian-test --classifier=onejar --instance-name=server --parameters=ND --path-package=/path/do/deploy
or
batch: --application-name=experian-test --classifier=onejar --instance-name=server --parameters=ND --path-package=/path/do/deploy --no-service
```

`aws`

Realiza a implantação dos pacotes para processos Lambda na AWS.

Opções: 

```shell
--method          Metodo de deploy a ser usado [lambda|lambda_serverlessv3]
--path-package    Pacotes para ser feito o pacote de deploy
```

Exemplos:

```yaml
aws: --method=lambda_serverlessv3 --safe=<CYBERARK_SAFE_NAME> --iamUser=<IAM_USER> --awsAccount=<AWS_ACCOUNT_ID> 
ou 
aws: --method=lambda_serverlessv3 --path-package=serverless-eec.yml --safe=<CYBERARK_SAFE_NAME> --iamUser=<IAM_USER> --awsAccount=<AWS_ACCOUNT_ID>
aws: --method=lambda --safe=<CYBERARK_SAFE_NAME> --iamUser=<IAM_USER> --awsAccount=<AWS_ACCOUNT_ID> 
ou 
aws: --method=lambda --path-package=serverless-eec.yml --safe=<CYBERARK_SAFE_NAME> --iamUser=<IAM_USER> --awsAccount=<AWS_ACCOUNT_ID>
```


### `Metodo lambda_serverlessv3`

A versão do `Serverless` no ambiente atual é a `1.54.0`. Para utilizar os recursos da versão mais recente do Serverless, utilize o método `lambda_serverlessv3` no seu deploy. Com essa versão, poderão ser usados recursos mais recentes da versão 3.x, como por exemplo, o `Stage Parameters`. Para mais informações acesse: https://www.serverless.com/blog/serverless-framework-v3-is-live

Note que neste método o dockerizePip não deve ser utilizado.

`osgi`

Realiza a implantação dos pacotes em OSGI.

Exemplos:
```yaml
osgi: 
```

`database`

Realização a implantação dos pacotes de Database. Exclusivo para o time de DBOpen.

Opções: 

```shell
--cluster-name          Nome da instancia do banco para deploy @ dominio
--project               Schema do banco para deploy
--environment           Ambiente para deploy [develop/qa/prod]       
```

Exemplo:
```yaml
database: --cluster-name=spobrserafat.serasa.intranet --project=serafat
or
database:
  - --method=sqlserver --environment=develop --cluster-name=spobrsqldev01.serasa.intranet --project=dbgovdatabase 
  - --method=sqlserver --environment=qa --cluster-name=spobrsqlhom01.serasa.intranet --project=dbgovdatabase
```

`ansible`

Realiza a implantação dos pacotes através de um script Ansible Tower.

Opções: 

```shell
--runin                Executor ansible que irá ser chamado para deploy
                       Executores: tower
                                   tower-experian
                                   awx-midd
--w, --workflow-id     Id do workflow no ansible tower
--j, --job-id          Id do job no ansible tower
     --extra-vars      Variaveis extras usadas para o deploy no ansible tower
```

```yaml
ansible: --runin=awx-midd --workflow-id=51 --extra-vars='test_ci=bar'
ou
ansible: --runin=tower --job-id=50 --extra-vars='a=5 b=3'
ou
ansible: 
  - --runin=tower --job-id=50 --extra-vars='a=5 b=3'
  - --runin=tower --job-id=140 --extra-vars='c=5 d=3'
```

`rsync`

Pode ser utilizado para envio dos pacotes gerados para um destino específico.

Opções: 

```shell
rsync: options source destination
       Para source pode se usar WORKSPACE, que será subistituida pelo caminho do build
```

```yaml
rsync: -avzh WORKSPACE /opt/infratransac/core/
```

`rundeck`

Realiza a implantação dos pacotes gerados no Rundeck.

Opções: 

```shell
--path-jobs   Define path de jobs schedules para criação customizada no rundeck. Quando aplicação tem mais de um job, os yml
              devem ter o nome do job desejado.
```

```yaml
rundeck:
ou
rundeck: --path-jobs=rundeck/develop/
```

`script`

Com ele é possível invocar comandos shell, ou até mesmo executar um script.

Exemplo:

```yaml
script: echo "ola mundo" && 
        ./script.sh
```

`eks`

Realizao deploy do pacote Helm gerado para o cluster EKS.

Pré-requisitos:

- No stage `after_build` deve haver a opção `helm`;
- O repositório ECR precisa estar criado com o mesmo nome da aplicação ( item configurado em `global.application` );
- Ter o [onboarding do cofre CyberArk](cyberark_onboarding.md), com as credenciais do usuário IAM, realizado com o PiaaS:.

Opções:

```shell
--environment       Ambiente para deploy [de|deeid|hi|hieid|he|pi|pe|peeid|develop|qa|master]
--safe              Nome do safe do CyberArk
--iamUser           Nome do usuário IAM
--awsAccount        ID da conta AWS
--aws-region        Regiao AWS do repositorio ECR para registro da imagem para o EKS
--cluster-name      Nome do cluster AWS EKS
--project           Nome do projeto/namespace para ser realizado o deploy
```

Exemplos:

```yaml
eks: --cluster-name= --project= --safe= --iamUser= --awsAccount=1234567890 --aws-region=sa-east-1 --environment=
ou
eks:
  - --cluster-name= --project= --safe= --iamUser= --awsAccount=1234567890 --aws-region=sa-east-1 --environment=
  - --cluster-name= --project= --safe= --iamUser= --awsAccount=1234567890 --aws-region=sa-east-1 --environment=
```


### `after_deploy`

O `after_deploy` pode ser utilizado a execução de testes ou validações na aplicação que foi realizada o deploy.

`jmeter`

Realiza testes de performance na aplicação utilizando Jmeter.

Opções: 

```shell
--think-time              Define o tempo(de pausa) entre cada transação do script em milessegundos 
--virtual-users           Define o numero de usuário simultaneos
--rampup                  Define o de inicialização dos usuários simultaneos em segundos 
--test-duration           Define duração total do teste em segundos
--servername              Define o path de url para teste
--loopcount               Define numero de interacoes por --virtual-users
```

```yaml
jmeter:
ou
jmeter: --think-time=1000 --virtual-users=5 --rampup=60  --test-duration=120 --user-login=teste_user --password-login=teste_de_teste
ou
jmeter: --think-time=1000 --virtual-users=5 --rampup=60  --test-duration=120 --user-login=teste_user --password-login=teste_de_teste --servername=https://teste/login --loopcount=5
ou
jmeter: --think-time=1000 --virtual-users=5 --rampup=60  --test-duration=120 --servername=https://teste/login --loopcount=5
```


`cucumber`

Realiza testes de qualidade utilizando Cucumber.

<b>Caso os testes estejam no repositório da aplicação (RECOMENDADO):</b>

Utilize o diretório ``quality_tests/cucumber/`` dentro do repositório da aplicação para armazenar os códigos dos testes (arquivos .java, pom.xml, etc.)

<b>Caso os testes estejam em repositório externo:</b>

Caso deseje utilizar um repositório externo para seus testes, é possível. No entanto, OBRIGATORIAMENTE, o repositório deve conter o mesmo da sua aplicação com o póx-fixo "-test".
Exemplo: experian-fake-api-test

Este é um elemento de segurança para garantir a correta execução dos testes.

Você ainda pode definir qual o projeto do Bitbucket do repositório de testes, além da branch.

<b>Padrões</b>

<b>ATENÇÃO</b>: utilize o diretório ``cucumber_reports`` para armazenar os reports gerados pelos testes (arquivos .html, .json etc.). Além disso, o arquivo JSON gerado pelo teste deve ter o nome ``cucumber.json``. Este arquivo será analisado pela esteira para gerar o SCORE da aplicação.

Opções (obrigatórioas):
```shell
--jdk           Versão da JDK da aplicação de testes
```

Opções (não obrigatórias):
```shell
--external-repo Informe se deseja utilizar um repositório externo para executar seus testes
--branch        Caso utilize repositório externo, informe a branch. Se estiver vazio será usado a master
--project-repo  Caso utilize repositório externo, e esteja em um projeto do Bitbucket diferente da sua aplicação, informar a project key
--tag           Tag utilizado no build da aplicação
--environment   Ambiente que vai ser executado os testes, para manipular variaveis internas dos testes
```

Exemplo:
```yaml
cucumber: --jdk=11 --tag=DEV
ou
cucumber: --jdk=11 --environment=develop
ou
cucumber: --jdk=11 --external-repo --branch=develop
ou
cucumber: --jdk=11 --external-repo --branch=develop --project-repo=ABC
```





`qs-test`

Opções: 

```shell
--runner             Runner para executar
--method             Framework usado para os testes
--script             Define script customizado do desenvolvedor para testes (Obs.: Script deve estar no repo da aplicação para ser invocado na execução)
```

```yaml
qs-test: --method=protractor --runner=experian-polis-web-test --script=WORKSPACE/protractor-automate.sh
```

`cloudfront`

Realiza a invalidação de cache no CDN.

Pré-requisitos:

 ( item configurado em `global.application` );
- Ter o [onboarding do cofre CyberArk](cyberark_onboarding.md), com as credenciais do usuário IAM, realizado com o PiaaS, com as devidas permissões.

Opções: 

```shell
--safe               Safe do CyberArk
--awsAccount         Framework usado para os testes
--awsRegion          Região da AWS da conta. sa-east-1 é padrão
--iamUser            Usuário IAM da conta AWS
--paths              Informe os paths a serem invalidados. '/*' é padrão
--distribution       Distribuição CloudFront
```

```yaml
cloudfront: --safe=USCLD_PAWS_123456 --awsAccount=123456 --iamUser=BUUserForDevSecOpsPiaaS --distribution=EI1SNHDGB1K
```

`dependguard`

O DependGuard é uma ferramenta de automação de gerenciamento de dependências para projetos de software. Ele verifica regularmente as dependências de um projeto, identifica atualizações disponíveis e automaticamente cria pull requests para atualizar essas dependências. Isso ajuda a manter o software atualizado com as versões mais recentes de bibliotecas e componentes, melhorando a segurança e a estabilidade do projeto.

A ferramenta utilizará automaticamente informações do repositorio e da branch base que esta sendo executado o pipeline para ser feito o scan de dependencias. 

A ferramenta pode ser utilizada de duas formas:
- DependGuard CI/CD: A automação DependGuard CI/CD é executada durante o pipeline CI/CD, verificando dependências de forma imediata e garantindo que cada build utilize as dependências mais recentes e seguras.
- DependGuard RPA: A automação DependGuard RPA alimenta o lake de dados de DevSecOps, onde um escaneamento periódico é realizado por um RPA. Isso garante que todas as dependências sejam regularmente atualizadas e seguras.

Na primeira execução no repositorio(em ambos os casos), sera efetuado um pull request com o arquivo inicial de onboarding para a base branch do repositorio. Para que o scan ocorra, se faz necessario que seja criado o arquivo.

Exemplo:

```onboarding
  renovate.json
    {
  "$schema": "https://docs.renovatebot.com/renovate-schema.json"
    }          
```

Opções na execução manual: 

```shell
--repository              Repositorio a ser escaneado
--base_branch             Branch a ser escaneada e gerado a Pull Request
--log_level               Nivel de log da execucao
--image                   Imagem que sera utilizada pelo binario"
```

```yaml
Exemplos:
## Execução pontual, usando a branch onde esta sendo invocado
before_build:
  dependguard:
  dependguard: --log_level=debug ou --log_level=silent ou --log_level=trace ou --log_level=warn ou --log_level=error

OU

## Execucao periodica, de acordo com a automacao dependguard-bot-rpa no Cockpit
application:
  dependguard: true

```

** Os nomes de ambientes aceitos são: Todos.

`newman`

Realiza testes de qualidade a partir de collections do Postman, utilizando o Newman.

Sua collection deve estar dentro de uma estrutura de diretórios, sendo ela: "newman/AMBIENTE". Ele deve estar na raíz de seu repositório.
Dentro dessa estrutura deverá conter o arquivo 'collection.json' para realização dos testes padrões do newman.
Em casos que queiram utilizar o newman-openapi-reporter, será necessário ter o swagger.yaml da aplicação na mesma estrutura de "newman/AMBIENTE".
Se o arquivo swagger.yaml existir na estrutura "newman/AMBIENTE" automaticamente será utilizado o newman-openapi-reporter.

Para executar o teste direto em uma versão canary, é necessário incluir no collections.json a variavel {{strategyTest}} e informar --strategy-test=canary no piaas.yml

```
				"header": [
					{
						"key": "x-canary",
						"value": "{{strategyTest}}",
						"type": "text"
					}
				],
```

Exemplo:

```
default
- newman/dev/
  - collection.json

ou

newman-openapi-reporter
- newman/dev/
  - collection.json
  - swagger.yaml
```

** Os nomes de ambientes aceitos são: dev, qa e prod.

Opções: 

```shell
--strategy-test           Executa o teste direto em uma versão canary com argo-rollouts ( canaryHeader deve estar habilitado ) [canary|multiple]
```

```yaml
newman:
ou
newman: --strategy-test=canary
```

`k6`

Realiza testes de performance utilizando K6.

Suas collections devem estar dentro de uma estrutura de diretórios, sendo ela: "k6/AMBIENTE". Ele deve estar na raiz de seu repositório. Dentro dessa estrutura deverá conter o(s) arquivo(s) '.js' para realização dos testes de carga.
Em casos que utilize imports de arquivos o mesmo deverá estar padronizado "k6/AMBIENTE/tests".

Para executar o teste direto em uma versão canary, é necessário incluir no delivery_reliability.js a env STRATEGY_TEST e informar --strategy-test=canary no piaas.yml

```
export function setup() {
    let urlAuth = "urlTeste"

    let payloadAuth = JSON.stringify(
        {
        'clientId': __ENV.API_K6_USERNAME,
        'clientSecret': __ENV.API_K6_PASSWORD
        }
    );
    let params = tokenAuthFunction(urlAuth, payloadAuth);

    if (__ENV.STRATEGY_TEST === 'canary') {
        params.headers['x-canary'] = 'true';
    }

    return params;
}
```

Exemplo:

```
k6/dev/
  - delivery_reliability.js
  - tests/
    - auth.js
    - default.js
    - health.js
```

** Os nomes de ambientes aceitos são: dev, qa e prod.

Obs.: Os tempos a serem adicionados no parâmetro test-duration deverão estar em mílisegundos com minimo de 1000ms (10 segundos = 10000 mílisegundos)
Obs.: Os tempos a serem adicionados no parâmetro max-req-duration deverão estar em mílisegundos, default é 500ms.
Obs.: Para casos de usos que contenham o "export default function" é possivel a utilização dos parâmetros abaixo: 

Opções: 

```shell
--virtual-users           Número de usuários virtuais
--max-req-duration        Tempo maximo em milisegundos de resposta para 95% das requisicoes para obter sucesso
--test-duration           Tempo de duração do teste em mílisegundos
--strategy-test           Executa o teste direto em uma versão canary com argo-rollouts ( canaryHeader deve estar habilitado ) [canary|multiple]
```

```yaml
k6:
ou
k6: --virtual-users="10" --test-duration="1000" --max-req-duration="400"
ou
k6: --strategy-test=canary
```

`delivery-reliability`

Realiza testes de performance e qualidade em único módulo [newman|k6].
Para executar o teste direto em uma versão canary, é necessário incluir as variáveis nas collections/delivery_reliability (visualizar k6/newman) e informar o parâmetro --strategy-test=canary no piaas.yml.
É aceito todas as opções de parâmetros dos testes k6 e newman.


Opções: 

```shell
--virtual-users           Número de usuários virtuais [k6]
--max-req-duration        Tempo maximo em milisegundos de resposta para 95% das requisicoes para obter sucesso [k6]
--test-duration           Tempo de duração do teste em mílisegundos [k6]
--strategy-test           Executa o teste direto em uma versão canary com argo-rollouts ( canaryHeader deve estar habilitado ) [canary|multiple] [k6/newman]
```

```yaml
delivery-reliability:
ou
delivery-reliability: --strategy-test=canary
ou
delivery-reliability: --strategy-test=canary --virtual-users="10" --test-duration="1000" --max-req-duration="400"
```

`rundeck`

Opções: 

```shell
--path-jobs            Definição jobs schedules para criação customizada no rundeck Ou quando aplicação tem mais de um job.
```

```yaml
rundeck:
ou
rundeck: --path-jobs=rundeck/develop
```


`airflow-test`

Realiza testes nas DAGs de Airflow.

Opções: 

```shell
--airflow-version        Versão do airflow usada  [1|2]
--variables-file         Arquivo de variaveis das dag's
--requirements-file      Arquivo requirements das dag's 
```

```yaml
airflow-test: --airflow-version=2 --variables-file=variables.json --requirements-file=requirements.txt
```


`sdelements`

Opções: 

```shell
--sdelements-id   Id do projeto no SD Elements
```

```yaml
sdelements: --sdelements-id=107
```


`selenium`

Realiza testes de qualidade utilizando Selenium.

<b>Caso os testes estejam no repositório da aplicação (RECOMENDADO):</b>

Utilize o diretório ``quality_tests/selenium/`` dentro do repositório da aplicação para armazenar os códigos dos testes (arquivos .java, pom.xml, etc.)

<b>Caso os testes estejam em repositório externo:</b>

Caso deseje utilizar um repositório externo para seus testes, é possível. No entanto, OBRIGATORIAMENTE, o repositório deve conter o mesmo da sua aplicação com o póx-fixo "-test".
Exemplo: experian-fake-api-test

Este é um elemento de segurança para garantir a correta execução dos testes.

Você ainda pode definir qual o projeto do Bitbucket do repositório de testes, além da branch.

<b>Padrões</b>

<b>ATENÇÃO</b>: utilize o diretório ``selenium_reports`` para armazenar os reports gerados pelos testes(exemplo: arquivos html do "cucumber-html-reports", arquivo .json etc.). 
* O arquivo JSON com o resultado dos testes, deve ter o nome ``selenium.json``. Este arquivo será analisado pela esteira para gerar o SCORE da aplicação.

IMPORTANTE: Utilize a Variável de Ambiente `SELENIUM_SERVER` para definir o apontamento do Selenium Grid. Note que o valor dessa variável de ambiente é injetado pela esteira, você só necessita defini-la. Exemplo:

```java
		try {
			String seleniumTestServer = System.getenv("SELENIUM_SERVER"); //utilize o comando System.getenv
			if(driver == null) {
				driver = new RemoteWebDriver(new URL(seleniumTestServer), capabilities);
			}
		} catch (MalformedURLException e) {
			logger.error("Erro ao instaciar remoteWebDriver: " + e);
		}
		return driver;
```

Opções (obrigatórias):
```shell           
--browser=BROWSER      Browser que será utilizado para os testes. Opções: chrome, firefox e edge
--jdk                  Versão da JDK da aplicação de testes
```

Opções (não obrigatórias):
```shell
--external-repo Informe se deseja utilizar um repositório externo para executar seus testes
--branch        Caso utilize repositório externo, informe a branch. Se estiver vazio será usado a master
--project-repo  Caso utilize repositório externo, e esteja em um projeto do Bitbucket diferente da sua aplicação, informar a project key
```

Exemplo:
```yaml
selenium: --browser=chrome --jdk=11
ou
selenium: --browser=firefox --jdk=11 --external-repo
ou
selenium: --browser=edge --jdk=11 --external-repo --projecto-repo=AB --branch=develop
```



`ansible`

Opções: 

```shell
--runin                Executor ansible que irá ser chamado para deploy
                       Executores: tower
                                   tower-experian
                                   awx-midd
--w, --workflow-id     Id do workflow no ansible tower
--j, --job-id          Id do job no ansible tower
     --extra-vars      Variaveis extras usadas para o deploy no ansible tower
```

```yaml
ansible: --runin=awx-midd --workflow-id=51 --extra-vars='test_ci=bar'
ou
ansible: --runin=tower --job-id=50 --extra-vars='a=5 b=3'
```

`script`

Com ele é possível invocar comandos shell, ou até mesmo executar um script.

Exemplo:

```yaml
script: echo "ola mundo" && 
        ./script.sh
```

### `notifications`

O bloco `notifications` é usado para mensagerias com sistemas de gestão, envio de e-mail ou request para o bitbucket. 

`changeorder`

Realiza a criação de Ordem de Mudança no Service Now.

```yaml
changeorder : normal
```

`pullrequest`

Gera uma URL pronta para realizar a abertura de uma PR.

```yaml
pullrequest: 
```

`cypress`

Realiza testes de qualidade utilizando Cypress.

<b>Caso os testes estejam no repositório da aplicação (RECOMENDADO):</b>

Utilize o diretório ``quality_tests/cypress/`` dentro do repositório da aplicação para armazenar os arquivos de teste (arquivos .json, js, .spec.js, cypress.json, package.json etc.)

<b>Caso os testes estejam em repositório externo:</b>

Caso deseje utilizar um repositório externo para seus testes, é possível. No entanto, OBRIGATORIAMENTE, o repositório deve conter o mesmo da sua aplicação com o póx-fixo "-test".
Exemplo: experian-fake-api-test

Este é um elemento de segurança para garantir a correta execução dos testes.

Você ainda pode definir qual o projeto do Bitbucket do repositório de testes, além da branch.

<b>Padrões</b>

* O arquivo JSON com o resultado dos testes, que deve ter o nome ``cypress.json``. Este arquivo será analisado pela esteira para gerar o SCORE da aplicação.
* Se necessário, ajuste o seu package.json com as mudanças necessárias.

Uma das principais novidades é que, a partir de agora, os testes com cypress não necessitam mais dos arquivos de configuração no repositório da aplicação, respectivamente: ``run-cypress-test.conf`` e ``cypress-automate.sh``, pois agora esstas etapas são controladas diretamente pela esteira corporativa - PiaaS.

Além disso, os arquivos de testes só funcionarão excepcionalmente dentro do repositório da própria aplicação, não sendo mais possível o uso de repositórios externos.

IMPORTANTE: Os testes com cypress em versões superiores a ``10`` (cypress13, cypress12 e cypress12-node20 ), devem seguir o novo padrão fornecido pela própria documentação oficial: https://docs.cypress.io/guides/references/configuration. Exemplo:

```js
const { defineConfig } = require('cypress')

module.exports = defineConfig({
  component: {
    // component options here
  },
})
		
```

Para melhorar o entendimento, segue um exemplo do arquivo no padrão antigo ``cypress.json`` e no padrão novo ``cypress.config.js``, para fins de comparação: 


``cypress.json``:

```js
{
    "projectId": "Piaas pipeline front end flutter web",
    "video": false,
    "viewportWidth": 1280,
    "viewportHeight": 800,
    "reporter": "mochawesome",
    "reporterOptions": {
      "reportDir": "reports/mocha",
      "overwrite": true,
      "html": true,
      "json": true
    },
    "env": {
      "baseUrl": "https://piaas-front-sand.sandbox-devsecops-paas.br.experian.eeca/"
    }
  }
```  

``cypress.config.js``:

```js
// cypress.config.js

const { defineConfig } = require('cypress');

module.exports = defineConfig({
  projectId: "Piaas pipeline front end flutter web",
  video: false,
  viewportWidth: 1280,
  viewportHeight: 800,
    reporter: "mochawesome",
    reporterOptions: {
      reportDir: "cypress_reports",
      overwrite: true,
      html: true,
      json: true,
    },
  e2e: {
    supportFile: false,  
    baseUrl: "https://piaas-front-sand.sandbox-devsecops-paas.br.experian.eeca/",
    specPattern: "integration", 
  }  
});
``` 

Os arquivos para os testes realizados nas versões inferiories a ``10`` ( node12.18.0-chrome83-ff77, node16.16.0-chrome105-ff104-edge e latest ), seguem no mesmo formato, salvo as alterações relacionadas ao diretório do ``report``, como já mencionado acima e enventuais ajustes nos mesmos.

Opções (obrigatórias):
```shell           
'--cypress-version=cypress13'    Versão cypress fornecida em seu arquivo piaas.yml. Opções: cypress13, cypress12, cypress12-node20, node12.18.0-chrome83-ff77, node16.16.0-chrome105-ff104-edge e latest.
```

Opções (não obrigatórias):
```shell   
--external-repo Informe se deseja utilizar um repositório externo para executar seus testes
--branch        Caso utilize repositório externo, informe a branch. Se estiver vazio será usado a master
--project-repo  Caso utilize repositório externo, e esteja em um projeto do Bitbucket diferente da sua aplicação, informar a project key
```

Exemplo:
```yaml
cypress: --cypress-version=cypress13
ou
cypress: --cypress-version=cypress13 --external-repo --branch=develop
ou
cypress: --cypress-version=cypress13 --external-repo --branch=develop --project-repo=ABC
ou
cypress: --cypress-version=cypress12
ou
cypress: --cypress-version=cypress12-node20
ou
cypress: --cypress-version=node12.18.0-chrome83-ff77
ou
cypress: --cypress-version=node16.16.0-chrome105-ff104-edge
ou
cypress: --cypress-version=latest
```
