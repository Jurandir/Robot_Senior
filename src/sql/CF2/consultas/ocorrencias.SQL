-- 13/10/2021 14:31 -- OCORRÊNCIAS MANUAIS - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste (DePara Sênior) - 28/01/2022

SELECT TOP 10 -- Limite de 10 linhas por lote de envio na API CF
	 CO.ID                                         AS FLAG_ID
	,CF.NUMERO                                     AS embarque_numero
	,CF.SERIE                                      AS embarque_serie
	,CF.CHAVE                                      AS embarque_chave
	,CF.EMBARCADOR                                 AS embarcador_cnpj
	,CF.TRANSPORTADOR                              AS transportadora_cnpj
	,CO.OCORRENCIA_ID                              AS ocorrencia_tipoEntrega
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP 
	      THEN FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy') ELSE FORMAT(CURRENT_TIMESTAMP ,'dd-MM-yyyy') END 
	                                               AS ocorrencia_dtOcorrencia
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP 
	      THEN FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss') ELSE FORMAT(CURRENT_TIMESTAMP ,'HH:mm:ss') END 
	                                               AS ocorrencia_hrOcorrencia
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME)  AS ocorrencia_comentario
	,CASE WHEN CO.OCORRENCIA_ID=(SELECT TOP 1 X.CdHistoricoRemetente 
                                   FROM softran_termaco.dbo.GTCVHist X
                                  WHERE X.CdHistoricoEntrega = 91 and X.CdInscricao = CF.BASE_CNPJ)  -- ENTREGA PROGRAMADA
	      THEN FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) ,'dd-MM-yyyy') 
		  ELSE NULL END                            AS ocorrencia_dataAgendamento
	,CASE WHEN CO.OCORRENCIA_ID=(SELECT TOP 1 X.CdHistoricoRemetente 
                                   FROM softran_termaco.dbo.GTCVHist X
                                  WHERE X.CdHistoricoEntrega = 91 and X.CdInscricao = CF.BASE_CNPJ) -- ENTREGA PROGRAMADA
	      THEN FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole),'HH:mm:ss') 
		  ELSE NULL END                            AS ocorrencia_horaAgendamento
    ,CFF.TOKEN                                     AS TOKEN_ID 

FROM SIC..CONFIRMAFACILOCORRENCIA   CO
JOIN SIC..CONFIRMAFACIL             CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN softran_termaco.dbo.gtcconhe  CNH ON CNH.CdEmpresa  = CF.CdEmpresa   AND CNH.NrSeqControle = CF.NrSeqControle
JOIN SIC..CONFIRMAFACILCLIENTES    CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND = 0
  
  AND CO.OCORRENCIA_ID NOT IN ( 999 ) -- CODIGOS CONFIRMAFACIL (ROBOT AUTOMATICO)
  AND CO.OCORRENCIA_ID NOT IN
  (SELECT TOP 1 X.CdHistoricoRemetente -- Codigo ConfirmaFacil 
                            FROM softran_termaco.dbo.GTCVHist X
                            JOIN SIC..CONFIRMAFACILCLIENTES   C ON C.CNPJ = X.CdInscricao
                           WHERE X.CdHistoricoEntrega in ( 0,1,91,84,89,101,102,110,128,119,899,999 ) 
                             AND C.RAIZ = CFF.RAIZ )  
  AND CF.FASE_ID < 9
  AND CF.FLAG_COMPROVANTE = 0 -- AINDA NÃO FOI CONFIRMADO A IMAGEM DO COMPROVANTE DE ENTREGA NA API (TERMACO)

  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA

/*
 
 (softran_termaco..GTCHisEn)

1	ENTREGA REALIZADA NORMALMENTE
84	ENTREGA RETIDA PARA CONFERENCIA
89	AGUARDANDO REFATURAMENTO DAS MERCADORIAS
91	ENTREGA PROGRAMADA
101	EM TRANSFERENCIA ENTRE FILIAIS
102	CHEGADA NA FILIAL DE TRANSBORDO
110	ICMS LIBERADO
119	CRIACAO
128	CRIACAO
899	PROCESSO DE TRANSPORTE JA INICIADO
999	BLOQUEADO PELA GERENCIA

*/