// 11/09/2021 08:37 - (100) - EM ROTA PARA ENTREGA - ITRACK

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/IT/consultas/rota_para_entrega.SQL')
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const enviaOcorrencias     = require('../../metodsAPI/IT/enviaOcorrencias')
const sqlQuery             = require('../../connection/sqlSENIOR')
const dataSetToJson        = require('../../helpers/dataSetToJson')
const grava_MsgApiResponse = require('../../metodsDB/IT/grava_MsgApiResponse')

const rotaEntrega = async () => { 
    let ret = []
    try {
        let oco   = await sqlQuery(sql)
        let bodys = dataSetToJson(oco)
  
        for await (let body of bodys ){
          let env = await enviaOcorrencias(body)
          if(env.success){
            let grv  = await grava_MsgApiResponse( env.data, body.content.idTrackingCliente )
            env.body = body
            env.upd  = grv
            ret.push(env)
          }
        }
        return ret
  
    } catch (err) {
      console.log('(rotaEntrega) ERRO:',err)
      return ret
    }
  }

module.exports = rotaEntrega