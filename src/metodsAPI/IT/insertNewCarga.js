// 09/09/2021 15:20 - Metódo API para inserir carga nova no iTrack (insertNewCarga.js)
// Response: { "success": true,"data": 0 } <- idCargaPK

const loadAPI           = require('../../helpers/loadAPI')
const config            = require('../../../.config/iTrack.json')
const geraJsonNovaCarga = require('../../../src/metodsDB/IT/geraJsonNovaCarga')

const method   = 'POST'
const endpoint = '/User/Carga/Danfe'
const server   =  (config.run=='Test') ? config.testeURL : config.producaoURL

const insertNewCarga = async (params) => {
    let monta   = await geraJsonNovaCarga(params)
    let body    = monta[0]
    let ret     = await loadAPI(method,endpoint,server,body)
    ret.send    = params
    return ret
}
module.exports = insertNewCarga

/*
params = {
    CdEmpresa     : 2, 
    NrSeqControle : 4221,
    danfe         : '35210689674782001391550010015177721007675588'
}
*/
