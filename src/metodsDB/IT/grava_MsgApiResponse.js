// 09/09/2021 09:45 - GRAVA Retorno da API "idCargaPK" em "SIC.dbo.ITRACK_DANFE"

const sqlExec       = require('../../connection/sqlExSENIOR')

const grava_MsgApiResponse = async (resposta,id) => {
   let { success, message, data, code } = resposta
   
   message = message ? message : success ? 'OK' : 'ERR'

   let FLAG_SEND          = success ? 1 : 0
   let RESPOSTA_PROTOCOLO = `${code ? code : 0}`
   let RESPOSTA_STATUS    = success ? 200 : RESPOSTA_PROTOCOLO==0 ? -1 : 400
   let RESPOSTA_MSG       = `'${message} - ${data ? data :'ERRO' }'` 
   let ID                 = id
   
   let sql = `
   SET XACT_ABORT ON

   BEGIN TRY
        BEGIN TRANSACTION

        UPDATE SIC.dbo.ITRACK_OCORRENCIA
           SET DT_SEND            = CURRENT_TIMESTAMP
              ,FLAG_SEND          = ${FLAG_SEND}
              ,RESPOSTA_STATUS    = ${RESPOSTA_STATUS}
              ,RESPOSTA_PROTOCOLO = ${RESPOSTA_PROTOCOLO}
              ,RESPOSTA_MSG       = ${RESPOSTA_MSG}
         WHERE
            ID = ${ID}
            ;

        UPDATE SIC.dbo.ITRACK_DANFE
           SET DT_UPDATE          = CURRENT_TIMESTAMP
         WHERE FASE_ID <= 1
           AND ID = (SELECT ITRACK_DANFE_ID FROM SIC.dbo.ITRACK_OCORRENCIA WHERE ID=${ID})
           ;

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
    
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
    
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
    ;`  

    try {

        result = await sqlExec(sql)         
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'grava_MsgApiResponse',
            sql: sql,
            err: err
        }
        return Erro
    } 

}

module.exports = grava_MsgApiResponse
