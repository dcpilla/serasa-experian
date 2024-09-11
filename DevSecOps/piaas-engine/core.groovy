#!/usr/bin/env groovy

/**
 *
 * Este arquivo é parte do projeto DevOps Serasa Experian
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.37.0
 * @description    Criação de novo tipo de aplicação "parent"
 * @copyright      2024 &copy Serasa Experian
 *
 * @version        8.37.0
 * @change         [FEATURE] Criação método validação se a aplicação possui uma estratégia de deploy no EKS
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 * @date           11-07-2024
 * 
 * @version        8.36.0
 * @change         [FEATURE] Criação método validação Gearr - Error Budget Data
 *                 [FEATURE] Criação método validação primeiro deploy para usuario
 *                 [FEATURE] Criação método validação IT Owner e envio de token
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 * @date           13-06-2024
 *
 * @version        8.35.0
 * @change         [FEATURE] Criação método validação jira_key
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 * @date           10-06-2024
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.34.0
 * @description    Criação de funcao para invocar dependguard(Renovate) para analise de dependencias
 * @copyright      2024 &copy Serasa Experian
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.33.0
 * @description    Criação de novo tipo de aplicação "parent"
 * @copyright      2024 &copy Serasa Experian
 *
 * @version        8.33.0
 * @change         [FEATURE] Criação de novo tipo de aplicação "parent"
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 * @date           07-03-2024
 *
 * @version        8.32.0
 * @change         [FEATURE] Criação de função de testes com bruno-api
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 brunoApi.sh     
 *                 Imagens docker : bruno-api
 * @date           22-01-2024
 *
 * @version        8.31.0
 * @change         [ FEATURE ] Liberando multiplos deploy para o modulo database
 * @author         DevSecOps Architecture Brazil
 * @contribution   joao.leite2@br.experian.com
 *                 lucas.francoi@br.experian.com
 *                 rafael.franca@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 bin/*
 *                 lib/*     
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           22-09-2023
 *
 * @version        8.30.0
 * @change         [ FEATURE ] Criação de novo tipo language "java-gradle", para recuperar informações do arquivo "gradle.properties;
 *                 [ FEATURE ] Criação arquivo gradle.sh, para execução do build e execução do sonarqube;
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 *                 andre.arioli@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 bin/*
 *                 lib/*     
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           06-09-2023
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.29.0
 * @description    Script que valida módulo SEDS, Script setenv que valida variavel de ambiente e script para recuperação do lead time
 * @copyright      2023 &copy Serasa Experian
 *
 * @version        8.29.0
 * @change         [ FEATURE ] Integração ao snow para validação de problem;
 *                 [ FEATURE ] Integração ao wiz para validação de vulnerabilidades em conteiner com estratificação de risco;
 *                 [ FEATURE ] Validação do README da aplicação aplicando padrões de handover;
 *                 [ FEATURE ] Integração ao PA de Egoc para envio de OM implantadas;
 * @author         DevSecOps Architecture Brazil
 * @contribution   joao.leite2@br.experian.com
 *                 felipe.olivotto@br.experian.com
 *                 douglas.pereira@br.experian.com
 *                 pauloricassio.dossantos@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 bin/*
 *                 lib/*     
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           29-08-2023
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.28.0
 * @description    Script que valida módulo SEDS, Script setenv que valida variavel de ambiente e script para recuperação do lead time
 * @copyright      2023 &copy Serasa Experian
 *
 * @version        8.28.0
 * @change         [ FEATURE ] Criacao de funcao em Groovy para realizar a busca dos modulos nos diretorios da aplicação 
 *                 [ FEATURE ] Criacao de funcao para recuperar informações sobre Lead Time do Bitbucket
 *                 [ FIX ] Ajuste para ficar dinamico a busca pelos modulos
 *                 [ FIX ] Ajuste para aceitar branch feature
 * @author         DevSecOps Architecture Brazil
 * @contribution   fabio.zinato@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 bin/*
 *                 lib/*     
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           09-08-2023
 *
 * @version        8.27.0
 * @description    Script que controla os stages do fluxo CI
 * @copyright      2023 &copy Serasa Experian
 *
 * @version        8.27.0
 * @change         [ FEATURE ] Implantacao dos fluxos para sala MAV
 *                 [ FEATURE ] Implementação de fluxo para brscan
 *                 [ FIX ] Ajuste de path modulo k6 DE->.raven/k6/AMBIENTE PARA->k6/AMBIENTE, removendo o .raven como diretório principal
 *                 [ FIX ] Invocando getPullRequestID() para branch uat
 *                 [ FIX ] Função checkout com mais debug de msg's
 * @author         DevSecOps Architecture Brazil
 * @contribution   joao.leite2@br.experian.com
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 bin/*
 *                 lib/*     
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           18-07-2023
 *
 * @version        8.26.0
 * @change         [ FEATURE ] Implantacao testes de carga utilizando k6
 * @change         [ ADD ] Metodo k6 para execucao dos testes, validacao das regras e score
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 k6.sh
 * @date           02-05-2023
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.25.0
 * @description    Método selectedPlannedWindow recebe interação de usuário via select box para escolha de janela de mudança
 * @copyright      2023 &copy Serasa Experian
 *
 * @version        8.25.0
 * @change         [ FEATURE ] As informacoes sobre datas de start e end, estarão disponiveis em combos
 * @change         [ ADD ] Metodo selectedPlannedWindow para preenchimento das novas combos de data e hora
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh    
 *                 validateTypesApp.sh        
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           27-03-2023
 *
 * @package        DevOps
 * @name           core.groovy
 * @version        8.24.0
 * @description    Script que controla os stages do fluxo do pipeline
 * @copyright      2022 &copy Serasa Experian
 *
 * @version        8.24.0
 * @change         [ FIX ] Mudança da validação do validateTypesApp.sh para mostrar arquivos que violaram a politica;
 *                 [ FEATURE ] Mapeamento de reuso do seds;
 * @author         DevSecOps Architecture Brazil
 * @contribution   João Leite <joao.leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh    
 *                 validateTypesApp.sh        
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           28-03-2023
 *
 * @version        8.23.0
 * @change         [FEATURE] Função para executar testes sonarqube em node workers para as linguagens baseadas em jdk;
 *                 [UPD] Função para executar testes sonarqube na linguagem scala para o pacote jdk11
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 incluir no jenkins pipeline as funções flagJdkSonarWorker e slaveRunning para executar em node workers
 *
 * @date           27-03-2023
 *
 * @version        8.22.0
 * @change         [FEATURE] Validação de tipos de aplicações com caracteristicas diferentes;
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh    
 *                 validateTypesApp.sh        
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           23-03-2023
 *
 * @version        8.21.0
 * @change         [UPD] Adicionando servidor prod para função airflow;
 *                 [UPD] Adicionando code error para bloqueio do primer hour;
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           23-03-2023
 *
 * @version        8.20.0
 * @change         [NIKEDEVSEC-2896] Aplicar a validação de Primer Hour via pipeline para apps cujo gear = highly critical;
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           06-02-2023
 *
 * @version        8.19.0
 * @change         [NIKEDEVSEC-2909] sonarqube 8.9.10 para jdk17;
 * @author         DevSecOps Architecture Brazil
 * @contribution   DevSecOps PaaS Brazil.
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 core.groovy
 *                 openshiftLib.sh
 * @date           31-01-2023
 *
 * @version        8.18.0
 * @change         - [UPD - CHG0684942] Validação do grace_period_expired no report do veracode, onde grace_period_expired = false não parar o pipeline de CI/CD;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>, 
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           10-01-2023
 *
 * @version        8.17.0
 * @change         - [UPD] Verificação de janela de mudança da OM informada;
 *                 - [UPD] Adicionar help para tipos de OM;
 *                 - [UPD] Validação de SCA antes da compilação de programas java;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>, 
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           30-11-2022
 *
 * @version        8.16.0
 * @change         - [UPD] Remoção da regra de aplicações com SCA em lista de exeção;
 *                 -´[UPD] Remoção da lista de liberações para migrações EKS na função do veracode;
 *                 - [FIX] Correção do bug da definição de url do nexus para função airflow e validação de servidores não default;
 *                 - [FIX] Impedir na contraução de parametros informar um hash de commit de QA e branch MASTER;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>, 
 *                 Andre Arioli <andre.arioli@br.experian.com>,
 *                 Lucas Francoi <lucas.francoi@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           29-10-2022
 *
 * @version        8.15.0
 * @change         - [FIX] Melhoria na validação de relatorios de testes de qualidade Cucumber/Cypress
 * @author         DevSecOps Architecture Brazil
 * @contribution   Felipe Olivotto. <felipe.olivotto@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 qsTest.sh
 *                 cucumber.sh            
 *
 * @date           24-10-2022
 *
 * @version        8.14.0
 * @change         - [FIX] Leitura do package json para aplicações com node16-with-yarn;
 *                 - [FIX] Alteração do template de change order para aplicações com score > 80;
 *                 - [FEATURE] Implementação de suporte da função de deploy para banco de dados;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           16-09-2022
 *
 * @version        8.13.0
 * @change         - [UPD] Implementação de looping enquanto erro para "Change justification","Planed start date" e "Planed end date" ;
 * @author         DevSecOps PaaS Brazil
 * @date           30-08-2022
 *
 * @version        8.12.0
 * @change         - [FIX] Remoção de validação de gearr para aplicações c++ mainframe;
 *                 - [FIX] Forçando o ambiente de deploy para operações mainframe;
 * @author         DevSecOps PaaS Brazil
 * @date           22-08-2022
 *
 * @version        8.11.0
 * @change         - [FIX] Validação do getScore do pipeline. Realização de 3 tentativas de 5s caso a api do snow falhe.
 * @author         DevSecOps PaaS Brazil
 * @date           15-07-2022
 *
 * @version        8.10.0
 * @change         - [FIX] Manter envio de logs para aplicações mainframe;
 *                 - [FIX] Retirar validação de versão das OM para execuções mainframe;
 *                 - [UPD] Parametro de OM no form de inicio do pipeline para evitar a pergunta durante o pipeline;
 *                 - [UPD] Parametros do mainframe no inicio do pipeline de user/senha da integração para produção
 * @author         DevSecOps PaaS Brazil
 * @date           11-06-2022
 *
 * @version        8.9.0
 * @change         - [UPD] Segregação templates OM para mainframe;
 * @author         DevSecOps PaaS Brazil
 * @date           10-06-2022
 *
 * @version        8.8.0
 * @change         - [FIX] Removendo pilares qs_test/performance/pentest/waf para bibliotecas;
 *                 - [FIX] Validação dos atributos gearr_dependencies e cmdb_dependencies;
 * @author         DevSecOps PaaS Brazil
 * @date           06-05-2022
 *
 * @version        8.7.0
 * @change         - [UPD] Configurado score minimo para deploy > 80 ;
 *                 - [FEATURE] Adicionado container de sonarqube para node16;
 * @author         DevSecOps PaaS Brazil
 * @date           28-04-2022
 *
 * @version        8.6.0
 * @change         - [FIX] Retirada do parametro de TRACE no sonarqube;
 *                 - [FEATURE] Criação de função de testes com postman + newman;
 *                 - [FEATURE] Melhoria na gestão de images bases;
 *                 - [FEATURE] Otimização de performance para aplicações angular sonarqube/compilaçao/cypress;
 *                 - [FEATURE] Função airflow_test com leitura de controles do COE;
 *                 - [FEATURE] Suporte ao sonarqube para scan de python 3.8;
 *                 - [FIX] Remoção dos path dos binarios do jmeter do repositorio core;
 *                 - [FEATURE] Simplificação do modo de leitura dos report do veracode para considerar as tag policy_rules_status / policy_compliance_status / software_composition_analysis
 *                 - [FEATURE] Bloqueios de abertura de OM com score < 30, com validação de incidentes P1 P2;
 *                 - [FEATURE] Leitura de lista de exeções para abertura de OM mesmo com score não compliance;
 *                 - [FEATURE] Alteração da leitura do score de qs_test, agora será validado somente se teve erros, e se os cenários > 1; 
 *                 - [FEATURE] Adicionado o campo jira_key para lake de produtos;
 *                 - [FEATURE] Alteração da regua do score para 60;
 *                 - [FEATURE] Adicionado campo cmdb_dependencies;
 *                 - [FEATURE] Suporte a sonarqube para php;
 * @author         DevSecOps PaaS Brazil
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 maven-mvnd : https://github.com/apache/maven-mvnd
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 newman.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  sonar-scanner-python-pytest
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           24-01-2022
 *
 * @version        8.5.0
 * @change         - [FEATURE] Busca de grupos para abertura de OM de IIS;
 *                 - [FEATURE] Leitura de incidente e validação de severidade para template emergencial;
 *                 - [FEATURE] Implementação do detect-secrets para detecção de senhas no código fonte da aplicação; 
 *                 - [FEATURE] Suporte ao zulu 17;
 *                 - [FEATURE] Suporte ao zulu 13;
 *                 - [FEATURE] Suporte a deploy no eks;
 *                 - [FEATURE] Passagem de parametro application-type no modulo veracode para novas regras do veracode;
 *                 - [FIX] Validar aplicação se tem execption de vulnerabildiade log4j e enviar informação para change;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>, Renato M Thomazine <renato.thomazine@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 *                                  detect-secrets
 * @date           21-01-2022
 *
 * @version        8.4.0
 * @change         - [FEATURE] Deploy simultaneo nos DC do airflow;
 *                 - [FEATURE] Implementação de tipo de aplicação para o time Machine Learning Operations - CoE com template exclusivo;
 *                 - [UPDATE] Validação de tipos de aplicações exclusivas;
 *                 - [FEATURE] Build cobol mainframe;
 *                 - [FEATURE] Parametro de squad no piaas.yml;
 *                 - [FEATURE] Novo processo de esteira para aplicações Hadoop;
 *                 - [FEATURE] Add motor de validações GSO;
 *                 - [UPDATE] Validação de campos obrigatórios no piaas.yml para aberturas de OM;
 *                 - [FEATURE] Add campo gearr_dependencies;
 *                 - [FEATURE] ADD no e-mail de finalização do deploy do projeto Core os links de cucumber e jmeter se o projeto tiver;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 * @date           05-07-2021
 *
 * @version        8.3.0
 * @change         - [UPDATE] Melhorias nos códigos de erros para buscas mais exatas de soluções;
 * @change         - [FEATURE] snow.sh manipulação de request, leitura de dados e fechamento;
 * @change         - [FEATURE] core, abertura de OM com o user que aprovou a PR quando o grupo é informado;
 * @change         - [FEATURE] core, correções de vulnerabilidades;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 * @date           30-01-2021
 *
 * @version        8.2.0
 * @change         - [FEATURE] Implementação do modulo qs-test no after_deploy para invocação de qualquer metodo de teste e suporte ao score;
 *                 - [DEL] Remoção do SD Element no calculo do DevSecOps Score;
 *                 - [UPDATE] Tratamento de aplicações para test com as mesmas regras das LIB's, somente build;
 *                 - [UPDATE] Leitura de parametros de network type do gearr para criação de score pentest;
 *                 - [FEATURE] DevSecOps Score com calculo de pentest;
 *                 - [FEATURE] DevSecOps Score com calculo de WAF;
 *                 - [FEATURE] Deploy para Airflow;  
 *                 - [FEATURE] Suporte veracode para php;   
 * @author         DevSecOps Architecture Brazil
 * @contribution   Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 * @date           02-10-2020
 *
 * @version        8.1.0
 * @change         - [BUG] Update/Correção de cluster para deploy WAS;
 *                 - [BUG] Correção de job de expurgo de workspaces do jenkins;
 *                 - [FEATURE] Promoção de images para openshift;
 *                 - [FEATURE] Deploy multiplo para openshift openshift;
 *                 - [FEATURE] Integração com o GEARR;
 *                 - [MELHORIA] Ignorando notificação de criação de pullrequest para develop;
 *                 - [FEATURE] Suporte a build e deploy openshiftZ;
 *                 - [FEATURE] Criacao da label 'tribe' no namespace sempre que o deploy é executado para contabilizar o consumo de recursos por tribe;
 *                 - [BUG] Abertura de om com detalhes de testes para branch uat;
 *                 - [FEATURE] Bloqueio de aplicações ser gearr configurado;
 *                 - [FEATURE] Bloqueio de aplicações com SCA violados;
 *                 - [BUG] Dados dos score das ferramentas para BI quando é produção;
 * @author         DevSecOps Architecture Brazil
 * @contribution   Thiago Costa <Thiago.Costa@br.experian.com>
 *                 Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Luiz Bartholomeu <Luiz.Bartholomeu@br.experian.com>
 *                 Renato M Thomazine <renato.thomazine@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 openshiftLib.sh
 *                 veracode.sh
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 * @date           18-05-2020
 *
 * @version        8.0.0
 * @change         - [Feature] Suporte a componentes 3rdParty para comunidade DevSecOps poder contribuir;
 *                 - [Feature] Monitoramento dos jobs do CORE para prever erros com suporte proativos;
 *                 - [Feature] Adicionado tipos erros do CORE;
 *                 - [Feature] Adicionado monitoramento do bitbucket/snow/nexus do dashboard DevSecOps;
 *                 - [Melhoria] String ETL;
 *                 - [Melhoria] Mostrar tamanho da image dos conteiner nos deploy do openshift para analise de melhorias do dockerfile;
 *                 - [Feature] Integração com SD Elements;
 *                 - [BUG] Expurgo automatico da base de dados do health-devsecops;
 *                 - [BUG] Retry de deploy no openshift eliminando o kubeconfig para evitar problemas de deploy simultâneos;
 *                 - [Feature] Função slave para rodar comandos em outros jenkins;
 *                 - [Feature] Parametro --only-hadouken para somente deploy de infra para hadoop (Ex.: hadoop: --only-hadouken);
 *                 - [FEATURE] Lista offline para consultas das aplicações no veracode evitando erros de CI para start de scans;
 *                 - [FEATURE] Sonarqube para linguagens type script ;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @contribution   Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
 *                 Michel Miranda  <Michel.Miranda@br.experian.com>
 *                 Wagner Nakamura <Wagner.Nakamura@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh 
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  sonar-scanner-typescript
 *                                  yamllint
 *                                  minify
 * @date           18-02-2020
 *
 * @version        7.2.0
 * @change          - [Feature] Monitoração proativa das ferramentas devsecops;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh 
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  minify
 * @date           18-02-2020
 *
 * @version        7.1.0
 * @change          - [Feature] Suporte a deploy aws lambda usando serverless;
 *                  - [Feature] Suporte ao rundeck para parametro --path-jobs definição jobs schedules para criação customizada no rundeck. Quando aplicação tem mais de um job.
 *                  - [Feature] Melhoria na criação de triggers para core;
 *                  - [BUG] Ajustes de ETL;
 *                  - [Feature] Criação de parametro --script para função cucumber. Para execução de script customizado do desenvolvedor para testes;
 *                  - [Feature] Suporte a deploy de jobs schedules no rundeck para execuções de cronjobs do openshift. Template disponibilizado;
 *                  - [BUG] Sair com erro em caso de falha nas integrações dataops;
 *                  - [Feature] Método seta credenciais para parametros seguros buscando em data vault. 
 *                              Ex: --user-login=jenkins.credentials.user.usr_ci_integra_serasa_intranet, isso irá sobrescrever o parametro --user-login pelo user da credencial jenkins.credentials.user.usr_ci_integra_serasa_intranet
 *                                  --password-login=jenkins.credentials.password.usr_ci_integra_serasa_intranet , isso irá sobrescrever o parametro --password-login pela senha da credencial jenkins.credentials.password.usr_ci_integra_serasa_intranet
 *                 -  [Feature] Suporte a deploy WAS via wsadmin para desativação do RA;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @contribution   Leonardo Silva <Leonardo.Silva2@br.experian.com>
 *                 Douglas Souza <Douglas.Souza@br.experian.com>
 *                 Michel Miranda <Michel.Miranda@br.experian.com>
 *                 Thiago Costa <Thiago.Costa@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh 
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  minify
 * @date           14-Out-2019
 *
 * @version        7.0.0
 * @change          - [Feature] Suporte a deploy WAS via ansible para desativação do RA;
 *                  - [Feature] Suportes a aws:
 *                              - lambda;
 *                              - terraform;
 *                  - [BUG] Melhoria para criação de topicos kafka via hadouken somente quando o topico não existir;
 *                  - [Feature] Add parametro timeoutExit na função inputUser para sair sem erro o pipeline evitando criar falso positivos;
 *                  - [Feature] Criação de string ETL para criação de processo de envio de info para Dash Board DevSecOps;
 *                  - [Feature] Suporte a linguagem SCALA para função sonarqube;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @contribution   Gregory Iyama <Gregory.Iyama@br.experian.com>
 *                 Murilo Ramos  <Dextra.Murilo.Ramos@br.experian.com>
 *                 Robson Agapito <Gft.Robson.Agapito@br.experian.com>
 *                 Michel Miranda <Michel.Miranda@br.experian.com>
 *                 Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh 
 *                 jmeter.sh
 *                 snow.sh
 *                 cucumber.sh            
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  minify
 * @date           14-Out-2019
 *
 * @version        6.4.0
 * @change          - [Feature] Adicionado parametro --no-service para deploy de batch, quando o mesmo será orquestrado pelo rundeck/control-m;
 *                  - [Feature] Suporte ao pytest para sonarqube;
 *                  - [Feature] Suporte ao python 3.6 para sonarqube;
 *                  - [BUG] Ajustes de score Jmeter;
 *                  - [BUG] Bloquear echo de senhas de integração;
 *                  - [Feature] Melhorias Hadouken DataOps:
 *                              - Integração com kafka;
 *                              - Logs;
 *                              - Liberação até produção para SETUP;
 *                              - Verificação de alteração no hadouken.yml para invocar automação de SETUP;
 *                  - [Feature] Start integração para LGPD ;
 *                  - [Bug] Corrigido o campo changeorderRollback para aberturas de changes order;
 *                  - [Bug] Definição de ambientes para deploy de job schedules develop/qa/prod [https://confluenceglobal.experian.local/confluence/display/EDS/Using+Rundeck];
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  deploy.sh
 *                                  veracode.sh
 *                                  jmeter.sh
 *                                  snow.sh
 *                                  cucumber.sh
 * @date           05-Set-2019
 *
 * @version        6.3.0
 * @change          - [Feature] Deploy terraform;
 *                  - [Feature] Deploy de job schedule no rundeck;  
 *                  - [Feature] Fechamento da change ordem depois de implantadas com sucesso;
 *                  - [Feature] Compatibilidade com jdk12;
 *                  - [Bug] Remoção de uso de plugin git para git checkout, trazendo mais performace;
 *                  - [Feature] Usar curinga para mapa de dados piaas.yml feature*;
 *                  - [Feature] Add Nome reservado GITBRANCH para o uso no piaas.yml - Define branch do commit;
 *                  - [Feature] Metodo hadouken para build de pacote para DataOps;
 *                  - [Bug] Mudar forma de envio para nexus quando liguagem é java e pacote é tar, não usando o mvn para envio;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  deploy.sh
 *                                  veracode.sh
 *                                  jmeter.sh
 *                                  snow.sh
 *                                  cucumber.sh
 * @date           07-Jun-2019
 *
 * @version        6.2.0
 * @change         Melhorias:
 *                   - [Feature] Deploy para outsystem;
 *                   - [Feature] Tratamento de linguagem scala;
 *                   - [Feature] Build para aplicações dotnet;
 *                   - [Melhoria] Deploy unico para WAS em dois ambientes he,hi;
 *                   - [Feature] Tipo de aplicação para SRE, para garantir flexibilidade nas change ordem;
 *                   - [BUF] Setando valor default changeorderUSysOutage=no;
 *                   - [Feature] Start Deploy no apigee de proxy;
 *                   - [BUG] Quando status projeto sonar for diferente de OK, score.sonar = 0;
 *                   - [Melhoria] Ecoar perguntas dos input de usuário no logtrace;
 *                   - [Feature] Change order aprovada automáticamente quando score > thresholdScore;
 *                   - [Melhoria] Adicionado url de cucumber e jmete na OM;
 *                   - [Melhoria] Adicionado suporte ao hadouken;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Joao Aloia <Joao.Aloia@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  deploy.sh
 *                                  veracode.sh
 *                                  jmeter.sh
 *                                  snow.sh
 *                                  cucumber.sh
 * @date           24-Jan-2019
 *
 * @version        6.1.0
 * @change         Melhorias:
 *                   - Implementação de deploy para hadoop;
 *                   - Equalização de pod's openshift para reduzir consumo de recurso;
 *                   - Adicionar função ansible aos steps after_deploy|deploy|before_deploy|install;
 *                   - Função minify para css e js;
 *                   - Deploy OSGi;
 *                   - Validação da tribe no piaas.yml;
 *                   - Envio de email com ajuda para autor do commit quando esteira quebra por erro;
 *                   - Implementação de deploy de batch;
 *                   - Ignorar criacao de rotas no deploy no openshift;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  deploy.sh
 *                                  veracode.sh
 *                                  jmeter.sh
 *                                  snow.sh
 *                                  cucumber.sh
 * @date           27-Nov-2018
 *
 * @version        6.0.0
 * @change         Melhorias:
 *                   - Score CI / CD das aplicações
 *                   - Integração com cucumber
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  deploy.sh
 *                                  veracode.sh
 *                                  jmeter.sh
 *                                  snow.sh
 *                                  cucumber.sh
 * @date           23-Out-2018
 *
 * @version        5.9.0
 * @change         Melhorias:
 *                   - Tratamento de esteira para componete
 *                   - Padronização de versão para DEVELOP , QA e MASTER de acordo com https://semver.org
 *                   - Tratar replace para variaveis reservadas do core de forma global, evitando duplicidades em funções
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           09-Out-2018
 * 
 * @version        5.8.0
 * @change         Migração de service desk para compatibilidade com service now
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           04-Set-2018
 *
 * @version        5.7.0
 * @change         Suporte ao jmeter
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           28-Ago-2018
 * 
 * @version        5.6.0
 * @change         Sugestão Baldo, Tiago para performace de checkout do pipeline: 
 *                 Referencia: https://vetlugin.wordpress.com/2017/01/31/guide-jenkins-pipeline-merge-requests/
 *                             https://stackoverflow.com/questions/48936345/how-can-i-execute-code-on-prune-stale-remote-tracking-branches-in-jenkins
 *                             https://jenkins.io/doc/pipeline/steps/workflow-scm-step/                 
 *                 checkout():
 *                    - Quando o pipeline for dar o fetch coloca os parametros --all --prune, ele nao vê as branchs que ja foram apagadas.
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           02-Ago-2018
 *
 * @version        5.5.0
 * @change         Feature:
 *                   - Implementação da função playbook para o step install:
 *                     Essa função irá disponibilizar para a SQUAD a aplicação de playbook's para infra as code para criação ou atualização dos serviços
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           30-Jul-2018
 *
 * @version        5.4.0
 * @change         Melhorarias:
 *                   - Quando pullrequest é aceita de QA > MASTER a função de changeOrder() já será invocada não precisando estar no playbook da esteira;
 *                   - Validação de taks da ordem de mudança para garantir se foi aprovado pelo time de mudanças;
 *                   - Gravação de todas as metricas do sonarqube na ordem de mudança;
 *                   - Retirado a pergunta para abertura de ordem de mudança, já abre qdo a função changeOrder() é invocada;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           25-Jul-2018
 * 
 * @version        5.3.0
 * @change         Melhorar função sonarqube: 
 *                   - Tratar try função setSonarQualityGates para sair qdo for o primeiro scan da aplicação;
 *                   - Analisar as demais metricas do sonar e melhorar email quando aplicação não passa nelas,
 *                     hoje só é analisado o coverage;
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           12-Jul-2018
 * 
 * @version        5.2.0
 * @change         Tratar controle versões das tag's, quando a mesma já existir quebrar esteira, e orientar o DEV
 *                 a ajustar sua versão de desenvolvimento.
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           11-Jul-2018
 *
 * @version        5.1.0
 * @change         A Release 5.0.0 do pipeline será uma padronização de execução podendo se adaptar a qualquer aplicação e mais maturidade de código,
 *                 com a adoção de arquivos yaml para customização da execução dos fluxos algo similar a modo de como o Travis-Ci/GitLab-CI executa os 
 *                 seus fluxo de pipeline. Onde cada aplicação irá ter suas configurações em um arquivo yaml independente. Esse arquivo irá ser a estruturação dos 
 *                 stages do pipeline, com isso podemos definir vários tipos diferentes de execução com um unico script sendo adaptável. 
 *                 A escolha da escrita por meio de linguagem de marcação yaml se dá pelo motivo de que a serasa está adotando ansible nas construções
 *                 de playbooks assim ficariamos padronizado com o resto dos times.
 *                 Restruturação do script para poder atender as necessidades são:
 *                   - [UPD] renomear script de pipeline-script-was.groovy para core.groovy por pradronização.
 *                   - [ADD] readYamlFile: Implementação de função de leitura de variaveis do arquivo yaml.
 *                   - [ADD] ticketJira : Implementação da função de abertura de ticket no jira, com o envio de email.
 *                   - [UPD] mensagem: Melhoria no layout das mensagens de envio.
 *                   - [UPD] checkout: Implementação de checkout via Bitbucket.
 *                   - [DEL] deployRA: Para implantação de melhorias de tipo de deploy, onde a nome deployRa reflete um vendor lockin.
 *                   - [ADD] deploy: Implementação de tipo de deploy no openshift|bluegreen, e juntar com função provisionamento. 
 *                   - [DEL] build_release: Para melhorias de tipo de build.
 *                   - [DEL] deployMenuProdutos: Juntar com função deploy.
 *                   - [ADD] build: Implementação de build em docker gerando imagens.
 *                   - [DEL] envioEmail: Incluir na função ticketJira. 
 *                   - [UPD] sonar : Mudança na forma de envio para o sonarqube, exigencia do sonar 6.7.
 *                   - [UPD] pipeline: Melhoria nos tipos de chamada, com maior reastreabilidade.
 *                   - [DEL] getContextRoot
 *                   - [DEL] provisionamento: Incluido em função deploy.
 *                   - [UPD] Realizar manutenção em variaveis ambíguoas ou com nome que expressa um vendor lockin. Para deixa-las genéricas para qualquer tipo de uso, ex.: job_ra mudaria para job_deploy.
 *                   - [ADD] Centralização de logs com ELASTICSEARCH AND KIBANA.
 * @author         Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *                 Yros Pereira Aguiar Batista <Yros.Aguiar@br.clara.net>
 * @dependencies   AnsiColor : https://wiki.jenkins.io/display/JENKINS/AnsiColor+Plugin | https://misc.flogisoft.com/bash/tip_colors_and_formatting
 *                 deploy.sh
 *                 veracode.sh               
 *                 Imagens docker : sonar-scanner-python
 *                                  yamllint
 *                                  ansible-tower-cli
 * @date           28-Fev-2017
 *
 * @version        2.1.0
 * @change         Implementação do stage de Deploy Menu Produtos -> Stage que implementa o menu de produtos para ambientes provisionados
 * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
 * @dependencies   searchEmail.sh 
 *                 provisionar.sh
 * @date           14-Nov-2017
 *
 * @version        2.0.0
 * @change         Implementação do stage de provisionamento para WAS
 *                 Implementação/Melhoria do stage de deploy para realização de auto deploy
 *                 Melhoria no e-mail de start pipeline contendo as configurações do mesmo para trace DEV
 * @author         Joao Paulo Bastos L. <jpbl.bastos at gmail dot com>
 * @dependencies   searchEmail.sh 
 *                 provisionar.sh
 * @date           08-Ago-2017
 *
 * @version        1.1.0
 * @change         Integração via email com os DEV 
 * @author         Andre Luiz Colavite <Andre.Colavite@br.experian.com>
 * @dependencies   searchEmail.sh 
 * @date           01-Ago-2017
 * 
 * @version        1.0.0
 * @description    Script que controla os stages do fluxo CI
 * @author         Andre Luiz Colavite <Andre.Colavite@br.experian.com>
 * @date           27-Jul-2017
 *
 **/

import hudson.model.*
import hudson.EnvVars
import groovy.json.JsonSlurper
import org.yaml.snakeyaml.Yaml
import org.yaml.snakeyaml.DumperOptions
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL
import java.io.*
import java.util.Map
import jenkins.util.*
import jenkins.model.*
import static groovy.io.FileType.FILES
import hudson.FilePath
import groovy.io.FileType
import java.util.Calendar
import java.time.YearMonth
import java.text.SimpleDateFormat
import java.nio.charset.StandardCharsets

/**
 * Declaração Variaveis 
 **/

/**
 * score 
 * sonarqube : Peso baseado no quality gates default do sonarqube
 * veracode : Peso baseado que nenhuma aplicação possa ter vulnerabilidade
 * performance : Peso baseado que uma aplicação tenha chegado em extress de 50% dela
 * qa_test : Peso baseado que uma aplicação  tenha passado por todos testes QS
 * sd_test : Peso baseado que uma aplicação  tenha passado por todos testes SD
 * pentest : Peso baseado que uma aplicação tenha os testes de pentest em dias quando necessario
 * waf : Peso baseado que uma aplicação tenha o WAF configurado
 * problem : Peso baseado que uma aplicação tenha problem no snow
 * handover : Peso baseado que uma aplicação tenha no readme melhores práticas de handover
 **/
toolsScore = [
    'sonarqube': ['peso': 80, 'score': 0 , 'analysis_performed' : 'false'],
    'veracode': ['peso': 100, 'score': 0 , 'analysis_performed' : 'false'],
    'performance': ['peso': 20, 'score': 0 , 'analysis_performed' : 'false'],
    'qs_test': ['peso': 100, 'score': 0, 'analysis_performed' : 'false'],
    //'sd_test': ['peso': 1, 'score': 0, 'analysis_performed' : 'false'],
    'gearr': ['peso': 5, 'score': 0, 'analysis_performed' : 'false'],
    'pentest': ['peso': 1, 'score': 0, 'analysis_performed' : 'false'],
    'waf': ['peso': 1, 'score': 0, 'analysis_performed' : 'false'],
    'problem': ['peso': 1, 'score': 0, 'analysis_performed' : 'false'],
    'handover': ['peso': 1, 'score': 0, 'analysis_performed' : 'false']
]
score = 0
thresholdScore = 80
thresholdDropScore = 80

/**
 * packageBasePath
 * Define o base path do package do PiaaS
 **/
packageBasePath = "/opt/infratransac/core/br/com/experian"

/**
 * piaasMainInfo
 * Define instancia da classe PiaasMainInfo
 **/
piaasMainInfo = load "${packageBasePath}/model/PiaasMainInfo.groovy"

/**
 * controllerBuildsJava
 * Define instancia da classe Java
 **/
controllerBuildsJava = load "${packageBasePath}/controller/builds/Java.groovy"

/**
 * controllerBuildsShell
 * Define instancia da classe Shell
 **/
controllerBuildsShell = load "${packageBasePath}/controller/builds/Shell.groovy"

/**
 * controllerBuildsDocker
 * Define instancia da classe Docker
 **/
controllerBuildsDocker = load "${packageBasePath}/controller/builds/Docker.groovy"

/**
 * controllerNotifications
 * Define instancia da classe Notifications
 **/
controllerNotifications = load "${packageBasePath}/controller/notifications/Notifications.groovy"

/**
 * controllerNotificationsEgoc
 * Define instancia da classe Egoc
 **/
controllerNotificationsEgoc = load "${packageBasePath}/controller/notifications/Egoc.groovy"

/**
 * controllerIntegrationsBitbucket
 * Define instancia da classe Bitbucket
 **/
controllerIntegrationsBitbucket = load "${packageBasePath}/controller/integrations/Bitbucket.groovy"

/**
 * controllerIntegrationsEnvs
 * Define instancia da classe ReplaceEnvs
 **/
controllerIntegrationsEnvs = load "${packageBasePath}/controller/integrations/ReplaceEnvs.groovy"

/**
 * controllerIntegrationsTechdocs
 * Define instancia da classe Techdocs
 **/
controllerIntegrationsTechdocs = load "${packageBasePath}/controller/integrations/Techdocs.groovy"

/**
 * controllerTestsPentest
 * Define instancia da classe Pentest
 **/
controllerTestsPentest = load "${packageBasePath}/controller/tests/Pentest.groovy"

/**
 * controllerTestsWaf
 * Define instancia da classe WAF
 **/
controllerTestsWaf = load "${packageBasePath}/controller/tests/Waf.groovy"

/**
 * controllerTestsPerformance
 * Define instancia da classe Performance
 **/
controllerTestsPerformance = load "${packageBasePath}/controller/tests/Performance.groovy"

/**
 * controllerTestsQuality
 * Define instancia da classe Quality
 **/
controllerTestsQuality = load "${packageBasePath}/controller/tests/Quality.groovy"

/**
 * controllerTestsDeliveryReliability
 * Define instancia da classe Performance
 **/
controllerTestsDeliveryReliability = load "${packageBasePath}/controller/tests/DeliveryReliability.groovy"

/**
 * controllerTestsSonarqube
 * Define instancia da classe Quality
 **/
controllerTestsSonarqube = load "${packageBasePath}/controller/tests/Sonarqube.groovy"

/**
 * controllerTestsHadolint
 * Define instancia da classe Hadolint
 **/
controllerTestsHadolint = load "${packageBasePath}/controller/tests/Hadolint.groovy"

/**
 * serviceSecuritySast
 * Define instancia da classe Sast
 **/
serviceSecuritySast = load "${packageBasePath}/service/security/Sast.groovy"

/**
 * serviceSecurityValidations
 * Define instancia da classe SecurityValidations
 **/
serviceSecurityValidations = load "${packageBasePath}/service/security/SecurityValidations.groovy"

/**
 * serviceDeployAnsible
 * Define instancia da classe Ansible
 **/
serviceDeployAnsible = load "${packageBasePath}/service/deploy/Ansible.groovy"

/**
 * serviceDeployBatch
 * Define instancia da classe Ansible
 **/
serviceDeployBatch = load "${packageBasePath}/service/deploy/Batch.groovy"

/**
 * serviceDeployOsgi
 * Define instancia da classe Ansible
 **/
serviceDeployOsgi = load "${packageBasePath}/service/deploy/Osgi.groovy"

/**
 * serviceDeployKubernetes
 * Define instancia da classe Kubernetes
 **/
serviceDeployKubernetes = load "${packageBasePath}/service/deploy/Kubernetes.groovy"

/**
 * serviceDeployNexus
 * Define instancia da classe Nexus
 **/
serviceDeployNexus = load "${packageBasePath}/service/deploy/Nexus.groovy"

/**
* serviceDeployEcr
* Define instancia da classe Ecr
**/
serviceDeployEcr = load "${packageBasePath}/service/deploy/Ecr.groovy"

/**
* serviceDeployMiddleware
* Define instancia da classe Ecr
**/
serviceDeployMiddleware = load "${packageBasePath}/service/deploy/Middleware.groovy"

/**
 * serviceGovernanceApplication
 * Define instancia da classe Application
 **/
serviceGovernanceApplication = load "${packageBasePath}/service/governance/Application.groovy"

/**
 * serviceGovernanceErrorBudget
 * Define instancia da classe ErrorBudget
 **/
serviceGovernanceErrorBudget = load "${packageBasePath}/service/governance/ErrorBudget.groovy"

/**
 * serviceGovernanceItil
 * Define instancia da classe Itil
 **/
serviceGovernanceItil = load "${packageBasePath}/service/governance/Itil.groovy"

/**
 * serviceGovernanceMetrics
 * Define instancia da classe Metrics
 **/
serviceGovernanceMetrics = load "${packageBasePath}/service/governance/Metrics.groovy"

/**
 * serviceGovernancePiaasValidation
 * Define instancia da classe PiaasValidation
 **/
serviceGovernancePiaasValidation = load "${packageBasePath}/service/governance/PiaasValidation.groovy"

/**
 * serviceGovernanceScore
 * Define instancia da classe Score
 **/
serviceGovernanceScore = load "${packageBasePath}/service/governance/Score.groovy"

/**
 * serviceGovernanceTeam
 * Define instancia da classe Team
 **/
serviceGovernanceTeam = load "${packageBasePath}/service/governance/Team.groovy"

/**
 * utilsDateLib
 * Define instancia da classe utilsDateLib
 **/
utilsDateLib = load "${packageBasePath}/utils/DateLib.groovy"

/**
 * utilsMessage
 * Define instancia da classe MessageLib
 **/
utilsMessageLib = load "${packageBasePath}/utils/MessageLib.groovy"

/**
 * utilsRestLib
 * Define instancia da classe RestLib
 **/
utilsRestLib = load "${packageBasePath}/utils/RestLib.groovy"

/**
 * utilsJsonLib
 * Define instancia da classe JsonLib
 **/
utilsJsonLib = load "${packageBasePath}/utils/JsonLib.groovy"

/**
 * utilsUserInputLib
 * Define instancia da classe UserInputLib
 **/
utilsUserInputLib = load "${packageBasePath}/utils/UserInputLib.groovy"

/**
 * utilsMapLib
 * Define instancia da classe MapLib
 **/
utilsMapLib = load "${packageBasePath}/utils/MapLib.groovy"

/**
 * utilsIamLib
 * Define instancia da classe IamLib
 **/
utilsIamLib = load "${packageBasePath}/utils/IamLib.groovy"

/**
 * utilsLanguageLib
 * Define instancia da classe LanguageLib
 **/
utilsLanguageLib = load "${packageBasePath}/utils/LanguageLib.groovy"

/**
 * script3rdParty
 * Define script 3rd party
 * @var array
 **/
script3rdParty = ''

/**
 * tribe
 * Define a tribe da aplicação
 * @var string
 **/
tribe = ''

/**
 * squad
 * Define a squad da aplicação
 * @var string
 **/
squad = ''

/**
 * jiraKey
 * Define o jiraKey da aplicação
 * @var string
 **/
jiraKey = ''

/**
 * gearrDependencies
 * Define o gearrDependencies da aplicação
 * @var string
 **/
gearrDependencies = ''

/**
 * gearrBusinessCriticality
 * Define o gearrBusinessCriticality da aplicação
 * @var string
 **/
gearrBusinessCriticality = ''

/**
 * cmdbDependencies
 * Define o cmdbDependencies da aplicação
 * @var string
 **/
cmdbDependencies = ''

/**
 * language
 * Define a linguagem da aplicação
 * @var string
 **/
def language = ''

/**
 * running variables
 * Define onde a esteira irá rodar
 **/
running      = 'master'
slaveRunning = ''
cmdExecSlave = ''

/**
 * version
 * Define versão do pipeline
 * @var string
 **/
def version = ''

/**
 * pipeline
 * Define o pipeline da aplicação
 * @var string
 **/
def pipeline = ''

/**
 * applicationName
 * Define o Nome da aplicação 
 * @var string
 **/
def applicationName = ''

/**
 * clusterName
 * Define o nome do cluster EKS
 * @var string
 **/
clusterName = []

/**
* codigosDL
* Define os códigod DL's capturados
* @var string
**/
codigosDL = new HashSet()

/**
 * artifactId
 * Define o artifactId da aplicação 
 * @var string
 **/
def artifactId = ''

/**
 * groupId
 * Define o groupId da aplicação 
 * @var string
 **/
def groupId = ''

/**
 * gitPullRequestID
 * Define o Pull request ID da aplicação 
 * @var string
 **/
def gitPullRequestID = ''

/**
 * jdk
 * Define o jdk nas compilações java
 * @var string
 **/
jdk = ''

/**
 * languageName
 * Define o languageName das linguagens
 * @var string
 **/
languageName = ''

/**
 * languageVersion
 * Define o languageVersion das linguagens
 * @var string
 **/
languageVersion = ''

/**
 * toolsVersion
 * Define o ToolsVersion nas compilações dotnet
 * @var string
 **/
tv = ''

/**
 * dotNetDeploys
 * Define os deploy a seram feitos no iis
 * @var array
 **/
dotNetDeploys = []

/**
 * typePackage
 * Define o tipo de pacote gerado nas compilações
 * @var string
 **/
typePackage = ''

/**
 * sonarScanStatus
 * Define a validacao ok ou nok do sonar only scan
 * @var string
 **/
sonarScanStatus = true

/**
 * packageArtifact
 * Define o packageArtifact gerado nas compilações
 * @var string
 **/
packageArtifact = ''

/**
 * fileDetailsApp
 * Define o objeto do arquivo com os detalhes aplicação
 * @var object
 **/
def fileDetailsApp = ''

/**
 * versionApp
 * Define a versão da aplicação 
 * @var string
 **/
def versionApp = ''

/**
 * type
 * Define o tipo de aplicaçao
 * @var string
 **/
type = ''

/**
 * idPiaasEntityExec
 * Define o id da execução corrente gravada por POST
 * @var string
 **/
idPiaasEntityExec = '0'

/**
 * envJobName
 * Define o ambiente da execução
 * @var string
 **/
envJobName = "PiaaS"

/**
 * ecrRegistry
 * Define o ECR do PiaaS
 * @var string
 **/
ecrRegistry = (piaasEnv == "prod") ? '707064604759.dkr.ecr.sa-east-1.amazonaws.com/' : '559037194348.dkr.ecr.sa-east-1.amazonaws.com/'

/**
 * piaasMvnBuilderImage
 * Imagem utilizadas para execuções Mvn
 * @var string
 **/
piaasMvnBuilderImage = "${ecrRegistry}piaas-mvn-builder:latest"

/**
 * git variables
 * Define as variaveis utilizadas quando o scm for git
 **/
def gitRepo = ''
def gitBranch = ''
def gitCommit = ''
def gitMsgCommit = ''
def gitAuthor = ''
gitAuthorEmail = ''
def gitUrlPullRequest = ''
flagPullRequestCreated = 0
def detectSecretsResp = ''
def titleUser = ''

/**
 * outsystem variables
 * Define as variaveis utilizadas para outsystem deploy
 **/
def outsystemResp = ''
def outsystemApplicationName = ''
def outsystemApplicationKey = ''
def outsystemEnvironment = ''
def outsystemEnvironmentKey = ''

/**
 * pentest variables
 * Define as variaveis utilizadas para pentest
 **/
pentestStatus = ''
pentestComplianceStatus = ''

/**
 * waf variables
 * Define as variaveis utilizadas para waf
 **/
wafStatus = ''
wafActive = ''
wafComplianceStatus = ''

/**
 * psa variables
 * Define as variaveis utilizadas para psa
 **/
psaReport = '/opt/infratransac/core/psa/report-psa-normalizado.csv'
psaGearrId = 'NAO_LOCALIZADO'
psaProjectName = 'NAO_LOCALIZADO'
psaProjectId = 'NAO_LOCALIZADO'
psaProjectName = 'NAO_LOCALIZADO'
psaTargetGoLiveDate = 'NAO_LOCALIZADO'
psaProjectStatus = 'NAO_LOCALIZADO'
psaSignificantChange = ''

/**
 * changeorder variables
 * Define as variaveis utilizadas para changeorder
 **/
flagChangeOrderCreated = 0
changeorderAuthorized = 0 
def changeorderNumberProduction = ''
changeorderNumber = ''
changeorderJustification = ''
changeorderTemplate = ''
changeorderMavRoom = 'no'
changeorderMavRoomGroups = '28ed2503db086c9493b479403996191c 95a47983db186b801a5b3b2ffe9619db ba106d36dbdb481093b4794039961944 c4bcf8f21bc8bc5876a13c66464bcb9c f81ce5d0db60f7800c977940399619a2'
changeorderBrScan = 'no'
changeorderBrScanGroups = 'Brazil - DA IDF - OI/TIM Brazil IDF Squad Mobile Brazil - DA IDF - Squad Claro Brazil IDF Biometria Brazil - DA IDF - Squad Vivo Brazil - DA IDF - Data Science Brazil - DA IDF - BrFlow / BrSafe - Brazil IDF Documentoscopia - IDF Mobile Solutions'
changeorderHowto = 'https://pages.experian.com/pages/viewpage.action?pageId=1033936437'
changeorderCreatedState = '-3'
changeorderBusinessService = ''
changeorderCategory = 'Applications Software'
changeorderAssignmentGroup = ''
changeorderAssignedTo = ''
changeorderSummary = ''
changeorderDescription = ''
changeorderTestResult = ''
changeorderRelatedIncident = ''
changeorderUEnvironment = ''
changeorderUSysOutage = 'no'
changeorderStartDate= '' 
changeorderEndDate=''
changeorderRiskImpactAnalysis = ''
changeorderRollout = 'N/S'
changeorderRollback = 'Em caso da implementação não surtir o efeito esperado, deverá ser executado  um novo deploy da aplicação. Este deploy poderá ser de uma nova versão com os devidos ajustes ou com a versão anterior.'
changeorderConfigItens = ''
changeorderState = ''
changeorderVersion = ''
changeorderRequirements = ''
changeorderCloseCode='successful'
changeorderCloseNotes=''
changeorderWorkStart=''
changeorderWorkEnd=''
changeorderClient = "${packageBasePath}/service/governance/snow.sh"
exceptionListFlag = false
flagChangeOrder = false

/**
 * urlBaseJenkins
 * Define a url base do jenkins
 * @var string
 **/
urlBaseJenkins = (piaasEnv == "prod") ? 'https://piaas.devsecops-paas-prd.br.experian.eeca/job/PiaaS' : 'https://piaas.sandbox-devsecops-paas.br.experian.eeca/job/PiaaS'

/**
 * urlBaseHelpCore
 * Define a url base da ajuda do core
 * @var string
 **/
urlBaseHelpCore = 'https://code.experian.local/projects/EDVP/repos/core-help/'

/**
 * urlPackageNexus
 * Define a url base do nexus
 * @var string
 **/
urlPackageNexus = ''

/**
 * urlPipeline
 * Define a url do pipeline 
 * @var string
 **/
def urlPipeline = ''

/**
 * urlOpenshiftToken
 * Define a url do Openshift Token
 * @var string
 **/
def urlOpenshiftToken = ''

/**
 * sonar variables
 * Define as variaveis do sonar
 **/
sonarEnv = ''
sonarUrl = ''
sonarProfile = ''
def sonarProjectStatus = ''
def sonarAllowedPercentage = ''
def sonarQualityGatesThreshold = ''
def sonarQualityGatesActualValue = ''
sonarQualityGatesDescription = ''
flagJdkSonarWorker = ''
sonarOnlyScan = true

/**
 * apigee variables
 * Define as variaveis do apigee
 **/
apigeeProxy = ''
flagChangedSwagger = ''

/**
 * cucumber variables
 * Define as variaveis do jmeter
 **/
cucumberUrlReports = ''

/**
 * Quality variables
 * Define as variaveis testes de qualidade
 **/
qsTestUrlReports = ''

/**
 * jmeter variables
 * Define as variaveis do jmeter
 **/
jmeterUrlReports = ''

/**
 * veracode variables
 * Define as variaveis do veracode
 **/
veracodeUrlReports = ''

/**
 * respInput
 * Recebe resposta de input de usuário
 * @var string
 **/
respInput = ''

/**
 * userInput
 * Define input de usuário
 * @var string
 **/
def userInput = ''

/**
 * emailMsg
 * Recebe corpo dos email
 * @var string
 **/
def emailMsg = ''

/**
 * scriptExecOut
 * Recebe resposta de output da execução de script
 * @var string
 **/
def scriptExecOut = ''

/**
 * env
 * Pega todas as variaveis de ambiente
 * @var array
 **/
def env = ''

/**
 * environmentName
 * Define o Environment de deploy (develop/qa/prod) com base na branch
 * @var string
 **/
def environmentName = ''

/**
 * release
 * Define o Environment de deploy (develop/qa/prd) com base na branch
 * @var string
 **/
def release = ''

/**
 * fileName
 * Define o arquivo yml para leitura
 * @var string
 **/
final String fileName = ''

/**
 * mapResult3rdParty
 * Recebe do mapa de dados do para passagem de parametros ao componentes 3rdParty
 * @var string
 **/
def mapResult3rdParty = ''

/**
 * mapResult
 * Recebe leitura do mapa de dados do yml 
 * @var string
 **/
def mapResult = ''

/**
 * errorPipeline
 * Messagem de erro da esteira
 * @var string
 **/
def errorPipeline = ''

/**
 * helpPipeline
 * Ajuda da solução do erro
 * @var string
 **/
def helpPipeline = ''

/**
* gearrDetails
* Define os detalhes de um Gearr
* @var string
**/
gearrDetails = ''

/**
* appErrorBudgetData
* Define se app esta em Error Budget Data
* @var bool
**/
appErrorBudgetData = false

/**
* Hadoop Variables
* Define variaveis para o metodo Hadoop
* @var string
**/
def hadoopDirPath = ''

/**
* Apollo11 variables
* Define se a aplicação foi criada a partir do Apollo11
* @var bool
**/
madeByApollo11 = false

/**
 * Inicializando variáveis
 **/
env = System.getenv()
sonarUrl = "https://sonarqube.devsecops-paas-prd.br.experian.eeca"
sonarProfile = ''

/**
 * core
 * Método faz o controle dos stage's de fluxo
 * @version 8.0.0
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def core() {
    echo "Invoking function core"

    try {
        dir(currentBuild.number.toString()) {
            checkout()
            coreBoot()            

            if ((mapResult.application != null) && (mapResult.team != null)) {
                stage('application') {
                    serviceGovernanceApplication.application()
                }
                stage('team') {
                    serviceGovernanceTeam.team()
                }
            }
            else {
                piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_000'
                utilsMessageLib.errorMsg("Could not load data map for application or team info in file '${fileName}'? Or is not correct?")
                currentBuild.description = "Could not load data map file piaas.yml, or is not correct"
                errorPipeline = "Could not load data map for application or team info in file ${fileName}? Or is not correct?"
                helpPipeline = "Verifique se em seu piaas.yml existe as configurações para a aplicação ou o time, caso não exista crie a entrada ou se existir verifique se esta correta."
                echo "Solucao: ${helpPipeline}"
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }

            stage('governance') {
                echo "Start stage : [GOVERNANCE]"
                serviceGovernanceApplication.piaasEntityApi('RUNNING')
                serviceGovernancePiaasValidation.pipelineValidation()
                serviceGovernanceItil.changeOrderValidation()
            }

            if (mapResult['branches'][gitBranch] != null) {
                mapResult = mapResult['branches'][gitBranch]
            } else if ( (gitBranch.contains("feature/")) && (mapResult['branches']['feature*'] != null) ) {
                mapResult = mapResult['branches']['feature*']
            } else {
                piaasMainInfo.pipeline_code_error  = 'ERR_START_STEPS_000'
                utilsMessageLib.errorMsg("Could not load data map for branch '${gitBranch}' in file '${fileName}'? Or is not correct?")
                currentBuild.description = "Could not load data map file piaas.yml, or is not correct"
                errorPipeline = "Could not load data map for branch ${gitBranch} in file ${fileName}? Or is not correct?"
                helpPipeline = "Verifique se em seu piaas.yml existe as configurações para a branch ${gitBranch} caso não exista crie a entrada ou se existir verifique se esta correta."
                echo "Solucao: ${helpPipeline}"
                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }

            controllerTestsHadolint.hadolintCheck()
            startSteps()

            if ( ( language == "cobol" ) || ( language == "assembly" ) || ( language == "bms" ) || ( language == "c++" ) ) {
                piaasMainInfo.pipeline_code_error  = '00'
                serviceGovernanceApplication.piaasEntityApi('SUCCESS')
            } else {
                serviceGovernanceApplication.piaasEntityApi('SUCCESS')
            }

            currentBuild.description = "Success in DevSecOps"
            controllerIntegrationsBitbucket.setBitbucketStatus("SUCCESSFUL")

        }
    } catch (err) {
        echo "Code Error " + piaasMainInfo.pipeline_code_error
        controllerNotifications.houstonWeHaveAProblem()
        echo "Search our Help in " + urlBaseHelpCore 
        controllerIntegrationsBitbucket.setBitbucketStatus("FAILED")
        currentBuild.description = "Code Error " + piaasMainInfo.pipeline_code_error
        
        piaasMainInfo.score = 0
        if ( gitAuthorEmail != "" ) {
            serviceGovernanceApplication.piaasEntityApi('FAILURE')
        } else {
            utilsMessageLib.warnMsg("Impossível enviar para a API de Entidade do PiaaS o status de falha.")
        }

        throw err

    }
    finally {
        try {
            pathBuildLog = new File("/opt/infratransac/jenkins/jobs/${envJobName}/builds/${currentBuild.number.toString()}/log")
            stringValAborted = 'Aborted by'
            validAborted = pathBuildLog.text.contains(stringValAborted)
    
            if ( validAborted ) {
                if ( !(pipeline.equals('')) && (idPiaasEntityExec == '0') ) {
                    serviceGovernanceApplication.piaasEntityApi('ABORTED')
                }
                else if ( idPiaasEntityExec != '0' ) {
                    serviceGovernanceApplication.piaasEntityApi('ABORTEDPut')
                }
            }
        }
        catch (err) {
            echo "Error: ${err}"
        }

    }
}

/**
 * coreBoot
 * Inicialização do core 
 * @version 8.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def coreBoot() {
    echo "Invoking function coreBoot"
    urlPipeline                           = urlBaseJenkins + '/' + currentBuild.number + '/console'
    piaasMainInfo.pipeline_code_execution = currentBuild.number
    
    try {
        fileName = WORKSPACE + '/' + currentBuild.number + '/piaas.yml'
        result = readYaml file: fileName
        mapResult = result
        mapResult3rdParty = result['application']
        echo "Definitions of the pipeline ${fileName} loaded successfully, initiating get flows!"
    } catch (err) {
        utilsMessageLib.errorMsg("Could not load data map. Does this file '${fileName}' exist? Or is correct?")
        utilsMessageLib.errorMsg("Or this file '${fileName}' is correct sintaxe yaml? To valide file http://www.yamllint.com/")
        currentBuild.description = "Could not load data map file piaas.yml, or is not correct"
        errorPipeline = "Could not load data map. Does this file piaas.yml exist? Or is correct?"
        helpPipeline = "Verifique se em seu piaas.yml existe ou está correto em seu repositório, use o validador para validação de sintaxe http://www.yamllint.com/."
        piaasMainInfo.pipeline_code_error  = 'ERR_COREBOOT_000'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }
}

/**
 * startSteps
 * Método execução do start dos step's do pipeline
 * @version 8.8.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def startSteps() {
    echo "Invoking function startSteps"

    if ( (type == "lib") || (type == "test") ) {
        piaasMainInfo.pipeline_code_error = 'ERR_STARTSTEPS_000'

        utilsMessageLib.warnMsg("Start step for libraries and test in small mode")

        utilsMessageLib.warnMsg("For libraries and test remove in score pentest/waf/qs_test/performance")
        toolsScore.remove('pentest')
        toolsScore.remove('waf')
        toolsScore.remove('qs_test')
        toolsScore.remove('performance')

        mapResult.each { key, value ->
            switch (key.toLowerCase()) {
                case "version":
                    break
                case "application":
                    break
                case "before_build":
                    stage('before_build') {
                        before_build()
                    }
                    break
                case "build":
                    stage('build') {
                        build()
                    }
                    break
                case "after_build":
                    stage('after_build') {
                        after_build()
                    }
                    break
                case "notifications":
                    break
                default:
                    utilsMessageLib.errorMsg("Implementation '${key}' not performed :(")
            }
        }
    }
    else if ( (type == "parent") ) {
        piaasMainInfo.pipeline_code_error = 'ERR_STARTSTEPS_000'

        utilsMessageLib.warnMsg("Start step for parents in small mode")

        utilsMessageLib.warnMsg("For libraries and test remove in score pentest/waf/qs_test/performance/veracode/sonarqube")
        toolsScore.remove('pentest')
        toolsScore.remove('waf')
        toolsScore.remove('qs_test')
        toolsScore.remove('performance')
        toolsScore.remove('veracode')
        toolsScore.remove('sonarqube')

        mapResult.each { key, value ->
            switch (key.toLowerCase()) {
                case "version":
                    break
                case "application":
                    break
                case "build":
                    stage('build') {
                        build()
                    }
                    break
                case "notifications":
                    break
                default:
                    utilsMessageLib.errorMsg("Implementation '${key}' not performed :(")
            }
        }
    } 
    else {
        mapResult.each { key, value ->
            switch (key.toLowerCase()) {
                case "version":
                    break
                case "application":
                    break
                case "install":
                    stage('install') {
                        install()
                    }
                    break
                case "before_build":
                    stage('before_build') {
                        before_build()
                    }
                    break
                case "build":
                    stage('build') {
                        build()
                    }
                    break
                case "after_build":
                    stage('after_build') {
                        after_build()
                    }
                    break
                case "before_deploy":
                    stage('before_deploy') {
                        before_deploy()
                    }
                    break
                case "deploy":
                    stage('deploy') {
                        deploy()
                    }
                    break
                case "after_deploy":
                    stage('after_deploy') {
                        after_deploy()
                    }
                    break
                case "notifications":
                    break
                default:
                    utilsMessageLib.errorMsg("Implementation '${key}' not performed :(")
            }
        }
    }

    stage('techdocs') {
        controllerIntegrationsTechdocs.techdocs()
    }

    /*if (mapResult.notifications != null) {
        stage('notifications') {
            notifications()
        }
    }*/

    try {
        if (gitBranch == "master") {
            sh(script: "git tag -a v${versionApp} -m 'Version: ${versionApp}'", returnStdout: false)
            sh(script: "git push origin --tags", returnStdout: false)
            echo "Tag ${versionApp} successfully created"
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Sorry, could not create a tag. Please do the creation manually")
    }

    try {
        if ( (type != "lib") && (type != "test") && (type != "parent") && (gitBranch.contains("master")) ) {
            if ( ( language == "cobol" ) || ( language == "assembly" ) || ( language == "bms" ) || ( language == "c++" ) ) {
                echo "Ignore close change order ${changeorderNumber}, because is mainframe package"
            } 
            else if ( piaasMainInfo.deployment_strategy == "not_implement" ) {
                changeorderCloseNotes = "Implantação realizada de forma automatizada pelo pipeline:" + urlPipeline
                changeorderWorkEnd    = new Date().format("yyyy-MM-dd HH:mm:ss")
                piaasMainInfo.change_order_work_end = changeorderWorkEnd
                utilsMessageLib.infoMsg("Fim da implantação em ${changeorderWorkEnd}")
                utilsMessageLib.infoMsg("Fechando a Change Order ${changeorderNumber}")
                sh(script: "${changeorderClient} --action=close-change \
                                                 --number-change=${changeorderNumber} \
                                                 --close-code='${changeorderCloseCode}' \
                                                 --close-notes='${changeorderCloseNotes}' \
                                                 --work-start='${changeorderWorkStart}' \
                                                 --work-end='${changeorderWorkEnd}'", returnStdout: false)
                
            } else {
                utilsMessageLib.warnMsg("The change order ${changeorderNumber} needs to close manually. This application is using Deployment Strategy.")
            }
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Sorry, could not close change order ${changeorderNumber}. Please close manually")
    }

    try {
        if (gitBranch.contains("master")) {
            controllerNotificationsEgoc.egocSendOmInfos()
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Ops, error in send post for egoc team about this implementation" + err) 
    }
    
    try {
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('endPipeline')
        }
    } catch (err) {
        utilsMessageLib.warnMsg("Card not sent in function endPipeline")
    }

}

/**
 * checkout
 * Método faz o checkout da branch para workspace do jenkins
 * @version 8.27.0
 * @package DevOps
 * @author  Yros Pereira Aguiar Batista <Yros.Aguiar@br.clara.net>
 * @change  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def checkout() {
    echo "Invoking function checkout"

    def gitHashBranch = ''
    piaasMainInfo.date_execution_start = new Date().format("yyyy-MM-dd HH:mm:ss")
    piaasMainInfo.pipeline_code_error  = 'ERR_CHECKOUT_000'

    if (type == "outsystem") {
        utilsMessageLib.infoMsg("Start Outsystem DevSecOps o/")

        outsystemResp = sh(script: "/opt/infratransac/core/bin/deploy.sh --target=outsystem --method=getenvironmets|tail -1", returnStdout: true)
        outsystemResp = outsystemResp.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "").replaceAll(";", "\n")
        echo "Question for user: Choose the environment to deploy"
        utilsUserInputLib.selectedProperty("Choose the environment to deploy", outsystemResp, "outsystemEnvironment", 180)
        echo "Answer informed: '${respInput}'"

        respInput = respInput.split(":")
        outsystemEnvironment = respInput[0]
        outsystemEnvironmentKey = respInput[1]
        if (outsystemEnvironment == "Homologacao") {
            gitBranch = 'qa'
        } else if (outsystemEnvironment == "Producao") {
            gitBranch = 'master'
        } else {
            utilsMessageLib.errorMsg("Ops, environment development not allowed deploy for outsystem")
            throw err
        }

        outsystemResp = ''
        outsystemResp = sh(script: "/opt/infratransac/core/bin/deploy.sh --target=outsystem --method=getapplications|tail -1", returnStdout: true)
        outsystemResp = outsystemResp.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "").replaceAll(";", "\n")
        echo "Question for user: Choose the application to deploy in ${outsystemEnvironment}"
        utilsUserInputLib.selectedProperty("Choose the application to deploy in ${outsystemEnvironment}", outsystemResp, "outsystemApplicationName", 180)
        echo "Answer informed: '${respInput}'"

        respInput = respInput.split(":")
        outsystemApplicationName = respInput[0]
        outsystemApplicationKey = respInput[1]

        writeFile file: 'piaas.yml', text: """---
version: 6.0.0
global:
  application: ${outsystemApplicationName}
  type: outsystem
  language: outsystem
  tribe: shared service
qa:
  build:
    outsystem:
  deploy:
    outsystem:
  notifications:
    changeorder: normal
master:
   build:
     outsystem:
   deploy:
      outsystem:"""
    } else {
        utilsMessageLib.infoMsg("Checkout GIT with values: GIT_REPO=${gitRepo} and GIT_BRANCH=${gitBranch}")
        sh "git clone -b ${gitBranch} ${gitRepo} ${WORKSPACE}/${currentBuild.number} && \
            git checkout -f ${gitCommit} 2>/dev/null && \
            git rev-list --no-walk ${gitCommit} && \
            git rev-parse --verify HEAD && \
            git reset --hard && \
            git clean -fdx && \
            git log -n1 ${gitCommit}"
        
        if ( ( gitBranch.contains('qa') ) || ( gitBranch.contains('uat') ) ) {
            echo "For branch qa and uat invoke pull request details"
            controllerIntegrationsBitbucket.getPullRequestID()
            if ( ! gitPullRequestID.isNumber() ) {
                errorMsg ("Seu commit não tem origem de uma PR. Abortando execução.")
                throw err
            }
            else {
                controllerIntegrationsBitbucket.getPRDetails(gitPullRequestID)
            }
        }
        else if ( ( gitBranch.contains('master') ) || ( gitBranch.contains('main') ) ) {
            echo "For branch master or main invoke leadtime details"
            serviceGovernanceMetrics.getLeadTime()
        }

        echo "Set details for commit"
        gitAuthor = sh(script: "git --no-pager show -s --format='%an' ${gitCommit}", returnStdout: true)
        gitAuthor = gitAuthor.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

        gitAuthorEmail = sh(script: "git --no-pager show -s --format='%ae' ${gitCommit}", returnStdout: true)
        gitAuthorEmail = gitAuthorEmail.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")

        gitMsgCommit = sh(script: "git log -n1 ${gitCommit} | sed -e '/commit/d'| sed -e '/Merge/d'| awk 'NF>0'|grep -v 'SYNC'", returnStdout: true)
        gitMsgCommit = gitMsgCommit.replaceAll("'", " ")

        titleUser = sh(script: "${packageBasePath}/utils/getUserInfo.sh ${gitAuthorEmail} title", returnStdout: true).toUpperCase().trim()

        piaasMainInfo.author       = gitAuthor
        piaasMainInfo.author_email = gitAuthorEmail
        piaasMainInfo.author_title = titleUser
        piaasMainInfo.repository   = gitRepo
    }

    if ( gitBranch.contains('master') ) {
        gitHashBranch = sh(script: "git rev-parse ${gitBranch}", returnStdout: true)
        gitHashBranch = gitHashBranch.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
        if ( ! gitHashBranch.contains(gitCommit) ) {
            utilsMessageLib.errorMsg("Commit informado diferente do último commit da branch master. Abortando execução.")
            piaasMainInfo.pipeline_code_error  = 'ERR_CHECKOUT_001'
            throw err    
        }
    }
}

/**
 * install
 * Método execução de stage install
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def install() { 
    piaasMainInfo.pipeline_code_error  = 'ERR_INSTALL_000'

    echo "Start stage : [INSTALL]"
    mapResult.install.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "ansible":
                piaasMainInfo.pipeline_code_error  = 'ERR_INSTALL_ANSIBLE_000'
                ansible(value, 'install')
                break
            case "playbook":
                piaasMainInfo.pipeline_code_error  = 'ERR_INSTALL_PLAYBOOK_000'
                playbook(value)
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_INSTALL_SCRIPT_000'
                echo "Start script to stage [INSTALL]"
                controllerBuildsShell.script(value, 'install')
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_INSTALL_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in install stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.install(value)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in install stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * before_build
 * Método execução de stage before_build
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def before_build() {
    piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_000'
    
    echo "Start stage : [BEFORE_BUILD]"
    mapResult.before_build.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "dependguard":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_DEPENDGUARD_000'
                dependguard(value)                    
                break
            case "mvn":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_MVN_000'
                controllerBuildsJava.compilationMvn(value)
                break
            case "sonarqube":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SONARQUBE_000'
                controllerTestsSonarqube.sonarqubeTest(value)                    
                break
            case "veracode":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_VERACODE_000' 
                serviceSecuritySast.veracode(value, 'before_build')
                break
            case "setenv":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SETENV_000'
                controllerIntegrationsEnvs.setenv(value)
                break
            case "rpfs":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_RPFS_000'
                rpfs(value)
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_SCRIPT_000'
                echo "Start script to stage [BEFORE_BUILD]"
                controllerBuildsShell.script(value, 'before_build') 
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_BUILD_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in before_build stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.before_build(value)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in before_build stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * build
 * Método execução de stage build
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def build() {
    piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_000'

    echo "Start stage : [BUILD]"
    mapResult.build.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "mvn":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_JAVA_SCALA_000'
                controllerBuildsJava.compilationMvn(value)
                break
            case "docker":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_DOCKER_000'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Builds for Docker"
                    for ( item in value ) { 
                        item = controllerIntegrationsEnvs.setTemplateEngines(item)
                        controllerBuildsDocker.compilationDocker(item)
                    }
                } else {
                    controllerBuildsDocker.compilationDocker(value)
                }
                break
            case "docker-z":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_DOCKERZ_000'
                controllerBuildsDocker.compilationDockerZ(value)
                break
            case "hadouken":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_HADOUKEN_000'
                hadouken(value)
                break
            case "tar":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_TAR_000'
                controllerBuildsShell.tar(value)
                break
            case "zip":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_ZIP_000'
                controllerBuildsShell.zip(value)
                break
            case "slave": 
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_SLAVE_000'
                runningSlave(value)
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_BUILD_SCRIPT_000'
                echo "Start script to stage [BUILD]"
                controllerBuildsShell.script(value, 'build')
                break
            default:
                try {
                    script3rdParty = ''
                    echo "Running in build stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.build(value,mapResult3rdParty)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in build stage not performed or error in function '${key}' 3rd Party")
                    piaasMainInfo.pipeline_code_error  = "ERR_BUILD_" + key.toUpperCase() + "_000"
                    println(err)
                    throw err
                }
        }
    }
}


/**
 * after_build
 * Método execução de stage after_build
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def after_build() {
    piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_000'

    echo "Start stage : [AFTER_BUILD]"
    mapResult.after_build.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "veracode":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_VERACODE_000'
                serviceSecuritySast.veracode(value, 'after_build')
                break
            case "nexus":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_NEXUS_000'
                serviceDeployNexus.nexus()
                break
            case "ecr":
                piaasMainInfo.pipeline_code_error  = 'ERR_PUSH_ECR_000'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for AWS ECR enabled"
                    for ( item in value ) {
                        serviceDeployEcr.ecr(item)
                    }
                } else {
                    serviceDeployEcr.ecr(value)
                }
                break
            case "sonarqube":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_SONAR_000'
                echo "Running sonarqube test in Master"
                controllerTestsSonarqube.sonarqubeTest(value)    
                break
            case "helm":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_HELM_000'
                def flagEksScoreAvg = 0
                def flagEksScoreRes = 0
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for AWS Helm enabled"
                    for ( item in value ) {
                        flagEksScoreAvg += serviceDeployKubernetes.helm(item) 
                    }
                    flagEksScoreRes = Math.round(flagEksScoreAvg / value.size())
                    piaasMainInfo.eks_policy_score = String.valueOf(flagEksScoreRes)
                    utilsMessageLib.infoMsg("The average EKS Policy score of '${value.size}' deployments was '${flagEksScoreRes}'")
                } else {
                    flagEksScoreAvg = serviceDeployKubernetes.helm(value) 
                    piaasMainInfo.eks_policy_score = String.valueOf(flagEksScoreAvg)
                }
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_SCRIPT_000'
                echo "Start script to stage [AFTER_BUILD]"
                controllerBuildsShell.script(value, 'after_build')
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_BUILD_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in after_build stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.after_build(value)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in after_build stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * before_deploy
 * Método execução de stage before_deploy 
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def before_deploy() {
    piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_000'

    echo "Start stage : [BEFORE_DEPLOY]"
    mapResult.before_deploy.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_SCRIPT_000'
                echo "Start script to stage [BEFORE_DEPLOY]"
                controllerBuildsShell.script(value, 'before_deploy')
                break
            case "minify":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_MINIFY_000'
                echo "Start parser minifier for files"
                minify(value)
                break
            case "ansible":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_ANSIBLE_000'
                ansible(value, 'before_deploy')
                break
            case "jcl":
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_JCL_000'
                jcl(value)
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_BEFORE_DEPLOY_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in before_deploy stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.before_deploy(value)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in before_deploy stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * deploy
 * Método execução de stage deploy 
 * @version 8.31.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def deploy() {
    piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_000'

    echo "Start stage : [DEPLOY]"

    mapResult.deploy.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "was":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_WAS_000'
                piaasMainInfo.type_deploy = 'was'
                if (value.getClass().toString().contains("class java.util.ArrayList") ){
                    utilsMessageLib.infoMsg("Multiple Deploy for Was enabled.")
                    for ( item in value ) {
                        serviceDeployMiddleware.was(item)
                    }
                } else {
                    serviceDeployMiddleware.was(value)
                }  
                break
            case "iis":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_IIS_000'
                piaasMainInfo.type_deploy = 'iis'
                iis(value)
                break
            case "openshift":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_OPENSHIFT_000'
                piaasMainInfo.type_deploy = 'openshift'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    utilsMessageLib.infoMsg("Multiple Deploy for openshift enabled")
                    for ( item in value ) {
                        openshift(item)
                    }
                } else {
                    openshift(value) 
                }
                break
            case "openshift-z":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_OPENSHIFT_000'
                piaasMainInfo.type_deploy = 'openshift-z'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    utilsMessageLib.infoMsg("Multiple Deploy for openshift-z enabled")
                    for ( item in value ) {
                        openshiftZ(item) 
                    }
                } else {
                    openshiftZ(value) 
                }
                break
            case "database":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_DATABASE_000'
                piaasMainInfo.type_deploy = 'database'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for database enabled"
                    for ( item in value ) {
                        database(item) 
                    }
                } else {
                    database(value)
                }
                break
            case "aws":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_AWS_000'
                piaasMainInfo.type_deploy = 'aws'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for AWS enabled"
                    for ( item in value ) {
                        aws(item) 
                    }
                } else {
                    aws(value) 
                }
                break
            case "eks":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_EKS_000'
                piaasMainInfo.type_deploy = 'eks'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for AWS EKS enabled"
                    count = 0
                    arrayCount = value.size()
                    for ( item in value ) {
                        count += 1
                        if ( count == arrayCount ) {
                            serviceDeployKubernetes.eks(item)
                        } else {
                            serviceDeployKubernetes.eks(item + " --no-delete-image ")
                        }
                        
                    }
                } else {
                    serviceDeployKubernetes.eks(value) 
                }
                break
            case "ansible":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_ANSIBLE_000'
                piaasMainInfo.type_deploy = 'ansible'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for ansible enabled"
                    for ( item in value ) {
                        serviceDeployAnsible.ansible(item, 'deploy')
                    }
                } else {
                        serviceDeployAnsible.ansible(value, 'deploy')
                }
                break
            case "batch":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_BATCH_000'
                piaasMainInfo.type_deploy = 'batch'
                serviceDeployBatch.batch(value)
                break
            case "airflow":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_AIRFLOW_000'
                piaasMainInfo.type_deploy = 'airflow'
                if ( value.getClass().toString().contains("class java.util.ArrayList") ) {
                    echo "Multiple Deploy for airflow enabled"
                    for ( item in value ) {
                        airflow(item) 
                    }
                } else {
                    airflow(value) 
                }
                break
            case "rsync":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_RSYNC_000'
                piaasMainInfo.type_deploy = 'rsync'
                rsync(value)
                break
            case "terraform":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_TERRAFORM_000'
                piaasMainInfo.type_deploy = 'terraform'
                terraform(value)
                break
            case "rundeck":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_RUNDECK_000'
                piaasMainInfo.type_deploy = 'rundeck'
                rundeck(value, 'deploy')
                break
            case "hadoop":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_HADOOP_000'
                piaasMainInfo.type_deploy = 'hadoop'
                hadoop(value)
                break
            case "osgi":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_OSGI_000'
                piaasMainInfo.type_deploy = 'osgi'
                serviceDeployOsgi.osgi(value)
                break
            case "outsystem":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_OUTSYSTEM_000'
                piaasMainInfo.type_deploy = 'outsystem'
                outsystem(value)
                break
            case "nexus":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_NEXUS_000'
                piaasMainInfo.type_deploy = 'nexus'
                serviceDeployNexus.nexus()
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_SCRIPT_000'
                echo "Start script to stage [DEPLOY]"
                piaasMainInfo.type_deploy = 'script'
                controllerBuildsShell.script(value, 'deploy')
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in deploy stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.deploy(value,mapResult3rdParty)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in deploy stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * after_deploy
 * Método execução de stage after_deploy 
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def after_deploy() {
    piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_000'

    echo "Start stage : [AFTER_DEPLOY]"
    mapResult.after_deploy.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "jmeter":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_JMETER_000'
                controllerTestsPerformance.jmeter(value)
                break
            case "cucumber":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_CUCUMBER_000'
                controllerTestsQuality.cucumber(value)
                break
            case "newman":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_NEWMAN_000'
                controllerTestsQuality.newman(value)
                break
            case "qs-test":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_QS-TEST_000'
                //controllerTestsQuality.qsTest(value)
                utilsMessageLib.warnMsg("O uso da task qs-test foi descontinuada. Utilize 'cypress' no lugar.")
                break
            case "cypress":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_CYPRESS_000'
                controllerTestsQuality.cypress(value)
                break      
            case "airflow-test":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_AIRFLOW_TEST_000'
                airflowTest(value)
                break
            case "bruno-api":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_BRUNO_API_000'
                controllerTestsQuality.brunoApi(value)
                break
            case "k6":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_K6_000'
                controllerTestsPerformance.k6(value)
                break
            case "delivery-reliability":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_DR_000'
                controllerTestsDeliveryReliability.deliveryReliability(controllerTestsPerformance, controllerTestsQuality, value)
                break
            case "selenium":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_SELENIUM_000'
                controllerTestsQuality.selenium(value)
                break
            case "qualys":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_QUALYS_000'
                qualys(value)
                break
            case "dynatrace":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_DYNATRACE_000'
                dynatrace(value)
                break
            case "sql":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_SQL_000'
                sql(value)
                break
            case "ansible":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_ANSIBLE_000'
                ansible(value, 'after_deploy')
                break
            case "playbook":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_PLAYBOOK_000'
                playbook(value)
                break
            case "rundeck":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_RUNDECK_000'
                rundeck(value, 'after_deploy')
                break
            case "jcl":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_JCL_000'
                jcl(value)
                break
            case "sdelements":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_SDELEMENTS_000'
                sdelements(value)
                break
            case "script":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_SCRIPT_000'
                echo "Start script to stage [AFTER_DEPLOY]"
                controllerBuildsShell.script(value, 'after_deploy')
                break
            case "cloudfront":
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_CLOUDFRONT_000'
                cloudfront(value)
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in after_deploy stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.after_deploy(value,mapResult3rdParty)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in after_deploy stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}


/**
 * notifications
 * Método execução de stage notifications 
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def notifications() {
    piaasMainInfo.pipeline_code_error  = 'ERR_NOTIFICATIONS_000'

    echo "Start stage : [NOTIFICATIONS]"
    mapResult.notifications.each { key, value ->
        value = controllerIntegrationsEnvs.setTemplateEngines(value)
        switch (key.toLowerCase()) {
            case "pullrequest":
                piaasMainInfo.pipeline_code_error  = 'ERR_NOTIFICATIONS_PULLREQUEST_000'
                controllerIntegrationsBitbucket.pullRequest(value)
                break
            default:
                piaasMainInfo.pipeline_code_error  = 'ERR_NOTIFICATIONS_DEFAULT_000'
                try {
                    script3rdParty = ''
                    echo "Running in notifications stage function 3rd party '${key}' using values '${value}' "
                    script3rdParty = load "/opt/infratransac/core/3rdparty/${key}.groovy"
                    script3rdParty.notifications(value)
                } catch (err) { 
                    utilsMessageLib.errorMsg("Implementation '${key}' in notifications stage not performed or error in function '${key}' 3rd Party")
                    println(err)
                }
        }
    }
}

/**
 * runningSlave
 * Método faz o chamadas de execução em slave
 * @version 8.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *          Michel Miranda <michel.miranda@br.experian.com>
 * @return  true | false
 **/
def runningSlave(def cmdSlave) {
    echo "Invoking execution in jenkins slave"
    echo "Details of execution '${cmdSlave}'"

    getDetailsSlaveExecution(cmdSlave)

    if ( ( slaveRunning == "" ) || ( cmdExecSlave == "" ) ) {
        utilsMessageLib.errorMsg("Error function slave parameters --target or --command not informed in piaas.yml")
        currentBuild.description = "Error function slave"
        errorPipeline = "Error function slave parameters --target or --command not informed in piaas.yml."
        helpPipeline = "Em seu piaas.yml verifique a função slave e informe os parametros necessarios (Ex.: slave: --target=aws_eid --command=build.sh)"
        echo "Solucao: ${helpPipeline}"
        
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    
    }

    echo "Slave to execution ${slaveRunning}"
    echo "Command execution ${cmdExecSlave}"

    node( slaveRunning ) {
        sh(script: "${cmdExecSlave}", returnStdout: false)
    }

    echo "Execution in slave ${slaveRunning} success"

}

/**
 * getDetailsSlaveExecution
 * Extrai as variaveis da string de paramentros para execução em slave com @NonCPS 
 *   Ref.: - https://issues.jenkins-ci.org/browse/JENKINS-35444
 * @version 8.0.0
 * @package DevOps
 * @author  Daniel.Miyamoto <Daniel.Miyamoto@br.experian.com>
 * @return  true | false
 **/
@NonCPS
String getDetailsSlaveExecution(String cmdStr) {
    def match = cmdStr =~ /--target=(?<target>[^ ]+) --command=(?<command>.*)$/
    if( match.matches()){
       slaveRunning = match.group('target')
       cmdExecSlave = match.group('command')
    } 
}

/**
 * rsync
 * Método faz deploy via a rsync 
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def rsync(def cmdRsync) {
    scriptExecOut = ''

    echo "Invoking deploy rsync"
    echo "Details deploy '${cmdRsync}'"

    scriptExecOut = sh(script: "rsync ${cmdRsync}", returnStdout: false)

}

/**
 * airflow
 * Método faz chamadas ao deploy para airflow
 * @version 8.22.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def airflow(def cmdAirflow) {
    def urlPackageArtifactId = artifactId
    def airflowServer = ''
    def airflowHome = '/opt/airflow/'
    scriptExecOut = ''

    echo "Invoking execution airflow"

    if ( gitBranch == "master" ) {
        urlPackageNexus = "http://spobrnxs01-pi:8081/nexus/service/local/artifact/maven/redirect?r=releases&g=" + groupId + "&a=" + urlPackageArtifactId + "&v=" + versionApp + "&e=" + typePackage
    } else {
        urlPackageNexus = "http://spobrnxs01-pi:8081/nexus/service/local/artifact/maven/redirect?r=snapshots&g=" + groupId + "&a=" + urlPackageArtifactId + "&v=" + versionApp.toString().replace("-RC", "-SNAPSHOT") + "&e=" + typePackage
    }

    airflowServerPrd = 'spbrhdpcorp66,spbrhdpcorpdr66,airflow2-prod,airflow3-prod,airflow4-prod,airflow2-proddr'
    airflowServerQa = 'spbrhdphm02,airflow2-uat,airflow3-uat,airflow4-uat'
    airflowServerDev = 'spbrhdpdev1,airflow2-dev,airflow3-dev,airflow4-dev'

    if ( cmdAirflow != null ) {
        echo "Details execution '${cmdAirflow}' to airflow deploy"
        cmdAirflow.split().each {
            if ( it.toLowerCase().contains("--airflow-server") ) {
                airflowServer = it.split('=')[1]
                switch (gitBranch) {
                    case "master":
                        if ( ! airflowServerPrd.contains(airflowServer) ) {
                            imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                            utilsMessageLib.errorMsg("Check environment informed for branch in playbook")
                            currentBuild.description = "Check environment informed to deploy airflow for branch in piaas.yml"
                            errorPipeline = "Check environment informed to deploy airflow for branch in piaas.yml."
                            helpPipeline = "Você está tentando fazer um deploy indevido em ambientes airflow. Corrija o destino do deploy para algum valido."
                            piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_AIRFLOW_001'
                            echo "Solucao: ${helpPipeline}"
                            if (gitAuthorEmail != "") {
                                controllerNotifications.cardStatus('helpPipeline')
                            }
                            throw new Exception(errorPipeline)
                        }
                        break
                    case ["qa", "hotfix"]:
                        if ( ! airflowServerQa.contains(airflowServer) ) {
                            imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                            utilsMessageLib.errorMsg("Check environment informed for branch in playbook")
                            currentBuild.description = "Check environment informed to deploy airflow for branch in piaas.yml"
                            errorPipeline = "Check environment informed to deploy airflow for branch in piaas.yml."
                            helpPipeline = "Você está tentando fazer um deploy indevido em ambientes airflow. Corrija o destino do deploy para algum valido."
                            piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_AIRFLOW_001'
                            echo "Solucao: ${helpPipeline}"
                            if (gitAuthorEmail != "") {
                                controllerNotifications.cardStatus('helpPipeline')
                            }
                            throw new Exception(errorPipeline)
                        }
                        break
                    default:
                        if ( ! airflowServerDev.contains(airflowServer) ) {
                            imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                            utilsMessageLib.errorMsg("Check environment informed for branch in playbook")
                            currentBuild.description = "Check environment informed to deploy airflow for branch in piaas.yml"
                            errorPipeline = "Check environment informed to deploy airflow for branch in piaas.yml."
                            helpPipeline = "Você está tentando fazer um deploy indevido em ambientes airflow. Corrija o destino do deploy para algum valido."
                            piaasMainInfo.pipeline_code_error  = 'ERR_DEPLOY_AIRFLOW_001'
                            echo "Solucao: ${helpPipeline}"
                            if (gitAuthorEmail != "") {
                                controllerNotifications.cardStatus('helpPipeline')
                            }
                            throw new Exception(errorPipeline)
                        }
                        break
                        }
                    }
                }
    } else {
        echo "Execution default to airflow deploy"
        if ( gitBranch == "master" ) {
            airflowServer = 'spbrhdpcorp66,spbrhdpcorpdr66'
        } else if ( ( gitBranch == "qa" ) || ( gitBranch == "hotfix" ) ) {
            airflowServer = 'spbrhdphm02'
        } else {
            airflowServer = 'spbrhdpdev1'
        }
    }

    echo "The url redirect nexus ${urlPackageNexus}"
    urlPackageNexus = sh(script: "curl -I '${urlPackageNexus}' |grep Location|cut -d' ' -f 2", returnStdout: true)
    urlPackageNexus = urlPackageNexus.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\t", "").replaceAll("\n", "")
    echo "The url nexus to deploy ${urlPackageNexus}"

    airflowServer.split(',').each {
        echo "Running deploy in airflow ${it}[${environmentName}] using airflow home ${airflowHome}"
        sh(script: "/opt/infratransac/core/bin/deploy.sh --target=ansible --runin=tower --job-id=564 --extra-vars='deploy_host_target=${it} path_target=${airflowHome} nexus_url=${urlPackageNexus}'", returnStdout: false)
    }

    if ((gitBranch == "qa") || (gitBranch == "hotfix")) {
        urlPackageNexus = ''
        urlPackageNexus = "http://spobrnxs01-pi:8081/nexus/service/local/artifact/maven/redirect?r=releases&g=" + groupId + "&a=" + urlPackageArtifactId + "&v=" + versionApp + "&e=" + typePackage

        changeorderDescription = changeorderDescription +
            "*** Nexus{/n}" +
            "Url pacote: ${urlPackageNexus}{/n}" +
            "{/n}";
    }
}

/**
 * sdelements
 * Método faz chamadas ao sd elements
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 *          Marcelo Oliveira <Marcelo.Oliveira@br.experian.com>
 * @return  true | false
 **/
def sdelements(def cmdSDElements) {
    def sdelementsCredentialConection ='usr_sdelements'
    def sdelementsTokenConection      = ''
    def sdelementsProjectId           = ''
    def sdelementsProxy               = 'spobrproxy.serasa.intranet'
    def sdelementsProxyPort           = '3128'
    def sdelementsReturn              = ''

    echo "Invoking SD Elements"
    echo "Details '${cmdSDElements}'"
    
    cmdSDElements.split().each {
        if (it.contains("--sdelements-id")) {
            sdelementsProjectId = it.split('=')[1]
        }
    }

    withCredentials([usernamePassword(credentialsId: "${sdelementsCredentialConection}", passwordVariable: 'pass', usernameVariable: 'user')]) {
        sdelementsTokenConection = pass
    }
 
    try {
        script3rdParty   = ''
        script3rdParty   = load "/opt/infratransac/core/3rdparty/sdelements.groovy"
        sdelementsReturn = script3rdParty.after_deploy(sdelementsProjectId,sdelementsTokenConection,sdelementsProxy,sdelementsProxyPort)
        
        toolsScore.sd_test.analysis_performed  = 'true'
        toolsScore.sd_test.score               = sdelementsReturn.sdelement_score.toFloat()

        piaasMainInfo.sdelement_analysis_performed = 'true'
        piaasMainInfo.sdelement_score              = sdelementsReturn.sdelement_score.toString() 
        piaasMainInfo.sdelement_tasks              = sdelementsReturn.sdelement_tasks
        piaasMainInfo.sdelement_tasks_complete     = sdelementsReturn.sdelement_tasks_complete

        if ((gitBranch == "hotfix") || (gitBranch == "qa") || (gitBranch == "uat") || (gitBranch == "master")) {
            changeorderTestResult = changeorderTestResult +
                                    "**** SD Elements - [ Score: " + sdelementsReturn.sdelement_score + " ]{/n}" +
                                    "Tasks : " +  sdelementsReturn.sdelement_tasks + "{/n}" +
                                    "Tasks Complete : " + sdelementsReturn.sdelement_tasks_complete + "{/n}{/n}";
        }
    } catch (err) { 
        utilsMessageLib.errorMsg("Error in integration with SD Elements. Impossible to continue :(")
        currentBuild.description = "Error in integration with SD Elements"
        errorPipeline = "Error in integration with SD Elements."
        helpPipeline = "Contate o time de DevSecOps para verificação da causa da falha de integração com SD Elements"
        echo "Solucao: ${helpPipeline}"
        
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }
}

/**
 * openshiftZ
 * Método faz chamadas ao deploy openshift-z
 * @version 8.1.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def openshiftZ(def cmdOpenshift) {
    scriptExecOut = ''

    echo "Invoking deploy in openshift-Z"
    echo "Details deploy '${cmdOpenshift}'"

    if (cmdOpenshift.toLowerCase().contains("--image")) {
        withCredentials([usernamePassword(credentialsId: 'zlinux', passwordVariable: 'pass', usernameVariable: 'user')]) {
            sh(script: "sshpass -p '${pass}' ssh ${user}@10.52.18.21 /opt/infratransac/core/bin/deploy.sh --target=openshift --environment=${environmentName} ${cmdOpenshift}", returnStdout: false)
        }
    } else {
        withCredentials([usernamePassword(credentialsId: 'zlinux', passwordVariable: 'pass', usernameVariable: 'user')]) {
            sh(script: "sshpass -p '${pass}' ssh ${user}@10.52.18.21 /opt/infratransac/core/bin/deploy.sh --target=openshift --environment=${environmentName} --image=${artifactId}:${versionApp} ${cmdOpenshift}", returnStdout: false)
        }    
    }

    echo "Success deploy in openshift-Z"

}

/**
 * database
 * Método faz chamadas ao deploy aws
 * @version 8.31.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def database(def cmdDatabase) {
    def gitBranchValidate = ''
    scriptExecOut = ''

    echo "Invoking deploy database type ${type}"

    if (gitBranch.contains("feature")) {
        gitBranchValidate = 'feature'
    }
    else {
        gitBranchValidate = gitBranch
    }

    switch (gitBranchValidate) {
        case ["feature", "develop", "qa", "hotfix"]:
            if (cmdDatabase.toLowerCase().contains("--environment=prod")) {
                imLookingMsg("Trying to cheat the deploy? Impossible to continue :(")
                utilsMessageLib.errorMsg("Check environment informed for branch in piaas.yml")
                currentBuild.description = "Check environment informed to deploy database for branch in piaas.yml"
                errorPipeline = "Check environment informed to deploy database for branch in piaas.yml."
                helpPipeline = "Você está tentando fazer um deploy indevido em ambientes database, para feature*/develop/qa/hotfix os ambientes permitidos são develop/qa."
                echo "Solucao: ${helpPipeline}"

                if (gitAuthorEmail != "") {
                    controllerNotifications.cardStatus('helpPipeline')
                }
                throw new Exception(errorPipeline)
            }
            break
    }

    if ( cmdDatabase != null ) {
        if ( ! cmdDatabase.toLowerCase().contains("--environment") ) {
           cmdDatabase = cmdDatabase + ' --environment=' + environmentName
        }
    }   

    echo "Details deploy '${cmdDatabase}'"

    scriptExecOut = sh(script: "/opt/infratransac/core/bin/deploy.sh --target=database --method=${type} --path-package=${WORKSPACE}/${currentBuild.number} ${cmdDatabase}", returnStdout: false)
}

/**
 * aws
 * Método faz chamadas ao deploy aws
 * @version 8.3.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def aws(def cmdAws) {
    scriptExecOut = ''

    echo "Invoking deploy aws"
    echo "Details deploy '${cmdAws}'"

    if ( cmdAws != null ) {
        if ( ! cmdAws.toLowerCase().contains("--environment") ) {
           cmdAws = cmdAws + ' --environment=' + environmentName
        } 
    } 

    scriptExecOut = sh(script: "/opt/infratransac/core/bin/deploy.sh --target=aws ${cmdAws}", returnStdout: false)

}

/**
 * cloudfront
 * Método faz chamadas ao CloudFront
 * @package DevOps
 * @return  true | false
 **/
def cloudfront(def cmdCloudFront) {
    echo "Invoking function cloudfront"

    sh(script: "/opt/infratransac/core/bin/cloudfront.sh --action=invalidate ${cmdCloudFront}", returnStdout: false)

}

/**
 * airflowTest
 * Método faz chamadas a validação de qualidade do airflow
 * @version 8.6.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @return  true | false
 **/
def airflowTest(def cmdAirflowTest) {
    def versionAppAirflowTest = ''
    qsTestUrlReports          = ''
    def airflowTestScore      = 100
    def airflowTestMethod     = ''
    def airflowTestScript     = '/opt/infratransac/coe-scripts/airflow_test_validate.sh'
    def airflowTestExtraVars  = ''

    versionAppAirflowTest = versionApp.toString().replace("-SNAPSHOT", "").replace("-RC", "")

    echo "Invoking Airflow Test"
    echo "Details test '${cmdAirflowTest}'"

    echo "Script for running ${airflowTestScript}"
    sh(script: "${airflowTestScript} ${cmdAirflowTest}", returnStdout: false)

    echo "Score Airflow Test '${airflowTestScore}' for execution in version ${versionAppAirflowTest}"

    toolsScore.qs_test.analysis_performed    = 'true'
    toolsScore.qs_test.score                 = airflowTestScore.toFloat()

    piaasMainInfo.qs_test_analysis_performed = 'true'
    piaasMainInfo.qs_test_score              = airflowTestScore
    piaasMainInfo.qs_test_url                = 'N/S'

}

/**
 * dependGuard
 * Método executa automacao de analise de dependencias de cogidos
 * @version 8.34.0
 * @package DevOps
 * @author  Lucas Francoi <lucas.francoi@experian.com>
 * @return  true | false
 **/
def dependguard(def cmdDependguard) {
    
    echo "Invoking dependGuard dependencies analysis"

    def bitbucketRepository = controllerIntegrationsBitbucket.getBitbucketRepository()
    def bitbucketProjectKey = controllerIntegrationsBitbucket.getBitbucketProject()
    def repository = bitbucketProjectKey + "/" + bitbucketRepository

    if (!cmdDependguard) {
        utilsMessageLib.warnMsg("dependguard() ->Nenhum parametro definido. Seguindo com os parametros padrões ja definidos")
    } else {
        utilsMessageLib.infoMsg("dependguard() ->Parametros: ${cmdDependguard}")
    }

    sh(script: "/opt/infratransac/core/bin/dependguard.sh ${cmdDependguard} --repository=${repository} --base_branch=${gitBranch} --image=${ecrRegistry}dependguard-bot-devsecops:latest", returnStdout: false)

}

return this

utilsMessageLib.warnMsg("Em caso de erro acesse o test-rollback-launch e retorne ao commit anterior")
