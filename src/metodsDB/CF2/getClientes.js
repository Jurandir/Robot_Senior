// 11/10/2021 14:48 - CLIENTES CONFIRMA FACIL - ("CONFIRMA FACIL V2")

// TEST 

const sqlQuery = require('../../connection/sqlSENIOR')

const getClientes = async () => {
    let sql = `SELECT * FROM TEST..CONFIRMAFACILCLIENTES WHERE FLAG_ATIVO = 1`
 
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