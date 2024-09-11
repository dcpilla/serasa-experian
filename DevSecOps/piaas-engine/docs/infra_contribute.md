# Contribuição - Infraestrutura

![Mais que amigos, friends!](https://miro.medium.com/v2/resize:fit:960/1*3gux4QZq2gfyRKFkP3shew.jpeg)

Então como você já leu nós agora trabalhamos com conceito de efemeridade de servidores para o nosso PiaaS. Mas antes de entrarmos no assunto, vamos entender a divisão da nossa infraestrutura.

A estrutura física está divida em:

* Controller: responsável por orquestrar as execuções através dos workers, configurações, plugins etc.
* Workers: responsável por executar o processo de CI/CD.

Sendo que o Controller é provisionado através de um ASG (Auto Scaling Group) através de uma AMI com todas as configurações necessárias, com um ALB escutando as requisições.

Já os workers, são configurados internamente no PiaaS para serem provisionados conforme a necessidade, de forma automática, também baseado em uma AMI.

Ambas as AMIs são geradas via automação utilizando Packer e Ansible.

### AMIs

Nossa [AMI do Controller](https://code.experian.local/projects/SCIB/repos/piaas-build-controller-ami/browse) e [AMI dos Workers](https://code.experian.local/projects/SCIB/repos/piaas-build-agent-ami/browse) são automações disponibilizadas no CockPit DevSecOps. Ou seja, você pode contribuir diretamente nos repositórios para que sejam incorporados em futuras AMIs a serem utilizadas no PiaaS, assim como já acontece em outras automações disponibilizadas por lá.

Novos pacotes de SO, configurações extras, novos softwares: as possibilidades são infinitas!

### Observações

Por uma questão de segurança a execução dessas automações são restritas ao time DevSecOps. Quando realizar suas alterações e submeter a PR para homologação, solicite ao time DevSecOps que realize o processo de provisionamento da nova AMI no ambiente de testes do PiaaS bem como sua homologação para garantir sua estabilidade.

Estando tudo certo, será realizado o merge para master e programada a alteração em ambiente produtivo.

Você pode solicitar a homologação por parte do time DevSecOps através da nossa [fila do Service Now](https://experian.service-now.com/now/nav/ui/classic/params/target/com.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3Ddb92652c1bab70142e00a860f54bcbeb).