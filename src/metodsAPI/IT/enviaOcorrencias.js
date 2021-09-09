const loadAPI = require('../../helpers/loadAPI')
const config  = require('../../../.config/iTrack.json')

const method   = 'POST'
const endpoint = '/User/Carga/Tracking/Ocorrencia/Danfe'
const server   =  (config.run=='Test') ? config.testeURL : config.producaoURL

const enviaOcorrencias = async (body) => {
    return await loadAPI(method,endpoint,server,body)
}

module.exports = enviaOcorrencias


/* (RETURN)
dados:
{
    "success": true,
    "message": "string",
    "data": true,
    "code": 0
}
*/  
