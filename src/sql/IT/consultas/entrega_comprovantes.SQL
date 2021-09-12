SELECT TOP 10
    'ENTREGA REALIZADA'                                    as content_observacao
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataInicioEntrega
    ,DF.JSON_COMPROVANTE                                   as content_fotosComprovantes
	,ISNULL(CO.RECEBEDOR_NOME,'COLABORADOR RESPONSAVEL')   as content_nomeRecebedor
    ,DF.CHAVE                                              as content_danfe
	,SUBSTRING(DF.CTRC,5,10)                               as content_nroCte   
	,0                                                     as content_idSucessoMotivo
	,FORMAT(DF.DT_EMISSAO,'yyyy-MM-ddThh:mm:ss-03')        as content_dataEmissaoDanfe
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataFinalizacao
	,ISNULL(CO.RECEBEDOR_DOC,'N.INFO')                     as content_documentoRecebedor
    ,CO.ID                                                 as content_idTrackingCliente
	,TK.TOKEN                                              as token
FROM SIC.dbo.ITRACK_DANFE DF
JOIN SIC.dbo.ITRACK_OCORRENCIA CO ON CO.ITRACK_DANFE_ID = DF.ID
JOIN SIC.dbo.ITRACK_TOKEN      TK ON TK.CNPJ = DF.TRANSPORTADOR
WHERE DF.IDCARGA          > 0
  AND CO.OCORRENCIA_ID    = 999  
  AND CO.FLAG_SEND        = 0
  AND DF.FASE_ID          = 6
  AND DF.FLAG_COMPROVANTE = 1
  AND ISNULL(CO.RESPOSTA_STATUS,0)  <> -1
ORDER BY CO.OCORRENCIA_DATA
