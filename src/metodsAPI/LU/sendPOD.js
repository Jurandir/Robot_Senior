const loadAPI       = require('../../helpers/loadAPI')
const cfg           = require('../../../.config/lupeon.json')
const saveLogJSON   = require('../../helpers/saveLogJSON')

const sendPOD = async (credenciais) => {
    let method   = 'POST'
    let endpoint = ''
    let token    = credenciais.TOKEN
    let server   = cfg.embarqueURL
    let params   = credenciais.BODY
    let headers  = { CompanyId: credenciais.CompanyId }
   
    let ret = await loadAPI(method,endpoint,server,params,token,headers)

    let log ={
        dados: credenciais,
        method: method,   
        endpoint: endpoint,
        token: token,   
        server: server,  
        params: params,  
        headers: headers,
        response: ret 
    }

    saveLogJSON('LU',`parametros_${ credenciais.BODY[0].ChaveNFe }.txt`,log)
    saveLogJSON('LU',`response_${ credenciais.BODY[0].ChaveNFe }.txt`,ret)

    return ret
}

module.exports = sendPOD