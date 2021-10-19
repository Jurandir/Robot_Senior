// 19/10/2021 09:43 - VERIFICA CTRCs CANCELADAS E AJUSTA - (" iTrack ")

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/IT/rotinas/ajustaCTRCcanceladas.SQL')
const sqlEncerraProcessos  = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const ajusteCTRC = async () => {
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
            rotine: 'IT ajusteCTRC',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 
}

module.exports = ajusteCTRC
