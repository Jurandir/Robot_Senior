// 11/09/2021 10:43 - (999) - COMPROVANTE DE ENTREGA - ITRACK

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                 = require('fs')
const path               = require('path')
const sqlFileName        =  path.join(__dirname, '../../sql/IT/rotinas/geraComprovante.SQL')
const sqlInitComprovante = fs.readFileSync(sqlFileName, "utf8")

let flag_livre      = true

const initComprovante = async () => {
    let sql = sqlInitComprovante

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
            rotine: 'initComprovante',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initComprovante
