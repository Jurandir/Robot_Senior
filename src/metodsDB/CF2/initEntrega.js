// 13/10/2021 14:53 - BAIXA, REGISTRO DE ENTREGA - ("CONFIRMA FACIL V2")

// PROD-15/102021

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/CF2/rotinas/geraProcessoEntrega.SQL')
const sqlInitEntrega       = fs.readFileSync(sqlFileName, "utf8")

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
            rotine: 'V2 initEntrega',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 
}

module.exports = initEntrega
