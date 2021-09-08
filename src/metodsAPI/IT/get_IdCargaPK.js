const loadAPI = require('../../helpers/loadAPI')
const config  = require('../../../.config/iTrack.json')

const method   = 'GET'
const endpoint = '/User/CargaSimples'
const server   =  (config.run=='Test') ? config.testeURL : config.producaoURL

const get_IdCargaPK = async (danfe,token) => {

    let params = {
        token: token ,
        danfe: danfe,
    }

    let temp = 'https://integracao.itrackbrasil.com.br/ws'
  
//    return await loadAPI(method,endpoint,server,params)
    return await loadAPI(method,endpoint,temp,params)

}

module.exports = get_IdCargaPK
