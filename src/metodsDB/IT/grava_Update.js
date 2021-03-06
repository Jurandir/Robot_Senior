// 09/09/2021 09:45 - GRAVA Retorno da API "idCargaPK" em "SIC.dbo.ITRACK_DANFE"

const sqlExec       = require('../../connection/sqlExSENIOR')

const grava_Update = async (params) => {
   let { idCargaPK, CdEmpresa, NrSeqControle, danfe, addCarga } = params
   let sql = `
   UPDATE SIC.dbo.ITRACK_DANFE
      SET DT_UPDATE = CURRENT_TIMESTAMP
        , CTRC_OLD  = '${addCarga}'
    WHERE CdEmpresa = ${CdEmpresa}
      AND NrSeqControle = ${NrSeqControle}
      AND CHAVE = '${danfe}'
   `
    if(!danfe) { return { success: false, message: 'DANFE não informado !!!' }} 
   
    try {

        result = await sqlExec(sql)         
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'grava_Update',
            sql: sql,
            err: err
        }
        return Erro
    } 

}

module.exports = grava_Update
