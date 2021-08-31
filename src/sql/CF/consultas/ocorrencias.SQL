-- 31/08/2021 14:39 -- OCORRÊNCIAS MANUAIS
SELECT TOP 10
	 CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
    ,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP THEN FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy') 
	                                                ELSE FORMAT(CURRENT_TIMESTAMP ,'dd-MM-yyyy')  END 
	                                             AS ocorrencia_dtOcorrencia
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP THEN FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss') 
	                                                ELSE FORMAT(CURRENT_TIMESTAMP ,'HH:mm:ss')  END 
	                                             AS ocorrencia_hrOcorrencia
    ,CO.OCORRENCIA_OBS                           AS ocorrencia_comentario
	,CASE WHEN CO.OCORRENCIA_ID=91  -- ENTREGA PROGRAMADA
	      THEN FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole) ,'dd-MM-yyyy') ELSE NULL END 
	                                             AS ocorrencia_dataAgendamento
	,CASE WHEN CO.OCORRENCIA_ID=91  -- ENTREGA PROGRAMADA
	      THEN FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(CNH.DtEmissao, CNH.CdEmpresaDestino, CNH.CdPercurso, CNH.CdTransporte, CNH.CdRemetente, CNH.CdDestinatario, CNH.cdempresa, CNH.nrseqcontrole),'HH:mm:ss') ELSE NULL END 
                                                 AS ocorrencia_horaAgendamento
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA  CO
JOIN SIC.dbo.CONFIRMAFACIL            CF  ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN softran_termaco.dbo.gtcconhe     CNH ON CNH.CdEmpresa   = CF.CdEmpresa   AND CNH.NrSeqControle = CF.NrSeqControle
WHERE CO.FLAG_SEND = 0
  AND CO.OCORRENCIA_ID NOT IN ( 000,001,110,128,801,999 )
  AND CF.FASE_ID < 9
  AND CF.FLAG_COMPROVANTE = 0 -- AINDA NÃO FOI CONFIRMADO A IMAGEM DO COMPROVANTE DE ENTREGA NA API (TERMACO)
