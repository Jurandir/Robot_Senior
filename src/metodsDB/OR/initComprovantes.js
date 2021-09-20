// 20/09/2021 09:59 - PREPARA PROCESSO PARA ENVIO DOS COMPROVANTES - SÊNIOR - ("ORION/CEVA")

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/OR/rotinas/geraProcessoComprovantes.SQL')
const sqlInitOcorrencias   = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initComprovantes = async () => {
    let sql = sqlInitOcorrencias

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
            rotine: 'initOcorrencias',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initComprovantes
