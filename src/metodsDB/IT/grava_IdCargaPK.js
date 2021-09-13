// 09/09/2021 09:45 - GRAVA Retorno da API "idCargaPK" em "SIC.dbo.ITRACK_DANFE"

const sqlExec       = require('../../connection/sqlExSENIOR')

const grava_IdCargaPK = async (params) => {
   let { idCargaPK, CdEmpresa, NrSeqControle, danfe } = params
   let sql = `
   UPDATE SIC.dbo.ITRACK_DANFE
      SET IDCARGA = ${idCargaPK}
        , DT_VALIDACAO = CURRENT_TIMESTAMP
    WHERE CdEmpresa = ${CdEmpresa}
      AND NrSeqControle = ${NrSeqControle}
      AND CHAVE = '${danfe}'
   `
    if(!idCargaPK) { return { success: false, message: 'idCargaPK não informado !!!' }} 
    if(!danfe) { return { success: false, message: 'DANFE não informado !!!' }} 
   
    try {

        result = await sqlExec(sql)         
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'grava_IdCargaPK',
            sql: sql,
            err: err
        }
        return Erro
    } 

}

module.exports = grava_IdCargaPK
