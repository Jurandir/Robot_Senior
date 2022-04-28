const sqlQuery      = require('../../connection/sqlSENIOR')

const listSendComprovantes = async () => {
    let sql = `
    SELECT TOP 50
                 oc.ID
    ,            nfe.EMBARCADOR
    ,            cli.NOME AS EMBARCADOR_NOME
    ,            nfe.NUMERO 
    ,            nfe.SERIE 
    ,            nfe.CHAVE 
    ,            nfe.TRANSPORTADOR 
    ,            oc.OCORRENCIA_NOME
    ,            CONCAT(FORMAT( oc.OCORRENCIA_DATA,'yyyy-MM-dd'),' ', FORMAT(oc.OCORRENCIA_DATA,'HH:mm:ss') ) AS OCORRENCIA_DATA
    ,            nfe.CTRC 
	,            tkn.ID AS CompanyId
	,            tkn.TOKEN    
    FROM  SIC..LUPEON_OCORRENCIA oc
    JOIN  SIC..LUPEON_NFE     nfe ON nfe.ID   = oc.LUPEON_ID
    JOIN  SIC..LUPEON_CLIENTE cli ON cli.CNPJ = nfe.EMBARCADOR
    JOIN  SIC..LUPEON_TOKEN   tkn ON tkn.ID   = 373
    WHERE oc.OCORRENCIA_ID = 999
      AND nfe.FASE_ID = 6
      AND oc.FLAG_SEND IN (0,2)
      AND DATEDIFF(day,OCORRENCIA_DATA, CURRENT_TIMESTAMP) <= 60  -- Pesquisa durante 60 dias
    `
    let ret = await sqlQuery(sql)
    return ret    
}

module.exports = listSendComprovantes