-- 31/08/2021 16:26 - (098) - CHEGADA NA CIDADE OU FILIAL DE DESTINO - ITRACK
-- 08/02/2022 11:34 - Ajuste (DePara) Sênior

SET XACT_ABORT ON

BEGIN 
    UPDATE IT
    SET DT_CHEGADA = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime),
        DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
    FROM SIC.dbo.ITRACK_DANFE IT
    JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = IT.CdEmpresa AND CNH.NrSeqControle = IT.NrSeqControle
    JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = IT.CdEmpresa AND MOV.NrSeqControle = IT.NrSeqControle
    WHERE MOV.CdOcorrencia = 098 -- Codigo no Sênior (CHEGADA NA CIDADE OU FILIAL DE DESTINO)
      AND IT.DT_CHEGADA IS NULL    
END   

;
BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE IT
          SET FASE_ID = 3,
              DT_UPDATE = CURRENT_TIMESTAMP
        FROM SIC.dbo.ITRACK_DANFE IT
        WHERE IT.FASE_ID <= 2 AND IT.DT_CHEGADA IS NOT NULL
          AND EXISTS ( SELECT 1 
                         FROM      SIC..ITRACK_OCORRENCIA CO
                         LEFT JOIN softran_termaco.dbo.GTCVHist DP ON DP.CdInscricao        = IT.BASE_CNPJ AND 
                                                                      DP.CdHistoricoEntrega = 098 -- (CdHistoricoEntrega) Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
                         WHERE CO.ITRACK_DANFE_ID = IT.ID  
                           AND CO.OCORRENCIA_ID   = ISNULL(DP.CdHistoricoRemetente, 098 ) ) -- (CdHistoricoRemetente) Codigo no Cliente         
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS = CONCAT('CHEGADA EM : ',n.DsLocal,' / ',n.DsUF) 
        FROM SIC.dbo.ITRACK_OCORRENCIA      CO
          JOIN SIC.dbo.ITRACK_DANFE         IT ON IT.ID                 = CO.ITRACK_DANFE_ID
          JOIN softran_termaco.dbo.GTCVHist DP ON DP.CdInscricao        = IT.BASE_CNPJ AND 
                                                  DP.CdHistoricoEntrega = 098 -- (CdHistoricoEntrega) Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
        JOIN softran_termaco.dbo.GTCConhe    a ON a.CdEmpresa = CO.CdEmpresa AND a.NrSeqControle = CO.NrSeqControle 
        JOIN softran_termaco.dbo.SISEMPRE    m ON m.CdEmpresa = a.CdEmpresaDestino -- Filial Destino
        JOIN softran_termaco.dbo.SISCep      n ON n.NrCep     = m.NrCep
       WHERE CO.OCORRENCIA_OBS IS NULL
         AND CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 098 ) -- (CdHistoricoRemetente) Codigo no Cliente 
    END
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
