// 12/09/2021 11:46 - ENTREGA COMPROVANTE - ITRACK

const loadAPI = require('../../helpers/loadAPI')
const config  = require('../../../.config/iTrack.json')

const method   = 'POST'
const endpoint = '/User/Carga/Entrega/Danfe'
const server   =  (config.run=='Test') ? config.testeURL : config.producaoURL

const enviaComprovantes = async (body) => {
    return await loadAPI(method,endpoint,server,body)
}

module.exports = enviaComprovantes
