// 23/09/2021 16:22 - Metódo API para inserir carga nova no iTrack (insertNewCarga.js)
// Response: { "success": true,"data": 0 } <- idCargaPK

const loadAPI                   = require('../../helpers/loadAPI')
const config                    = require('../../../.config/orion.json')
const upd_response              = require('../../metodsDB/OR/upd_response')
const geraJsonOcorrenciaOutras = require('../../metodsDB/OR/geraJsonOcorrenciaOutras')

const debug    = false
const method   = 'POST'
const endpoint = config.URL_OCORRENCIA
const server   =  (config.run=='Test') ? config.TEST_SRV : config.SERVIDOR

const enviaOcorrenciasOutras = async () => {
    let retorno  = []
    let bodys    = await geraJsonOcorrenciaOutras()

    // if(debug) { console.log('Params bodys:',bodys) }

    if(!bodys || bodys.length==0) {
        return retorno
    }
    
    for await (let body of bodys) {
        let ret = { 
            success: true,
            message: 'API Ok.',
            dados: { 
                BaixaOcorrenciaResult:{         
                    Mensagem: 'teste. (teste/fake)',
                    Protocolo: 'B3B14EB1748226DFE053C24DEC0AA494',
                    Sucesso: false 
                }            
            },
            body: body 
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
                console.log('(enviaOcorrenciasIniciais) Mensagem:', ret )     //--- TESTES
            }            
            
            ret.grv  = await upd_response( { id, Mensagem, Protocolo, Sucesso } )

            retorno.push( ret ) 

        } catch (err) {

            console.log('(enviaOcorrenciasOutras) err:', err.message )     //--- TESTES

            ret.success = false
            ret.message = err.message
            ret.dados   = {}
            retorno.push( ret ) 
        }
        let grv = {}    
    }  

    return retorno
}

module.exports = enviaOcorrenciasOutras
