SELECT 
     DF.CHAVE                                              as content_danfe
	,DF.IDCARGA                                            as content_idCargaFk
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataOcorrencia
	,CO.OCORRENCIA_ID                                      as content_idOcorrenciaPk
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME)          as content_descricao
	,CO.ID                                                 as content_idTrackingCliente
	,DF.NUMERO                                             as content_nroNotaFiscal
	,TK.TOKEN                                              as token
	,TK.VALIDO                                             as idResponsavelFk
FROM SIC.dbo.ITRACK_DANFE DF
JOIN SIC.dbo.ITRACK_OCORRENCIA CO ON CO.ITRACK_DANFE_ID = DF.ID
JOIN SIC.dbo.ITRACK_TOKEN      TK ON TK.CNPJ = DF.TRANSPORTADOR
WHERE DF.IDCARGA > 0
  AND CO.FLAG_SEND = 0
  -- AND ( CO.DT_ENVIO IS NULL OR DATEDIFF(minute,CO.DT_ENVIO, CURRENT_TIMESTAMP) > 30)   --- depois de 30min da ultima tentativa
  -- AND ( CO.DT_ENVIO IS NULL OR DATEDIFF(day,CO.DT_ENVIO, CURRENT_TIMESTAMP) < 3 )      --- ATE 3 DIAS
  AND DF.FASE_ID < 9
  AND CO.OCORRENCIA_ID NOT IN ( 000,001,110,128,801,899,999 )     -- CODIGOS "CONFIRMAFACIL" (ROBOT AUTOMATICO)
  AND CF.FLAG_COMPROVANTE = 0                                     -- AINDA NÃO FOI CONFIRMADO A IMAGEM DO COMPROVANTE DE ENTREGA NA API (TERMACO)
ORDER BY CO.OCORRENCIA_DATA
