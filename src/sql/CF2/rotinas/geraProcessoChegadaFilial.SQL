-- 11/10/2021 17:16 - CHEGADA NA CIDADE OU FILIAL DE DESTINO  - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste DePara (Sênior) - 24/01/2022

SET XACT_ABORT ON
BEGIN 
    UPDATE CF
    SET DT_CHEGADA = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime),
        DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
    FROM SIC..CONFIRMAFACIL CF
    JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = CF.CdEmpresa AND CNH.NrSeqControle = CF.NrSeqControle
    JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = CF.CdEmpresa AND MOV.NrSeqControle = CF.NrSeqControle
    WHERE MOV.CdOcorrencia = 098 -- Codigo no Sênior (CHEGADA NA CIDADE OU FILIAL DE DESTINO)
      AND CF.DT_CHEGADA IS NULL    
END   

;
BEGIN TRY
    BEGIN TRANSACTION

    BEGIN
        UPDATE CF
          SET FASE_ID = 3,
              DT_UPDATE = CURRENT_TIMESTAMP
        FROM SIC..CONFIRMAFACIL CF
        WHERE CF.FASE_ID <= 2 
          AND CF.DT_CHEGADA IS NOT NULL
           AND EXISTS ( SELECT 1 
                          FROM      SIC..CONFIRMAFACILOCORRENCIA CO
                          LEFT JOIN softran_termaco.dbo.GTCVHist DP  ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                                        DP.CdHistoricoEntrega = 098 -- (CdHistoricoEntrega) Codigo no Sênior 
                         WHERE CO.CONFIRMAFACIL_ID = CF.ID  
                           AND CO.OCORRENCIA_ID    = ISNULL(DP.CdHistoricoRemetente, 098 ) )        -- (CdHistoricoRemetente) Codigo no Cliente 
        ;
    END
    ;

    BEGIN
        UPDATE CO
           SET OCORRENCIA_OBS = CONCAT('CHEGADA EM : ',CEP.DsLocal,' / ',CEP.DsUF)
        FROM SIC..CONFIRMAFACILOCORRENCIA   CO
        JOIN SIC..CONFIRMAFACIL              CF ON CF.ID = CO.CONFIRMAFACIL_ID
        JOIN softran_termaco.dbo.GTCVHist    DP ON DP.CdInscricao        = CF.BASE_CNPJ AND 
                                                   DP.CdHistoricoEntrega = 089 -- (CdHistoricoEntrega) Codigo no Sênior (EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS)
		JOIN softran_termaco.dbo.GTCConhe    CNH ON CNH.CdEmpresa = CO.CdEmpresa AND CNH.NrSeqControle = CO.NrSeqControle 
		JOIN softran_termaco.dbo.sisempre    EMP ON EMP.CdEmpresa = CNH.CdEmpresaDestino -- Filial Destino
		LEFT JOIN softran_termaco.dbo.siscep CEP ON CEP.NrCep     = EMP.NrCEP
       WHERE CO.OCORRENCIA_OBS IS NULL 
         AND CO.OCORRENCIA_ID = ISNULL(DP.CdHistoricoRemetente, 089 ) ) -- (CdHistoricoRemetente) Codigo no Cliente

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
