-- 02/09/2021 09:37 - ENTREGA PROGRAMADA
SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN 
        UPDATE CF
        SET DT_AGENDAMENTO = CAST(CONCAT(FORMAT(MOV.DtAgendamento,'yyyy-MM-dd'),' ', FORMAT(MOV.HrAgendamento,'HH:mm:ss')) as datetime),
            DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
        FROM SIC.dbo.CONFIRMAFACIL CF
        JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = CF.CdEmpresa AND CNH.NrSeqControle = CF.NrSeqControle
        JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = CF.CdEmpresa AND MOV.NrSeqControle = CF.NrSeqControle
        WHERE MOV.CdOcorrencia = 91 -- Codigo no Sênior (ENTREGA PROGRAMADA)
        AND CF.DT_AGENDAMENTO IS NULL    
    END   
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS =  
                              CONCAT('ENTREGA PREVISTA PARA : ',FORMAT(OUN.DtAgendamento,'dd/MM/yyyy'), ' as ',FORMAT(OUN.HrAgendamento,'HH:mm'),' Hs.')
        FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
        JOIN softran_termaco.dbo.gtcmoven    OUN ON OUN.CdEmpresa = CO.CdEmpresa AND OUN.NrSeqControle = CO.NrSeqControle AND OUN.CdSequencia = CO.CdSequencia
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = 91 -- Codigo no Sênior (ENTREGA PROGRAMADA)
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
