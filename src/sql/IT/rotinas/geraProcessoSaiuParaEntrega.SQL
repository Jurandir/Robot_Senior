-- 11/09/2021 08:03 - (100) - EM ROTA PARA ENTREGA - ITRACK

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE IT
          SET IT.FASE_ID   = 4,
              IT.DT_UPDATE = CURRENT_TIMESTAMP
        FROM SIC.dbo.ITRACK_DANFE IT
        WHERE IT.FASE_ID = 3 AND IT.DT_CHEGADA IS NOT NULL 
          AND EXISTS (SELECT 1 FROM SIC.dbo.ITRACK_OCORRENCIA CO  WHERE CO.ITRACK_DANFE_ID = IT.ID AND CO.OCORRENCIA_ID = 100 )  -- Codigo no Sênior
        -- CASO A (FASE < OU = 3) E EXISTIR OCORRENCIA = 100 GERADA, MUDA PARA FASE = 4        
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS =  
                              (SELECT TOP 1 CONCAT('A CAMINHO DO DESTINATÁRIO EM : ',n.DsLocal,' / ',n.DsUF)
                                 FROM softran_termaco.dbo.GTCConhe a
                            LEFT JOIN softran_termaco.dbo.siscep   n ON n.nrcep = a.nrcepentrega  -- CEP Local Entrega
                                WHERE a.CdEmpresa = CO.CdEmpresa 
                                  AND a.NrSeqControle = CO.NrSeqControle )
        FROM SIC.dbo.ITRACK_OCORRENCIA CO
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = 100 -- Codigo no Sênior
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
