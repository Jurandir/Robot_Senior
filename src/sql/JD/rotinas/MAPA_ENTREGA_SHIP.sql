 -- 29/09/2021 17:29 -  SHIP - EM ROTA DE ENTREGA - "JON DEERE"

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
    ,SHIPDATE
    ,CARRIERTYPE
    ,CARRIERCODE
    ,LICENSEPLATENUMBER
    ,TRUCKNUMBER
    ,BOLNUMBER
    ,MANIFESTNUMBER
    ,DESTINATIONLOC
    ,DESTINATIONETA
    ,FINALDESTETA
    ,VOLUME
    ,GROSSWT
    ,NETWT
    ,COMMENTS
    ,SENDXML
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
    , 'SHIP'                                                                      AS EVENTTYPE
    , FDT.NrCGCCPF                                                                AS RAILHEAD -- EMPRESA DESTINO
    , CONCAT(FORMAT(MOV.DtMovimento,'yyyyMMdd'),FORMAT(MOV.HrMovimento,'HHmmss')) AS SHIPDATE -- DATA DE ENTREGA
    , 'TRUCK'                                                                     AS CARRIERTYPE
    , 'TERM'                                                                      AS CARRIERCODE
    , MAN.NrPlaca                                                                 AS LICENSEPLATENUMBER
    , ''                                                                          AS TRUCKNUMBER
    , ISNULL(FAT.CdFatura,'')                                                     AS BOLNUMBER
    , SUBSTRING(MAN.NrManifesto, CHARINDEX ('-',MAN.NrManifesto)+1, 8 )           AS MANIFESTNUMBER
    , CONCAT(ENT.DsLocal,',',ENT.DsUF,'-BR')                                      AS DESTINATIONLOC -- LOCAL DE ENTREGA
    , CONCAT(FORMAT(MOV.DtMovimento,'yyyyMMdd'),FORMAT(MOV.HrMovimento,'HHmmss')) AS DESTINATIONETA -- DATA DE ENTREGA
    , FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) ,'yyyyMMddHHmmss')
                                                                                  AS FINALDESTETA -- PREVISÃO DE ENTREGA
    , NFR.QtVolume                                                                AS VOLUME
    , NFR.VlNotaFiscal                                                            AS GROSSWT
    , ''                                                                          AS NETWT
    , 'EM ROTA PARA ENTREGA'                                                      AS COMMENTS                                   
    , '0'                                                                         AS SENDXML
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
LEFT JOIN softran_termaco.dbo.GTCFatIt FAT ON FAT.CdEmpresaConhec = CNH.CdEmpresa   AND FAT.NrSeqControle = CNH.NrSeqControle AND FAT.CdSequencia   = 1 AND FAT.Insituacao = 1
JOIN softran_termaco.dbo.GTCManCn      LMA ON LMA.CdEmpresa       = CNH.CdEmpresa   AND LMA.NrSeqControle = CNH.NrSeqControle
LEFT JOIN softran_termaco.dbo.siscep   ENT ON ENT.nrcep           = CNH.NrCepEntrega   -- CEP Local Entrega
LEFT JOIN softran_termaco.dbo.sisempre FDT ON FDT.cdempresa       = CNH.cdempresadestino -- Filial Destino
JOIN softran_termaco.dbo.GTCMan        MAN ON MAN.NrManifesto     = LMA.NrManifesto

WHERE  
--      CNH.InTipoEmissao = 00                      --- CTRC Normal
--   AND CNH.InImpressao   = 1                       --- Impresso
  ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) ) 
  AND MOV.CdOcorrencia  IN (100,202)	          --- "EM ROTA PARA ENTREGA" OU "EM ROTA DE ENTREGA PELO REDESPACHO"
  AND SUBSTRING( CNH.CdInscricao,1,8) ='89674782' --- JOHN DEERE BRASIL LTDA (89674782001391)
  
  AND CNH.CDREMETENTE IN ('89674782001391')

  AND NOT EXISTS ( SELECT 1 FROM SIC..JOHNDEERE_INFO INF
                    WHERE INF.EVENTTYPE      = 'SHIP' 
                      AND DESTINATIONLOC  LIKE '%-BR'
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

-- 28/12/2021 10:19 - Ajustado tipo de conhecimento e desconsidera impressão