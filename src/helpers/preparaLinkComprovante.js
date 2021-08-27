
const preparaDownload = require('../metodsAPI/preparaDownload')
const updDownload     = require('../metodsDB/updDownloadOK')
const logEventos      = require('../helpers/logEventos')

const sqlQuery        = require('../connection/sqlQuery')
const fs              = require('fs')
const path            = require('path')
const sqlFileName     = path.join(__dirname, '../../sql/consultas/prepararDownloadComprovantes.SQL')
const sqlPendentes    = fs.readFileSync(sqlFileName, "utf8")

const preparaLinkComprovante = async (cfg) => {
    let sql       = sqlPendentes
    let resposta  = { success: true, message: 'Em Processamento.',  rowsAffected: 0 }

    try {
        let ret  = await sqlQuery( sql )

        ret.map( itn => {

            preparaDownload(itn.CTRC).then(resp=>{
                
                if(resp.success) {
                    resp.rowsAffected = 0
                    let api = resp.data
                    if(api.success){
                        logEventos(cfg,`SUCCESS LINK :${api.message} - ${api.url}`,resp)
                        updDownload( itn.CTRC )
                    }
                } else {
                    resp.rowsAffected = -1
                    resp.data = []
                    logEventos(cfg,`ERROR LINK :${resp.err}`,'preparaLinkComprovante.js') // ,resp)
                }   

            })

        })

    } catch (err) {
        resposta = { success: false, message: err.message, rowsAffected:-1 }
    }

    return resposta
}

module.exports = preparaLinkComprovante
