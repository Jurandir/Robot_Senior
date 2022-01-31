-- 11/10/2021 16:24 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste DePara (Sênior) - 24/01/2022

SET XACT_ABORT ON

BEGIN 
    UPDATE CF
    SET DT_EMBARQUE = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime),
        DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
    FROM SIC..CONFIRMAFACIL CF
    JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = CF.CdEmpresa AND CNH.NrSeqControle = CF.NrSeqControle
    JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = CF.CdEmpresa AND MOV.NrSeqControle = CF.NrSeqControle
    WHERE MOV.CdOcorrencia = 101 -- Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
      AND CF.DT_EMBARQUE IS NULL    
END   
;
BEGIN TRY
    BEGIN TRANSACTION

        UPDATE CF
           SET FASE_ID = 2,
               DT_UPDATE = CURRENT_TIMESTAMP
          FROM SIC..CONFIRMAFACIL       CF
         WHERE 
               FASE_ID = 1 
           AND DT_EMBARQUE IS NOT NULL
           AND EXISTS ( SELECT 1 
                          FROM      SIC..CONFIRMAFACILOCORRENCIA CO
                          LEFT JOIN softran_termaco.dbo.GTCVHist DP  ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                                        DP.CdHistoricoEntrega = 101 -- (CdHistoricoEntrega) Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
                         WHERE CO.CONFIRMAFACIL_ID = CF.ID  
                           AND CO.OCORRENCIA_ID    = ISNULL(DP.CdHistoricoRemetente, 101 ) ) -- (CdHistoricoRemetente) Codigo no Cliente 
        ;

        UPDATE CO
           SET OCORRENCIA_OBS = CONCAT('EM TRÂNSITO ENTRE FILIAIS: ',ORIG.dsApelido,'/',DEST.dsApelido) 
          FROM SIC..CONFIRMAFACILOCORRENCIA    CO
          JOIN SIC..CONFIRMAFACIL              CF ON CF.ID = CO.CONFIRMAFACIL_ID
          JOIN softran_termaco.dbo.GTCVHist    DP ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                     DP.CdHistoricoEntrega = 101 -- (CdHistoricoEntrega) Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
          JOIN softran_termaco.dbo.gtcconhe   CNH ON CNH.CdEmpresa  = CO.CdEmpresa AND CNH.NrSeqControle = CO.NrSeqControle
          JOIN softran_termaco.dbo.sisempre  ORIG ON ORIG.CdEmpresa = CNH.CdEmpresa        -- Filial Origem
          JOIN softran_termaco.dbo.sisempre  DEST ON DEST.CdEmpresa = CNH.CdEmpresaDestino -- Filial Destino
         WHERE CO.OCORRENCIA_OBS IS NULL 
           AND CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 101 ) -- (CdHistoricoRemetente) Codigo no Cliente 
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
