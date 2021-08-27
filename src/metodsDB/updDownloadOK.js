const moment  = require('moment')
const sqlExec = require('../connection/sqlExec')

const updDownload = async (par_ctrc) => {
    let flag = 1

    let sql = `UPDATE SIC.dbo.CONFIRMAFACIL 
                SET FLAG_COMPROVANTE  = ${flag}
                WHERE CTRC = '${par_ctrc}'`
    try {

        let result = await sqlExec(sql)         
        if( result.success ) {
            console.log(moment().format(),'- SUCCESS - PREPARAÇÃO DOWNLOAD',par_ctrc )
        } else {
            console.log(moment().format(),'- FALHA UPD FLAG - PREPARAÇÃO:',par_ctrc,'-',result.message )
        }

        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'updDownload',
            sql: sql,
            err: err
        }
        console.log(moment().format(),'- ERRO UPD FLAG - PREPARAÇÃO:',par_ctrc,'-',err.message )
        return Erro
    }

}

module.exports = updDownload
