-- 13/10/2021 13:52 - EM ROTA PARA ENTREGA - ("CONFIRMA FACIL V2")

-- TEST

SELECT TOP 10 -- Limite de 10 linhas por lote de envio na API CF
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

FROM TEST..CONFIRMAFACILOCORRENCIA CO
JOIN TEST..CONFIRMAFACIL           CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN TEST..CONFIRMAFACILCLIENTES  CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 110  -- Codigo ConfirmaFacil
  AND CF.FASE_ID < 9
  AND CAST( CO.OCORRENCIA_DATA AS date ) <= CAST( CURRENT_TIMESTAMP AS date ) -- Testa envio apenas apos não está no futuro

  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA