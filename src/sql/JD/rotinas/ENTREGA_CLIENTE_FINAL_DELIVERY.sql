 -- 30/09/2021 09:32 -  "DELIVERY-BR" - REGISTRO DE ENTREGA - "JOHN DEERE"

INSERT INTO SIC..JOHNDEERE_INFO (
     MESSAGETYPE
    ,MESSAGESENDER
    ,MESSAGERECIPIENT
    ,WITSFILENAME
    ,TIMESTAMP
    ,CONTROLNUMBER
    ,INVOICENUMBER
    ,COMMERCIALINVOICENUMBER
    ,CUSTOMER
    ,EVENTTYPE
    ,RAILHEAD
    ,DELIVERYLOC
    ,DEALERDELIVERYDATE
    ,SENDXML
    ,COMMENTS
    ,NrManifesto
    ,CdEmpresa
    ,NrSeqControle
    ,CdRemetente
    ,NrNotaFiscal
    ,NrSerie
    ,CdSequencia )

SELECT DISTINCT
      'INVOICE'                                                                   AS MESSAGETYPE
    , 'CARRIER_TERM'                                                              AS MESSAGESENDER
    , 'VISIBILITY'                                                                AS MESSAGERECIPIENT
    , FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss')                                  AS WITSFILENAME
    , FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss')                                  AS TIMESTAMP
    , '000000000'                                                                 AS CONTROLNUMBER
    , NFR.nrnotafiscal                                                            AS INVOICENUMBER
    , ''                                                                          AS COMMERCIALINVOICENUMBER
    , 'JDP'                                                                       AS CUSTOMER
    , 'DELIVERY'                                                                  AS EVENTTYPE
    , FDT.NrCGCCPF                                                                AS RAILHEAD
    , CONCAT(ENT.DsLocal,',',ENT.DsUF,'-BR')                                      AS DELIVERYLOC  -- EMPRESA/LILIAL ENTREGA
    , CONCAT(FORMAT(MOV.DtMovimento,'yyyyMMdd'),FORMAT(MOV.HrMovimento,'HHmmss')) AS DEALERDELIVERYDATE -- DATA BAIXA ENTREGA
    , '0'                                                                         AS SENDXML
    , 'ENTREGA REALIZADA NORMALMENTE'                                             AS COMMENTS
    ,MAN.NrManifesto
    ,CNH.CdEmpresa
    ,CNH.NrSeqControle
    ,NFR.CdRemetente
    ,NFR.NrNotaFiscal
    ,NFR.NrSerie
    ,MOV.CdSequencia

FROM softran_termaco.dbo.gtcconhe      CNH                                        
JOIN softran_termaco.dbo.gtcnfcon      LNK ON LNK.cdempresa       = CNH.cdempresa   AND LNK.nrseqcontrole = CNH.nrseqcontrole  
JOIN softran_termaco.dbo.gtcnf         NFR ON NFR.cdremetente     = LNK.cdinscricao AND NFR.nrserie       = LNK.nrserie AND NFR.nrnotafiscal = LNK.nrnotafiscal
JOIN softran_termaco.dbo.gtcmoven      MOV ON MOV.cdempresa       = CNH.cdempresa   AND MOV.nrseqcontrole = CNH.nrseqcontrole  -- Movimento de Ocorrencias 
LEFT JOIN softran_termaco.dbo.GTCFatIt FAT ON FAT.CdEmpresaConhec = CNH.CdEmpresa   AND FAT.NrSeqControle = CNH.NrSeqControle AND FAT.CdSequencia   = 1
JOIN softran_termaco.dbo.GTCManCn      LMA ON LMA.CdEmpresa       = CNH.CdEmpresa   AND LMA.NrSeqControle = CNH.NrSeqControle
LEFT JOIN softran_termaco.dbo.siscep   ENT ON ENT.nrcep           = CNH.NrCepEntrega   -- CEP Local Entrega
LEFT JOIN softran_termaco.dbo.sisempre FDT ON FDT.cdempresa       = CNH.cdempresadestino -- Filial Destino
JOIN softran_termaco.dbo.GTCMan        MAN ON MAN.NrManifesto     = LMA.NrManifesto

WHERE  
--      CNH.InTipoEmissao = 00                      --- CTRC Normal
--  AND CNH.InImpressao   = 1                       --- Impresso
  ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,13,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
  AND MOV.CdOcorrencia  = 1         	            --- "ENTREGA REALIZADA NORMALMENTE"
  AND SUBSTRING( CNH.CdInscricao,1,8) ='89674782' --- JOHN DEERE BRASIL LTDA (89674782001391)
  
  AND CNH.CDREMETENTE IN ('89674782001391')

  AND NOT EXISTS ( SELECT 1 FROM SIC..JOHNDEERE_INFO INF
                    WHERE INF.EVENTTYPE      = 'DELIVERY' 
                      AND DELIVERYLOC        LIKE '%-BR'
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

-- 28/12/2021 10:22 - Ajustado tipo de conhecimento e desconsidera impressão
