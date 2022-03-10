const saveLogJSON       = require('../../helpers/saveLogJSON')
const saveLog           = require('../../helpers/saveLog')

const montaJsonPOD = async (itn) => {
    let ret = [{
            EmbarcadorCNPJ: itn.EMBARCADOR,
            Embarcador: itn.EMBARCADOR_NOME,
            TransportadoraCNPJ: itn.TRANSPORTADOR,
            Transportadora: "TERMACO",
            NFeNumero: itn.NUMERO,
            SerieNFe: itn.SERIE,
            ChaveNFe: itn.CHAVE,
            StatusAtual: itn.OCORRENCIA_NOME,
            DataOcorrencia: itn.OCORRENCIA_DATA,
            ImgComprovante: itn.ImgComprovante,
            ExtensaoDoc: itn.ExtensaoDoc
    }]
    
    saveLog('LU',`base64_${ itn.CHAVE }.txt`,itn.ImgComprovante)
    saveLogJSON('LU',`body_${ itn.CHAVE }.txt`,ret)

    return ret
}

module.exports = montaJsonPOD