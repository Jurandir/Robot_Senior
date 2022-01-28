-- 14/10/2021 17:23 -  CONHECIMENTO DE TRANSPORTE RETIDO - ("CONFIRMA FACIL V2")

-- PROD-15/10/2021

SELECT TOP 10 -- Limite de 10 linhas por lote de envio na API CF
     CO.ID                                        AS FLAG_ID
	,CF.NUMERO                                    AS embarque_numero
	,CF.SERIE                                     AS embarque_serie
	,CF.CHAVE                                     AS embarque_chave
	,CF.EMBARCADOR                                AS embarcador_cnpj
	,CF.EMBARCADOR                                AS destinatario_cnpj
	,CF.TRANSPORTADOR                             AS transportadora_cnpj
	,001                                          AS ocorrencia_tipoEntrega
	,FORMAT(CO.OCORRENCIA_DATA,'dd-MM-yyyy')      AS ocorrencia_dtOcorrencia
	,FORMAT(CO.OCORRENCIA_DATA,'HH:mm:ss')        AS ocorrencia_hrOcorrencia
	,CO.RECEBEDOR_DOC                             AS ocorrencia_documentoRecebedor
	,CO.RECEBEDOR_NOME                            AS ocorrencia_nomeRecebedor
	,'CONHECIMENTO DE TRANSPORTE RETIDO'          AS ocorrencia_comentario
    ,CFF.TOKEN                                    AS TOKEN_ID 

FROM SIC..CONFIRMAFACILOCORRENCIA CO
JOIN SIC..CONFIRMAFACIL           CF ON CF.ID          = CO.CONFIRMAFACIL_ID
JOIN SIC..CONFIRMAFACILCLIENTES  CFF ON CFF.FLAG_ATIVO = 1 AND
                                          (( CFF.RAIZ = SUBSTRING(CF.EMBARCADOR,1,8)  ) OR 
                                          (  CFF.RAIZ = SUBSTRING(CF.DESTINATARIO,1,8) ) )

WHERE CO.FLAG_SEND                   in (1,2)    -- 1 = Já enviado (119), 2 = tentou enviar e deu erro
--  AND CO.OCORRENCIA_ID               = 119  -- Codigo ConfirmaFacil
  AND CO.OCORRENCIA_ID = (SELECT TOP 1 X.CdHistoricoRemetente -- Codigo ConfirmaFacil 
                            FROM softran_termaco.dbo.GTCVHist X
                            JOIN SIC..CONFIRMAFACILCLIENTES   C ON C.CNPJ = X.CdInscricao
                           WHERE X.CdHistoricoEntrega in ( 84,119 ) -- ENTREGA RETIDA PARA CONFERENCIA
                             AND C.RAIZ = CFF.RAIZ )  

  AND ISNULL(CO.OCORRENCIA_OBS,'*') <> 'ENTREGA REALIZADA'
  AND CF.FASE_ID                     < 9
  AND NOT EXISTS (SELECT 1 FROM SIC..CONFIRMAFACILOCORRENCIA ENT 
                   WHERE ENT.CONFIRMAFACIL_ID = CO.CONFIRMAFACIL_ID 
				     AND ENT.OCORRENCIA_ID=1)
  
  AND CFF.DT_VALIDADE  > CURRENT_TIMESTAMP   -- TOKEN valido
  AND CFF.RAIZ = '${raiz}'
  AND ISNULL(CO.OCORRENCIA_OBS,'*') <> 'TENTATIVA DE ENVIO OCORRÊNCIA (01) P/ API'

ORDER BY CFF.RAIZ,CO.OCORRENCIA_DATA
