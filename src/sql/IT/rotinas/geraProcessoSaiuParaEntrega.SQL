-- 11/09/2021 08:03 - (100) - EM ROTA PARA ENTREGA - ITRACK
-- 08/02/2022 15:31 - Ajuste (DePara) Sênior

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE IT
          SET IT.FASE_ID   = 4,
              IT.DT_UPDATE = CURRENT_TIMESTAMP
        FROM SIC.dbo.ITRACK_DANFE IT
        WHERE IT.FASE_ID = 3 
          AND IT.DT_CHEGADA IS NOT NULL 
          AND EXISTS ( SELECT 1 
                         FROM      SIC..ITRACK_OCORRENCIA CO
                         LEFT JOIN softran_termaco.dbo.GTCVHist DP  ON DP.CdInscricao        = IT.BASE_CNPJ AND 
                                                                       DP.CdHistoricoEntrega = 100 -- (CdHistoricoEntrega) Codigo no Sênior 
                        WHERE CO.ITRACK_DANFE_ID = IT.ID  
                          AND CO.OCORRENCIA_ID   = ISNULL(DP.CdHistoricoRemetente, 100 ) )        -- (CdHistoricoRemetente) Codigo no Cliente        
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS = CONCAT('A CAMINHO DO DESTINATÁRIO EM : ',n.DsLocal,' / ',n.DsUF) 
        FROM SIC.dbo.ITRACK_OCORRENCIA    CO
        JOIN SIC.dbo.ITRACK_DANFE         IT ON IT.ID                 = CO.ITRACK_DANFE_ID
        JOIN softran_termaco.dbo.GTCVHist DP ON DP.CdInscricao        = IT.BASE_CNPJ AND 
                                                DP.CdHistoricoEntrega = 100 -- (CdHistoricoEntrega) Codigo no Sênior 
        JOIN softran_termaco.dbo.GTCConhe    a ON a.CdEmpresa = CO.CdEmpresa AND a.NrSeqControle = CO.NrSeqControle 
        JOIN softran_termaco.dbo.SISEMPRE    m ON m.CdEmpresa = a.CdEmpresaDestino -- Filial Destino
        JOIN softran_termaco.dbo.SISCep      n ON n.NrCep     = m.NrCep
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 100 ) -- (CdHistoricoRemetente) Codigo no Cliente 
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
