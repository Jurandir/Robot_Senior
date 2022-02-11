-- 12/09/2021 15:00 - XXX - OCORRENCIAS MANUAIS DIVERSAS - ITRACK
-- 11/02/2022 15:36 -  Ajustes ( DePara ) Sênior

SELECT TOP 100
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
  AND DF.FASE_ID < 9
  -- AND CO.OCORRENCIA_ID NOT IN ( 000,001,100,101,89,210,801,899,999 )  -- CODIGOS (ROBOT AUTOMATICO)
  AND CO.OCORRENCIA_ID NOT IN (SELECT DISTINCT X.CdHistoricoRemetente -- Codigo cliente iTrack 
                            FROM softran_termaco.dbo.GTCVHist X
                           WHERE X.CdHistoricoEntrega IN ( 000,001,100,101,89,210,801,899,999 ) -- Codigos Sênior
                             AND X.CdInscricao = DF.BASE_CNPJ ) 
  AND DF.FLAG_COMPROVANTE = 0                                     -- AINDA NÃO FOI CONFIRMADO A IMAGEM DO COMPROVANTE DE ENTREGA NA API (TERMACO)
  AND RESPOSTA_STATUS <> -1  -- ( -1 = API NÃO IRÁ RECEBER, EX: Danfe Invalida. )
ORDER BY CO.OCORRENCIA_DATA


/* 
   (Codigos Sênior)
   CdHistoricoEntrega	
   DsHistoricoEntrega
001	ENTREGA REALIZADA NORMALMENTE
089	AGUARDANDO REFATURAMENTO DAS MERCADORIAS
100	EM ROTA PARA ENTREGA
101	EM TRANSFERENCIA ENTRE FILIAIS
210	MERCADORIA DESCARREGADA NO ARMAZEM DE TRANSBORDO
899	PROCESSO DE TRANSPORTE JA INICIADO
999	BLOQUEADO PELA GERENCIA
*/