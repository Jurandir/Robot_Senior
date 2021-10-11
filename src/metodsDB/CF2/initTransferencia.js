// 11/10/2021 16:18 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS - ("CONFIRMA FACIL V2")

// TEST

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/CF2/rotinas/geraProcessoTransferenciaFiliais.SQL')
const sqlInitTransferencia = fs.readFileSync(sqlFileName, "utf8")

let flag_livre      = true

const initTransferencia = async () => {
    let sql = sqlInitTransferencia

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
            rotine: 'V2 initTransferencia',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initTransferencia
