// 13/10/2021 16:06 - UPDATE DOWNLOAD OK - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment  = require('moment')
const sqlExec = require('../../connection/sqlExSENIOR')

const updDownload = async (par_ctrc,data) => {
    let flag = 1
    try {
        let jComprovantes = JSON.stringify( data.map(i=>i.url) )

        let sql = `UPDATE SIC..CONFIRMAFACIL 
                    SET FLAG_COMPROVANTE  = ${flag},
                        JSON_COMPROVANTE  = '${jComprovantes}'
                    WHERE CTRC = '${par_ctrc}'`

        let result = await sqlExec(sql)         
        if( result.success ) {
            console.log(moment().format(),'- SUCCESS - V2 - PREPARAÇÃO DOWNLOAD PARA CTRC:',par_ctrc )
        } else {
            console.log(moment().format(),'- FALHA UPD FLAG - V2 - PREPARAÇÃO:',par_ctrc,'-',result.message )
        }

        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'V2 updDownload',
            sql: sql,
            err: err
        }
        console.log(moment().format(),'- ERRO UPD FLAG - V2 - PREPARAÇÃO:',par_ctrc,'-',err.message )
        return Erro
    }
}

module.exports = updDownload
