const loadAPI = require('../../helpers/loadAPI')
const config  = require('../../../.config/iTrack.json')

const method   = 'GET'
const endpoint = '/User/CargaSimples'
const server   =  (config.run=='Test') ? config.testeURL : config.producaoURL

const get_IdCargaPK = async (danfe,token) => {

    let urlToken = token

    let params = {
        token:  urlToken,
        danfe: danfe,
    }

    let ret = await loadAPI(method,endpoint,server,params)
    
    // console.log('token',token)
    // console.log('url token',urlToken)
    console.log('danfe',danfe)
    console.log('ret',ret)
    
    return ret

//   let temp = 'https://integracao.itrackbrasil.com.br/ws' 
//   return await loadAPI(method,endpoint,temp,params)

}

module.exports = get_IdCargaPK
