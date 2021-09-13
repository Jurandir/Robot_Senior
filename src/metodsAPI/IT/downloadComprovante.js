const moment     = require('moment')
const loadAPI    = require('../../helpers/loadAPI')
const servicos   = require('../../../.config/servicos.json')

const server     = servicos.localtest ? servicos.test_comprovantes.server   : servicos.comprovantes.server
const endpoint   = servicos.localtest ? servicos.test_comprovantes.endpoint : servicos.comprovantes.endpoint

const downloadComprovante = async (par_ctrc) => {
    let method   = 'GET'
    let params   = { 
        ctrc: par_ctrc,
        retTipo: 1
    }

    let ret = await loadAPI(method,endpoint,server,params)

    if(servicos.localtest) {
        let obs = ret.success ? ret.data[0].message : ret.data.code
        console.error(moment().format(),'-','DOWNLOAD COMPROVANTE',`CTRC ${par_ctrc}, Local Test ${server}/${endpoint} - ${obs}`)
    }

    if(!ret.success) {
        ret.message = ret.data.code
        ret.err = ret.data
        ret.data = []
    }

    return ret
}

module.exports = downloadComprovante
