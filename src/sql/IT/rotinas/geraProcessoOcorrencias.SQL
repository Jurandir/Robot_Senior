-- 15/12/2021 14:34 - OCORRENCIAS DIVERSAS - MANUAIS (iTrack)
SET XACT_ABORT ON

DECLARE @ITRACK_DANFE_ID  as INT
DECLARE @OCORRENCIA_DATA  as DATETIME
DECLARE @DATAOCO          as DATETIME
DECLARE @OCORRENCIA_ID    as INT
DECLARE @OCORRENCIA_NOME  as NVARCHAR(60)
DECLARE @OCORRENCIA_OBS   as NVARCHAR(2000)
DECLARE @RECEBEDOR_NOME   as NVARCHAR(60)
DECLARE @RECEBEDOR_DOC    as NVARCHAR(40)
DECLARE @CdEmpresa        as INT
DECLARE @NrSeqControle    as BIGINT
DECLARE @CdSequencia      as INT

DECLARE Ocorrencia_Cursor CURSOR FOR 
SELECT TOP 10
     IT.ID                   AS ITRACK_DANFE_ID
	,CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
	                         AS OCORRENCIA_DATA
  ,(CASE WHEN OUN.CdOcorrencia=105 THEN 001 ELSE OUN.CdOcorrencia END) AS OCORRENCOA_ID
	,OCO.DsHistoricoEntrega  AS OCORRENCIA_NOME
	,OUN.DsComplementoOcorr  AS OCORRENCIA_OBS
  ,OUN.NrDoctoIdentPessoal AS RECEBEDOR_DOC
  ,OUN.DsContato           AS RECEBEDOR_NOME
	,OUN.CdEmpresa           AS CdEmpresa
	,OUN.NrSeqControle       AS NrSeqControle
	,OUN.CdSequencia         AS CdSequencia

FROM SIC.dbo.ITRACK_DANFE           IT
JOIN softran_termaco.dbo.GTCNf     NFR ON NFR.NrChaveAcessoNFe   = IT.CHAVE               -- NOTA FISCAL
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
WHERE 1=1
  AND ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
  AND CTE.insituacaosefaz = 100
  AND  (isnull(OCO.InExibehist, 0) = 0 OR OUN.CdOcorrencia=219)               -- 219 = AGUARDANDO AGENDAMENTO/SOLICITADO AGENDA
  AND NOT EXISTS ( SELECT 1 FROM SIC..ITRACK_OCORRENCIA CO    
                            WHERE CO.ITRACK_DANFE_ID = IT.ID             AND 
                                  CO.CdEmpresa       = OUN.CdEmpresa     AND 
																	CO.NrSeqControle   = OUN.NrSeqControle AND 
																	CO.CdSequencia     = OUN.CdSequencia   AND 
																	CO.OCORRENCIA_ID = OUN.CdOcorrencia ) 
  AND OUN.CdOcorrencia NOT IN ( 000,210,801,899,999 )
  AND IT.FASE_ID < 5
ORDER BY
   IT.ID,
   CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
;	

OPEN Ocorrencia_Cursor;  

FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @ITRACK_DANFE_ID, 
         @OCORRENCIA_DATA, 
         @OCORRENCIA_ID, 
         @OCORRENCIA_NOME,
         @OCORRENCIA_OBS,
         @RECEBEDOR_DOC,
         @RECEBEDOR_NOME,
         @CdEmpresa,
         @NrSeqControle,
         @CdSequencia
         ;
          
WHILE @@FETCH_STATUS = 0  
BEGIN      
      BEGIN TRANSACTION;

         INSERT INTO SIC.dbo.ITRACK_OCORRENCIA ( 
             ITRACK_DANFE_ID, 
             OCORRENCIA_ID, 
             OCORRENCIA_NOME, 
             OCORRENCIA_DATA,
             OCORRENCIA_OBS,
             RECEBEDOR_DOC,
             RECEBEDOR_NOME,
             CdEmpresa,
             NrSeqControle,
             CdSequencia 
        ) VALUES ( 
            @ITRACK_DANFE_ID, 
            @OCORRENCIA_ID, 
            @OCORRENCIA_NOME,  
            @OCORRENCIA_DATA,  
            @OCORRENCIA_OBS,
            @RECEBEDOR_DOC,
            @RECEBEDOR_NOME,
            @CdEmpresa,
            @NrSeqControle,
            @CdSequencia 
        )

      -- Print @@ROWCOUNT
      ; 

      COMMIT TRANSACTION
      ;
      
      -- Print @ITRACK_DANFE_ID ;
      -- Print @OCORRENCIA_ID ;
      -- Print @OCORRENCIA_DATA ;

      FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @ITRACK_DANFE_ID, 
         @OCORRENCIA_DATA, 
         @OCORRENCIA_ID, 
         @OCORRENCIA_NOME,
         @OCORRENCIA_OBS,
         @RECEBEDOR_DOC,
         @RECEBEDOR_NOME,
         @CdEmpresa,
         @NrSeqControle,
         @CdSequencia
         ;

END
;

CLOSE Ocorrencia_Cursor
;  
DEALLOCATE Ocorrencia_Cursor
;  
-- REGRAS APLICADAS: 
-- 2.2 -  Ocorrência 105-CLIENTE RETIROU MERCADORIA EM DEPOSITO - ENTREGUE deve ter "de > para" 001-ENTREGA REALIZADA NORMALMENTE
