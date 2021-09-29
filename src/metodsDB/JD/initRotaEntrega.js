// 29/09/2021 16:46 - EM ROTA DE ENTREGA - SÊNIOR - ("JOHN DEERE")

const sqlExec              = require('../../connection/sqlExSENIOR')
const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/JD/rotinas/MAPA_ENTREGA_SHIP.SQL')
const sqlInit              = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initRotaEntrega = async () => {
    let sql = sqlInit

    if(!flag_livre) { return { success: false, message: 'Processo ocupado !!!' }} 
    flag_livre = false
   
    try {

        let result = await sqlExec(sql)
        
        console.log('MAPA_ENTREGA_SHIP:',result)

        flag_livre = true
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'initRotaEntrega',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initRotaEntrega
