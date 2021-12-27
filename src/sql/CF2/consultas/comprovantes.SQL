-- 13/10/2021 17:22 - COMPROVANTE DE ENTREGA, LINKS - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021

SELECT TOP 10 -- Limite de 10 linhas por lote de envio na API CF 
	 CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.EMBARCADOR                                AS destinatario_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,CO.OCORRENCIA_NOME                           AS ocorrencia_descricaoTipoEntrega
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia       
    ,CONCAT('ENTREGUE EM ',FORMAT(CF.DT_ENTREGA,'dd-MM-yyyy'),' / ',ISNULL(CO.RECEBEDOR_NOME,'CONFORME COMPROVANTE.' ))
                                                  AS ocorrencia_comentario
	,JSON_COMPROVANTE                             AS ocorrencia_fotos
    ,CFF.TOKEN                                    AS TOKEN_ID 

FROM SIC..CONFIRMAFACILOCORRENCIA CO
JOIN SIC..CONFIRMAFACIL           CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN SIC..CONFIRMAFACILCLIENTES  CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )
WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 999  -- Codigo ConfirmaFacil
  AND CF.FASE_ID < 9
  AND CF.FLAG_COMPROVANTE = 1 -- A API (TERMACO) CONFIRMOU QUE EXISTE IMAGEM DO COMPROVANTE
  AND (CHARINDEX('.jpg', JSON_COMPROVANTE) > 0 OR CHARINDEX('.jpeg', JSON_COMPROVANTE) > 0 ) -- CF SÓ ACEITA ( JPG OU JPEG )

  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA
