// 09/09/2021 09:45 - GRAVA Retorno da API "idCargaPK" em "SIC.dbo.ITRACK_DANFE"

const sqlExec       = require('../../connection/sqlExSENIOR')

const grava_MsgApiResponse = async (resposta,id) => {
   let { success, message, data, code } = resposta
   

   let FLAG_SEND          = success ? 1 : 0
   let RESPOSTA_STATUS    = success ? 200 : -1
   let RESPOSTA_PROTOCOLO = code ? code : 0
   let RESPOSTA_MSG       = message 


   let sql = `
   UPDATE SIC.dbo.ITRACK_OCORRENCIA
      SET IDCARGA = ${idCargaPK}
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

module.exports = grava_MsgApiResponse
