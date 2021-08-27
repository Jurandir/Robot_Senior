-- PROCESSO DE TRANSPORTE INICIADO
SELECT TOP 10
    -- ROW_NUMBER() OVER(ORDER BY CO.DT_CREATE ASC) AS Row#,
	CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	--,FORMAT(CF.DT_EMISSAO,'dd-MM-yyyy')           AS embarque_dtEmissao,
	--,FORMAT(CF.DT_PREVISAO,'dd-MM-yyyy')          AS embarque_dtPrevisao,
	--,FORMAT(CF.DT_PREV_ORIGINAL,'dd-MM-yyyy')     AS embarque_dtPrevisaoDestinatario,
	--,CF.VALOR                                     AS embarque_valor,
	--,'convencional'                               AS embarque_tipoEnvio,
	,CF.EMBARCADOR                                AS embarcador_cnpj
	--,DE.NOME                                      AS destinatario_nome,
	--,CF.EMBARCADOR                                AS destinatario_cnpj,
	--,DE.EMAIL                                     AS destinatario_email,
	--,DE.CEP                                       AS destinatario_endereco_cep,
	--,CD.UF                                        AS destinatario_endereco_uf,
	--,CD.NOME                                      AS destinatario_endereco_cidade,
	--,CONCAT(DE.BAIRRO,', ',DE.ENDERECO)           AS destinatario_endereco_logradouro,
	--,DE.NUMERO                                    AS destinatario_endereco_numero,
	--,DE.LATITUDE                                  AS destinatario_endereco_latitude,
	--,DE.LONGITUDE                                 AS destinatario_endereco_longitude,
	--,CONCAT('TERMACO - ',SUBSTRING(CF.CTRC,1,3))  AS transportadora_nome,
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	--,CF.CTRC                                      AS pedido_numero,
	,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	--,CO.OCORRENCIA_NOME                           AS ocorrencia_descricaoTipoEntrega,
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia
	,CONCAT('VIA CTRC: ',CF.CTRC)                 AS ocorrencia_comentario
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
JOIN SIC.dbo.CONFIRMAFACIL           CF ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN CARGASSQL.dbo.CLI               DE ON CF.DESTINATARIO = DE.CGCCPF 
JOIN CARGASSQL.dbo.CID               CD ON CD.CODIGO       = DE.CID_CODIGO 
WHERE CO.FLAG_SEND = 0
  AND CO.OCORRENCIA_ID = 0
  AND CF.FASE_ID < 9


