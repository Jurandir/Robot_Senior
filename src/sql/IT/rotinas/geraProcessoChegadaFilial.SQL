-- 31/08/2021 16:26 - (098) - CHEGADA NA CIDADE OU FILIAL DE DESTINO - ITRACK

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
          AND EXISTS ( SELECT 1 FROM SIC.dbo.ITRACK_OCORRENCIA CO WHERE CO.ITRACK_DANFE_ID = IT.ID AND CO.OCORRENCIA_ID = 098 ) 
        -- CASO A (FASE < OU = 2) E EXISTIR OCORRENCIA = 098 GERADA, MUDA PARA FASE = 3        
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS =  
                              (SELECT TOP 1 CONCAT('CHEGADA EM : ',n.DsLocal,' / ',n.DsUF)
                                 FROM softran_termaco.dbo.GTCConhe a
                            LEFT JOIN softran_termaco.dbo.sisempre m ON m.cdempresa = a.cdempresadestino -- Filial Destino
                            LEFT JOIN softran_termaco.dbo.siscep   n ON n.nrcep     = m.nrcep
                                WHERE a.CdEmpresa = CO.CdEmpresa 
                                  AND a.NrSeqControle = CO.NrSeqControle )
        FROM SIC.dbo.ITRACK_OCORRENCIA CO
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = 098 -- Codigo no Sênior
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
