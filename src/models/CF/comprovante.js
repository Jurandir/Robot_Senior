// 30/08/2021 16:00
const fs             = require('fs')
const path           = require('path')
const sqlFileName    = path.join(__dirname, '../../sql/CF/consultas/comprovantes.SQL')
const sqlFile        = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../../helpers/enviaDadosAPI_CF')

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
   let sql    = eval('`'+sqlFile+'`')
   let debug  = false

   let ret = await enviaDadosAPI(cfg,cli,base,sql,debug)

    return ret
}

module.exports = comprovante