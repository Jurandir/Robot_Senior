// 12/09/2021 14:57 - OCORRENCIAS MANUAIS - SÊNIOR - ITRACK

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/IT/consultas/ocorrencias.SQL')
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const enviaOcorrencias     = require('../../metodsAPI/IT/enviaOcorrencias')
const sqlQuery             = require('../../connection/sqlSENIOR')
const dataSetToJson        = require('../../helpers/dataSetToJson')
const grava_MsgApiResponse = require('../../metodsDB/IT/grava_MsgApiResponse')

const ocorrencias = async () => {
  let ret = []
  try {
      let oco  = await sqlQuery(sql)
      let bodys = dataSetToJson(oco)

      for await (let body of bodys ){
        let env = await enviaOcorrencias(body)
        if(env.success){
          let grv  = await grava_MsgApiResponse( env.data, body.content.idTrackingCliente )
          env.body = body
          env.upd  = grv
          ret.push(env)
        } else { 
          let erro = { success:false , message: env.err, data: [], code: env.data.response.status }
          grv = await grava_MsgApiResponse( erro, body.content.idTrackingCliente )
          env.body = body
          env.upd  = grv
          ret.push(env)
        }

      }
      return ret

  } catch (err) {
    console.log('ERRO:',err)
    return ret
  }
}

module.exports = ocorrencias