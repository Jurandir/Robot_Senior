// 11/10/2021 15:55 - UPDATE STATUS ENVIADO - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment  = require('moment')
const sqlExec = require('../../connection/sqlExSENIOR')

const updFlagsEnvio = async (dados,response) => {
    let IDs = dados.map( item => item.FLAG_ID).join()

    // console.log('(updFlagsEnvio) RESPONSE:',response)

    if(!response.data) {
        return { success: false, message: 'updFlags - Sem Dados (1)', rowsAffected: 0 }     
    }

    // console.log('updFlagsEnvio:',dados,response)
    
    let list      = response.data.message
    let code      = response.data.status
    let flag      = code==200 ? 1 : 0
    let protocolo = response.data.protocolo
    let message   = ''
    list.map( item => {
        message += `(${item.posicao}-${dados[item.posicao].FLAG_ID}-OK),`
    })

    let sql = `UPDATE SIC..CONFIRMAFACILOCORRENCIA 
                SET FLAG_SEND          = ${flag},
                    DT_SEND            = CURRENT_TIMESTAMP,
                    RESPOSTA_MSG       = '${message}',
                    RESPOSTA_STATUS    = '${code}',
                    RESPOSTA_PROTOCOLO = '${protocolo}'
                WHERE ID IN (${IDs})`
    try {

        if(!IDs) {
            return { success: false, message: 'updFlags - Sem Dados (2)', rowsAffected: 0 }     
        }

        let result = await sqlExec(sql)         
        if( result.success ) {
            console.log(moment().format(),'- SUCCESS - V2 - ENVIO p/ API, IDs:',IDs )
        } else {
            console.log(moment().format(),'- FALHA UPD FLAG - V2 - ENVIO p/ API, IDs:',IDs,'-',result.message )
            console.log('updFlagsEnvio SQL:',sql)
            console.log('updFlagsEnvio RESULT:',result)

        }

        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'V2 updFlagsEnvio',
            sql: sql,
            err: err
        }
        console.log(moment().format(),'- ERRO UPD FLAG - V2 - ENVIO p/ API, IDs:',IDs,'-',err.message )
        return Erro
    }
}

module.exports = updFlagsEnvio
