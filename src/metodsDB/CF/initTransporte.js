// 30/08/2021 15:00
const sqlExec       = require('../../connection/sqlExSENIOR')

const fs                 = require('fs')
const path               = require('path')
const sqlFileName        =  path.join(__dirname, '../../sql/CF/rotinas/geraProcessoTransporteIniciado.SQL')
const sqlInitTransporte  = fs.readFileSync(sqlFileName, "utf8")

let flag_livre      = true

const initTransporte = async () => {
    let sql = sqlInitTransporte

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
            rotine: 'initTransporte',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initTransporte
