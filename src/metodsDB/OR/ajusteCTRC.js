// 19/10/2021 10:47 - VERIFICA CTRCs CANCELADAS E AJUSTA - (" Orion ")
// (CODIGO EM ANALISE - SEM USO - 19/10/2021)

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/OR/rotinas/ajustaCTRCcanceladas.SQL')
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
            rotine: 'ORION ajusteCTRC',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 
}

module.exports = ajusteCTRC