-- 13/10/2021 10:52 - ENTREGA PROGRAMADA - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste DePara (Sênior) - 24/01/2022


SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN 
        UPDATE CF
        SET DT_AGENDAMENTO = CAST(CONCAT(FORMAT(MOV.DtAgendamento,'yyyy-MM-dd'),' ', FORMAT(MOV.HrAgendamento,'HH:mm:ss')) as datetime),
            DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
        FROM SIC..CONFIRMAFACIL                CF
        LEFT JOIN softran_termaco.dbo.GTCVHist DP ON DP.CdInscricao   = CF.BASE_CNPJ AND 
                                                     DP.CdHistoricoEntrega = 091 -- (CdHistoricoEntrega) Codigo no Sênior
        JOIN softran_termaco.dbo.gtcconhe CNH ON CNH.CdEmpresa = CF.CdEmpresa AND CNH.NrSeqControle = CF.NrSeqControle
        JOIN softran_termaco.dbo.GTCMovEn MOV ON MOV.CdEmpresa = CF.CdEmpresa AND MOV.NrSeqControle = CF.NrSeqControle
        WHERE MOV.CdOcorrencia = ISNULL(DP.CdHistoricoRemetente, 091 ) -- Codigo no Sênior (ENTREGA PROGRAMADA)
        AND CF.DT_AGENDAMENTO IS NULL    
    END   
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS =  
                              CONCAT('ENTREGA PREVISTA PARA : ',FORMAT(OUN.DtAgendamento,'dd/MM/yyyy'),' as ',FORMAT(OUN.HrAgendamento,'HH:mm'),' Hs.')
        FROM SIC..CONFIRMAFACILOCORRENCIA      CO
        JOIN SIC..CONFIRMAFACIL                CF ON CF.ID = CO.CONFIRMAFACIL_ID
        LEFT JOIN softran_termaco.dbo.GTCVHist DP ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                     DP.CdHistoricoEntrega = 091 -- (CdHistoricoEntrega) Codigo no Sênior
        JOIN softran_termaco.dbo.gtcmoven     OUN ON OUN.CdEmpresa     = CO.CdEmpresa     AND 
                                                     OUN.NrSeqControle = CO.NrSeqControle AND 
                                                     OUN.CdSequencia   = CO.CdSequencia
       WHERE 
             CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 091 ) -- Codigo no Sênior (ENTREGA PROGRAMADA)
         AND CO.FLAG_SEND = 0
         AND (CO.OCORRENCIA_OBS IS NULL) 
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
