// 08/10/2021 16:12 - INICIA PROCESSO - "CONFIRMA FACIL V2"

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs            = require('fs')
const path          = require('path')
const sqlFileName   =  path.join(__dirname, '../../sql/CF2/consultas/montaConfirmaFacil.SQL')
const sqlInitNF     = fs.readFileSync(sqlFileName, "utf8")

const faixa_down = '-15'
const faixa_up   = '+01'

let flag_livre      = true

const initNFs = async () => {
   let sql = `
    --- ( CF2 - initNFs.js ) - BD - CAPTURA NFs - CF V2
    
    INSERT INTO TEST.dbo.CONFIRMAFACIL ( EMBARCADOR,	NUMERO, SERIE,
     CHAVE, DT_EMISSAO, DT_EMBARQUE, DT_CHEGADA, DT_ENTREGA, DT_PREVISAO, DT_PREV_ORIGINAL,
     VALOR, CTRC, DESTINATARIO, TRANSPORTADOR, DT_UPDATE, CdEmpresa, NrSeqControle, FASE_ID, VER_ID )
    ${sqlInitNF}
    WHERE 
         CNH.InTipoEmissao in ( 00, 11 , 12 ) 
     AND CNH.DtEmissao  BETWEEN (CURRENT_TIMESTAMP${faixa_down}) AND (CURRENT_TIMESTAMP${faixa_up})
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
            rotine: 'CF V2 initNFs.js',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initNFs
