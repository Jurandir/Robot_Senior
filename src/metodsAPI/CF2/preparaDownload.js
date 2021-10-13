// 13/10/2021 16:03 - PREPARA DOWNLOAD EM API LOCAL - ("CONFIRMA FACIL V2")

const moment     = require('moment')
const loadAPI    = require('../../helpers/loadAPI')
const servicos   = require('../../../.config/servicos.json')

const server     = servicos.localtest ? servicos.test_comprovantes.server   : servicos.comprovantes.server
const endpoint   = servicos.localtest ? servicos.test_comprovantes.endpoint : servicos.comprovantes.endpoint

const preparaDownload = async (par_ctrc) => {
    let method   = 'GET'
    let params   = { 
        ctrc: par_ctrc,
        retTipo: 1
    }
    let ret = await loadAPI(method,endpoint,server,params)

    if(servicos.localtest) {
        let obs = ret.data[0].message
        console.error(moment().format(),'-','PREPARA DOWNLOAD V2',`CTRC ${par_ctrc}, Local Test ${server}/${endpoint} - ${obs}`)
    }

    return ret
}

module.exports = preparaDownload