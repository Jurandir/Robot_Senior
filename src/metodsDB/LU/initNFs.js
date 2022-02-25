//-- Inicia Nfs ( 25/02/2022 14:49 ) - Lupe-ON - V.01 - By: Jurandir Ferreira

const sqlExec       = require('../../connection/sqlExSENIOR')

const fs            = require('fs')
const path          = require('path')
const sqlFileName   =  path.join(__dirname, '../../sql/LU/consultas/monta_LupeOn.SQL')
const sqlInitNF     = fs.readFileSync(sqlFileName, "utf8")

const faixa_down = '-999'
const faixa_up   = '+001'

let flag_livre      = true

const initNFs = async () => {
   let sql = `
    --- ( LU - initNFs.js ) - BD - CAPTURA NFs
    
    INSERT INTO SIC..LUPEON_NFE ( EMBARCADOR,	NUMERO, SERIE,
     CHAVE, DT_EMISSAO, DT_EMBARQUE, DT_CHEGADA, DT_ENTREGA, DT_PREVISAO, DT_PREV_ORIGINAL,
     VALOR, CTRC, DESTINATARIO, TRANSPORTADOR, DT_UPDATE, CdEmpresa, NrSeqControle, FASE_ID, VER_ID, BASE_CNPJ )
    ${sqlInitNF}
    WHERE 
         ( CNH.InTipoEmissao in (00,01,02,03,09,11,12,13,14) or ( CNH.InTipoEmissao = 05 and CNH.InTpCTE = 00) )
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
            rotine: 'LU initNFs.js',
            sql: sql,
            err: err
        }
        flag_livre = true
        return Erro
    } 

}

module.exports = initNFs
