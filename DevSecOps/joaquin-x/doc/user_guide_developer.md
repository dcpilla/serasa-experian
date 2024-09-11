** Guia do Desenvolvedor **
----
> Browse Catalog Serasa Experian, Como Desenvolver :)

## Como Desenvolver

Simplesmente um arquivo `joaquin-infra.yml` para o paraiso de lançadores de recursos e acabe com trabalhos braçais.
------

Toda a mágica acontece por meio de um repositório no bitbucket onde ficam todos os insumos da automação (aquivos terraform, playbooks ansible, scripts shell entre outros) e nesse repositório deve estar também o arquivo `joaquin-infra.yml`. Ele é um playbook que define toda configuração necessária para o lançamento de recursos, como por exemplo, se há ou não integração com ITIL para abertura de change order ou leitura de dados de rollout a partir de request, campos de entrada de parâmetros pelo usuário e o rollout da automação a ser executada.

Abaixo se encontra um exemplo de definição de um arquivo `joaquin-infra.yml`:

```yaml
---
running_in: aws_slave
itil: 
  request: true
  changeorder: false
definition: Este job é apenas para testes do time devsecops-paas
team_owner: DevSecOps PaaS Brazil
manual_time: 30
notification:
bu: Insira o nome da sua BU.
  onfailure:
    email:
      recipients: time@br.experian.com
      subject: 'JoaquinX falha automação do launch meu-launch-xpto '
    teams:
      team_id: 'TEAM ID'
      channel_id: 'CHANNEL ID'
  onsuccess:
    email:
      recipients: time@br.experian.com
      subject: 'JoaquinX sucesso automação do launch meu-launch-xpto '
    teams:
      team_id: 'TEAM ID'
      channel_id: 'CHANNEL ID'
  disable_in_qa: true
global:
  project:
    type: text 
    pattern: ~/\w{4}/
    description: Define o nome do projeto/tribe, exemplo devsecops-arquitetura
    required: true
    answer: ritm.nome_campo_da_ritm_para_considerar
    reference:
      table_name: nome_table
      field_name: nome_do_campo
  user:
    type: text 
    pattern: ~/\w{4}/
    description: Define o nome do projeto/tribe, exemplo devsecops-arquitetura
    required: true
    answer: ritm.nome_campo_da_ritm_para_considerar
  name_resource:
    type: text 
    pattern : ~/\w{4}/
    description : Define o nome do recurso que sera criado, exemplo prod-s3-positivo
    required: true
    answer: null
  environment:
    type: options 
    options: Staging;Dev;UAT;Production
    description: Define o ambiente de criacao
    required: true
    answer: null
  opcoes_checkbox:
    type: checkbox
    options: checkbox1;checkbox2;checkbox3;checkbox4
    description: Selecione uma ou mais opções
    required: true
    answer: null
before_plan:
  - replace apply.sh
plan:
  - ./apply.sh
``` 

## Explorando joaquin-infra.yml
> Os playbooks seguem uma ordem de execução cronológica, a sua construção deve possuir os seguintes step's:

1. `running_in`:
2. `itil:`
3. `definition:`
4. `global:`
5. `before_plan:`
6. `plan:`

A seguir serão apresentados os atributos disponíveis para definições dos playbooks `joaquin-infra.yml`. Note que alguns atributos são obrigatórios e não definí-los irá causar erro na execução do lançador.

### Sessão _running_in_ - Opcional
> `running_in` é o atributo responsável por definir que a execução do launch acontecerá em um slave pré-definido, o mesmo não definido a execução ocorrerá no proprio servidor onprimes.

Opções slave: 
```shell
aws       Ativa execução do launch em um slave na aws com assume roles para as contas corporativas.
```
```shell
Windows       Ativa execução do launch em um slave Windows.
```

###### Definindo execução no slave aws
```yaml
running_in: aws 
```
###### Definindo execução no slave Windows
```yaml
running_in: windows-serasa 
```

### Sessão _itil_ - Opcional
> `itil` é o atributo responsável por ativar a integração com o SNOW para abertura de `change order` ou leitura de dados de rollout a partir do `RITM` da request. A request deve passar por um processo de normalização para sua integração com o catalog, que pode ser consultada neste guia [Normalizar Request](doc/normalizar_request.md).

Opções: 
```shell
request       Ativa a integração com o snow para leitura dos dados da RITM para usar no rollout. Abaixo parametros:
              true  - O usuário terá que informar o número da RITM valido e já aprovada;
              false - Ignora a integração;
request_rules Possibilita a manipulação das requests do SNOW lidas pelo Catálogo de Serviços. Abaixo, opções permitidas neste campo:
              read_and_close - false - Caso esteja como false, a request será lida porém não será fechada automaticamente ao fim da execução.
              read_and_close - true - Caso esteja como true, a request permanecerá com o comportamento padrão.
changeorder_rules Possibilita a manipulação das changes do SNOW abertas pelo Catálogo de Serviços, além do input do template e group a ser usado na abertura. Abaixo, opções permitidas neste campo:
              open_and_close - false - Caso esteja como false, a OM não será encerrada de forma automática.
              open_and_close - true - Caso esteja como true, a OM será encerrada de forma automática.
              template - Informar o nome da sua OM Standard no SNOW para ser utilizado
              group - Informar o nome do grupo a assinar a OM Standard a ser aberta
changeorder   Ativa a integração com o snow para abertura de change order para registros. Abaixo parametros:
              true  - Uma change order será aberta para registro do lançamento solicitado, que será encerrada automaticamente ao final da execução do lançador;
              false - Ignora a integração;
```

Abaixo exemplos de uso para integrações com ITIL.

###### Parse com request e sem abertura de change order
```yaml
itil: 
  request: true      
  changeorder: false
```

###### Sem parse com request e sem abertura de change order
```yaml
itil: 
  request: false      
  changeorder: false
```

###### Sem parse com request e com abertura de change order
```yaml
itil: 
  request: false      
  changeorder: true
```

Saiba mais: https://pages.experian.com/display/EDPB/ITIL+in+Service+Catalog

### Sessão _definition_ - Obrigatório
> `definition` é o atributo usado como descrição do lançador, ele será exibido como uma pergunta inicial ao usuário para confirmar se ele realmente deseja seguir com o lançamento do recurso escolhido.

Opções: 
```shell
definition    Descreve os detalhes da automação
```

###### Aplicando a definição da automação
```yaml
definition: Este launch cria um servidor virtual na platadorma VmWare
```

###### Definindo o team owner - Obrigatório
```yaml
team_owner: NomeDaTribe/NomeDaSquad responsável pela automação.
```

###### Definindo o tempo - Obrigatório
```yaml
manual_time: Informar o tempo, em minutos, que a automação a ser criada levaria para ser realizada de forma manual.
```

###### Definindo o tempo - Opcional
```yaml
bu: Informar o nome da sua respectiva BU.
```

### Sessão _notification_ - Opcional
> `notification` é o atributo usado para notificar os times onwer dos lançadores, você pode ativar a mesma somente em casos de falhas para eventuais processos de monitoração do time ou para ambas as situações.
É possível receber a notificação por e-mail ou canal do Teams.

Opções: 
```shell
recipients    E-mail do time owner do launch - válido somente para envio via e-mail
subject       Como deseja o titulo do e-mail a ser enviado que pode ser usado em seus processos de monitoração - válido somente para envio via e-mail
team_id       ID do seu team no Teams - válido somente para envio via Teams
channel_id    ID do seu canal no Teams - válido somente para envio via Teams
disable_in_qa Desativa o envio de notificações quando executado em ambiente de homologação
```

Obs: para uso do Teams, adicione o usuário "Joaquim" como membro do seu canal.

###### Notificando somente em casos de falhas - e-mail
```yaml
notification:
  onfailure:
    email:
      recipients: devsecopsteam@br.experian.com
      subject: 'JoaquinX falha automacao  tools-test '
```

###### Notificando em casos de sucesso e falhas - e-mail
```yaml
notification:
  onfailure:
    email:
      recipients: devsecopsteam@br.experian.com
      subject: 'JoaquinX falha automacao  tools-test '
  onsuccess:
    email:
      recipients: devsecopsteam@br.experian.com
      subject: 'JoaquinX sucesso automacao tools-test '
```

###### Notificando somente em casos de falhas - Teams
```yaml
notification:
  onfailure:
    teams:
      team_id: 'TEAM ID'
      channel_id: 'CHANNEL ID'
```

###### Notificando em casos de sucesso e falhas - Teams
```yaml
notification:
  onfailure:
    teams:
      team_id: 'TEAM ID'
      channel_id: 'CHANNEL ID'
  onsuccess:
    teams:
      team_id: 'TEAM ID'
      channel_id: 'CHANNEL ID'
```

### Sessão _global_ - Obrigatório
> `global` é a sessão resposável pelos campos do formulário dinâmico ou fixo a partir do RITM de uma request. Caso a integração ITIL para request esteja como `false`  o usuário irá entrar com as informações que a automação precisará para executar, se estiver como `true` o campos serão automagicamente preenchidos pelas as informações encontradas no RITM. Nela são definidas quais são os nomes dos parâmetros de entrada e seus tipos, veja detalhes dos tipos logo abaixo.

Exemplo:
```yaml
global:
  name_resource_1:
    :
  name_resource_2:
    :
  name_resource_N:
    :
```

#### Definindo um parâmetro de entrada
> Conforme descrito anteriormente, dentro da sessão `global` deve-se defirnir os parâmetros de entrada de informações para o usuário digitar ou o parse do RITM da request, devem seguir a seguinte forma:

Opções: 
```shell
type        Define o tipo do campo ( obrigatório )
            text     - Campos abertos de texto 
            options  - Campos com lista de opções separados com 
            password - Campos para digitar informações sensiveis
            vault    - Campos com integração com vault do jenkins
            cyberark - Campos com integração com Cyberark DAP
            sef      - Campos com integração com o SEF
pattern     Pattern para validação da informação entrada ( opcional )
description Descrição da informação que se espera do usuário ( obrigatório )
required    Deve exigir a digitação do campo ( obrigatório )
            true  - Torna ele requirido
            false - Torna ele não requirido
answer      Campos para tratar respota do usuário ( obrigatório )
            null            - Sempre pedirá ao usuário a respota para o campo
            Resposta Padrão - Suprime que usuário responda a informação do campo  
            Parse da RITM   - Realiza parse com o valor do campo da RITM
reference   Trata campos do RITM que são tabelas de referência ( opcional )
            table_name - Nome da tabela de referência do SNOW
            field_name - Nome do campo para parseamento
```

Abaixo exemplos de uso para definições de campos.

###### Tipo `text`
> Use para solicitar ao usuário uma string de informações que podem ser abertas.
```yaml 
  project_name:
    type: text 
    pattern: ~/\w{4}/
    description: Nome do projeto
    required: true
    answer: null
```

###### Tipo `text` com parse de RITM
> No campo answer se realiza o parse do campo da RITM para suprimir a resposta do usuário
```yaml 
  u_schema:
    type: text 
    pattern : ~/\w{4}/
    description : Define o schema
    required: true
    answer: ritm.u_schema
```

###### Tipo `text` com parse de RITM em tabelas de referências
> No campo answer se realiza o parse do campo da RITM para suprimir a resposta do usuário e busca a informação em tabelas de referência do SNOW.
```yaml 
  u_tabelaDW_referencia:
    type: text 
    pattern : ~/\w{4}/
    description : Define o noem da tabela
    required: true
    answer: ritm.u_tabelaDW_referencia
    reference:
      table_name: u_tbdwinformation
      field_name: u_nome_tabela
```

###### Tipo `options`
> Use para solicitar uma resposta dentro de um conjunto pré-definido de opções, ideal para quando se deseja limitar ou padronizar a escolha do usuário. As opções de escolha devem estar separadas com ';'.
```yaml 
  environment:
    type: options 
    options: dev;qa;prod
    description: Ambiente de entrega
    required: true
    answer: null
```

###### Tipo `options` com parametro uri que traz a lista de opções com base no retorno da chamada informada
> Use para solicitar uma resposta dentro de um conjunto pré-definido de opções, deve ser adicionado o atributo objeto 'uri' nele deve ser informado duas url homolog/prod que retorne uma lista no formato array Ex do retorno: ['carro', 'bicicleta', 123, 0.25]
```yaml 
  environment:
    type: options
    description: Selecione uma empresa
    uri:
      homolog: uat-serasa.experian.com/v1/empresas
      prod: prod-serasa.experian.com/v1/empresas
    required: true
    answer: null
```

###### Tipo `password`
> Use para solicitar ao usuário senhas ou qualquer informação que não pode ser aberta.
```yaml 
  ssh_key: 
    type: password
    description: Senha para acesso ssh
    required: true
    answer: null
```

###### Tipo `vault`
> Use para disponibilizar a integração com o vault do jenkins, assim será disponibilizado a escolha do vault pelo usuário e o mesmo será enviado a automação. Caso deseje fixar um vault na automação sem a necessidade do usuário escolher, basta deixar o nome do vault fixo em `answer`.
```yaml
  deploy_credentials:
    type: vault
    description: Credenciais para deploy
    required: true
    answer: null
```

###### Tipo `cyberark`
> Use para disponibilizar a integração com o vault do cyberark. O campo `type` precisa ser cyberark, o campo `answer` pode ser static para secrets estaticas, ou aws para secrets aws, o `safe` de onde esta a sua conta e `account` o nome da conta que deseja resgatar. 
Para maiores informações acesse:
How to request onboarding Cyberark Safe to Service Catalog: https://pages.experian.com/display/EDPB/How+to+request+onboarding+CyberArk+Safe+to+Service+Catalog
How to retrieve secrets from CyberArk to use in Service Catalog https://pages.experian.com/display/EDPB/How+to+retrieve+secrets+from+CyberArk+to+use+in+Service+Catalog
```yaml
  credencialcyberark:
    type: cyberark
    description: Cyberark integration
    required: false 
    answer: static ou aws
    safe: NOME_DO_SAFE
    account: NOMEDACONTA
```

###### Tipo `sef`
> Use para interagir com o SEF, retornando o valor da Feature Flag informada como valor para a variável. Saiba [mais](https://pages.experian.com/pages/viewpage.action?pageId=1130348272).
```yaml 
  feature_flag_variable: 
    type: sef
    description: My FF
    required: true
    answer: FF_1234_FEATURE
```

###### Tipo `checkbox`
> Use para para permitir que o usuário tenha a capacidade de escolher uma ou mais opções com uma checkbox list.
```yaml 
  checkbox_example: 
    type: checkbox
    description: My checkbox
    required: true
    options: Opcao1;Opcao2;Opcao3;Opcao4
    answer: null
```

###### Tipo `checkbox`  com parametro uri que traz a lista de opções no formato checkbox com base no retorno da chamada informada
> Use para para permitir que o usuário tenha a capacidade de escolher uma ou mais opções com uma checkbox list, deve ser adicionado o atributo objeto 'uri' nele deve ser informado duas url homolog/prod que retorne uma lista no formato array Ex do retorno: ['carro', 'bicicleta', 123, 0.25]
```yaml 
  checkbox_example: 
    type: checkbox
    description: Selecione uma ou mais empresas
    required: true
    uri:
      homolog: uat-serasa.experian.com/v1/empresas
      prod: prod-serasa.experian.com/v1/empresas
    answer: null
```

###### Validação com `Pattern`
> O atributo `pattern` define uma _regular expression_ que deve ser utilizado em conjunto com a definição de um parâmetro do tipo `text` pois ele valida a entrada digitada pelo usuário contra essa _regular expression_.
> No exemplo abaixo, será validado se foi entrado 4 caracteres alfa-numéricos.
```yaml 
  project_key:
    type: text 
    pattern: ~/\w{4}/
    description: Nome do projeto
    required: true
    answer: null
```
**Obs**: para saber mais e testar suas regular expressions, vide: [https://regexr.com/](https://regexr.com/)

### Sessão before_plan - Obrigatório
> `before_plan` é a sssão que define as ações que serão executadas antes do plano de lançamento do recurso.


As seguintes funções são disponibilizadas como facilitadores para esse _step_ do lançador.

#### `replace`
> Essa é a sessão mais importante do joaquinX, pois essa função irá injetar os valores informados pelo usuário colhidos na section `global` nos arquivos que executam a automação. Com isso na execução dos planos definidos na sessão `plan`, os scripts serão executados com os valores das variáveis que o usuário informou. É possível informar mais de um script para ser aplicado o `replace`, para isso basta separá-los por vírgula conforme exemplo abaixo.

Opções: 
```shell
replace   Define um ou N arquivos para ser injetado os paramêtros de rollout da automação.
```

###### Único arquivo
```yaml 
before_plan:
  - replace apply.sh
```
###### Multiplos arquivos:
*** Atenção: Para automacções Windows(powershell) não é suportado a execucao de multiplos arquivos na versão atual.

```yaml 
before_plan:
  - replace apply.sh,playbooks/onboarding.yml,playbooks/roles/bitbucket/templates/README.md
```

Para que a substituição seja aplicada, deve-se definir as variáveis nos arquivos de automação da seguinte forma:
```shell script
var1=@@VAR1@@
```
Onde `@@NOME_DA_VARIAVEL@@` deve ser o nome da variável definida na sessão `global`. Vale lembrar que o replace acontece mesmo com o nome do campo em caixa alta, por exemplo `var1=@@VAR1@@` com isso o campo global `var1` informado pelo usuário será aplicado no lugar de `@@VAR1@@`.

### Sessão plan - Obrigatório
> `plan` é a sessão que define o plano de rollout do lançamento, pode ter um ou vários comandos sequenciados e por isso é agnostico a tecnologia e método de automação.

###### Único step
```yaml
plan: 
  - ./apply.sh
```

###### Múltiplos steps
**Obs**: Para automacções Windows(powershell) não é suportado a execucao de multiplos arquivos na versão atual.
```yaml
plan: 
  - ./apply.sh
  - ./update.sh
  - terraform init
  - ansible-playbook configure.yml
```

## Agora vamos lançar algo :)

1.  [Crie seu repositório](https://code.experian.local/projects/SCIB/repos/joaquinx-launch-onboarding/browse) GITOPS para começar a automatizar use [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `joaquinx-launch-onboarding`.

2. Caso o launch terá integração ITIL com request. Realize a normalização [Guia Normalizar Request](normalizar_request.md).

3. Realize o clone para sua máquina.
``` shell
git clone https://code.br.experian.local/scm/code/scib/MEU_LAUNCH_CRIADO.git
git checkout develop
```

4. E a partir dai a imaginação é o limite, solte o automatizador dentro de você e inove para seu time. Codifique a automação de lançamento e a configuração do joaquin-infra.yml.

5. Envie sua automação para o bitbucket e abra uma PR para homologar.
``` shell
git commit -am "[UPD] Descrição da minhas alterações"
git push
```

6. Realize a Homologação. Aqui está o guia para uma homologação perfeita [Criterios de Homologação](criterios_homologacao.md).

7. Solicite a promoção do lançador da homologação para produção.

8. Divulge e seja feliz :)

### Parabéns o Greenpeace agradeçe pois você acaba de salvar 1 baleia no mundo e todos Serasa Experian ficaram felizes com você com esse novo lançador!!!

## Referencias

* [Guia de patterns](https://pages.experian.com/display/DCB/Regex+catalog)
* [Arquitetura Geral](https://code.experian.local/projects/SCIB/repos/architecture/browse) 

## Author

* **DevSecOps PaaS** - (devsecops-architecture-brazil@br.experian.com)
