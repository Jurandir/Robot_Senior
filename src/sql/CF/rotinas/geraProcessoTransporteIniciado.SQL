-- 30/08/2021 15:00 / 01/09/2021 11:15 - PROCESSO DE TRANSPORTE INICIADO
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

        ;
        INSERT INTO SIC.dbo.CONFIRMAFACILOCORRENCIA
          ( CONFIRMAFACIL_ID, OCORRENCIA_ID, OCORRENCIA_NOME,OCORRENCIA_OBS, OCORRENCIA_DATA, CdEmpresa, NrSeqControle )
        SELECT
          CF.ID                              AS CONFIRMAFACIL_ID
          ,000                               AS OCORRENCIA_ID
          ,'PROCESSO DE TRANSPORTE INICIADO' AS OCORRENCIA_NOME
          ,CONCAT('INICIADO VIA CTRC: ',CF.CTRC)      
                                             AS OCORRENCIA_OBS
          ,CNH.DtEmissao                     AS OCORRENCIA_DATA
	        ,CNH.CdEmpresa                     AS CdEmpresa
	        ,CNH.NrSeqControle                 AS NrSeqControle
        FROM SIC.dbo.CONFIRMAFACIL CF
          JOIN softran_termaco.dbo.gtcconhe CNH ON CNH.CdEmpresa = CF.CdEmpresa   AND CNH.NrSeqControle = CF.NrSeqControle
        WHERE FASE_ID = 0
          AND NOT EXISTS ( SELECT 1 FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO WHERE CO.CONFIRMAFACIL_ID = CF.ID AND CO.OCORRENCIA_ID = 0 )         
        -- CASO A (FASE = 0) E  NÃO EXISTIR OCORRENCIA = 0 GERADA, INCLUI OCORRENCIA
        ;
        UPDATE CF 
          SET FASE_ID = 1,
              DT_UPDATE = CURRENT_TIMESTAMP
        FROM  SIC.dbo.CONFIRMAFACIL CF
        WHERE FASE_ID = 0
          AND EXISTS ( SELECT 1 FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO WHERE CO.CONFIRMAFACIL_ID = CF.ID AND CO.OCORRENCIA_ID = 0 ) 
        -- CASO A (FASE = 0) E EXISTIR OCORRENCIA = 0 GERADA, MUDA PARA FASE = 1
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
;