-- 03/09/2021 17:37 - COMPROVANTE DE ENTREGA

SELECT TOP 1 -- 10
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
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
JOIN SIC.dbo.CONFIRMAFACIL           CF ON CF.ID           = CO.CONFIRMAFACIL_ID
WHERE CO.FLAG_SEND     = 0
  AND CO.OCORRENCIA_ID = 999  -- Codigo ConfirmaFacil
  AND CF.FASE_ID < 9
  AND CF.FLAG_COMPROVANTE = 1 -- A API (TERMACO) CONFIRMOU QUE EXISTE IMAGEM DO COMPROVANTE
