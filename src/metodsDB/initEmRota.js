const sqlExec       = require('../connection/sqlExec')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/rotinas/geraProcessoSaiuParaEntrega.SQL')
const sqlInitEmRota        = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initEmRota = async () => {
    let sql = sqlInitEmRota

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
            rotine: 'initEmRota',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initEmRota
