UPDATE NFE
SET BASE_CNPJ = CFF.CNPJ,
      VER_ID = 0 
--SELECT NFE.ID, NFE.BASE_CNPJ, CFF.CNPJ, NFE.VER_ID
FROM softran_termaco.dbo.gtcconhe  CNH
JOIN softran_termaco.dbo.gtcnfcon  LNK  ON LNK.CdEmpresa   = CNH.CdEmpresa   AND LNK.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.gtcnf     NFR  ON NFR.CdRemetente = LNK.CdInscricao AND NFR.NrSerie       = LNK.NrSerie AND NFR.NrNotaFiscal = LNK.NrNotaFiscal 
JOIN softran_termaco.dbo.sisempre  EMP  ON EMP.CdEmpresa   = CNH.CdEmpresa
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = CNH.CdEmpresa	 AND CTE.NrSeqControle = CNH.NrSeqControle
JOIN SIC..ITRACK_DANFE             NFE  ON NFE.CHAVE       = NFR.NrChaveAcessoNFe
JOIN SIC..ITRACK_CLIENTE           CFF  ON CFF.FLAG_ATIVO = 1 AND
                                          ((CFF.RAIZ_CNPJ = SUBSTRING(CNH.CdRemetente,1,8)) OR 
                                           (CFF.RAIZ_CNPJ = SUBSTRING(CNH.CdDestinatario,1,8)) OR
                                           (CFF.RAIZ_CNPJ = SUBSTRING(CNH.CdInscricao,1,8)))
WHERE NFE.BASE_CNPJ IS NULL
;

-- select * from SIC..ITRACK_DANFE WHERE BASE_CNPJ IS NULL



