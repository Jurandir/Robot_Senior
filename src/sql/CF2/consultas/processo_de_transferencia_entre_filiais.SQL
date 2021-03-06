-- 11/10/2021 16:20 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS -- ("CONFIRMA FACIL V2")

-- PROD-15/10/2021
-- Ajuste (DePara Sênior) - 28/01/2022

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

FROM SIC..CONFIRMAFACILOCORRENCIA  CO
JOIN SIC..CONFIRMAFACIL            CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN SIC..CONFIRMAFACILCLIENTES   CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND = 0
  -- AND CO.OCORRENCIA_ID = 128  -- codigo na ConfirmaFacil
    AND CO.OCORRENCIA_ID IN (SELECT DISTINCT X.CdHistoricoRemetente -- Codigo ConfirmaFacil 
                            FROM softran_termaco.dbo.GTCVHist X
                            JOIN SIC..CONFIRMAFACILCLIENTES   C ON C.CNPJ = X.CdInscricao
                           WHERE X.CdHistoricoEntrega IN (128,101,102) -- EM TRANSFERENCIA ENTRE FILIAIS / CHEGADA NA FILIAL DE TRANSBORDO
                             AND C.RAIZ = CFF.RAIZ )							 
  AND CF.FASE_ID < 9

  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA
