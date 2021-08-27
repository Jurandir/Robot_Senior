const sqlExec       = require('../connection/sqlExec')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/rotinas/geraEncerramento.SQL')
const sqlEncerraProcessos  = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const encerraProcessos = async () => {
    let sql = sqlEncerraProcessos

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
            rotine: 'encerraProcessos',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = encerraProcessos
