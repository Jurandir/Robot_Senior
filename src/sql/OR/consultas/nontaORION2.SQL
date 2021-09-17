-- 15/09/2021 16:32 - INICIA PROCESSO DE MONITORAMENTO (monta ORION)

SELECT DISTINCT  
     CONCAT(EMP.DSAPELIDO,'E',CNH.NrDoctoFiscal)                as DOCUMENTO
	,CTE.CdChaveAcesso                                          as CHAVE
	,CNH.CdRemetente                                            as EMBARCADOR
	,CNH.DtEmissao                                              as DT_EMISSAO
	,(SELECT TOP 1 CAST(CONCAT(FORMAT(d.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(d.hrMovimento,'HH:mm:ss')) as datetime) 
     FROM softran_termaco.dbo.GTCMovEn d WHERE d.CdEmpresa = CNH.CdEmpresa AND d.NrSeqControle = CNH.NrSeqControle AND d.CdOcorrencia = 101	) -- 101 codigo Sênior - "EM TRANSFERENCIA ENTRE FILIAIS"
	                                                            as DT_EMBARQUE
	,(SELECT TOP 1 CAST(CONCAT(FORMAT(d.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(d.hrMovimento,'HH:mm:ss')) as datetime) 
      FROM softran_termaco.dbo.GTCMovEn d WHERE d.CdEmpresa = CNH.CdEmpresa AND d.NrSeqControle = CNH.NrSeqControle AND d.CdOcorrencia = 98	) --  98 codigo Sênior - "CHEGADA NA CIDADE OU FILIAL DESTINO"
	                                                            as DT_CHEGADA
	,CNH.DtEntrega                                              as DT_ENTREGA
	,softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) 
	                                                            as DT_PREVISAO
	,softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) 
	                                                            as DT_PREV_ORIGINAL
	,CNH.CdDestinatario                                         as DESTINATARIO
	,EMP.NRCGCCPF                                               as TRANSPORTADOR

	,CNH.dtdigitacao                                            as DT_UPDATE
	,CNH.CdEmpresa                                              as CdEmpresa
	,CNH.NrSeqControle                                          as NrSeqControle
	,CNH.NrDoctoFiscal                                          as NrDoctoFiscal  
	,0                                                          as FASE_ID
FROM softran_termaco.dbo.gtcconhe  CNH
JOIN softran_termaco.dbo.sisempre  EMP  ON EMP.CdEmpresa   = CNH.CdEmpresa
JOIN softran_termaco.dbo.gtcconce  CTE  ON CTE.CdEmpresa   = CNH.CdEmpresa	 AND CTE.NrSeqControle = CNH.NrSeqControle
LEFT JOIN SIC.dbo.ORION_CTE        OCT  ON OCT.CHAVE       = CTE.CdChaveAcesso

WHERE CNH.InTipoEmissao IN ( 00, 11 , 12 )
     AND ( EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdRemetente   ,1,8) ) OR 
           EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdDestinatario,1,8) ) OR 
           EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdInscricao   ,1,8) ) )
		   
