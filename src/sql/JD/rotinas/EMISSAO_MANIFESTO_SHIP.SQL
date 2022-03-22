-- 22/09/2021 14:53 - INSERT DADOS NA TABELA DE CONTROLE "JOHN DEERE"

INSERT INTO SIC.dbo.JOHNDEERE_INFO (
    CONTROLNUMBER
    ,INVOICENUMBER
    ,SHIPDATE
    ,LICENSEPLATENUMBER
    ,BOLNUMBER
    ,MANIFESTNUMBER
    ,DESTINATIONLOC
    ,DESTINATIONETA
    ,FINALDESTETA
    ,VOLUME
    ,GROSSWT
    ,COMMENTS
    ,NrManifesto
    ,CdEmpresa
    ,NrSeqControle
    ,CdRemetente
    ,NrNotaFiscal
    ,NrSerie
)
SELECT DISTINCT
     '000000000'                                                                              AS CONTROLNUMBER
    ,NFR.nrnotafiscal                                                                         AS INVOICENUMBER
    ,FORMAT(CNH.dtemissao,'yyyyMMddHHmmss')                                                   AS SHIPDATE
    ,MAN.NrPlaca                                                                              AS LICENSEPLATENUMBER
    ,ISNULL(FAT.CdFatura,'')                                                                  AS BOLNUMBER
    ,SUBSTRING(MAN.NrManifesto, CHARINDEX ('-',MAN.NrManifesto)+1, 8 )                        AS MANIFESTNUMBER
    ,FDT.NrCGCCPF                                                                             AS DESTINATIONLOC
    ,CONCAT(FORMAT(MAN.DtPrevisaoChegada,'yyyyMMdd'),FORMAT(MAN.HrPrevisaoChegada,'HHmmss'))  AS DESTINATIONETA
    ,FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole),'yyyyMMddHHmmss') 
                                                                                              AS FINALDESTETA
    ,NFR.QtVolume                                                                             AS VOLUME
    ,NFR.VlNotaFiscal                                                                         AS GROSSWT
    ,'INICIO'
    ,MAN.NrManifesto
    ,CNH.CdEmpresa
    ,CNH.NrSeqControle
    ,NFR.CdRemetente
    ,NFR.NrNotaFiscal
    ,NFR.NrSerie

FROM softran_termaco.dbo.gtcconhe      CNH   
JOIN softran_termaco.dbo.gtcconce      CTE ON CTE.CdEmpresa       = CNH.CdEmpresa	  AND CTE.NrSeqControle = CNH.NrSeqControle                               
JOIN softran_termaco.dbo.gtcnfcon      LNK ON LNK.cdempresa       = CNH.cdempresa   AND LNK.nrseqcontrole = CNH.nrseqcontrole  
JOIN softran_termaco.dbo.gtcnf         NFR ON NFR.cdremetente     = LNK.cdinscricao AND NFR.nrserie       = LNK.nrserie       AND NFR.nrnotafiscal = LNK.nrnotafiscal
LEFT JOIN softran_termaco.dbo.GTCFatIt FAT ON FAT.CdEmpresaConhec = CNH.CdEmpresa   AND FAT.NrSeqControle = CNH.NrSeqControle AND FAT.CdSequencia  = 1 AND FAT.Insituacao = 1
JOIN softran_termaco.dbo.GTCManCn      LMA ON LMA.CdEmpresa       = CNH.CdEmpresa   AND LMA.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.GTCMan        MAN ON MAN.NrManifesto     = LMA.NrManifesto
LEFT JOIN softran_termaco.dbo.sisempre FDT ON FDT.cdempresa       = CNH.cdempresadestino -- Filial Destino

WHERE  
     -- CNH.InTipoEmissao   = 00                     --- CTRC Normal
     ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,13,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )      
  AND CTE.insituacaosefaz = 100                    --- REGISTRADO NA SEFAZ
  -- AND SUBSTRING( CNH.CdInscricao,1,8) ='89674782'  --- JOHN DEERE BRASIL LTDA (89674782001391)
  AND EXISTS (SELECT 1 FROM SIC..JOHNDEERE_CLIENTES CLI WHERE CLI.CNPJ = CNH.CdInscricao) -----<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  
  AND NOT EXISTS ( SELECT 1 FROM SIC..JOHNDEERE_INFO INF
                    WHERE INF.EVENTTYPE      = 'SHIP' 
                      AND INF.NrManifesto    = MAN.NrManifesto
                      AND INF.CdEmpresa      = CNH.CdEmpresa
                      AND INF.NrSeqControle  = CNH.NrSeqControle
                      AND INF.CdRemetente    = NFR.CdRemetente
                      AND INF.NrNotaFiscal   = NFR.NrNotaFiscal
                      AND INF.NrSerie        = NFR.NrSerie )
;

UPDATE SIC..JOHNDEERE_INFO
   SET CONTROLNUMBER = FORMAT( CODEINSERT ,'000000000') 
 WHERE CONTROLNUMBER = '000000000'
;
 
-- 28/12/2021 10:00 - Ajustado tipo de conhecimento
