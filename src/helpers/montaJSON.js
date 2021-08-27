const montaJSON = async (lista,base) => {
    let dados   = {}
    let retorno = []
    const setVar = async (campo,valor) => {
        if(campo=='FLAG_ID') {return}
        if(valor==null) {return}
        let chave  = `${campo}`.split('_')
        let chaves = chave.length

        if(campo=='ocorrencia_fotos') {
            chaves=0
            dados[chave[0]][chave[1]] = [valor]
        }

        if(chaves==1) { dados[chave[0]] = valor }
        if(chaves==2) { dados[chave[0]][chave[1]] = valor }
        if(chaves==3) { dados[chave[0]][chave[1]][chave[2]] = valor }
        if(chaves==4) { dados[chave[0]][chave[1]][chave[2]][chave[3]] = valor }
    }

    for await (let obj of lista) {

        dados       = base()
        let campos  = Object.keys(obj)

        for await (let campo of campos) {
            await setVar( campo , obj[ campo ] )
        } 
        retorno.push(dados)
    } 

    return retorno
}

module.exports = montaJSON
