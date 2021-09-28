// 23/09/2021 16:22 - Metódo API para inserir carga nova no iTrack (insertNewCarga.js)
// Response: { "success": true,"data": 0 } <- idCargaPK

const loadAPI                   = require('../../helpers/loadAPI')
const config                    = require('../../../.config/orion.json')
const upd_response              = require('../../metodsDB/OR/upd_response')
const upd_flag_comprovante      = require('../../metodsDB/OR/upd_flag_comprovante')
const geraJsonComprovantes      = require('../../metodsDB/OR/geraJsonComprovantes')

const debug    = false
const server_comprovante   = config.comprovanteURL
const endpoint_comprovante = '/api/preparaDownload'
const method   = 'POST'
const endpoint = config.URL_EVIDENCIAR_OCORRENCIA
const server   =  (config.run=='Test') ? config.TEST_SRV : config.SERVIDOR

const enviaComprovantes = async () => {
    let retorno  = []
    let bodys    = await geraJsonComprovantes()

    if(!bodys || bodys.length==0) {
        return retorno
    }
    
    for await (let body of bodys) {
        let comp    = await loadAPI('GET',endpoint_comprovante,server_comprovante,{ ctrc: body.CTRC, retTipo:2 })
        let idx_img = comp.data.length > 1 ? 1 : 0
        let imagem  =  comp.data[idx_img].base64  // Pega a imagem da lista no index "idx_img"
        if(comp.success && imagem) {

            upd_flag_comprovante(body.CTRC)
            
            body.imagem     = imagem
            body.observacao = 'ENVIO DO COMPROVANTE/EVIDÊNCIA'
            let ret = { 
                success: true,
                message: 'API Ok.',
            }
            try {
                
                console.log('Request ID:',body.REFID,method,endpoint) 

                let api   = await loadAPI(method,endpoint,server,body)
                ret.dados = api.data
                ret.body  = body 
                                
                let id        = body.REFID
                let Mensagem  = api.data.EvidenciaOcorrenciaResult.Mensagem
                let Protocolo = api.data.EvidenciaOcorrenciaResult.Protocolo
                let Sucesso   = api.data.EvidenciaOcorrenciaResult.Sucesso

                if(!Mensagem) {
                    console.log('Response:',api)
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

        } 
    }  

    return retorno
}

module.exports = enviaComprovantes
