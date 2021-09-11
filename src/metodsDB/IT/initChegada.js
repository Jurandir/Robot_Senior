// 10/09/2021 17:54 - (098) - CHEGADA NA CIDADE OU FILIAL DE DESTINO - ITRACK

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/IT/rotinas/geraProcessoChegadaFilial.SQL')
const sqlInitChegada       = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initChegada = async () => {
    let sql = sqlInitChegada

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
            rotine: 'initChegada',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initChegada
