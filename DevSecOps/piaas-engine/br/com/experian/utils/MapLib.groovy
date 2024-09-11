/**
 * parseArguments
 * Recebe uma string de argumetos e transforma em um map
 * @version 8.0.0
 * @package DevOps
 * @author  Daniel Miyamoto <Daniel.Miyamoto@br.experian.com>
 * @return  map com os argumentos parseados
 **/
def parseArguments(def args) {
    def pattern = ~/--(?<argument>[^ =]+)=(?<value>('[^']+?'|"[^"]+?"|[^ ]+))/
    def matcher = pattern.matcher(args)
    
    def arguments = [:]
    while(matcher.find()){
        arguments[matcher.group('argument').trim().toLowerCase()] = matcher.group('value').replaceAll('''^(?<quote>['"])(.*)\\k<quote>''',"\$2")
    }

    return arguments
}

return this