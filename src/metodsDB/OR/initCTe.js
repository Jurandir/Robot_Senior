// 16/09/2021 09:57 - INICIA PROCESSO DE MONITORAMENTO (BD) - "ORION/CEVA"

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs            = require('fs')
const path          = require('path')
const sqlFileName   =  path.join(__dirname, '../../sql/OR/consultas/montaORION.SQL')
const sqlInitCTe    = fs.readFileSync(sqlFileName, "utf8")

const faixa_down = '-30'
const faixa_up   = '+1'

let flag_livre      = true

const initCTe = async () => {
   let sql = `
    INSERT INTO SIC.dbo.ORION_CTE (DOCUMENTO,CHAVE,CHAVEORIGINAL,EMBARCADOR,DT_ATUAL,
                                   DT_EMISSAO,DT_EMBARQUE,DT_CHEGADA,DT_ENTREGA,
                                   DT_PREVISAO,DT_PREV_ORIGINAL,DESTINATARIO,TRANSPORTADOR,
                                   CdEmpresa, NrSeqControle, NrDoctoFiscal, 
                                   FASE_ID)
    ${sqlInitCTe}

    WHERE 
    -- CNH.InTipoEmissao IN ( 00, 11 , 12 )
    ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,13,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
    AND ORI.NrChaveAcessoCTeOrigem  IS NOT NULL
    AND ( EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdRemetente   ,1,8) ) OR 
          EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdDestinatario,1,8) ) OR 
          EXISTS (SELECT 1 FROM SIC.dbo.ORION_CLIENTES WHERE CNPJ_RAIZ=SUBSTRING(CNH.CdInscricao   ,1,8) ) )
     AND CNH.DtEmissao BETWEEN (CURRENT_TIMESTAMP${faixa_down}) AND (CURRENT_TIMESTAMP${faixa_up})
     -- AND CNH.InImpressao = 1
     AND CNH.NrDoctoFiscal IS NOT NULL  
     AND CTE.insituacaosefaz = 100
     AND OCT.CHAVE IS NULL
   `
    if(!flag_livre) { return { success: false, message: 'Processo ocupado !!!' }} 
    flag_livre = false
   
    try {

        result = await sqlExec(sql)         
        flag_livre = true
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'initCTe',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}
module.exports = initCTe
