# Contribuição - CORE

O CORE é todo o código responsável pela execução do PiaaS, ou seja, todo o código contido nesse repositório.

Toda a estrutura aqui disponível pode passar por contribuições que venham a melhorar os processos existentes ou até mesmo criar novos fluxos que possam ser disponibilizados a todos os usuários do PiaaS!

### Feature Branch Workflow

Trabalhamos com a lógica de Feature Branch em nosso repositório. Ou seja, temos apenas uma branch principal (master) e as demais são feature branches que serão incorporadas a branch principal quando as implantações estiverem finalizadas.

Então, para contribuir, você deve:

* Clonar esse repositório a partir de master;
* Criar uma feature branch (exemplo: feature/JIRAKEY-1234);
* Realizar suas implantações e testes em nosso ambiente de desenvolvimento;
* Submeter uma PR para master para revisão.

### Solicitando os acessos necessários

Para que você possa acessar o PiaaS de desenvolvimento solicite os grupos abaixo via IDC:

* APP-COCKPIT-DEVSECOPS_USER (Okta Preview)
* APP-COCKPIT-DEVSECOPS_PIAAS_USER  (Okta Preview)

Com eles você poderá acessar o [CockPit DevSecOps QA](https://cockpit-container-front-qa.devsecops-paas-prd.br.experian.eeca/login), onde terá acesso ao PiaaS de desenvolvimento.

### Atualizando o ambiente de desenvolvimento com sua feature branch

Agora que você já possuí os acessos do ambiente de desenvolvimento e sua branch está pronta pra ser testada, está na hora de atualizar o ambiente com sua branch!

Acesse o [CockPit DevSecOps Produtivo](https://cockpit-container-front-prod.devsecops-paas-prd.br.experian.eeca/login), vá até o <b>Service Catalog</b> e em seguida porcure a categoria <b>PiaaS</b>. Na seqûencia selecione a automação <b>piaas-core-update</b>.

Preencha:

* <b>aws_account_id</b>: informe 559037194348 para o ambiente de testes.
* <b>branch_name_core</b>: informe o nome da sua feature branch que irá realizar a homologação.
* <b>branch_name_3rdparty</b>: caso sua contribuição seja pelo 3rd party, informe o nome da branch aqui. Caso não, deixe vazio.

Após isso o nosso ambiente de homologação estará atualizado com sua branch e você poderá realizar seus testes para validar sua implantação.

Quando tudo estiver validado, submeta a PR para avaliação e informe na PR os IDs de execução dos testes realizados, além de detalhes da implantação.

<b>Observação: por questões de segurança, o único repositório que pode ser executado em sandbox é o <i>go-demo</i>, disponível no projeto EDVP no Bitbucket.</b>