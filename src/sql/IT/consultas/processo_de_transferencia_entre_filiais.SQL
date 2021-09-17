-- 10/09/2021 15:46 - (101) -EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS - SÊNIOR - ITRACK

SELECT TOP 10
     DF.CHAVE                                              as content_danfe
	,DF.IDCARGA                                            as content_idCargaFk
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataOcorrencia
	,302                                                   as content_idOcorrenciaPk
	,ISNULL(CO.OCORRENCIA_OBS,CO.OCORRENCIA_NOME)          as content_descricao
	,CO.ID                                                 as content_idTrackingCliente
	,DF.NUMERO                                             as content_nroNotaFiscal
	,TK.TOKEN                                              as token
	,TK.VALIDO                                             as idResponsavelFk
FROM SIC.dbo.ITRACK_DANFE DF
JOIN SIC.dbo.ITRACK_OCORRENCIA CO ON CO.ITRACK_DANFE_ID = DF.ID
JOIN SIC.dbo.ITRACK_TOKEN      TK ON TK.CNPJ = DF.TRANSPORTADOR
WHERE DF.IDCARGA          > 0
  AND CO.OCORRENCIA_ID    = 101 -- CODIGO SÊNIOR
  AND CO.FLAG_SEND        = 0
  AND DF.FASE_ID          < 9
  AND DF.FLAG_COMPROVANTE = 0
  AND ISNULL(CO.RESPOSTA_STATUS,0)  <> -1
ORDER BY CO.OCORRENCIA_DATA
