## Utilizando onlyscan para C# (.NET Core)

Antes de continuar leia [como funciona o SonarQube no PiaaS](sonarqube.md).

Em seu processo de build da imagem docker você precisa passar um argumento para que seja possível receber o token do Sonar, algo como:

```
build:
  docker: docker build -t="example:VERSION" --build-arg SONAR_TOKEN=SONAR_TOKEN .
``` 

Agora, declare as seguintes ENV em seu Dockerfile:

```
## Set env's for sonarqube
ENV projectKey=@@PROJECT_KEY@@
ENV projectName=@@PROJECT_NAME@@
ENV projectVersion=@@PROJECT_VERSION@@
ENV gitRepo=@@GIT_REPO@@
ENV SONAR_TOKEN=${SONAR_TOKEN}
```  

Você também precisará instalar algumas ferramentas:

```
# Install SonarScanner and coverage tool
RUN dotnet tool install --global dotnet-sonarscanner && \
dotnet tool install --global dotnet-coverage
``` 

Por fim, realize o processo de Test Coverage:

```
RUN dotnet sonarscanner begin /k:${projectKey} /n:${projectName} /d:sonar.links.scm=${gitRepo} /v:${projectVersion} /d:sonar.host.url=http://10.99.48.166:9000 /d:sonar.cs.vscoveragexml.reportsPaths=coverage.xml /d:sonar.login=${SONAR_TOKEN} && \
dotnet build --no-incremental <Your solution file.sln> && \
dotnet-coverage collect 'dotnet test' -f xml  -o 'coverage.xml' && \
dotnet sonarscanner end /d:sonar.login=${SONAR_TOKEN}
``` 