-- 20/09/2021 10:03 - PREPARA ESTRUTURA PARA ENVIO DE COMPROVANTES - MANUAIS ("ORION/CEVA")

SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

    --- AJUSTA DATA CHEGADA 
    UPDATE OCT
       SET DT_CHEGADA = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.hrMovimento,'HH:mm:ss')) as datetime)
         , DT_PREVISAO = softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole)
      FROM SIC.dbo.ORION_CTE OCT
      JOIN softran_termaco.dbo.gtcconhe CNH   ON CNH.CdEmpresa = OCT.CdEmpresa AND CNH.NrSeqControle = OCT.NrSeqControle
      JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = OCT.CdEmpresa AND MOV.NrSeqControle = OCT.NrSeqControle
     WHERE MOV.CdOcorrencia = 098 -- Codigo no Sênior (CHEGADA NA CIDADE OU FILIAL DE DESTINO)
       AND OCT.DT_CHEGADA IS NULL
    ;
    --- AJUSTA DATA ENTREGA
    UPDATE OCT
       SET DT_ENTREGA = CAST(CONCAT(FORMAT(MOV.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(MOV.HrMovimento,'HH:mm:ss')) as datetime)
         , FASE_ID = 5 
      FROM SIC.dbo.ORION_CTE OCT
      JOIN softran_termaco.dbo.GTCMovEn MOV   ON MOV.CdEmpresa = OCT.CdEmpresa AND MOV.NrSeqControle = OCT.NrSeqControle
     WHERE MOV.CdOcorrencia = 1 -- Codigo no Sênior (ENTREGA REALIZADA NORMALMENTE)      
       AND OCT.DT_ENTREGA IS NULL 

    --- INSERT REGISTRO PARA COMPROVANTE
    INSERT INTO SIC.dbo.ORION_OCORRENCIAS ( 
                      CNPJ, DOCUMENTO, CHAVE, CHAVEORIGINAL, DT_ATUAL, DT_OCORRENCIA,
                      TIPOIMAGEM, OBSERVACAO, RECEBEDOR_DOC, RECEBEDOR_NOME,
                      CdEmpresa, NrSeqControle, CdOcorrencia )
    SELECT TOP 20
             OCT.EMBARCADOR            AS CNPJ
            ,OCT.DOCUMENTO             AS DOCUMENTO
            ,OCT.CHAVE                 AS CHAVE
            ,OCT.CHAVEORIGINAL         AS CHAVEORIGINAL
            ,CURRENT_TIMESTAMP         AS DT_ATUAL
            ,CURRENT_TIMESTAMP         AS DT_OCORRENCIA
            ,1                         AS TIPOIMAGEM
            ,'COMPROVANTE DE ENTREGA'  AS OBSERVACAO

            ,CO.RECEBEDOR_DOC          AS RECEBEDOR_DOC
            ,CO.RECEBEDOR_NOME         AS RECEBEDOR_NOME
            ,OCT.CdEmpresa             AS CdEmpresa
            ,OCT.NrSeqControle         AS NrSeqControle
            ,999                       AS CdOcorrencia

     FROM SIC.dbo.ORION_CTE            OCT 
     JOIN SIC.dbo.ORION_OCORRENCIAS     CO ON CO.CdEmpresa = OCT.CdEmpresa AND CO.NrSeqControle = OCT.NrSeqControle
    WHERE OCT.FASE_ID     = 5    
      AND CO.CdOcorrencia = 1
      AND CO.FLAG_SEND    = 1
      AND NOT EXISTS (SELECT 1 FROM SIC.dbo.ORION_OCORRENCIAS a WHERE a.CdEmpresa = OCT.CdEmpresa AND a.NrSeqControle = OCT.NrSeqControle AND a.CdOcorrencia = 999)
    ; 

    UPDATE OCT
       SET FASE_ID   = 6
         , DT_UPDATE = CURRENT_TIMESTAMP
      FROM SIC.dbo.ORION_CTE        OCT
      JOIN SIC.dbo.ORION_OCORRENCIAS CO ON CO.DOCUMENTO = OCT.DOCUMENTO
     WHERE OCT.FASE_ID     = 5
       AND CO.CdOcorrencia = 999
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
