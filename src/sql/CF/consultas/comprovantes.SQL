-- COMPROVANTE DE ENTREGA
SELECT TOP 10
    -- ROW_NUMBER() OVER(ORDER BY CO.DT_CREATE ASC) AS Row#,
	CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
--	,DE.NOME                                      AS destinatario_nome
	,CF.EMBARCADOR                                AS destinatario_cnpj
--	,CONCAT('TERMACO - ',SUBSTRING(CF.CTRC,1,3))  AS transportadora_nome
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,CO.OCORRENCIA_NOME                           AS ocorrencia_descricaoTipoEntrega
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia       
	-- ,CONCAT('ENTREGUE EM ',FORMAT(CF.DT_ENTREGA,'dd-MM-yyyy'),' E RECEBIDO POR ',CO.RECEBEDOR_NOME ),
    ,CONCAT('ENTREGUE EM ',FORMAT(CF.DT_ENTREGA,'dd-MM-yyyy'),' / ',ISNULL(CO.RECEBEDOR_NOME,'CONFORME COMPROVANTE.' ))
                                                 AS ocorrencia_comentario
	,CONCAT('${server}/Img_',CF.CTRC,'.png')     AS ocorrencia_fotos
FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO
JOIN SIC.dbo.CONFIRMAFACIL           CF ON CF.ID           = CO.CONFIRMAFACIL_ID
JOIN CARGASSQL.dbo.CLI               DE ON CF.DESTINATARIO = DE.CGCCPF 
WHERE CO.FLAG_SEND = 0
  AND CO.OCORRENCIA_ID = 999
  AND CF.FASE_ID < 9
  AND CF.FLAG_COMPROVANTE = 1 -- A API (TERMACO) CONFIRMOU QUE EXISTE IMAGEM DO COMPROVANTE
