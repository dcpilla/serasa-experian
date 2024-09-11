# Operando o SonarQube no PiaaS

![Sonarqube](https://cdn.worldvectorlogo.com/logos/sonarqube.svg)

O [Sonarqube](https://sonarqube.devsecops-paas-prd.br.experian.eeca/) é a ferramenta utilizada no PiaaS para realizar o processo de Test Coverage na pipeline.
Caso você ainda não tenha acesso solicite via IDC o grupo <b>BR_DEVSECOPS_PAAS_SONARQUBE_DEVELOP</b>.

Temos atualmente <b>três</b> formas diferentes de execução do SonarQube no PiaaS, vamos explanar abaixo cada uma dessas formas para que você tenha pleno conhecimento dos processos.

### Execução através do Maven

Para aplicações Java e Scala o próprio Maven é utilizado para realizar o processo de Test Coverage, desde a execução dos testes até a análise do SonarQube nos resultados gerados.

Dito isso, para essas aplicações o recomendado é utilização do Sonar desta forma em seu piaas.yml dentro de <i>before_build</i>:

```yaml
before_build:
  sonarqube: 
```

### Execução através de containers

Para as demais linguagens que possuam suporte, o time DevSecOps mantêm containers que realizam todo o processo de testagem até o processo de Coverage pelo Sonar. Na [documentação de imagens Docker](docker_images.md) você pode conferir todas as imagens disponíveis.

Em questão processual ele não difere em nada do método acima, exceto pela distinção de linguagem. Por isso também é recomendado seu uso conforme abaixo:

```yaml
before_build:
  sonarqube: 
```

Com uma única exceção para as linguagens Python que devem informar o valor <i>pytest</i>:

```yaml
before_build:
  sonarqube: pytest
```

<b>O Pytest é o ÚNICO disponível para testagem no PiaaS para Python.</b>

### Execução durante o build no próprio Dockerfile da aplicação

Ambos os métodos acima tem uma grande semelhança e compartilham do mesmo princípio: o build e o scanning ocorrem em momentos distintos, por isso, o build de certa forma sempre será executado <b>duas</b> vezes.

Já neste método o build e todo o processo de coverage é realizado ao mesmo tempo, garantindo maior velocidade nos seus processos dentro do pipeline.

Para as novas linguagens, como Dart (Flutter para web) e C# (.NET Core), esse é o único método possível de ser utilizado. 

Chamamos essa bordagem de "onlyscan", onde você passa a invocar o sonarqube em seu piaas.yml no <i>after_build</i>, conforme abaixo, e somente será realizada a verificação do resultado do Test Coverage e atribuído ao seu Score neste pilar. Também fica obrigatório o uso do setenv Docker no <i>before_build</i>.

```yaml
before_build:
  setenv: docker
after_build:
  sonarqube: --onlyscan
```

Tecnicamente toda a linguagem que possua uma imagem de Sonar do time DevSecOps pode utilizar esse procedimento. No entanto, apenas acompanhamos e homologamos o processo para Dart, Node e C#. Com o C#, a distinção é que ele não possui uma imagem de Sonar para ele, pois o processo é feito por um binário da própria imagem de .NET Core.

Valorizamos o inner-source! Caso venha a homologar para sua linguagem esse procedimento, nos envie uma PR com essa documentação :)

Documentações disponíveis:

* [Onlyscan para Node](node_onlyscan.md)
* [Onlyscan para C#](csharp_onlyscan.md)
* [Onlyscan para Dart](dart_onlyscan.md)