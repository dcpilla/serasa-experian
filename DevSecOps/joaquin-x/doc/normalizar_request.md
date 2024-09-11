** Normalizar request para automações **
----
> A normalização é necssária para realizarção dos parse dos campos e deixar a categoria da request 100% automática

Iremos te guiar passo a passo de como solicitar a normalização e realizar o parse dos campso da sua request para incluir na automação. Uma request está normalizada quando se cumpre os seguintes itens:

| Item                       | Descrição             
| -------------------------------| ------------------------ 
| Não permitir que uma request tenha 1:n de ritm abertos | As request devem ser 1:1, ou seja um request com um unico ritm.
| Incluir campo u_template no formulário da request | Este campo é responsável em dizer qual catalogo será invocado para a execução da mesma. 


## Como Normalizar

São simplesmente `DOIS` passos para o paraiso.
------

1. Solicite o parse da request
> Envie um E-mail para o time DevSecOps Architecture Brazil, com o titulo `Solicitação de parse de request` e no corpo escreva o time onwer da request e um número de request de exemplo para a extração.

2. Solicite a normalização
> Abra uma request usando essa categoria [Request para Normalização](https://experian.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_guide_view.do%3Fv%3D1%26sysparm_initial%3Dtrue%26sysparm_guide%3D929d1263db2d5f80de5d3f3ffe9619a2%26sysparm_link_parent%3De9448ad3db0743007bd1317ffe96199a%26sysparm_catalog%3De0d08b13c3330100c8b837659bba8fb4%26sysparm_catalog_view%3Dcatalog_default) para o time de `Ferramentas de Ti` com os detalhes da categoria e solicitações de normalização. Exemplo de solicitação: REQ1444816.

## Author

* **DevSecOps PaaS** - (devsecops-architecture-brazil@br.experian.com)