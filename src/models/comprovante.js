const fs             = require('fs')
const path           = require('path')
const sqlFileName    = path.join(__dirname, '../../sql/consultas/comprovantes.SQL')
const sqlFile        = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../helpers/enviaDadosAPI')

const base = () => {
    return {
      "embarque": { },
      "embarcador": { },
      "destinatario": { },
      "transportadora": { },
      "ocorrencia": { },
    }
}

const comprovante = async (cfg,cli) => {
   let server = cfg.comprovanteURL
   let sql    = eval('`'+sqlFile+'`');
  
    return await enviaDadosAPI(cfg,cli,base,sql)
}

module.exports = comprovante