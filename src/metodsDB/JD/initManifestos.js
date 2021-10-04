// 27/09/2021 17:12 - MANIFESTOS EMITIDOS - SÊNIOR - ("JOHN DEERE")

const sqlExec              = require('../../connection/sqlExSENIOR')
const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../sql/JD/rotinas/EMISSAO_MANIFESTO_SHIP.SQL')
const sqlInit              = fs.readFileSync(sqlFileName, "utf8")

let flag_livre = true

const initManifestos = async () => {
    let sql = sqlInit

    if(!flag_livre) { return { success: false, message: 'Processo ocupado !!!' }} 
    flag_livre = false
   
    try {

        let result = await sqlExec(sql)

        if(!result.success) {
           console.log('EMISSAO_MANIFESTO_SHIP:',result)
        }   

        flag_livre = true
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'initManifestos',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initManifestos
