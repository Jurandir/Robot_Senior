-- 01/09/2021 13:56 - (100) - EM ROTA PARA ENTREGA - ITRACK

BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE IT
          SET IT.FASE_ID = 4,
              IT.DT_UPDATE = CURRENT_TIMESTAMP
        FROM SIC.dbo.ITRACK_ IT
        WHERE IT.FASE_ID = 3 AND IT.DT_CHEGADA IS NOT NULL 
          AND EXISTS (SELECT 1 FROM SIC.dbo.ITTRACK_OCORRENCIA CO 
               WHERE CO.ITTRACK__ID = IT.ID AND CO.OCORRENCIA_ID = 100 -- Codigo no Sênior       )
        -- CASO A (FASE < OU = 3) E EXISTIR OCORRENCIA = (DP.ID_ITTRACK_) GERADA, MUDA PARA FASE = 4        
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
        FROM SIC.dbo.ITTRACK_OCORRENCIA CO
        JOIN SIC.dbo.ITTRACK_DEPARA DP ON DP.ID_SENIOR = 100 -- Codigo no Sênior
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = DP.ID_ITTRACK_
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
