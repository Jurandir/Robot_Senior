-- 22/09/2021 14:53 - INSERT DADOS NA TABELA DE CONTROLE "JOHN DEERE"

INSERT INTO JOHNDEERE_INFO (
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
    ,NrManifesto
    ,CdEmpresa
    ,NrSeqControle
    ,CdRemetente
    ,NrNotaFiscal
    ,NrSerie
)
SELECT 
     '000000000'                                                                              AS CONTROLNUMBER
    ,NFR.nrnotafiscal                                                                         AS INVOICENUMBER
    ,FORMAT(CNH.dtemissao,'yyyyMMddHHmmss')                                                   AS SHIPDATE
    ,MAN.NrPlaca                                                                              AS LICENSEPLATENUMBER
    ,ISNULL(FAT.CdFatura,'')                                                                  AS BOLNUMBER
    ,MAN.NrManifesto                                                                          AS MANIFESTNUMBER
    ,CNH.cdEmpresadestino                                                                     AS DESTINATIONLOC
    ,CONCAT(FORMAT(MAN.DtPrevisaoChegada,'yyyyMMdd'),FORMAT(MAN.HrPrevisaoChegada,'HHmmss'))  AS DESTINATIONETA
    ,softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) 
                                                                                              AS FINALDESTETA
    ,NFR.QtVolume                                                                             AS VOLUME
    ,NFR.VlNotaFiscal                                                                         AS GROSSWT

    ,MAN.NrManifesto
    ,CNH.CdEmpresa
    ,CNH.NrSeqControle
    ,NFR.CdRemetente
    ,NFR.NrNotaFiscal
    ,NFR.NrSerie

FROM softran_termaco.dbo.gtcconhe      CNH                                        
JOIN softran_termaco.dbo.gtcnfcon      LNK ON LNK.cdempresa       = CNH.cdempresa AND LNK.nrseqcontrole = CNH.nrseqcontrole  
JOIN softran_termaco.dbo.gtcnf         NFR ON NFR.cdremetente     = LNK.cdinscricao AND NFR.nrserie     = LNK.nrserie AND NFR.nrnotafiscal = LNK.nrnotafiscal
LEFT JOIN softran_termaco.dbo.GTCFatIt FAT ON FAT.CdEmpresaConhec = CNH.CdEmpresa AND FAT.NrSeqControle = CNH.NrSeqControle AND FAT.CdSequencia   = 1
JOIN softran_termaco.dbo.GTCManCn      LMA ON LMA.CdEmpresa       = CNH.CdEmpresa AND LMA.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.GTCMan        MAN ON MAN.NrManifesto     = LMA.NrManifesto

WHERE  
      CNH.InTipoEmissao = 00                      --- CTRC Normal
  AND CNH.InImpressao   = 1                       --- Impresso
  AND SUBSTRING( CNH.CdInscricao,1,8) ='89674782' --- JOHN DEERE BRASIL LTDA (89674782001391)
  AND FAT.CdSequencia   = 1
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
