const fs             = require('fs')
const path           = require('path')
const sqlFileName    =  path.join(__dirname, '../../sql/consultas/processo_de_transferencia_entre_filiais.SQL')
const sql            = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../helpers/enviaDadosAPI')

const base = () => {
    return {
      "embarque": { },
      "embarcador": { },
      "destinatario": { "endereco": { } },
      "transportadora": { },
      "pedido": { },
      "trecho": { "enderecoOrigem": { } , "enderecoDestino": { } , "transportadora": { } },
      "ocorrencia": { },
    }
}

const transfereNF = async (cfg,cli) => {
    return await enviaDadosAPI(cfg,cli,base,sql)
}

module.exports = transfereNF