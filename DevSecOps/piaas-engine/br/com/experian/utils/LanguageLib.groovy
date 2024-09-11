/**
 * extractLanguageVersion
 * Método retorna a versão da linguagem
 * @version 8.24.0
 * @package DevOps
 * @author  <andre.arioli@br.experian.com>
 * @return  String
 **/
def extractLanguageVersion(def languageName) {

    def languageParts = languageName.split('-')
    def version = languageParts.size() > 1 ? languageParts[1] : ""

    return version
}

/**
 * extractLanguageName
 * Método retorna o nome da linguagem
 * @version 8.24.0
 * @package DevOps
 * @author  <andre.arioli@br.experian.com>
 * @return  String
 **/
def extractLanguageName(def languageName) {

    def languageParts = languageName.split('-')
    languageName = languageParts[0]

    return languageName
}

return this
