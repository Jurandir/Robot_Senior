const loadAPI       = require('../../helpers/loadAPI')
const cfg           = require('../../../.config/lupeon.json')

const loadBase64 = async (ctrc) => {
    let method   = 'GET'
    let endpoint = ''
    let server   = cfg.base64URL
    let params   = {
        ctrc: ctrc,
        retTipo: 2
    }
    let ret = await loadAPI(method,endpoint,server,params)
    return ret
}

module.exports = loadBase64