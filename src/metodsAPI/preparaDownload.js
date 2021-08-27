const loadAPI  = require('../helpers/loadAPI')
const server   = 'http://201.49.34.12:5000' // 'http://201.49.34.12:5000'
const endpoint = '/api/downloadAgileProcess'

const preparaDownload = async (par_ctrc) => {
    let method   = 'GET'
    let params   = { 
        ctrc: par_ctrc
    }
    let ret = await loadAPI(method,endpoint,server,params)
    return ret
}

module.exports = preparaDownload