# CONTRIBUTING
----
> Inner Source o/

## Execução

O framework  [JoaquinX](https://code.experian.local/projects/SCIB/repos/joaquin-x/browse) realiza o seguinte fluxo:
* `> LOAD` - Worflow definido em joaquin-infra.yml.
* `> ITIL INTEGRATION` -  Realiza ou Ignora integrações ITIL?
* `> WAIT` -  Aguarda confimação do usuário para execução do launch?
* `> PREPARE GLOBAL` -  Realiza a leitura das variáveis definidas em  global do joaquin-infra.yml.
* `> EXECUTION BEFORE_PLAN` -  Injeta variáveis nos arquivos de plano rollout:
	* Quais arquivos?
* `> EXECUTION PLAN` -  Executa o plano de rollout com o steps:
	* Quais arquivos do plano de rolout?

Todo o fluxo é considerado `return == 0` para seguir para o próximo step.

## Extruturação 

```
├── docs              - Documentação do launch
├── file1             - Descreve a file1
├── file2             - Descreve a file2
├── file3             - Descreve a file3
├── fileN             - Descreve a fileN
├── dir               - Descreve o dir
├── README.md         - Detalhamento do launch
└── joaquin-infra.yml - Worflow da automação 
```

## Porque contribuir?

O Greenpeace agradeçe pois você acaba de salvar 1 baleia no mundo e todos Serasa Experian ficaram felizes com sua contribuição !!! 

`#juntos_somos_mais_fortes`  `#everybody_can_devops` `#experianone`

## Author

* **Cristian.Alexandre** - (Cristian.Alexandre@br.experian.com)