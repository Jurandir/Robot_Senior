const fs             = require('fs')
const path           = require('path')
const sqlFileName    = path.join(__dirname, '../../sql/consultas/processo_de_transporte_iniciado.SQL')
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

const registraNF = async (cfg,cli) => {
    let ret = await enviaDadosAPI(cfg,cli,base,sql)    
    return ret
}

module.exports = registraNF