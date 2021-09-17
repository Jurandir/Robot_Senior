-- 16/09/2021 15:18 - OCORRENCIAS DIVERSAS - MANUAIS ("ORION/CEVA")

SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

        UPDATE OCT
        SET  DT_EMBARQUE = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime)
        , DT_UPDATE = CURRENT_TIMESTAMP
        , DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
        , FASE_ID = 2
        FROM SIC.dbo.ORION_CTE OCT
        JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = OCT.CdEmpresa AND CNH.NrSeqControle = OCT.NrSeqControle
        JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = OCT.CdEmpresa AND MOV.NrSeqControle = OCT.NrSeqControle
        WHERE MOV.CdOcorrencia = 101 -- EM TRANSFERENCIA ENTRE FILIAIS
        AND OCT.DT_EMBARQUE IS NULL  
        AND FASE_ID < 2
        ;  

        UPDATE OCT
        SET DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
          , DT_UPDATE = CURRENT_TIMESTAMP
          , FASE_ID = (CASE 
                        WHEN MOV.CdOcorrencia = 899 THEN 1  -- PROCESSO DE TRANSPORTE JA INICIADO
                        WHEN MOV.CdOcorrencia = 98  THEN 3  -- CHEGADA NA CIDADE OU FILIAL DESTINO
                        WHEN MOV.CdOcorrencia = 100 THEN 4  -- EM ROTA PARA ENTREGA
                        WHEN MOV.CdOcorrencia = 1   THEN 5  -- ENTREGA REALIZADA NORMALMENTE
                        ELSE OCT.FASE_ID END )
        FROM SIC.dbo.ORION_CTE OCT
        JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = OCT.CdEmpresa AND CNH.NrSeqControle = OCT.NrSeqControle
        JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = OCT.CdEmpresa AND MOV.NrSeqControle = OCT.NrSeqControle
        WHERE MOV.CdOcorrencia IN (100,98,899,1)
          AND ( (MOV.CdOcorrencia = 899 AND OCT.FASE_ID <> 1) OR
                (MOV.CdOcorrencia = 89  AND OCT.FASE_ID <> 3) OR
                (MOV.CdOcorrencia = 100 AND OCT.FASE_ID <> 4) OR
                (MOV.CdOcorrencia = 1   AND OCT.FASE_ID <> 5) )
          AND ( OCT.DT_UPDATE IS NULL OR DATEDIFF(minute,OCT.DT_UPDATE, CURRENT_TIMESTAMP) > 3) --- depois de 3min do ultimo update
          AND (OCT.FASE_ID < 5)
        ;

        INSERT INTO SIC.dbo.ORION_OCORRENCIAS ( 
                      CNPJ, DOCUMENTO, CHAVE, DT_OCORRENCIA, OBSERVACAO,
                      OCORR301, OCORR302, OCORRCASUAL, OCORRTRANSPORTE,
                      OCORRSIMPLIFICADA, RECEBEDOR_DOC, RECEBEDOR_NOME,
                      CdEmpresa, NrSeqControle, CdSequencia, CdOcorrencia )
        SELECT TOP 20
             OCT.EMBARCADOR          AS CNPJ
            ,OCT.DOCUMENTO           AS DOCUMENTO
            ,OCT.CHAVE               AS CHAVE
            ,CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
                                     AS DT_OCORRENCIA
            ,OCO.DsHistoricoEntrega  AS OBSERVACAO

            ,DPA.CASUAL_ID           AS OCORR301
            ,DPA.TRANSPORTE_ID       AS OCORR302
            ,DPA.CASUAL_ID           AS OCORRCASUAL
            ,DPA.TRANSPORTE_ID       AS OCORRTRANSPORTE
            ,DPA.TRANSPORTE_ID       AS OCORRSIMPLIFICADA

            ,OUN.NrDoctoIdentPessoal AS RECEBEDOR_DOC
            ,OUN.DsContato           AS RECEBEDOR_NOME
            ,OUN.CdEmpresa           AS CdEmpresa
            ,OUN.NrSeqControle       AS NrSeqControle
            ,OUN.CdSequencia         AS CdSequencia
            ,OUN.CdOcorrencia        AS CdOcorrencia

        FROM softran_termaco.dbo.gtcmoven     OUN                                                  -- Movimento das Ocorrencias
            JOIN softran_termaco.dbo.gtchisen OCO ON OCO.cdhistoricoentrega = OUN.cdocorrencia     -- Ocorrencias
            JOIN SIC.dbo.ORION_CTE            OCT ON OCT.CdEmpresa = OUN.CdEmpresa AND OCT.NrSeqControle = OUN.NrSeqControle 
            JOIN SIC.dbo.ORION_DEPARA         DPA ON DPA.OCORRENCIA_ID = OUN.CdOcorrencia
        WHERE 
        NOT EXISTS ( SELECT 1 FROM SIC.dbo.ORION_OCORRENCIAS CO WHERE CO.CdEmpresa = OUN.CdEmpresa AND CO.NrSeqControle = OUN.NrSeqControle  AND CO.CdSequencia = OUN.CdSequencia )
        AND OCT.FASE_ID < 5
        ORDER BY 
        CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 

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
