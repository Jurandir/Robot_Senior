// 11/09/2021 09:31 - (001) - ENTREGA REALIZADA NORMALMENTE - ITRACK

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/IT/rotinas/geraProcessoEntrega.SQL')
const sqlInitEntrega        = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initEntrega = async () => {
    let sql = sqlInitEntrega

    if(!flag_livre) { return { success: false, message: 'Processo ocupado !!!' }} 
    flag_livre = false
   
    try {

        let result = await sqlExec(sql)         
        flag_livre = true
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'initEntrega',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initEntrega
