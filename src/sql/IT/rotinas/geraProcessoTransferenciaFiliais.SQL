-- 10/09/2021 10:11 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS - SÊNIOR - (iTrack)
SET XACT_ABORT ON

BEGIN 
    UPDATE IT
    SET DT_EMBARQUE = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime),
        DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
    FROM SIC.dbo.ITRACK_DANFE IT
    JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = IT.CdEmpresa AND CNH.NrSeqControle = IT.NrSeqControle
    JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = IT.CdEmpresa AND MOV.NrSeqControle = IT.NrSeqControle
    WHERE MOV.CdOcorrencia = 101 -- Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
      AND IT.DT_EMBARQUE IS NULL    
END   
;
BEGIN TRY
    BEGIN TRANSACTION

        UPDATE IT
           SET FASE_ID = 2,
               DT_UPDATE = CURRENT_TIMESTAMP
          FROM SIC.dbo.ITRACK_DANFE  IT
         WHERE 
               FASE_ID = 1 
           AND DT_EMBARQUE IS NOT NULL
           AND EXISTS ( SELECT 1 FROM SIC.dbo.ITRACK_OCORRENCIA CO 
                         WHERE CO.ITRACK_DANFE_ID = IT.ID AND CO.OCORRENCIA_ID = 101 ) 
        -- CASO A (FASE = 1) E EXISTIR OCORRENCIA = (101) GERADA, MUDA PARA FASE = 2
        ;

        UPDATE CO
           SET OCORRENCIA_OBS = CONCAT('EM TRÂNSITO ENTRE FILIAIS: ',ORIG.dsApelido,'/',DEST.dsApelido) 
          FROM SIC.dbo.ITRACK_OCORRENCIA CO
          JOIN softran_termaco.dbo.gtcconhe   CNH ON CNH.CdEmpresa  = CO.CdEmpresa AND CNH.NrSeqControle = CO.NrSeqControle
          JOIN softran_termaco.dbo.sisempre  ORIG ON ORIG.CdEmpresa = CNH.CdEmpresa        -- Filial Origem
          JOIN softran_termaco.dbo.sisempre  DEST ON DEST.CdEmpresa = CNH.CdEmpresaDestino -- Filial Destino
         WHERE CO.OCORRENCIA_OBS IS NULL 
           AND CO.OCORRENCIA_ID = 101 -- Codigo no Sênior
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
