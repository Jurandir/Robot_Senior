-- 03/09/2021 09:19 -- ENTREGA PROGRAMADA

SELECT TOP 10
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
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA  CO
JOIN SIC.dbo.CONFIRMAFACIL            CF  ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN softran_termaco.dbo.gtcconhe     CNH ON CNH.CdEmpresa   = CF.CdEmpresa   AND CNH.NrSeqControle = CF.NrSeqControle
WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 91 -- Codigo ConfirmaFacil
  AND CF.DT_AGENDAMENTO IS NOT NULL
  AND CF.FASE_ID < 9
