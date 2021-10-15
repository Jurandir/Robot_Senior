// 15/10/2021 09:21 - GRAVA RETORNO DE ERROS API (119) - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment  = require('moment')
const sqlExec = require('../../connection/sqlExSENIOR')

const updFlagsErros = async (dados,response) => {
    let result = {success: false, message:'updFlagsErros' ,rowsAffected: 0 , embarque: response }

    if(!response.data) {
        return result
    }

    let base        = response.data.response  
    let list        = base.data.message
    let code        = base.data.status
    let flag        = code==200 ? 1 : 2
    let protocolo   = base.data.protocolo
    result.embarque = base

    if(!list) {
        list = []
        console.log(moment().format(),'- ERRO (119) - updFlagsErros.js ')
        return result
    }
    
    list.map( async (item) => {
        let sql = `UPDATE SIC..CONFIRMAFACILOCORRENCIA 
                      SET FLAG_SEND          = ${flag},
                          DT_SEND            = CURRENT_TIMESTAMP,
                          RESPOSTA_MSG       = '${item.message}',
                          OCORRENCIA_OBS     = 'TENTATIVA DE ENVIO OCORRÊNCIA (01) P/ API',
                          RESPOSTA_STATUS    = '${code}',
                          RESPOSTA_PROTOCOLO = '${protocolo}'
                    WHERE ID = (${dados[item.posicao].FLAG_ID})`
        try {

            let result = await sqlExec(sql)         
            if( result.success ) {
                console.log(moment().format(),'- Lista - V2 (119) - STATUS BD (UPD SUCESSO): ID:',dados[item.posicao].FLAG_ID,'MSG:', item.message )
            } else {
                console.log(moment().format(),'- Lista - V2 (119) - FALHA UPD (FLAG ERROS)- SQL DB:',item,sql )
            }
    
        } catch (err) {
            console.log(moment().format(),'- Lista - V2 (119) - ERRO UPD (FLAG ERROS)- SQL DB:',item,err.message,sql )
        }
    })
    return result
}

module.exports = updFlagsErros
