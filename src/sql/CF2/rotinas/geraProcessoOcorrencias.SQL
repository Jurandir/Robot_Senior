-- 01/09/2021 10:48 - OCORRENCIAS DIVERSAS - MANUAIS - ("Confirma Facil V2")
-- PROD-15/10/2021

-- Confirma Facil (20/12/2021)

SET XACT_ABORT ON

DECLARE @CONFIRMAFACIL_ID           as INT
DECLARE @OCORRENCIA_DATA            as DATETIME
DECLARE @DATAOCO                    as DATETIME
DECLARE @OCORRENCIA_ID              as INT
DECLARE @OCORRENCIA_NOME            as NVARCHAR(60)
DECLARE @OCORRENCIA_OBS             as NVARCHAR(2000)
DECLARE @RECEBEDOR_NOME             as NVARCHAR(60)
DECLARE @RECEBEDOR_DOC              as NVARCHAR(40)
DECLARE @CdEmpresa                  as INT
DECLARE @NrSeqControle              as BIGINT
DECLARE @CdSequencia                as INT


DECLARE Ocorrencia_Cursor CURSOR FOR 
SELECT TOP 50
     CF.ID                   AS CONFIRMAFACIL_ID
	,CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
	                         AS OCORRENCIA_DATA
    ,ISNULL(DP.ID_CONFIRMAFACIL,OUN.CdOcorrencia) AS OCORRENCOA_ID
	,OCO.DsHistoricoEntrega  AS OCORRENCIA_NOME
	,OUN.DsComplementoOcorr  AS OCORRENCIA_OBS
    ,OUN.NrDoctoIdentPessoal AS RECEBEDOR_DOC
    ,OUN.DsContato           AS RECEBEDOR_NOME
	,OUN.CdEmpresa           AS CdEmpresa
	,OUN.NrSeqControle       AS NrSeqControle
	,OUN.CdSequencia         AS CdSequencia

FROM SIC..CONFIRMAFACIL            CF
JOIN softran_termaco.dbo.GTCNf     NFR ON NFR.NrChaveAcessoNFe   = CF.CHAVE               -- NOTA FISCAL
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
LEFT JOIN SIC..CONFIRMAFACILDEPARA  DP ON DP.ID_SENIOR           = OUN.CdOcorrencia       -- DE PARA ( SENIOR -> CONFIRMAFACIL )

WHERE 1=1
  AND ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
  AND CTE.insituacaosefaz = 100 
  
  AND (isnull(OCO.InExibehist, 0) = 0 OR OUN.CdOcorrencia IN (219,112,031,105) )     
                                                           -- 219 = AGUARDANDO AGENDAMENTO/SOLICITADO AGENDA
                                                           -- 112 = ENTREGA PARCIAL COM RESSALVA 
                                                           -- 031 = ENTREGA COM INDENIZACAO EFETUADA 
                                                           -- 105 = CLIENTE RETIROU MERCADORIA EM DEPOSITO – ENTREGUE

  AND NOT EXISTS ( SELECT 1 FROM SIC..CONFIRMAFACILOCORRENCIA CO  
                            WHERE CO.CONFIRMAFACIL_ID = CF.ID             AND 
                                  CO.CdEmpresa        = OUN.CdEmpresa     AND 
								  CO.NrSeqControle    = OUN.NrSeqControle AND 
								  CO.CdSequencia      = OUN.CdSequencia   AND 
								  CO.OCORRENCIA_ID    = ISNULL(DP.ID_CONFIRMAFACIL,OUN.CdOcorrencia) ) 

  AND OUN.CdOcorrencia NOT IN ( 000,210,801,899,999 )
  AND CF.FASE_ID < 5
ORDER BY
   CF.ID,
   CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
;	

OPEN Ocorrencia_Cursor;  

FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @CONFIRMAFACIL_ID, 
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

         INSERT INTO SIC..CONFIRMAFACILOCORRENCIA ( 
             CONFIRMAFACIL_ID, 
             OCORRENCIA_ID, 
             OCORRENCIA_NOME, 
             OCORRENCIA_DATA,
             OCORRENCIA_OBS,
             RECEBEDOR_DOC,
             RECEBEDOR_NOME,
             CdEmpresa,
             NrSeqControle,
             CdSequencia,
             VER_ID 
        ) VALUES ( 
            @CONFIRMAFACIL_ID, 
            @OCORRENCIA_ID, 
            @OCORRENCIA_NOME,  
            @OCORRENCIA_DATA,  
            @OCORRENCIA_OBS,
            @RECEBEDOR_DOC,
            @RECEBEDOR_NOME,
            @CdEmpresa,
            @NrSeqControle,
            @CdSequencia,
            2 
        )

      -- Print @@ROWCOUNT
      ; 

      COMMIT TRANSACTION
      ;
      
      -- Print @CONFIRMAFACIL_ID ;
      -- Print @OCORRENCIA_ID ;
      -- Print @OCORRENCIA_DATA ;

      FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @CONFIRMAFACIL_ID, 
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
