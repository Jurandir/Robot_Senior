// 02/09/2021 16:07 - ENVIA DADOS PROCESSADOS PARA API CONFIRMAFACIL

const sqlQuery      = require('../connection/sqlSENIOR')
const montaJSON     = require('./montaJSON')
const embarque      = require('../metodsAPI/CF/embarque')
const updFlagsEnvio = require('../metodsDB/CF/updFlagsEnvio')
const updFlagsErros = require('../metodsDB/CF/updFlagsErros')

const enviaDadosAPI_CF = async (cfg,cli,base,sql) => {
    let resposta = { success: false, rowsAffected: 0 }
    let ROWS = 0
    let LIST = 0
    let EMBARQUE = {success: false}
    let UPDATE   = {success: false, rowsAffected: 0}

    try {
        ROWS      = await sqlQuery( sql )
        LIST      = ROWS.length >0   ? await montaJSON( ROWS, base )    : []
        EMBARQUE  = LIST.length >0   ? await embarque( cfg, cli, LIST ) : {success: false, message:'Sem dados para enviar.' ,rowsAffected: ROWS.length } 
        UPDATE    = EMBARQUE.success ? await updFlagsEnvio( ROWS, EMBARQUE ) : await updFlagsErros( ROWS, EMBARQUE )
               
        let msg = `Query:${ROWS.length} JSON:${LIST.length} API:${EMBARQUE.success} Flag:${UPDATE.success}`

        resposta  = { success: UPDATE.success, message: msg,  rowsAffected: UPDATE.rowsAffected , embarque: EMBARQUE }

    } catch (err) {
        resposta = { success: false, message: err.message, rowsAffected:-1 }
    }    
    return resposta
}

module.exports = enviaDadosAPI_CF