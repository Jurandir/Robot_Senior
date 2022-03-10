const sqlExec       = require('../../connection/sqlExSENIOR')

const runExecSQL = async (sql,rotine) => {
    try {
        let result = await sqlExec(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: rotine,
            sql: sql,
            err: err
        }
        console.log(moment().format(),`- ( ERRO UPDATE ) :`,Erro)
        return Erro
    } 
}

const updEnvio = async ({ID,flag,message,code,protocolo}) => {

    let sql = `UPDATE SIC..LUPEON_OCORRENCIA 
                SET FLAG_SEND          = ${flag},
                    DT_SEND            = CURRENT_TIMESTAMP,
                    RESPOSTA_MSG       = '${message}',
                    RESPOSTA_STATUS    = '${code}',
                    RESPOSTA_PROTOCOLO = '${protocolo}'
                WHERE ID = ${ID}
                `
    let ret = await runExecSQL(sql,'updEnvio')

    if(!ret.success) {
        console.log(moment().format(),`- ( ERRO UPDATE ) :`,ret)
    }
    
    return ret

}

module.exports = updEnvio