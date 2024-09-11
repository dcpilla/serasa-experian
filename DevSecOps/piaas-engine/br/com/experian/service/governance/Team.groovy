/**
 * team
 * Método execução de stage team
 * @version 8.27.0
 * @package DevOps
 * @author  Paulo Ricassio <pauloricassio.dossantos@br.experian.com>
 * @return  true | false
 **/
def team() {
    piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_000'

    echo "Start stage : [TEAM]"
    version = mapResult.version
    mapResult.team.each { key, value ->
        switch (key.toLowerCase()) {
            case "tribe":
                if (value != null) {
                    tribe = value.toLowerCase().replaceAll(" ", "_")
                    piaasMainInfo.tribe = tribe
                }
                break
            case "squad":
                if (value != null) {
                    squad = value.toLowerCase().replaceAll(" ", "_")
                    piaasMainInfo.squad = squad
                }
                break    
            case "business_service":
                changeorderBusinessService     = value
                piaasMainInfo.business_service = changeorderBusinessService
                break
            case "assignment_group":
                changeorderAssignmentGroup                 = value
                piaasMainInfo.assignment_group_application = changeorderAssignmentGroup
                break 
            default:
                utilsMessageLib.errorMsg("Implementation '${key}' in team stage not performed :(")  
        }
    }

    //piaasMainInfo.pipeline_code_error  = 'ERR_GLOBAL_DETECT_SECRETS_000'
    //serviceSecurityValidations.detectSecrets()

    if ( ( tribe == null ) || ( tribe.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Tribe not informed on piaas.yml, please add a attribute in stage team")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "team:"
        echo "  tribe: Credit Services"
        echo ""
        echo "Tribes available: Credit Services | DA And MS | TI | INFRA | Score | BackOffice | MPME | e-ID | Digital Transformation | Data Strategy"
        currentBuild.description = "Not informed the tribe of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Tribe not informed on piaas.yml, please add a tag in stage team."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de tribe caso não exista crie a entrada no stage team da sua respectiva tribe, exemplo tribe: Credit Services. Tribos disponiveis Credit Services | DA And MS | TI | INFRA | Score | BackOffice | MPME | e-ID | Digital Transformation | Data Strategy"
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_001'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }

    if ( ( squad == null ) || ( squad.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Squad not informed on piaas.yml, please add attribute in stage team")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "team:"
        echo "  squad: Pangolas"
        currentBuild.description = "Not informed the squad of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Squad not informed on piaas.yml, please add attribute in stage team."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de squad caso não exista crie a entrada no stage team da respectiva squad, exemplo squad: Pangolas."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_006'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }

    if ( ( changeorderBusinessService == null ) || ( changeorderBusinessService.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Business Service not informed on piaas.yml, please add attribute in stage team")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "team:"
        echo "  business_service: Cadastro Positivo"
        currentBuild.description = "Not informed the business_service of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Business Service not informed on piaas.yml, please add attribute in stage team."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de business_service caso não exista crie a entrada no stage team da respectiva business_service, exemplo business_service: Cadastro Positivo."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_007'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }

    if ( ( changeorderAssignmentGroup == null ) || ( changeorderAssignmentGroup.trim().isEmpty() ) ) {
        utilsMessageLib.errorMsg("Business Service not informed on piaas.yml, please add attribute in stage team")
        echo "Example of the using in piaas.yml:"
        echo ""
        echo "team:"
        echo "  assignment_group: Cadastro Positivo"
        currentBuild.description = "Not informed the assignment_group of the application. Impossible to proceed with the pipeline"
        errorPipeline = "Business Service not informed on piaas.yml, please add attribute in stage team."
        helpPipeline = "Verifique se em seu piaas.yml existe as configurações de assignment_group caso não exista crie a entrada no stage team da respectiva assignment_group, exemplo assignment_group: DevSecOps Paas Brazil."
        piaasMainInfo.pipeline_code_error = 'ERR_GLOBAL_008'
        echo "Solucao: ${helpPipeline}"
        if (gitAuthorEmail != "") {
            controllerNotifications.cardStatus('helpPipeline')
        }
        throw new Exception(errorPipeline)
    }

    utilsMessageLib.infoMsg("Tudo certo com o preencimento do piaas.yaml no campo team! Seguindo com a execução...")

}

return this