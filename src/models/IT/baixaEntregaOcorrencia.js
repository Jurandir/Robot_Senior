// 04/10/2021 04:46 - BAIXA ENTREGA VIA OCORRENCIA - ("ITRACK")

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/IT/consultas/baixa_entrega_via_ocorrencia.SQL')
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const enviaComprovantes     = require('../../metodsAPI/IT/enviaComprovantes')
const sqlQuery             = require('../../connection/sqlSENIOR')
const dataSetToJson        = require('../../helpers/dataSetToJson')
const grava_MsgApiResponse = require('../../metodsDB/IT/grava_MsgApiResponse')

const baixaEntregaOcorrencia = async () => { 
    let ret = []
    try {
        let oco   = await sqlQuery(sql)
        let bodys = dataSetToJson(oco)
  
        for await (let body of bodys ){
          let env = await enviaComprovantes(body) // ENDPOINT user/carga/entrega/danfe 
          let grv = []

          // console.log('env',env)
          
          if(env.success){

            if(env.data && env.data.message){

              if (env.data.message == 'Erro inesperado, tente novamente mais tarde' ) {
                  env.data.message = `${env.data.message} / Baixa Entrega Com Comprovante`
                  env.data.success = false
              }

            } else {
                env.data.message = `BAIXA DE ENTREGA - Via Ocorrência.`
            }

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
      console.log('(BX Via Ocorr) ERRO:',err)
      return ret
    }
  }

module.exports = baixaEntregaOcorrencia