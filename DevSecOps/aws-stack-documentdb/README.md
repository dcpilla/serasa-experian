# aws-stack-documentdb
----

## What is aws-stack-documentdb?

Hello, I'm a launch for creating AWS DocumentDB in your Amazon account. Special-pupose database service for large-scale management of JSONs data, based on MongoDB with at rest encryption.

 - For to be executed correctly, your AWS account must already have onboarding carried out with the CockPit. [Here for details](https://pages.experian.com/pages/viewpage.action?pageId=1081626313).


| Characteristic         | Description                                                            
| ---------------------- | ---------------------------------------------------------------------
| Category               | Aws
| ITIL Request           | True
| ITIL Change Order      | False;True
| Inner Source           | Teams can contribute to its evolution
| Conformidade           | Launch ensures DevSecOps PaaS standards for launch creation   


#### Instructions for Filling in: Data Governance Fields

## Campo category_new

* **Productive data**: storage of real data, commercial or not, confidential or restricted, in a production environment or not, and that may or may not be being used to feed some product. Example: CPF, CNPJ, address, email, telephone, denial data, variable books. This is the category that has the highest criticality, not only in the processes described by this procedure, but also in the monitoring and access control processes;

* **Development/Homologation/Sandbox**: data assets whose purpose is non-production, to support development and/or testing processes.

**IMPORTANT**: If the data asset environment is NON-PROD (dev, hml or sdb) and stores real and productive data, select the PRODUCTIVE DATA option.

**NOTE**: Productive data in a development environment must necessarily have the same security criteria as in a production environment (e.g. log monitoring, encryption, SOD, GSO risk acceptance, etc.).

* **Model Development**: data assets whose purpose is the manipulation of data to create models/variable books.

* **Logs**: exclusive purpose of logging operational activities

* **Embedded**: exclusive purpose to support a specific application;

* **Metadata**: exclusive purpose of storing technical operational data;

* **Cache**: Exclusive purpose of temporary cache storage;

**Campo data_type** – required if you have selected the Productive Data tag, otherwise select N/A.

**IMPORTANT**: If the data asset environment is NON-PROD (dev, hml or sdb) and stores real and productive data, select the PRODUCTIVE DATA option and fill in the data_type tag with the appropriate information.

**Campo category_data** – fill N/A if you have NOT selected the categories Productive data or Dev/Dev Models/Homolog/Sandbox

Inform the category of data that will be stored in the asset. The possible options are:

cadastral – exemplo: CPF, endereço, email; comportamental – exemplo: histórico de passagem, modelos/books; negativo – exemplo: dados de anotações negativas (PEFIN, REFIN); positivo – exemplo: histórico de crédito financeiro – exemplo: dados de balanço, dados relacionados a operações de vendas (clientes, fornecedores); transacional – exemplo: dados relacionados a transações específicas;

NOTE: If the data stored in your database does not fall into any of the above data categories, select N/A and contact the [Governança de Dados](https://experian.sharepoint.com/sites/DataGovernanceSerasaExperian/SitePages/EventPlanHome.aspx?OR=Teams-HL&CT=1634764844657#equipe-de-governan%C3%A7a-de-dados).

## How to launch
* [User Guide](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse/doc/user_guide.md) - Escolha `aws-stack-documentdb`.

## How to contribute
* [Contributing Guide](docs/CONTRIBUTING.md) - Inner Source.

## Versioning

Be sure to know and contribute to the next versions of `aws-stack-documentdb` [Backlog](docs/BACKLOG.md) 

`1.1.2` - Wed Apr 30 18:07:00 -03 2024
* `FIX`    - Correção na geração de senha sem caracteres especiais.
* `UPDATE` - Ajuste para o uso de Subnet Groups

`1.1.1` - Wed Mar 13 09:20:00 -03 2024
* `UPDATE` - Ajustes no código do terraform.
* `FIX`    - Correção na maneira que constroe o ambiente.
* `FIX`    - Correção para usar VENV do python.

`1.1.0` - Mon Jan 22 20:58:00 -03 2024
* `ADD` - Atualização para aproveitar recursos existentes.
* `UPDATE` - Atualização de providers e ajustes importantes no código.

`1.0.0` - Tue May 24 14:55:15 -03 2022
* `ADD` -  Criação do repositório e sua estrutura inicial  

## Author

* **Deivid Pilla** - (SRECSCross@br.experian.com)
