const fs             = require('fs')
const path           = require('path')
const sqlFileName    =  path.join(__dirname, '../../sql/consultas/ocorrencias.SQL')
const sql            = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../helpers/enviaDadosAPI')

const base = () => {
    return {
      "embarque": { },
      "embarcador": { },
      "destinatario": { "endereco": { } },
      "transportadora": { },
      "pedido": { },
      "ocorrencia": { },
    }
}

const ocorrencias = async (cfg,cli) => {
    return await enviaDadosAPI(cfg,cli,base,sql)
}

module.exports = ocorrencias