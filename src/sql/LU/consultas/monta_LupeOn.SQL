-- 21/02/2022 16:03 - MONTA DADOS - ("LUPEON V1")

SELECT DISTINCT  
	 CNH.CdRemetente                                               as EMBARCADOR
	,RIGHT(REPLICATE('0',7) + CAST(NFR.NrNotaFiscal AS VARCHAR),7) as NUMERO
	,NFR.NrSerie                                                   as SERIE
	,NFR.NrChaveAcessoNFe                                          as CHAVE
	,NFR.DtEmissao                                                 as DT_EMISSAO
	,(SELECT TOP 1 CAST(CONCAT(FORMAT(d.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(d.hrMovimento,'HH:mm:ss')) as datetime) 
     FROM softran_termaco.dbo.GTCMovEn d WHERE d.CdEmpresa = CNH.CdEmpresa AND d.NrSeqControle = CNH.NrSeqControle AND d.CdOcorrencia = 101	) -- 101 codigo Sênior - "EM TRANSFERENCIA ENTRE FILIAIS"
	                                                               as DT_EMBARQUE
	,(SELECT TOP 1 CAST(CONCAT(FORMAT(d.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(d.hrMovimento,'HH:mm:ss')) as datetime) 
      FROM softran_termaco.dbo.GTCMovEn d WHERE d.CdEmpresa = CNH.CdEmpresa AND d.NrSeqControle = CNH.NrSeqControle AND d.CdOcorrencia = 98	) --  98 codigo Sênior - "CHEGADA NA CIDADE OU FILIAL DESTINO"
	                                                               as DT_CHEGADA
	,CNH.DtEntrega                                                 as DT_ENTREGA
	,softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) 
	                                                               as DT_PREVISAO
	,softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) 
	                                                               as DT_PREV_ORIGINAL
	,NFR.VlNotaFiscal                                              as VALOR
	,CONCAT(EMP.DSAPELIDO,'E',CNH.NrDoctoFiscal)                   as CTRC
	,CNH.CdDestinatario                                            as DESTINATARIO
	,EMP.NRCGCCPF                                                  as TRANSPORTADOR
	,CNH.dtdigitacao                                               as DT_UPDATE
	,CNH.CdEmpresa                                                 as CdEmpresa
	,CNH.NrSeqControle                                             as NrSeqControle
	,0                                                             as FASE_ID
	,1                                                             as VER_ID
	,CFF.CNPJ                                                      as BASE_CNPJ
FROM softran_termaco.dbo.gtcconhe  CNH
JOIN softran_termaco.dbo.gtcnfcon  LNK  ON LNK.CdEmpresa   = CNH.CdEmpresa   AND LNK.NrSeqControle = CNH.NrSeqControle
JOIN softran_termaco.dbo.gtcnf     NFR  ON NFR.CdRemetente = LNK.CdInscricao AND NFR.NrSerie       = LNK.NrSerie AND NFR.NrNotaFiscal = LNK.NrNotaFiscal 
JOIN softran_termaco.dbo.sisempre  EMP  ON EMP.CdEmpresa   = CNH.CdEmpresa
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = CNH.CdEmpresa	 AND CTE.NrSeqControle = CNH.NrSeqControle
LEFT JOIN SIC..LUPEON_NFE          NFE  ON NFE.CHAVE       = NFR.NrChaveAcessoNFe
JOIN SIC..LUPEON_CLIENTE           CFF  ON CFF.FLAG_ATIVO = 1 AND
                                           ((CFF.RAIZ = SUBSTRING(CNH.CdRemetente,1,8)) OR 
                                           ( CFF.RAIZ = SUBSTRING(CNH.CdDestinatario,1,8)) OR
                                           ( CFF.RAIZ = SUBSTRING(CNH.CdInscricao,1,8)))



