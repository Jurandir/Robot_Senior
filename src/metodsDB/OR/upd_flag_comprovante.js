// 27/09/2021 13:45 - UPDATE EXISTE COMPROVANTE - SÊNIOR - ("ORION/CEVA")

const sqlExec       = require('../../connection/sqlExSENIOR')

const upd_flag_comprovante = async (ctrc) => {

    if(!ctrc) {
        return { success: false, message: 'CTRC error',  rowsAffected: -1, rotine: 'upd_flag_comprovante' }
    }

    let sql = `
    UPDATE SIC.dbo.ORION_CTE
       SET FLAG_COMPROVANTE = 1
     WHERE 
           DOCUMENTO = '${ctrc}'
    `
    try {

        let result = await sqlExec(sql)         
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'upd_flag_comprovante'
        }
        return Erro
    } 
}

module.exports = upd_flag_comprovante