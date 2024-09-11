/**
 * errorMsg
 * Método mensagem de erros
 * @version 5.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   msg - Mensagem a ser exibida 
 * @return  
 **/
def errorMsg(def msg) {

    currentDate = utilsDateLib.currentDate()

    echo "\u001B[31m[ERROR] ${currentDate} - ${msg}\u001B[m"
}

/**
 * infoMsg
 * Método mensagem de informação 
 * @version 5.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   msg - Mensagem a ser exibida 
 * @return  
 **/
def infoMsg(def msg) {

    currentDate = utilsDateLib.currentDate()

    echo "\u001B[32m[INFO] ${currentDate} - ${msg}\u001B[m"
}


/**
 * warnMsg
 * Método mensagem de alerta
 * @version 5.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   msg - Mensagem a ser exibida 
 * @return  
 **/
def warnMsg(def msg) {

    currentDate = utilsDateLib.currentDate()

    echo "\u001B[33m[ALERT] ${currentDate} - ${msg}\u001B[m"
}

/**
 * imLookingMsg
 * Método mensagem to te olhando
 * @version 5.0.0
 * @package DevOps
 * @author  Joao Paulo Bastos L. <Joao.Leite2@br.experian.com>
 * @param   msg - Mensagem a ser exibida 
 * @return  
 **/
def imLookingMsg(def msg) {

    currentDate = utilsDateLib.currentDate()

    echo "                             *%%%%%."
    echo "                         %%%         %%%"
    echo "                      ,%#               %%"
    echo "                     %%                   %%"
    echo "                    %#                     %%"
    echo "                   %%                       %"
    echo "                   %(                       %%"
    echo "                   %%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "                 %#%*%#///////%# %%///////%%%%%%"
    echo "                ,% %*%%******%#   %%******%(%%,%"
    echo "                  %%/ %%/**%%/%%%%%%%(**#%( %%#"
    echo "                   %%          %%%          %("
    echo "                    %                      .%"
    echo "                    *%        %%%%%       .%"
    echo "                      %#                 %%"
    echo "                       .%%            .%%"
    echo "                       .%%.%%,     %%%.%%/"
    echo "                 %%%%%%##%.  #%%%%%.  .%((%%%%%%"
    echo "             %%#(((((((((%%,         #%%(((((((((#%%."
    echo "       %%%((((((((((((((((((%%%, .%%%((((((((((((((((((#%%*"
    echo "     %%(((((((((((((((((((((((((%(((((((((((((((((((((((((#%."
    echo "   ,%(((((((((((((((((((((((((((((((((((((((((((((((((((((((%#"
    echo "   %#((((((((((((((((((((((((((((((((((((((((((((((((((((((((%"
    echo "   %%%%%%%%%%%%%(((((((((((((((((((((((((((((((((%%%%%%%%%%%%%"
    echo "  %%            %####((((((###%%%%%%%%#(((((((((%            ,%"
    echo " ,%             %%%%%%#.               %%%((((((%*            %%"
    echo " #%                                       %%%#                %%"
    echo " .%                             .%%%%%%%%%                    %#"
    echo "  %                         #%%%                              %"
    echo "  %                     %%%%                                  %*"
    echo " /%************/#%%%%%%######%%*                        ..,*/(%%"
    echo "               %%######(((((((##################%%"
    echo "               %%######(((((((((((((((((((((((((%%"
    echo " //////////////%%%%%%%%#########################%%/////////  ///"
    echo " ---------------------------------------------------------------"
    echo "\u001B[31m[ERROR] ${currentDate} - ${msg}\u001B[m"
}

return this