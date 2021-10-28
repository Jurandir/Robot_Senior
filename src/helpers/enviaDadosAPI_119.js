// 15/10/2021 09:23 - ENVIA DADOS PROCESSADOS PARA API (119) - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment        = require('moment')
const sqlQuery      = require('../connection/sqlSENIOR')
const montaJSON     = require('./montaJSON')
const embarque      = require('../metodsAPI/CF2/embarque')
const updFlagsEnvio = require('../metodsDB/CF2/updFlagsEnvio_119')
const updFlagsErros = require('../metodsDB/CF2/updFlagsErros_119')

const enviaDadosAPI_119 = async (cli,base,sql,debug) => {
    let resposta = { success: false, rowsAffected: 0 }
    let ROWS = []
    let LIST = []
    let EMBARQUE = {success: false}
    let UPDATE   = {success: false, rowsAffected: 0}

    try {
        ROWS      = await sqlQuery( sql )

        LIST      = ROWS.length >0   ? await montaJSON( ROWS, base )    : []

        EMBARQUE  = LIST.length >0   ? await embarque( LIST,cli ) : {success: false, message:'Sem dados para enviar.' ,rowsAffected: ROWS.length } 

        UPDATE    = EMBARQUE.success ? await updFlagsEnvio( ROWS, EMBARQUE ) : await updFlagsErros( ROWS, EMBARQUE )

        if(debug){
            console.log('sql',sql)
            console.log('ROWS',ROWS)
            console.log('LIST',LIST)
            console.log('EMBARQUE',EMBARQUE)
            console.log('UPDATE',UPDATE)
        }
               
        let msg = `Query:${ROWS.length} JSON:${LIST.length} API:${EMBARQUE.success} Flag:${UPDATE.success} Ocor: 119`

        resposta  = { success: UPDATE.success, message: msg,  rowsAffected: UPDATE.rowsAffected , embarque: EMBARQUE }

    } catch (err) {
        
        console.log(moment().format(),'- (enviaDadosAPI_119) ERRO:',err)

        resposta = { success: false, message: err.message, rowsAffected:-1 }
    }    
    return resposta
}

module.exports = enviaDadosAPI_119