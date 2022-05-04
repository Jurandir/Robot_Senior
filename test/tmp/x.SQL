/*
  REPROCESSA ENVIO DE COMPROVANTE - ITRACK
  Para ID 55 em ITRACK_DANFE && ID 5079 em ITRACK_OCORRENCIA
*/

BEGIN
BEGIN TRANSACTION
	UPDATE SIC..ITRACK_DANFE
	SET FASE_ID = 6,
		FLAG_COMPROVANTE = 0
	WHERE ID = 55 -- ID em ITRACK_DANFE   <<<<====== 
	;
	UPDATE SIC..ITRACK_OCORRENCIA
	SET FLAG_SEND = 0
	WHERE ID = 5079 -- ID em ITRACK_OCORRENCIA  <<<<======
COMMIT TRANSACTION
END


SELECT 
     CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.EMBARCADOR                                AS destinatario_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	,CO.OCORRENCIA_ID                             AS ocorrencia_tipoEntrega
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia
	,CO.RECEBEDOR_DOC                             AS ocorrencia_documentoRecebedor
	,CO.RECEBEDOR_NOME                            AS ocorrencia_nomeRecebedor
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME) AS ocorrencia_comentario
    ,CFF.TOKEN                                    AS TOKEN_ID 

FROM SIC..CONFIRMAFACILOCORRENCIA CO
JOIN SIC..CONFIRMAFACIL           CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN SIC..CONFIRMAFACILCLIENTES  CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.ID = 261100