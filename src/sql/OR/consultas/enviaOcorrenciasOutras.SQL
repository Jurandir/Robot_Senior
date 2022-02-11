-- 23/09/2021 16:27 - OUTRAS OCORRÊNCIAS NÃO ENVIADAS - ("ORION/CEVA")

SELECT TOP 100
     AC.LOGIN                                       AS "login"
    ,AC.SENHA                                       AS "senha"
    ,CO.CHAVEORIGINAL                               AS "chave"
    ,CO.OCORRCASUAL                                 AS "ocorrCasual"
    ,CO.OCORRTRANSPORTE                             AS "ocorrTransporte"
    ,FORMAT(CO.DT_OCORRENCIA,'dd/MM/yyyy HH:mm:ss') AS "dataOcorr"
    ,CO.REPLICAR                                    AS "replicar"
    ,CO.LATITUDE                                    AS "latitude"
    ,CO.LONGITUDE                                   AS "longitude"
    ,CO.OBSERVACAO                                  AS "observacao"
    ,CO.ID                                          AS "REFID"
FROM SIC.dbo.ORION_OCORRENCIAS CO
JOIN SIC.dbo.ORION_ACESSO      AC ON AC.ID=1
WHERE CO.FLAG_SEND = 0
  AND ISnull(CO.RESPOSTA_STATUS,0) <> -1
  AND CO.CdOcorrencia NOT IN (899,0,999)
  AND EXISTS ( SELECT 1 FROM SIC.dbo.ORION_OCORRENCIAS A WHERE A.CdOcorrencia in (899,0) AND A.FLAG_SEND = 1 AND A.DOCUMENTO = CO.DOCUMENTO )
  AND ( CO.DT_SEND IS NULL OR DATEDIFF(minute,CO.DT_SEND, CURRENT_TIMESTAMP) > 5) --- depois de 5min da ultima tentativa
ORDER BY 
   CO.CdEmpresa           
  ,CO.NrSeqControle       
  ,CO.CdSequencia        