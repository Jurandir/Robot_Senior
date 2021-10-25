-- 19/10/2021 10:49 - AJUSTA NOTAS FISCAIS COM CONHECIMENTO CANCELADOS - (" Orion ") 
-- (CODIGO EM ANALISE - SEM USO - 19/10/2021)

UPDATE NFE
SET CdEmpresa      = CNH.CdEmpresa
  , NrSeqControle  = CNH.NrSeqControle
  , CTRC_OLD       = NFE.CTRC
  , CTRC           = CONCAT(EMP.DSAPELIDO,'E',CNH.NrDoctoFiscal)
  , DT_UPDATE      = CURRENT_TIMESTAMP
FROM softran_termaco.dbo.gtcconhe  CNH
JOIN softran_termaco.dbo.sisempre  EMP  ON EMP.CdEmpresa   = CNH.CdEmpresa
JOIN softran_termaco.dbo.gtcnfcon  LNK  ON LNK.CdEmpresa   = CNH.CdEmpresa   AND LNK.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.gtcnf     NFR  ON NFR.CdRemetente = LNK.CdInscricao AND NFR.NrSerie       = LNK.NrSerie AND NFR.NrNotaFiscal = LNK.NrNotaFiscal 
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = CNH.CdEmpresa	 AND CTE.NrSeqControle = CNH.NrSeqControle
JOIN SIC..ORION_CTE                NFE  ON NFE.CHAVE       = NFR.NrChaveAcessoNFe
WHERE CTE.insituacaosefaz = 100 -- PESQUISA NOVO CTRC VALIDADO PELA SEFAZ
 AND NFE.CHAVE IN (

SELECT NFE.CHAVE
FROM SIC..ORION_CTE                NFE  
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = NFE.CdEmpresa	 AND CTE.NrSeqControle = NFE.NrSeqControle
WHERE  CTE.insituacaosefaz = 135

) -- PESQUISA CTRC CANCELADAS APOS INCLUSÃO NO MONITORAMENTO


-- TEM QUE TESTAR CTRC ORIGEM

/*
SELECT NFE.CHAVE
FROM softran_termaco.dbo.gtcconhe  CNH
JOIN softran_termaco.dbo.gtcnfcon  LNK  ON LNK.CdEmpresa   = CNH.CdEmpresa   AND LNK.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.gtcnf     NFR  ON NFR.CdRemetente = LNK.CdInscricao AND NFR.NrSerie       = LNK.NrSerie AND NFR.NrNotaFiscal = LNK.NrNotaFiscal 
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = CNH.CdEmpresa	 AND CTE.NrSeqControle = CNH.NrSeqControle
JOIN SIC..ORION_CTE                NFE  ON NFE.CdEmpresa   = CNH.CdEmpresa   AND NFE.NrSeqControle  = CNH.NrSeqControle
WHERE CTE.insituacaosefaz = 135
*/