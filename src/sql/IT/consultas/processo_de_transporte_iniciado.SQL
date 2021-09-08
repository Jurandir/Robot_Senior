-- 08/09/2021 14:49 - PROCESSO DE TRANSPORTE INICIADO - ITRACK

SELECT TOP 10
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
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
JOIN SIC.dbo.CONFIRMAFACIL           CF ON CF.ID           = CO.CONFIRMAFACIL_ID
WHERE CO.FLAG_SEND = 0
  AND CO.OCORRENCIA_ID = 0   -- codigo na ConfirmaFacil
  AND CF.FASE_ID < 9