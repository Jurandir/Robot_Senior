// 08/09/2021 13:52 - INICIA PROCESSO DE MONITORAMENTO (BD)

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs            = require('fs')
const path          = require('path')
const sqlFileName   =  path.join(__dirname, '../../sql/IT/consultas/montaITRACK.SQL')
const sqlInitNF     = fs.readFileSync(sqlFileName, "utf8")

const faixa_down = '-30'
const faixa_up   = '+1'

let flag_livre      = true

const initNFs = async (cli) => {
   let raiz = `${cli.cnpj}`.substr(0,8)
   let sql = `
    INSERT INTO SIC.dbo.ITRACK_DANFE ( EMBARCADOR,	NUMERO, SERIE,
     CHAVE, DT_EMISSAO, DT_EMBARQUE, DT_CHEGADA, DT_ENTREGA, DT_PREVISAO, DT_PREV_ORIGINAL,
     VALOR, CTRC, DESTINATARIO, TRANSPORTADOR, DT_UPDATE, CdEmpresa, NrSeqControle, FASE_ID )
    ${sqlInitNF}
    WHERE 
         -- CNH.InTipoEmissao in ( 00, 11 , 12 )
         ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
     AND ( EXISTS (SELECT 1 FROM SIC.dbo.ITRACK_CLIENTE WHERE RAIZ_CNPJ=SUBSTRING(CNH.CdRemetente,1,8) ) OR 
         EXISTS (SELECT 1 FROM SIC.dbo.ITRACK_CLIENTE WHERE RAIZ_CNPJ=SUBSTRING(CNH.CdDestinatario,1,8) ) OR 
         EXISTS (SELECT 1 FROM SIC.dbo.ITRACK_CLIENTE WHERE RAIZ_CNPJ=SUBSTRING(CNH.CdInscricao,1,8) ) )
     AND CNH.DtEmissao BETWEEN (CURRENT_TIMESTAMP${faixa_down}) AND (CURRENT_TIMESTAMP${faixa_up})
     -- AND CNH.InImpressao = 1
     AND NFR.NrChaveAcessoNFe IS NOT NULL  
     AND CTE.insituacaosefaz = 100
     AND NFE.ID IS NULL
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
            rotine: 'initNFs',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initNFs
