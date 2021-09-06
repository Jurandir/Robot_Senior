// 30/08/2021 16:11 - AVISA A API PARA DOWNLOAD DO COMPROVANTE - PREPARA API LOCAL

const preparaDownload = require('../metodsAPI/CF/preparaDownload')
const updDownload     = require('../metodsDB/CF/updDownloadOK')
const logEventos      = require('../helpers/logEventos')

const sqlQuery        = require('../connection/sqlSENIOR')
const fs              = require('fs')
const path            = require('path')
const sqlFileName     = path.join(__dirname, '../../src/sql/CF/consultas/prepararDownloadComprovantes.SQL')
const sqlPendentes    = fs.readFileSync(sqlFileName, "utf8")

const preparaLinkComprovante = async (cfg) => {
    let sql       = sqlPendentes
    let resposta  = { success: true, message: 'Em Processamento.',  rowsAffected: 0 }

    console.log('-------> Comprovantes inicio.')

    try {
        let ret  = await sqlQuery( sql )

        for await (let itn of ret ) {

            let resp = await preparaDownload(itn.CTRC)

                
            if(resp.success) {

                    resp.rowsAffected = 0
                    let api = resp.data[0]

                    if(api.success){

                        resposta  = { success: true, message: 'Sucesso na solicitação !!!',  rowsAffected: api.rows }
                        await updDownload( itn.CTRC, resp.data )
                        logEventos(cfg,`SUCCESS LINK :${api.message} - ${api.url}`,resp.data)
                    } else {
                        resposta  = { success: false, message: 'Solicitação sem sucesso !!!',  rowsAffected: 0 }
                    }
            } else {
                    resp.rowsAffected = -1
                    resp.data = []
                    logEventos(cfg,`ERROR LINK :${resp.err}`,'preparaLinkComprovante.js') // ,resp)
            }   

        }

        console.log('-------> Comprovantes final.')
        
        return resposta

    } catch (err) {
        resposta = { success: false, message: err.message, rowsAffected:-1 }
        return resposta
    }
    
}

module.exports = preparaLinkComprovante
