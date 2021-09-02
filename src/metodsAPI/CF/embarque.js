const moment  = require('moment')
const loadAPI = require('../../helpers/loadAPI')

const embarque = async (cfg,cli,body) => {
    let method   = 'POST'
    let endpoint = ''
    let server   = cfg.embarqueURL
    if(cfg.run=='Test') {
       server  = 'http://localhost:4999/test/embarque' 
    } 
    let params   = body
    let token    = cli.login.resposta.token
    
    let ret  = await loadAPI(method,endpoint,server,params,token)
    let base = ret
    
    if(!ret.success) {
        console.log('FALHA (embarque.js) RET:',ret)
    }    

    try {
          base = ret.data
    } catch (err) {
        console.log(moment().format(),'- (embarque.js) :',err,ret)
    }
    
    if( ret.success ) {
        console.log(moment().format(),'- SUCCESS - (API EMBARQUE) - RESPONSE:',`( STATUS:${base.status} )`,base.message)
    } else {
        base = ret.data.response.data
        console.log(moment().format(),'- (embarque.js) FALHA - API EMBARQUE:',`(CODE:${base.status}, ERROR:${base.error}, PATH:${base.path}, ERR:${ret.err})`)
        console.log('=========================================')
        console.log('>>:',ret)
        console.log('=========================================')
    }

    return ret

}

module.exports = embarque
