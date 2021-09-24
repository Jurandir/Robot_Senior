--- ORION
select OBSERVACAO,SUM(FLAG_SEND) send ,SUM((FLAG_SEND-1)*-1) notSend,count(*) total
from ORION_OCORRENCIAS
group by OBSERVACAO
