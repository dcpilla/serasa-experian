## Utilizando onlyscan para Dart (Flutter Web)

Antes de continuar leia [como funciona o SonarQube no PiaaS](sonarqube.md).

Para essas aplicações basta criar um novo stage intermediário para esse processo, sendo:

```
# STAGE 2: Sonarqube ###
FROM <DEVSECOPS_SONARQUBE_FLUTTERIMAGE> as sonarqube-for-piaas

## Set env's for sonarqube
ENV projectKey=@@PROJECT_KEY@@
ENV projectName=@@PROJECT_NAME@@
ENV projectVersion=@@PROJECT_VERSION@@
ENV gitRepo=@@GIT_REPO@@

## Copy app from builder to test
COPY --from=builder /app /app

## Running sonarscanner
RUN if [ -e sonar-runner.properties ] ; then echo "Update sonar-runner.properties" ; cp -f sonar-runner.properties /root/sonar-scanner-3.0.3.778-linux/conf/sonar-scanner.properties ; else echo "Using sonar-runner.properties default"; fi && \
echo "Send to sonar" &&\
sonar-scanner -Dsonar.projectBaseDir=/app \
-Dsonar.test.inclusions=**/*_test.dart \
-Dsonar.dart.coverage.reportPaths=tests.output \
-Dsonar.sources=lib \
-Dsonar.verbose=true \
-Dsonar.tests=test \
-Dsonar.projectKey=${projectKey} \
-Dsonar.links.scm=${gitRepo} \
-Dsonar.projectName=${projectName} \
-Dsonar.projectVersion=${projectVersion}
``` 