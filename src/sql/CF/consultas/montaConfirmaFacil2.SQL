SELECT DISTINCT  
	SUBSTRING(isnull(NFR.CLI_CGCCPF_REMET,'')+CNH.CLI_CGCCPF_REMET,1,14) as EMBARCADOR,
	RIGHT(REPLICATE('0',7) + CAST(NFR.NF AS VARCHAR),7)       as NUMERO,
	NFR.SERIE                                                 as SERIE,
	NFR.CHAVENFE                                              as CHAVE,
	NFR.DATA                                                  as DT_EMISSAO,
	CNH.DATAEMBARQUE                                          as DT_EMBARQUE,
    CNH.DATACHEGADA                                           as DT_CHEGADA,
	CNH.DATAENTREGA                                           as DT_ENTREGA,
	CNH.PREVENTREGA                                           as DT_PREVISAO,
	CNH.PREVENTREGA_ORIGINAL                                  as DT_PREV_ORIGINAL,
	NFR.VALOR                                                 as VALOR,
	CONCAT(CNH.EMP_CODIGO,CNH.SERIE,CNH.CTRC)                 as CTRC,
	CNH.CLI_CGCCPF_DEST                                       as DESTINATARIO,
	EMP.CGC                                                   as TRANSPORTADOR,
	CNH.DATATU                                                as DT_UPDATE,
	0                                                         as FASE_ID
FROM SIC.dbo.CONFIRMAFACIL CF
    JOIN CARGASSQL.dbo.CNH               ON CNH.EMP_CODIGO = SUBSTRING(CF.CTRC,1,3) AND 
	                                        CNH.SERIE      = SUBSTRING(CF.CTRC,4,1)	AND 
											CNH.CTRC       = SUBSTRING(CF.CTRC,5,103)

    JOIN CARGASSQL.dbo.NFR               ON NFR.EMP_CODIGO     = CNH.EMP_CODIGO	AND 
	                                        NFR.CNH_SERIE      = CNH.SERIE	AND 
											NFR.CNH_CTRC       = CNH.CTRC 

    JOIN CARGASSQL.dbo.EMP               ON EMP.CODIGO = CNH.EMP_CODIGO
    JOIN CARGASSQL.dbo.CTE               ON CTE.EMP_CODIGO_CNH = CNH.EMP_CODIGO	AND 
	                                        CTE.CNH_SERIE      = CNH.SERIE	AND 
											CTE.CNH_CTRC       = CNH.CTRC
