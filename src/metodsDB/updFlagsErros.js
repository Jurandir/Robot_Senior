const moment  = require('moment')
const sqlExec = require('../connection/sqlExec')

const updFlagsErros = async (dados,response) => {
    let result = {success: false, message:'updFlagsErros' ,rowsAffected: 0 , embarque: response }

    // console.log('(updFlagsErros) 0')

    if(!response.data) {
        // console.log('(updFlagsErros) Passou 2')
        return result
    }
    // console.log('(updFlagsErros) Passou 1')

    let base        = response.data.response  
    let list        = base.data.message
    let code        = base.data.status
    let flag        = code==200 ? 1 : 2
    let protocolo   = base.data.protocolo
    result.embarque = base

    console.log(moment().format(),'- (updFlagsErros.js) Lista:',list)
    
    list.map( async (item) => {
        let sql = `UPDATE SIC.dbo.CONFIRMAFACILOCORRENCIA 
                      SET FLAG_SEND          = ${flag},
                          DT_SEND            = CURRENT_TIMESTAMP,
                          RESPOSTA_MSG       = '${item.message}',
                          RESPOSTA_STATUS    = '${code}',
                          RESPOSTA_PROTOCOLO = '${protocolo}'
                    WHERE ID = (${dados[item.posicao].FLAG_ID})`
        try {

            let result = await sqlExec(sql)         
            if( result.success ) {
                console.log(moment().format(),'- Lista - STATUS BD (UPD SUCESSO): ID:',dados[item.posicao].FLAG_ID,'MSG:', item.message )
            } else {
                console.log(moment().format(),'- Lista - FALHA UPD (FLAG ERROS)- SQL DB:',item,sql )
            }
    
        } catch (err) {
            console.log(moment().format(),'- Lista - ERRO UPD (FLAG ERROS)- SQL DB:',item,err.message,sql )
        }
    })
    return result

}

module.exports = updFlagsErros
