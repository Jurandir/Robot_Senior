-- 11/10/2021 13:10 - PROCESSO DE TRANSPORTE INICIADO - ("Confirma Facil V2")

-- PROD-15/10/2021

SELECT TOP 10 -- tem que ser no maximo 10, porque a API da CF somente aceita no maximo 10 ocorrencias por envio
     CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME) AS ocorrencia_comentario
	,CFF.TOKEN                                    AS TOKEN_ID 
FROM SIC..CONFIRMAFACILOCORRENCIA CO
JOIN SIC..CONFIRMAFACIL           CF  ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN SIC..CONFIRMAFACILCLIENTES   CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 0                   -- codigo na ConfirmaFacil
  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CF.FASE_ID       < 9
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA
