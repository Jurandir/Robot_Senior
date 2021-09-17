-- 12/09/2021 15:00 - XXX - OCORRENCIAS MANUAIS DIVERSAS - ITRACK

SELECT 
     DF.CHAVE                                              as content_danfe
	,DF.IDCARGA                                            as content_idCargaFk
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataOcorrencia
	,(CASE WHEN CO.OCORRENCIA_ID = 102 THEN 302 ELSE CO.OCORRENCIA_ID END)  -- AVISO DE TRANSBORDO
	                                                       as content_idOcorrenciaPk
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
  AND DF.FASE_ID < 9
  AND CO.OCORRENCIA_ID NOT IN ( 000,001,100,101,89,801,899,999 )  -- CODIGOS (ROBOT AUTOMATICO)
  AND DF.FLAG_COMPROVANTE = 0                                     -- AINDA NÃO FOI CONFIRMADO A IMAGEM DO COMPROVANTE DE ENTREGA NA API (TERMACO)
ORDER BY CO.OCORRENCIA_DATA
