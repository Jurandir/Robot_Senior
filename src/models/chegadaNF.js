const fs             = require('fs')
const path           = require('path')
const sqlFileName    =  path.join(__dirname, '../../sql/consultas/chegada_na_cidade_ou_filial_destino.SQL')
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

const chegadaNF = async (cfg,cli) => {
    return await enviaDadosAPI(cfg,cli,base,sql)
}

module.exports = chegadaNF