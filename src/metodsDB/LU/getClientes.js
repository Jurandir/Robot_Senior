// 23/02/2022 09:48 - CLIENTES Lupe-ON - ("Lupe-ON - V.01")

const sqlQuery = require('../../connection/sqlSENIOR')

const getClientes = async () => {
    let sql = `SELECT * FROM SIC..LUPEON_CLIENTE WHERE FLAG_ATIVO = 1`
 
    try {
        let result = await sqlQuery(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'getClientes',
            sql: sql,
            err: err
        }
        return Erro
    } 
}

module.exports = getClientes