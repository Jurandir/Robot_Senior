// 13/10/2021 16:01 - AVISA A API PARA DOWNLOAD DO COMPROVANTE - PREPARA API LOCAL - ("CONFIRMA FACIL V2")

// TEST

const cfg             = require('../../.config/confirmaFacil.json') // .config/confirmaFacil.json
const preparaDownload = require('../metodsAPI/CF2/preparaDownload')
const updDownload     = require('../metodsDB/CF2/updDownloadOK')
const logEventos      = require('./logEventos')

const sqlQuery        = require('../connection/sqlSENIOR')
const fs              = require('fs')
const path            = require('path')
const sqlFileName     = path.join(__dirname, '../../src/sql/CF2/consultas/prepararDownloadComprovantes.SQL')
const sqlPendentes    = fs.readFileSync(sqlFileName, "utf8")

const preparaLinkComprovante_CF2 = async () => {
    let sql       = sqlPendentes
    let resposta  = { success: true, message: 'Em Processamento.',  rowsAffected: 0 }
    let varRet = []

    try {
        let ret  = await sqlQuery( sql )

        for await (let itn of ret ) {

            let resp = await preparaDownload(itn.CTRC)

            if(resp.success) {

                    resp.rowsAffected = 0
                    let api  = resp.data[0]
                    api.rows = resp.data.length || 0

                    if(api.success){
                        await updDownload( itn.CTRC, resp.data )
                        resposta  = { success: true, message: `Sucesso na solicitação !!!, CTRC: ${itn.CTRC}`,  rowsAffected: api.rows }
                        // logEventos(cfg,`SUCCESS LINK V2:${api.message} - ${api.url}`,resp.data)
                    } else {
                        resposta  = { success: false, message: `Solicitação sem sucesso !!!, CTRC: ${itn.CTRC}`,  rowsAffected: 0 }
                    }
                    varRet.push(resposta)
            } else {
                    resp.rowsAffected = -1
                    resp.data = []
                    logEventos(cfg,`ERROR LINK V2:${resp.err}`,'preparaLinkComprovante.js') 
            }   

        }        
        return varRet

    } catch (err) {
        resposta = { success: false, message: err.message, rowsAffected:-1 }
        varRet.push(resposta)
        return varRet
    }
    
}

module.exports = preparaLinkComprovante_CF2
