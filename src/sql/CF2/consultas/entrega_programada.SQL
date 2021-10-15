-- 13/10/2021 11:31 -- ENTREGA PROGRAMADA - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021

SELECT TOP 10 -- Limite de 10 linhas por lote de envio na API CF
	 CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
    ,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP 
	      THEN FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy') 
		  ELSE FORMAT(CURRENT_TIMESTAMP ,'dd-MM-yyyy') 
	 END                                          AS ocorrencia_dtOcorrencia
	,CASE WHEN CO.OCORRENCIA_DATA<CURRENT_TIMESTAMP 
	      THEN FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')    
		  ELSE FORMAT(CURRENT_TIMESTAMP ,'HH:mm:ss')  
	 END                                          AS ocorrencia_hrOcorrencia
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME) AS ocorrencia_comentario
	,FORMAT(CF.DT_AGENDAMENTO,'dd-MM-yyyy')       AS ocorrencia_dataAgendamento
	,FORMAT(CF.DT_AGENDAMENTO,'HH:mm:ss')         AS ocorrencia_horaAgendamento
    ,CFF.TOKEN                                    AS TOKEN_ID 

FROM SIC..CONFIRMAFACILOCORRENCIA    CO
JOIN SIC..CONFIRMAFACIL              CF  ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN softran_termaco.dbo.gtcconhe    CNH ON CNH.CdEmpresa   = CF.CdEmpresa   AND CNH.NrSeqControle = CF.NrSeqControle
JOIN SIC..CONFIRMAFACILCLIENTES      CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 91 -- Codigo ConfirmaFacil
  AND CF.DT_AGENDAMENTO IS NOT NULL
  AND CF.FASE_ID < 9

  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA