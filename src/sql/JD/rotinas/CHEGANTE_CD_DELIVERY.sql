 -- 29/09/2021 10:56 -  DELIVERY - CHEGADA NO CD TRANSBORDO - "JOHN DEERE"

INSERT INTO SIC..JOHNDEERE_INFO (MESSAGETYPE,MESSAGESENDER,MESSAGERECIPIENT,WITSFILENAME,TIMESTAMP,CONTROLNUMBER,INVOICENUMBER,COMMERCIALINVOICENUMBER,CUSTOMER,EVENTTYPE,RAILHEAD,DELIVERYLOC,DEALERDELIVERYDATE,SENDXML
    ,COMMENTS
    ,NrManifesto
    ,CdEmpresa
    ,NrSeqControle
    ,CdRemetente
    ,NrNotaFiscal
    ,NrSerie
    ,CdSequencia

)
SELECT DISTINCT
'INVOICE'      AS MESSAGETYPE,
'CARRIER_TERM' AS MESSAGESENDER,
'VISIBILITY'   AS MESSAGERECIPIENT,
FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss')  AS WITSFILENAME,
FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss')  AS TIMESTAMP,
'000000000'                                 AS CONTROLNUMBER,
NFR.nrnotafiscal            AS INVOICENUMBER,
''                    AS COMMERCIALINVOICENUMBER,
'JDP'                 AS CUSTOMER,
'DELIVERY'            AS EVENTTYPE,
'89674782001391'      AS RAILHEAD,
FDT.NrCGCCPF          AS DELIVERYLOC, 
CONCAT(FORMAT(MOV.DtMovimento,'yyyyMMdd'),FORMAT(MOV.HrMovimento,'HHmmss')) AS DEALERDELIVERYDATE,
'0' AS SENDXML
    ,'CD DELIVERY - CHEGADA NA FILIAL DE TRANSBORDO'
    ,MAN.NrManifesto
    ,CNH.CdEmpresa
    ,CNH.NrSeqControle
    ,NFR.CdRemetente
    ,NFR.NrNotaFiscal
    ,NFR.NrSerie
    ,MOV.CdSequencia

FROM softran_termaco.dbo.gtcconhe      CNH                                        
JOIN softran_termaco.dbo.gtcnfcon      LNK ON LNK.cdempresa       = CNH.cdempresa AND LNK.nrseqcontrole = CNH.nrseqcontrole  
JOIN softran_termaco.dbo.gtcnf         NFR ON NFR.cdremetente     = LNK.cdinscricao AND NFR.nrserie     = LNK.nrserie AND NFR.nrnotafiscal = LNK.nrnotafiscal
JOIN softran_termaco.dbo.gtcmoven      MOV ON MOV.cdempresa       = CNH.cdempresa   AND MOV.nrseqcontrole = CNH.nrseqcontrole  -- Movimento de Ocorrencias 
LEFT JOIN softran_termaco.dbo.GTCFatIt FAT ON FAT.CdEmpresaConhec = CNH.CdEmpresa AND FAT.NrSeqControle = CNH.NrSeqControle AND FAT.CdSequencia   = 1 AND FAT.Insituacao = 1
LEFT JOIN softran_termaco.dbo.sisempre FDT ON FDT.cdempresa       = CNH.cdempresadestino -- Filial Destino
JOIN softran_termaco.dbo.GTCManCn      LMA ON LMA.CdEmpresa       = CNH.CdEmpresa AND LMA.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.GTCMan        MAN ON MAN.NrManifesto     = LMA.NrManifesto
WHERE  
--      CNH.InTipoEmissao = 00                      --- CTRC Normal
--  AND CNH.InImpressao   = 1                       --- Impresso
     ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) ) 
  AND MOV.CdOcorrencia  = 102	                  --- "CHEGADA NA FILIAL DE TRANSBORDO"
  AND SUBSTRING( CNH.CdInscricao,1,8) ='89674782' --- JOHN DEERE BRASIL LTDA (89674782001391)
  AND NOT EXISTS ( SELECT 1 FROM SIC..JOHNDEERE_INFO INF
                    WHERE INF.EVENTTYPE      = 'DELIVERY' 
                      AND INF.NrManifesto    = MAN.NrManifesto
                      AND INF.CdEmpresa      = CNH.CdEmpresa
                      AND INF.NrSeqControle  = CNH.NrSeqControle
                      AND INF.CdRemetente    = NFR.CdRemetente
                      AND INF.NrNotaFiscal   = NFR.NrNotaFiscal
                      AND INF.NrSerie        = NFR.NrSerie
					  AND INF.CdSequencia    = MOV.CdSequencia )

;

UPDATE SIC..JOHNDEERE_INFO
   SET CONTROLNUMBER = FORMAT( CODEINSERT ,'000000000') 
 WHERE CONTROLNUMBER = '000000000'
;

-- 28/12/2021 10:05 - Ajustado tipo de conhecimento e desconsidera impressão
