// 11/10/2021 11:57 - REGISTRA NF - PROCESSO INICIADO - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment         = require('moment')
const fs             = require('fs')
const path           = require('path')
const sqlFileName    = path.join(__dirname, '../../sql/CF2/consultas/processo_de_transporte_iniciado.SQL')
const sqlBase        = fs.readFileSync(sqlFileName, "utf8")
const enviaDadosAPI  = require('../../helpers/enviaDadosAPI_CF2')
const getClientes    = require('../../metodsDB/CF2/getClientes')

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

const registraNF = async () => {    
  let retorno = []
  let listCli = await getClientes()                             // Lista de Clientes CF

  if(!Array.isArray(listCli)) {
    console.log(moment().format(),'conhecimentoRetido.js - getClientes():',listCli)    
    return retorno
  }

  for await (cli of listCli ) {                                 // Loop Clientes CF
      let raiz   = cli.RAIZ
      let sql    = eval('`'+sqlBase+'`');                       // Ajusta SQL para filtrar por RAIZ DO CNPJ
      let ret    = await enviaDadosAPI(cli,base,sql)
      ret.raiz   = raiz

      retorno.push(ret)
        
      if(!ret.success) {
        if(ret.rowsAffected == -1 ) {
            console.log(moment().format(),'V2 - FALHA (registraNF.js) RET:',ret)    
        }   
      }   
  }
  return retorno
}

module.exports = registraNF