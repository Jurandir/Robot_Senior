// 23/09/2021 16:22 - Metódo API para inserir carga nova no iTrack (insertNewCarga.js)
// Response: { "success": true,"data": 0 } <- idCargaPK

const loadAPI                   = require('../../helpers/loadAPI')
const config                    = require('../../../.config/orion.json')
const upd_response              = require('../../metodsDB/OR/upd_response')
const geraJsonComprovantes      = require('../../metodsDB/OR/geraJsonComprovantes')

const debug    = false
const server_comprovante   = config.comprovanteURL
const endpoint_comprovante = '/api/preparaDownload'
const method   = 'POST'
const endpoint = config.URL_EVIDENCIAR_OCORRENCIA
// const server   =  (config.run=='Test') ? config.TEST_SRV : config.SERVIDOR
const server   =  config.TEST_SRV  /// TESTES

const enviaComprovantes = async () => {
    let retorno  = []
    let bodys    = await geraJsonComprovantes()

    if(!bodys || bodys.length==0) {
        return retorno
    }

    for await (let body of bodys) {
        console.log('enviaComprovantes',body)
        let comp  = await loadAPI('GET',endpoint_comprovante,server_comprovante,{ ctrc: body.CTRC, retTipo:2 })
        console.log('enviaComprovantes COMP:',comp)
    }

    
    return retorno

    for await (let body of bodys) {
        let ret = { 
            success: true,
            message: 'API Ok.',
        }
        try {
            
            if(debug) { console.log('Request ID:',body.REFID) }

            let api   = await loadAPI(method,endpoint,server,body)
            ret.dados = api.data 
            
            if(debug) { console.log('Response:',api) }
            
            let id        = body.REFID
            let Mensagem  = ret.dados.BaixaOcorrenciaResult.Mensagem
            let Protocolo = ret.dados.BaixaOcorrenciaResult.Protocolo
            let Sucesso   = ret.dados.BaixaOcorrenciaResult.Sucesso

            if(!Mensagem) {
                console.log('(enviaComprovantes) Mensagem:', ret )     //--- TESTES
            }            
            
            ret.grv  = await upd_response( { id, Mensagem, Protocolo, Sucesso } )

            retorno.push( ret ) 

        } catch (err) {

            console.log('(enviaComprovantes) err:', err.message )     //--- TESTES

            ret.success = false
            ret.message = err.message
            ret.dados   = {}
            retorno.push( ret ) 
        }
        let grv = {}    
    }  

    return retorno
}

module.exports = enviaComprovantes
