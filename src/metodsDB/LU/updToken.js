
// 23/02/2022 09:48 - UPDATE TOKEN CLIENTES NA BASE DE DADOS - Lupe-ON - ("Lupe-ON - V.01")

const sqlExec = require('../../connection/sqlExSENIOR')
const validadeHoras = 2

const updToken = async ({ID,TOKEN,CREATE,VALIDADE}) => {
    let sql = `
    UPDATE SIC..LUPEON_TOKEN 
       SET TOKEN         = '${TOKEN}'
         , DT_CREATE     = '${CREATE}'
         , DT_VALIDADE   = '${VALIDADE}'
         , DT_UPDATE     = CURRENT_TIMESTAMP
     WHERE ID            = ${ID}
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