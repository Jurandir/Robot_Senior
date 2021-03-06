// 11/10/2021 17:12 - CHEGADA NA CIDADE OU FILIAL DE DESTINO - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/CF2/rotinas/geraProcessoChegadaFilial.SQL')
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
            rotine: 'V2 initChegada',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initChegada
