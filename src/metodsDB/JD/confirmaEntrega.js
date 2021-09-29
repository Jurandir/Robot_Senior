// 29/09/2021 16:10 - ENTREGA CONFIRMADA - SÊNIOR - ("JOHN DEERE")

const sqlExec              = require('../../connection/sqlExSENIOR')
const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/JD/rotinas/ENTREGA_CLIENTE_FINAL_DELIVERY.SQL')
const sqlInit              = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const confirmaEntrega = async () => {
    let sql = sqlInit

    if(!flag_livre) { return { success: false, message: 'Processo ocupado !!!' }} 
    flag_livre = false
   
    try {

        let result = await sqlExec(sql)
        
        console.log('ENTREGA_CLIENTE_FINAL_DELIVERY:',result)

        flag_livre = true
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'confirmaEntrega',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = confirmaEntrega
