// 13/10/2021 10:50 - ENTREGA PROGRAMADA - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/CF2/rotinas/geraProcessoEntregaProgramada.SQL')
const sqlInitEmRota        = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initEntregaProgramada = async () => {
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
            rotine: 'V2 initEntregaProgramada',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 
}

module.exports = initEntregaProgramada
