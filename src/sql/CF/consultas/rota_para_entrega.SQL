-- EM ROTA PARA ENTREGA
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
	,CONCAT('A CAMINHO, DESTINATÁRIO EM : ',CD.NOME,' ',CD.UF) AS ocorrencia_comentario
	--,CF.CTRC                                      AS trecho_ordem,
	--,FORMAT(CF.DT_EMBARQUE,'dd-MM-yyyy')          AS trecho_dtInicio,
	--,FORMAT(CF.DT_CHEGADA,'dd-MM-yyyy')           AS trecho_dtFim,
	--,FORMAT(CF.DT_PREVISAO,'dd-MM-yyyy')          AS trecho_dtPrevisao,
	--,FO.CEP                                       AS trecho_enderecoOrigem_cep,
	--,CFO.UF                                       AS trecho_enderecoOrigem_uf,
	--,CFO.NOME                                     AS trecho_enderecoOrigem_cidade,
	--,CONCAT(FO.BAIRRO,', ',FO.ENDERECO)           AS trecho_enderecoOrigem_logradouro,
	--,FO.NUMERO                                    AS trecho_enderecoOrigem_numero,
	--,FO.LATITUDE                                  AS trecho_enderecoOrigem_latitude,
	--,FO.LONGITUDE                                 AS trecho_enderecoOrigem_longitude,
	--,FD.CEP                                       AS trecho_enderecoDestino_cep,
	--,CFD.UF                                       AS trecho_enderecoDestino_uf,
	--,CFD.NOME                                     AS trecho_enderecoDestino_cidade,
	--,CONCAT(FD.BAIRRO,', ',FD.ENDERECO)           AS trecho_enderecoDestino_logradouro,
	--,FD.NUMERO                                    AS trecho_enderecoDestino_numero,
	--,FD.LATITUDE                                  AS trecho_enderecoDestino_latitude,
	--,FD.LONGITUDE                                 AS trecho_enderecoDestino_longitude,
	--,CONCAT('TERMACO - ',SUBSTRING(CF.CTRC,1,3))  AS trecho_transportadora_nome,
	--,CF.TRANSPORTADOR                             AS trecho_transportadora_cnpj

FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
JOIN SIC.dbo.CONFIRMAFACIL CF ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN CARGASSQL.dbo.CLI     DE ON CF.DESTINATARIO = DE.CGCCPF 
JOIN CARGASSQL.dbo.CID     CD ON CD.CODIGO       = DE.CID_CODIGO
JOIN CARGASSQL.DBO.CNH        ON CNH.EMP_CODIGO  = SUBSTRING(CF.CTRC,1,3) AND CNH.SERIE=SUBSTRING(CF.CTRC,4,1)  AND CNH.CTRC=SUBSTRING(CF.CTRC,5,10)
JOIN CARGASSQL.DBO.TRE        ON TRE.CODIGO      = CNH.TRE_CODIGO
JOIN CARGASSQL.DBO.EMP     FO ON FO.CODIGO       = TRE.EMP_CODIGO_COLETA
JOIN CARGASSQL.DBO.EMP     FD ON FD.CODIGO       = TRE.EMP_CODIGO_ENTREGA
JOIN CARGASSQL.dbo.CID    CFO ON CFO.CODIGO      = FO.CID_CODIGO
JOIN CARGASSQL.dbo.CID    CFD ON CFD.CODIGO      = FD.CID_CODIGO

WHERE CO.FLAG_SEND = 0
  AND CO.OCORRENCIA_ID = 110
  AND CF.FASE_ID < 9
  AND CAST( CO.OCORRENCIA_DATA AS date ) <= CAST( CURRENT_TIMESTAMP AS date ) -- Testa envio apenas apos não está no futuro

