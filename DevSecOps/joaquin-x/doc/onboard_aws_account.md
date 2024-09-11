** Onboard de contas AWS **
----
> O onboard de contas AWS é necessário para que a automação do JoaquinX consiga executar os lançadores de recursos e serviços AWS corretamente.

## Como fazer o onboard

1. Definição do usuário sistêmico para automação:
    * Caso seja a primeira vez de executar uma automação na sua conta é necessário a solicitação de um user sistêmico que orientamos seguir o padrão `BuUserForTerraform` com role anexada de `BUAdminBasePolicy`, solicite o time de cloud fazer o liberação para você [Request](https://experian.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3D6f7f615fdbefea007bd1317ffe961992%26sysparm_link_parent%3De9448ad3db0743007bd1317ffe96199a%26sysparm_catalog%3De0d08b13c3330100c8b837659bba8fb4%26sysparm_catalog_view%3Dcatalog_default%26sysparm_view%3Dtext_search), pois as automações necessitam desta role para seguir com sucesso. Sem esse Acesso a Automação `NÃO FUNCIONARA`. Você deverar ter o AWS_ID e o AWS_KEY_ID, estes dados serão solicitados no Inicio da automação do Catalogo de Serviço.
    * Se já tem um usuário sistêmico na conta verifique se o mesmo conta com a role `BUAdminBasePolicy`, caso não tenha solicite o time de cloud para anexar ao mesmo.

2. No repositório [ans-shared-vars](https://code.experian.local/projects/SCIB/repos/ans-shared-vars) crie uma nova branch a partir da branch 'master' e nessa nova branch, crie um novo arquivo seguindo a nomenclatura abaixo:

    `aws-<ACCOUNT_NUMBER>-env.yml`

3. Insira o seguinte template no conteúdo do arquivo criado:
    ```yaml
    domain: .serasa.intranet
    prefix_hostname: "{{ prefix_stack_hostname }}"
    stack_name: "{{ prefix_stack_name }}"
    aws_region: sa-east-1
    env: <AMBIENTE>
    tribe: <TRIBE>
    vpi_id: <ID_VPC>
    subnet:
        a: <ID_SUBNET_1>
        b: <ID_SUBNET_2>
    kms_id: <ID_KMS>
    aws_account_id: <ACCOUNT_NUMBER>
    ami_id: "{{ ami_id_rhel7 }}"
    ami_id_rhel7: ami-0079d0f7320c240ae
    ami_id_rhel8:
    ##Identity_ssh
    ansible_ssh_private_key_file: ~/.ssh/id_rsa_ansible
    ```

4. Substitua os valores entre '<' e '>':
    * `ACCOUNT_NUMBER`: Número da sua conta AWS, deve ser o mesmo número que nomeia o arquivo
    * `AMBIENTE`: Ambiente da sua conta (Ex: dev, uat, prd)
    * `TRIBE`: Nome da tribe dona da conta AWS ( shortname com 4 letras, se caso a tribe tiver menos de 4 letras, complementar com tr de TRibe) (manter padrão de nomes em minúsculo)
    * `ID_VPC`: Identificação da VPC da sua conta AWS
    * `ID_SUBNET_1/2`: Identificação das subnets da sua conta AWS
    * `ID_KMS`: Identificação da chave de criptografia criada em sua conta AWS
    * `AMI_ID_RHEL7`: Verificar se o ID da AMI da imagem RHEL7 compartilhada da EXPERIAN existe em sua conta, se for diferente, substituir o valor. (NAO UTILIZE AMI ID DE IMAGENS QUE NAO SAO COMPARTILHADAS DA EXPERIAN!!!)
    * `AMI_ID_RHEL8`: Incluir o ID da AMI da imagem RHEL8 compartilhada da serasa existe em sua conta. ( Ainda em desenvolvimento, mas podendo conter o Id da imagem )

    **Obs**: Caso sua conta AWS esteja em outra região diferente de `sa-east-1` (padrão Serasa), altere o valor do campo `aws_region` de acordo com a região da sua conta AWS.

    **Obs**: Em caso de dúvidas sobre de onde encontrar os identificadores acima da sua conta AWS, converse com DevOps Engineer ou SRE do seu time.

5. Faça o `commit` e `push` das alterações e crie um `Pull Request` dessas alterações para a branch `master`.

6. Assim que o time `DevSecOps PaaS Brazil` verificar e aprovar seu `Pull Request` sua conta estará pronta para receber novos recursos e serviços através das automações do JoaquinX.

## Author

* **DevSecOps PaaS** - (devsecops-architecture-brazil@br.experian.com)