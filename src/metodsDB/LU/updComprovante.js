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
        return Erro
    } 
}

const updComprovante = async ({CTRC,flag,data}) => {

    let jComprovantes = JSON.stringify( data.map(i=>i.url) )

    let sql = `UPDATE SIC..LUPEON_NFE 
                SET FLAG_COMPROVANTE  = ${flag},
                    JSON_COMPROVANTE  = '${jComprovantes}'
                WHERE CTRC = '${CTRC}'`

    let ret = await runExecSQL(sql,'updComprovante')

    if(!ret.success) {
        console.log(moment().format(),`- ( ERRO UPDATE ) :`,ret)
    }
    
    return ret
}

module.exports = updComprovante