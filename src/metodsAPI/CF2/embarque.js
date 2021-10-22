// 11/10/2021 13:40 - EMBARQUE API - ("CONFIRMA FACIL V2")

// PROD-15/10/2021

const moment  = require('moment')
const loadAPI = require('../../helpers/loadAPI')
const cfg     = require('../../../.config/confirmaFacil.json')


const embarque = async (body,cli) => {
    let method   = 'POST'
    let endpoint = ''
    let server   =  cfg.embarqueURL    // PROD-15/10/2021
    if(cfg.run=='Test') {
       server  = 'http://localhost:4999/test/embarque' 
    } 
    let params   = body
    let token    = cli.TOKEN

    let ret  = await loadAPI(method,endpoint,server,params,token)
    let base = ret

    if(!ret.success) {
        base = {
            success: false,
            status: 500,
            message: ret.err,
            data: ret.data.config.data,
            err: ret.err
        }
        console.log(moment().format(),'FALHA CF V2 - (embarque.js) RET:',base)
    }    

    try {
          base = ret.data
    } catch (err) {
        console.log(moment().format(),'- ERRO CF V2: (embarque.js) :',err)
    }
    
    if( ret.success ) {
        console.log(moment().format(),'- "ENVIO API" -',cli.NOME)
        console.log(moment().format(),'- SUCCESS - (API CF-V2 EMBARQUE) - RESPONSE:',`( STATUS:${base.status} )`,base.message)
    } else {
        
        if(ret.data==undefined) {
            ret.data= { response : { data: [] }}
        }

        if(ret.data.response.data==undefined) {
            ret.data = { response : { data: [] }}
        }

        base = ret.data.response.data
        console.log(moment().format(),'- (embarque.js) - RETORNO API CF V2- Erro ao importar todos os dados, PATH:/v2/embarque.')

    }

    return ret

}

module.exports = embarque
