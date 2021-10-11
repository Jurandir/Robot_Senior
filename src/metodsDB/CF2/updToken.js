
const sqlExec = require('../../connection/sqlExSENIOR')
const validadeHoras = 2

const updToken = async ({ID,TOKEN}) => {
    let sql = `
    UPDATE SIC..CONFIRMAFACILCLIENTES 
       SET TOKEN       = '${TOKEN}'
         , DT_VALIDADE = DATEADD(HOUR,${validadeHoras},CURRENT_TIMESTAMP)
         , DT_UPDATE   = CURRENT_TIMESTAMP
     WHERE FLAG_ATIVO  = 1
       AND ID          = ${ID}
    `
 
    try {
        let result = await sqlExec(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'updToken',
            sql: sql,
            err: err
        }
        return Erro
    } 
}

module.exports = updToken