-- 16/09/2021 15:43 - OCORRÊNCIAS NÃO ENVIADAS - ("ORION/CEVA")

SELECT TOP 5     --- TESTE 5 em 5    
     AC.LOGIN                                       AS "login"
    ,AC.SENHA                                       AS "senha"
    ,CO.CHAVE                                       AS "chave"
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
  AND CO.CdOcorrencia = 899 ---- ( TESTE  899 => "0 PROCEDA" )
  AND ( CO.DT_SEND IS NULL OR DATEDIFF(minute,CO.DT_SEND, CURRENT_TIMESTAMP) > 3) --- depois de 3min da ultima tentativa
ORDER BY 
   CO.CdEmpresa           
  ,CO.NrSeqControle       
  ,CO.CdSequencia         