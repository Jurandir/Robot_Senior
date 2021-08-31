-- 31/08/2021 14:25
SET XACT_ABORT ON
BEGIN 
    UPDATE CF
    SET DT_EMBARQUE = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime),
        DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
    FROM SIC.dbo.CONFIRMAFACIL CF
    JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = CF.CdEmpresa AND CNH.NrSeqControle = CF.NrSeqControle
    JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = CF.CdEmpresa AND MOV.NrSeqControle = CF.NrSeqControle
    WHERE MOV.CdOcorrencia = 101 -- Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
      AND CF.DT_EMBARQUE IS NULL    
END   
;
BEGIN TRY
    BEGIN TRANSACTION

        INSERT INTO SIC.dbo.CONFIRMAFACILOCORRENCIA ( CONFIRMAFACIL_ID, OCORRENCIA_ID, OCORRENCIA_NOME, OCORRENCIA_OBS, OCORRENCIA_DATA )
        SELECT
          CF.ID                                           AS CONFIRMAFACIL_ID,
          DP.ID_CONFIRMAFACIL                             AS OCORRENCIA_ID,
          DP.NOME_OCORRENCIA                              AS OCORRENCIA_NOME,
          'TRANSFERENCIA ENTRE AS FILIAIS'                AS OCORRENCIA_OBS,
          CF.DT_EMBARQUE                                  AS OCORRENCIA_DATA
        FROM SIC.dbo.CONFIRMAFACIL       CF
        JOIN SIC.dbo.CONFIRMAFACILDEPARA DP ON DP.ID_SENIOR = 101 -- Codigo no Sênior
        WHERE 
              FASE_ID = 1 
          AND CF.DT_EMBARQUE IS NOT NULL
          AND NOT EXISTS ( SELECT 1 FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO WHERE CO.CONFIRMAFACIL_ID = CF.ID AND CO.OCORRENCIA_ID = DP.ID_CONFIRMAFACIL ) 
        -- CASO A (FASE = 1) E  NÃO EXISTIR OCORRENCIA = (DP.ID_CONFIRMAFACIL) GERADA, INCLUI OCORRENCIA
        ;

        UPDATE CF
           SET FASE_ID = 2,
               DT_UPDATE = CURRENT_TIMESTAMP
          FROM SIC.dbo.CONFIRMAFACIL       CF
          JOIN SIC.dbo.CONFIRMAFACILDEPARA DP ON DP.ID_SENIOR = 101 -- Codigo no Sênior
         WHERE 
               FASE_ID = 1 
           AND DT_EMBARQUE IS NOT NULL
           AND EXISTS ( SELECT 1 FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO WHERE CO.CONFIRMAFACIL_ID = CF.ID AND CO.OCORRENCIA_ID = DP.ID_CONFIRMAFACIL ) 
        -- CASO A (FASE = 1) E EXISTIR OCORRENCIA = (DP.ID_CONFIRMAFACIL) GERADA, MUDA PARA FASE = 2
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
