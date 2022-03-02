-- 02/03/2022 10:38 - COMPROVANTE DE ENTREGA - (" LUPEON ")

SET XACT_ABORT ON

BEGIN TRY
    BEGIN TRANSACTION

        ;
        INSERT INTO SIC..LUPEON_OCORRENCIA
          ( LUPEON_ID, OCORRENCIA_ID, OCORRENCIA_NOME, OCORRENCIA_DATA , CdEmpresa, NrSeqControle, VER_ID )
        SELECT 
              NFE.ID                             AS LUPEON_ID
              ,999                               AS OCORRENCIA_ID
              ,'COMPROVANTE DE ENTREGA'          AS OCORRENCIA_NOME
              ,CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
                                                 AS OCORRENCIA_DATA
              ,OUN.CdEmpresa
              ,OUN.NrSeqControle
              ,1                                 AS VER_ID

        FROM SIC..LUPEON_NFE               NFE
        JOIN softran_termaco.dbo.GTCNf     NFR ON NFR.NrChaveAcessoNFe   = NFE.CHAVE               -- NOTA FISCAL
        JOIN softran_termaco.dbo.gtcnfcon  LNK ON NFR.CdRemetente        = LNK.CdInscricao AND 
                                                  NFR.NrSerie            = LNK.NrSerie     AND 
                                                  NFR.NrNotaFiscal       = LNK.NrNotaFiscal       -- Link NF x CTRC
        JOIN softran_termaco.dbo.gtcconhe  CNH ON CNH.CdEmpresa          = LNK.CdEmpresa   AND 
                                                  CNH.NrSeqControle      = LNK.NrSeqControle      -- CTRC
        JOIN softran_termaco.dbo.gtcconce  CTE ON CTE.CdEmpresa          = CNH.CdEmpresa	 AND 
                                                  CTE.NrSeqControle      = CNH.NrSeqControle      -- CTE  
        JOIN softran_termaco.dbo.gtcmoven  OUN ON OUN.CdEmpresa          = CNH.CdEmpresa   AND
                                                  OUN.NrSeqControle      = CNH.NrSeqControle      -- Movimento das Ocorrencias
        JOIN softran_termaco.dbo.gtchisen  OCO ON OCO.cdhistoricoentrega = OUN.cdocorrencia       -- Ocorrencias
        LEFT JOIN softran_termaco.dbo.GTCVHist DP  ON DP.CdInscricao     = NFE.BASE_CNPJ AND
                                                      DP.CdHistoricoEntrega = OUN.cdocorrencia --- AJUSTE (DEPARA)
        WHERE 1=1
          AND ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,13,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
          AND CTE.insituacaosefaz = 100 

          AND ( isnull(OCO.InExibehist, 0) = 0 OR isnull(DP.InGeraOcorrencia, 1) = 1 ) --- AJUSTE (DEPARA)

          AND NOT EXISTS ( SELECT 1 FROM SIC..LUPEON_OCORRENCIA CO  
                      WHERE CO.LUPEON_ID        = NFE.ID            AND 
                          CO.CdEmpresa        = OUN.CdEmpresa     AND 
                          CO.NrSeqControle    = OUN.NrSeqControle AND 
                          CO.CdSequencia      = OUN.CdSequencia   AND
                          CO.OCORRENCIA_ID    = 999  )  
          AND OUN.CdOcorrencia = 001
          AND NFE.FASE_ID < 5
        ORDER BY
          NFE.ID,
          CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
        ;

        UPDATE NFE 
          SET FASE_ID = 6,
              DT_UPDATE = CURRENT_TIMESTAMP
        FROM  SIC..LUPEON_NFE NFE
        WHERE FASE_ID < 6
          AND EXISTS ( SELECT 1 FROM SIC..LUPEON_OCORRENCIA CO 
                        WHERE CO.LUPEON_ID = NFE.ID 
                          AND CO.OCORRENCIA_ID = 999 
                          AND CO.FLAG_SEND = 0) 
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