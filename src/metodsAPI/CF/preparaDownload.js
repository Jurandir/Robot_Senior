const loadAPI  = require('../../helpers/loadAPI')
const servicos = require('../../../.config/servicos.json')
const server   = servicos.comprovantes.server
const endpoint = servicos.comprovantes.endpoint

const preparaDownload = async (par_ctrc) => {
    let method   = 'GET'
    let params   = { 
        ctrc: par_ctrc
    }
    let ret = await loadAPI(method,endpoint,server,params)
    return ret
}

module.exports = preparaDownload