-- 12/09/2021 15:25 - FINALIZA MONITORAMENTO - ITRACK

UPDATE IT
   SET IT.FASE_ID = 9
     , IT.DT_UPDATE = CURRENT_TIMESTAMP
     , IT.DT_ENVIO  = (SELECT DT_SEND FROM SIC.dbo.ITRACK_OCORRENCIA CO WHERE CO.ITRACK_DANFE_ID = IT.ID AND CO.OCORRENCIA_ID=999 AND CO.FLAG_SEND=1)
FROM SIC.dbo.ITRACK_DANFE IT
WHERE FASE_ID = 6
-- AND FLAG_COMPROVANTE = 1 
AND EXISTS (SELECT 1 FROM SIC.dbo.ITRACK_OCORRENCIA CO 
                WHERE CO.ITRACK_DANFE_ID = IT.ID AND CO.OCORRENCIA_ID=999 AND CO.FLAG_SEND=1)
