-- 27/09/2021 13:24 - COMPROVANTES NÃO ENVIADOS - ("ORION/CEVA")

SELECT  TOP 150
     AC.LOGIN                                       AS "login"
    ,AC.SENHA                                       AS "senha"
    ,CO.CHAVEORIGINAL                               AS "chave"
    ,'1'                                            AS "tipoImagem"
	  ,''                                             AS "imagem"
    ,CO.REPLICAR                                    AS "replicar"
    ,CO.ID                                          AS "REFID"
    ,CO.DOCUMENTO                                   AS "CTRC" 
FROM SIC.dbo.ORION_OCORRENCIAS CO
JOIN SIC.dbo.ORION_ACESSO      AC ON AC.ID=1
WHERE CO.FLAG_SEND = 0
  AND ISnull(CO.RESPOSTA_STATUS,0) <> -1
  AND ISnull(CO.RESPOSTA_STATUS,0) < 1000 -- TENTATIVAS DE ENVIO
  AND CO.CdOcorrencia = 999
  AND ( CO.DT_SEND IS NULL OR DATEDIFF(minute,CO.DT_SEND, CURRENT_TIMESTAMP) > 5) --- depois de 5min da ultima tentativa
  AND EXISTS(SELECT 1 FROM softran_termaco.dbo.GTCMVEDG c WHERE c.CdEmpresa = CO.CdEmpresa AND c.NrSeqControle = CO.NrSeqControle ) -- Comprovante de Entrega baixado pelo RMS
ORDER BY 
   CO.CdEmpresa           
  ,CO.NrSeqControle       
  ,CO.CdSequencia   
