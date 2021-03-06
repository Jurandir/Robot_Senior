-- 04/10/2021 16:34 - BAIXA ENTREGAS SEM COMPROVANTES ("ITRACK")

SELECT TOP 100 
    'BAIXA REALIZADA'                                      as content_observacao
--	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataInicioEntrega
    ,'[]'                                                  as content_fotosComprovantes
	,ISNULL(CO.RECEBEDOR_NOME,'COLABORADOR RESPONSAVEL')   as content_nomeRecebedor
    ,DF.CHAVE                                              as content_danfe
	,SUBSTRING(DF.CTRC,5,10)                               as content_nroCte   
	,0                                                     as content_idSucessoMotivo
	,FORMAT(DF.DT_EMISSAO,'yyyy-MM-ddThh:mm:ss-03')        as content_dataEmissaoDanfe
	,FORMAT(CO.OCORRENCIA_DATA,'yyyy-MM-ddThh:mm:ss-03')   as content_dataFinalizacao
	,ISNULL(CO.RECEBEDOR_DOC,'N.INFO')                     as content_documentoRecebedor
    ,'99'                                                  as content_motorista_tipoVeiculo
    ,ISNULL(MOT.DsNome,'N.INFO')                           as content_motorista_nome
    ,ISNULL(ROM.NrPlaca,'N.INFO')                          as content_motorista_placaVeiculo
    ,CO.ID                                                 as content_idTrackingCliente
	,DF.IDCARGA                                            as content_idCargaFk
	,TK.TOKEN                                              as token
FROM      SIC.dbo.ITRACK_DANFE          DF
JOIN      SIC.dbo.ITRACK_OCORRENCIA     CO ON CO.ITRACK_DANFE_ID = DF.ID
JOIN      SIC.dbo.ITRACK_TOKEN          TK ON TK.CNPJ = DF.TRANSPORTADOR
LEFT JOIN softran_termaco.dbo.CCERomIt ITR ON  ITR.CdEmpresaColetaEntrega = DF.CdEmpresa AND ITR.NrSeqControle = DF.NrSeqControle AND ITR.InColetaEntrega = 1
LEFT JOIN softran_termaco.dbo.CCERoman ROM ON ROM.CdEmpresa = ITR.CdEmpresa AND ROM.CdRomaneio = ITR.CdRomaneio AND ROM.CdRota = ITR.CdRota
LEFT JOIN softran_termaco.dbo.GTCFunDp MOT ON MOT.NrCPF = ROM.NrCPFMotorista
WHERE DF.IDCARGA          > 0
  AND CO.OCORRENCIA_ID    = 999 
  AND CO.FLAG_SEND        = 0 
  AND DATEDIFF(hour,CO.DT_CREATE, CURRENT_TIMESTAMP) > 26
ORDER BY CO.OCORRENCIA_DATA
