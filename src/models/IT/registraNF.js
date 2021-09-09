// 08/09/2021 18:34 - REGISTRA INCIO DE ACOMPANHAMENTO NA API

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/IT/consultas/processo_de_transporte_iniciado.SQL')
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const enviaOcorrencias     = require('../../metodsAPI/IT/enviaOcorrencias')
const sqlQuery             = require('../../connection/sqlSENIOR')
const dataSetToJson        = require('../../helpers/dataSetToJson')
const grava_MsgApiResponse = require('../../metodsDB/IT/grava_MsgApiResponse')

const registraNF = async () => {

  let ret = []
  let oco  = await sqlQuery(sql)
  let bodys = dataSetToJson(oco)

  for await (let body of bodys ){
    console.log(body)
    let env = await enviaOcorrencias(body)
    if(env.success){
      grava_MsgApiResponse( env.data, body.content.idTrackingCliente )
      ret.push(env)
    }
  }

  return ret

}

module.exports = registraNF