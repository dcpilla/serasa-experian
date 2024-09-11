## Utilizando onlyscan para Node

Antes de continuar leia [como funciona o SonarQube no PiaaS](sonarqube.md).

Para que o procedimento funcione primeiramente você deve instalar os seguintes pacotes:

```chromium-chromedriver git```

Em seguida, ainda no stage de build da sua imagem, declare os seguintes ENV:

```
ENV GIT_SSL_NO_VERIFY=false
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV BUILD_ENV=@@BUILD_ENV@
```

<b>Observação: o diretório do binário do Chrome pode variar conforme a imagem utilizada.</b>

Agora, realize as seguintes configurações para o Git e o NPM:

```
RUN npm set progress=false && \
npm config set depth 0 && \
npm cache clean --force && \
npm config set registry="https://nexus.devsecops-paas-prd.br.experian.eeca/repository/npm-central/" && \
git config --global http.sslVerify false
```

Agora faremos os ajustes para que sua imagem Docker possa realizar os testes da sua aplicação:

```
WORKDIR /ng-app
COPY . .
## Exec test for sonarqube
RUN $(npm bin)/ng test --watch=false --code-coverage=true --browsers=ChromeHeadless
```

<b>Observação: caso seus diretórios sejam diferentes, realize as alterações pertinentes.</b>

Também será necessário os seguintes ajustes no seu arquivo de configurações do Karma:

```

browsers: ['ChromeHeadless'],
customLaunchers: {
ChromeHeadless: {
base: 'Chrome',
flags: [ '--no-sandbox',
'--headless',
'--disable-gpu',
'--remote-debugging-port=9222']
}
},
```

E por fim, após realizar todos esses ajustes em seu stage de build, crie um novo stage intermediário para execução do Sonar:

```
# STAGE 2: Sonarqube ###
FROM <DEVSECOPS_SONARQUBE_NODEIMAGE> as sonarqube-for-piaas
 
## Set env's for sonarqube
ENV projectKey=@@PROJECT_KEY@@
ENV projectName=@@PROJECT_NAME@@
ENV projectVersion=@@PROJECT_VERSION@@
ENV gitRepo=@@GIT_REPO@@
 
## Copy app from builder to test
COPY --from=builder /ng-app /app
 
## Running sonarscanner
WORKDIR /app
RUN if [ -e sonar-runner.properties ] ; then echo "Update sonar-runner.properties" ; cp -f sonar-runner.properties /root/sonar-scanner-3.0.3.778-linux/conf/sonar-scanner.properties ; else echo "Using sonar-runner.properties default"; fi && \
echo "Send to sonar" &&\
sonar-scanner -Dsonar.projectBaseDir=/app \
-Dsonar.verbose=true \
-Dsonar.projectKey=${projectKey} \
-Dsonar.links.scm=${gitRepo} \
-Dsonar.projectName=${projectName} \
-Dsonar.projectVersion=${projectVersion}
```

<b>Observação: caso seus diretórios sejam diferentes, realize as alterações pertinentes.</b>