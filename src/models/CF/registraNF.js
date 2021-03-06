// 30/08/2021
const fs             = require('fs')
const path           = require('path')
const sqlFileName    = path.join(__dirname, '../../sql/CF/consultas/processo_de_transporte_iniciado.SQL')
const sql            = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../../helpers/enviaDadosAPI_CF')

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
    
    if(!ret.success) {
       if(ret.rowsAffected == -1 ) {
          console.log('FALHA (registraNF.js) RET:',ret)    
       }   
    }   

    return ret
}

module.exports = registraNF