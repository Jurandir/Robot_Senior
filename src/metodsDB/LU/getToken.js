// 23/02/2022 09:48 - TOKEN Lupe-ON - ("Lupe-ON - V.01")

const sqlQuery = require('../../connection/sqlSENIOR')

const getToken = async () => {
    let sql = `SELECT * FROM SIC..LUPEON_TOKEN` 
    try {
        let result = await sqlQuery(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'getToken',
            sql: sql,
            err: err
        }
        return Erro
    } 
}

module.exports = getToken