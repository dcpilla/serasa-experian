## Transição para o Novo PiaaS

### Geral

Para todas as execuções as seguintes alterações são necessárias:

* Criar o arquivo piaas.yml e realizar as adequações com base eu seu antigo .jenkins.yml. Temos uma automação no CockPit DevSecOps, na categoria PiaaS, chamada <b>piaas-migrate</b>, que realiza esse processo.
* Conferir nossa [documentação](pipelines.md) para entender a nova estrutura do piaas.yml e as mudanças referente as tasks que você utiliza, que possam ser necessários em seu novo yml.
* Desencoragamos o uso do proxy explícito em processos que você anteriormente utilizava: em todos os nossos testes, ele não era necessário e em alguns casos seu uso impedia o prosseguimento. Isso se dá pela mudança de ambiente (On premise para AWS).

### Uso do Nexus de artefatos

#### Geral

O antigo servidor de Nexus de artefatos (spobrnxs01-pi ou spobrccm02) será descontinuado no Novo PiaaS. Mas não se preocupe: todos os pacotes existentes no antigo servidor estarão acessíveis no novo, sem prejuízos aos times.

O processo de desligamento do antigo servidor será feito posteriormente, por enquanto ambos ficam de pé, mas é vedada sua utilização no Novo PiaaS.

A nova url é: https://nexus.devsecops-paas-prd.br.experian.eeca/.

Além disso, você não deve mais informar <b>nenhum parâmetro</b> ao utilizar a estratégia ```nexus``` em seu .yml. Internamente o PiaaS tomará a decisão do repository a ser utilizado.

Exemplo de como deve ficar:

```
deploy:
  nexus:
```

Por regra, <b>toda</b> execucação a partir de master terá o artefato disponibilizado no repositório de releases correspondente. Os demais, no repositório de snapshots.

#### Java:

Os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/releases/

Já para você configurar em seu ```settings.xml``` localmente, caso deseje ter acesso a todos os pacotes do Nexus durante seus builds locais, utilize o repository: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/maven-group-repositories/.

#### Node:

O antigo servidor de cacheamento de pacotes (spobrnexusregistry) será descontinuado. Ele será unificado no novo Nexus conforme citado acima.

Além disso, agora temos a possibilidade de publicar artefatos NPM.

Os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-releases/
* Proxy (cache): https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-group-repository/

#### Zip e Tar

Para pacotes gerados manualmente por compactação (zip e tar), os repositórios são:

* Snapshots: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/raw-snapshots/
* Releases: https://nexus.devsecops-paas-prd.br.experian.eeca/repository/raw-releases/

### Utilizadores de Cypress

O arquivo .sh para invocar o cypress, além do arquivo .conf do cypress, que anteriormente ficavam no repositório, não são mais necessários. Além disso, a forma de invocar o cypress no yml mudou.

Antes:

```
qs-test: --method=cypress --runner=cockpit-container-front-test --script=WORKSPACE/cypress-automate.sh
```

Agora:

```
cypress: --cypress-version=<<VERSION>>
```

Também se faz necessário o ajuste em alguns paths nos seus arquivos de teste, para onde os reports serão salvos.

Em seu ```cypress.json``` você terá algo como:

```json
{
  "reporter": "mochawesome",
  "reporterOptions": {
    "reportDir": "./cypress/results",
    "overwrite": false,
    "html": true,
    "json": true
  },
```

Altere para:

```json
{
  "reporter": "mochawesome",
  "reporterOptions": {
    "reportDir": "cypress_reports",
    "overwrite": true,
    "html": true,
    "json": true
  },
```

Em seu ```package.json``` você terá algo como:

```
...
    "merge_reports": "mochawesome-merge cypress/results/mochawesome*.json -o cypress/reports/mochareports/report.json",
    "generate_report": "marge --charts cypress/reports/mochareports/report.json -f report -o cypress/reports/mochareports/",
...
```

Altere para:

```
...
    "merge_reports": "mochawesome-merge cypress_reports/*.json > cypress_reports/cypress.json",
    "generate_report": "marge --charts cypress_reports/cypress.json -f report -o cypress_reports",
...
``` 

Além disso, como dito em nossa [documentação](pipelines.md), você agora pode utilizar seu teste dentro da sua aplicação, no padrão monorepo (e inclusive nós recomendamos). No entanto, você pode continuar utilizando um repositório externo normalmente.
Por lá você também pode conferir as versões possíveis para serem utilizadas no Cypress.

### Utilizadores de Cucumber

O arquivo .sh para invocar o Cucumber, que anteriormente ficava no repositório, não é mais necessário. Além disso, a forma de invocar o Cucumber no yml mudou.

Antes era:

```
cucumber: --script=WORKSPACE/cockpit-container-access-test.sh --runner=cockpit-container-access-test --type=api
```

Agora:

```
cucumber: --jdk=<<VERSION>>
```

Em jdk, você deve informar a versão da JDK da sua aplicação Cucumber de testes.

Também se faz necessário o ajuste em alguns paths nos seus arquivos de teste, para onde os reports serão salvos.

Como essa alteração pode variar bastante, apenas lembre-se de realizar as alterações previstas na documentação. Em resumo:

* O path para salvar os relatórios deve ser "cucumber_reports"
* O arquivo .json gerado deve se chamar "cucumber.json"
* Caso em seu Runner haja a remoção do diretório de report, caso ele exista previamente, retira essa lógica.
* Caso em seu pom.xml haja configurações para definir o input/output directory, realize as alterações referente as mudanças acima.

### Utilizadores de Selenium

O arquivo .sh para invocar o Selenium, além do Dockerfile, que anteriormente ficavam no repositório, não são mais necessários. Além disso, a forma de invocar o Selenium no yml mudou.

Antes:

```
cucumber: --script=WORKSPACE/cockpit-container-access-test.sh --runner=cockpit-container-access-test --type=selenium
```

Agora:

```
selenium: --jdk=<<VERSION>> --browser=<<BROWSER>>
```

Em jdk, você deve informar a versão da JDK da sua aplicação de testes. Em browser, você deve informar o browser a ser utilizado no Selenium para os testes, sendo eles: firefox, chrome ou edge.

Como você deixará de provisionar o Selenium Grid, e essa tarefa passará a ser do PiaaS, você também precisa alterar sua classe de Driver para que seu código saiba qual Selenium utilizar.

Exemplo:

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

Note que você definirá uma variável de ambiente, está por sua vez terá o valor do endereço Selenium Grid injetado em tempo de execução.

> [NOTA 📝]
> O Selenium Grid é provisionado em tempo de execução internamente, e excluído logo após o fim dos testes. 

Também se faz necessário o ajuste em alguns paths nos seus arquivos de teste, para onde os reports serão salvos.

Como essa alteração pode variar bastante, apenas lembre-se de realizar as alterações previstas na documentação. Em resumo:

* O path para salvar os relatórios deve ser "selenium_reports"
* O arquivo .json gerado deve se chamar "selenium.json"
* Caso em seu Runner haja a remoção do diretório de report, caso ele exista previamente, retira essa lógica.
* Caso em seu pom.xml haja configurações para definir o input/output directory, realize as alterações referente as mudanças acima.

> [NOTA 📝]
> Para Cucumber e Selenium a definição dos novos paths são a partir o baseDir da aplicação, e não do buildDirectory (target).