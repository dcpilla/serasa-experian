/**
 * deliveryReliability
 * Método faz chamadas aos testes de perfomance e qualidade
 * @version 8.3.0
 * @package DevSecOps
 * @author  Douglas Pereira <douglas.pereira@br.experian.com>
 * @return  true | false
 **/


def deliveryReliability(performance, quality, cmd) {
    try {
        def k6Params = []
        def newmanParams = []
        def commonParams = []

        if (cmd) {
            cmd.split(' ').each { param ->
                if (param.contains('--strategy-test')) {
                    commonParams << param
                } else if (param.contains('--virtual-users') || param.contains('--test-duration') || param.contains('--max-req-duration')) {
                    k6Params << param
                } else if (param.contains('--workspace')) {
                    newmanParams << param
                }
            }
        }

        def k6Cmd = (k6Params + commonParams).join(' ')
        def newmanCmd = (newmanParams + commonParams).join(' ')

        if (newmanCmd) {
            quality.newman(newmanCmd)
        } else {
            quality.newman('')
        }

        if (k6Cmd) {
            performance.k6(k6Cmd)
        } else {
            performance.k6('')
        }

        if (piaasMainInfo.qs_test_score == 100 && piaasMainInfo.performace_score == 100) {
            utilsMessageLib.infoMsg("All tests score passed")
            piaasMainInfo.delivery_reliability_performed = 'true'
        } else {
            piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_DR_000'
            utilsMessageLib.errorMsg("One or more tests failed")
            piaasMainInfo.delivery_reliability_performed = 'false'
        }
    } catch (err) {
        piaasMainInfo.pipeline_code_error  = 'ERR_AFTER_DEPLOY_DR_001'
        utilsMessageLib.errorMsg("Error during delivery reliability tests: ${err.message}")
        piaasMainInfo.delivery_reliability_performed = 'false'
    }
}

return this

