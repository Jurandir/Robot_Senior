// 11/09/2021 10:09 - (001) - ENTREGA REALIZADA NORMALMENTE - ITRACK

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/IT/consultas/entrega_comprovantes.SQL')
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const enviaComprovantes     = require('../../metodsAPI/IT/enviaComprovantes')
const sqlQuery             = require('../../connection/sqlSENIOR')
const dataSetToJson        = require('../../helpers/dataSetToJson')
const grava_MsgApiResponse = require('../../metodsDB/IT/grava_MsgApiResponse')

const comrovantes = async () => { 
    let ret = []
    try {
        let oco   = await sqlQuery(sql)
        let bodys = dataSetToJson(oco)
  
        for await (let body of bodys ){
          let env = await enviaComprovantes(body)
          let grv = []
          
          if(env.success){
            grv  = await grava_MsgApiResponse( env.data, body.content.idTrackingCliente )
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
      console.log('(comrovantes) ERRO:',err)
      return ret
    }
  }

module.exports = comrovantes