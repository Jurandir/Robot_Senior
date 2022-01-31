-- 13/10/2021 13:29 - EM ROTA PARA ENTREGA - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste DePara (Sênior) - 26/01/2022

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE CF
           SET CF.FASE_ID = 4,
               CF.DT_UPDATE = CURRENT_TIMESTAMP
          FROM SIC..CONFIRMAFACIL CF
         WHERE CF.FASE_ID = 3 AND CF.DT_CHEGADA IS NOT NULL 
           AND EXISTS ( SELECT 1 
                          FROM      SIC..CONFIRMAFACILOCORRENCIA CO
                          LEFT JOIN softran_termaco.dbo.GTCVHist DP  ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                                        DP.CdHistoricoEntrega = 100 -- (CdHistoricoEntrega) Codigo no Sênior 
                         WHERE CO.CONFIRMAFACIL_ID = CF.ID  
                           AND CO.OCORRENCIA_ID    = ISNULL(DP.CdHistoricoRemetente, 100 ) )        -- (CdHistoricoRemetente) Codigo no Cliente 
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS =  CONCAT('A CAMINHO DO DESTINATÁRIO EM : ',CEP.DsLocal,' / ',CEP.DsUF)
          FROM SIC..CONFIRMAFACILOCORRENCIA     CO
          JOIN SIC..CONFIRMAFACIL               CF ON CF.ID                 = CO.CONFIRMAFACIL_ID
          JOIN softran_termaco.dbo.GTCVHist     DP ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                      DP.CdHistoricoEntrega = 100 -- (CdHistoricoEntrega) Codigo no Sênior (EM ROTA PARA ENTREGA)
          JOIN softran_termaco.dbo.GTCConhe    CNH ON CNH.CdEmpresa     = CO.CdEmpresa AND 
                                                      CNH.NrSeqControle = CO.NrSeqControle
     LEFT JOIN softran_termaco.dbo.siscep      CEP ON CEP.NrCep         = CNH.NrCepEntrega  -- CEP Local Entrega
         WHERE 
               CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 100 ) -- (CdHistoricoRemetente) Codigo no Cliente
           AND CO.FLAG_SEND     = 0 
           AND CO.OCORRENCIA_OBS IS NULL 
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
