/**
 * inputUser
 * Método recebe interação de usuário 
 * @version 7.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          defaultValue   - Valor default do campo
 *          description    - Decrição da pergunta
 *          field          - Nome do campo
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 *          timeoutExit    - Parametros para tratar tipo de saida do timeout
 * @return  respInput
 **/

def inputUser(def question, def defaultValue, def description, def field, def inputTimeout, def timeoutExit='error') {
    respInput = ""

    try {
        timeout(time: inputTimeout, unit: 'SECONDS') {
            userInput = input(
                id: 'userInput', message: "${question}", parameters: [
                    [$class: 'TextParameterDefinition', defaultValue: "${defaultValue}", description: "${description}", name: "${field}"]
                ])
            respInput = userInput
        }
    } catch (err) {
        if ( timeoutExit == 'error' ){
            throw err
        }
    }
}


/**
 * selectedProperty
 * Método recebe interação de usuário via select box
 * @version 8.4.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   question       - Pergunta a ser exibida
 *          choices        - Valores do select box
 *          inputTimeout   - Define o timeout para a pergunta em segundos
 * @return  respInput
 **/
def selectedProperty(def question, def choices, def field, def inputTimeout) {
    choices   =  choices.replaceAll(";", "\n")
    respInput = ""

    timeout(time: inputTimeout, unit: 'SECONDS') {
        userInput = input(
            message: "${question}", parameters: [choice(name: "${field}", choices: "${choices}")]
        )
    }

    respInput = userInput
}

return this