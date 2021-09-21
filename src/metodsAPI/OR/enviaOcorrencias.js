// 09/09/2021 15:20 - Metódo API para inserir carga nova no iTrack (insertNewCarga.js)
// Response: { "success": true,"data": 0 } <- idCargaPK

const loadAPI            = require('../../helpers/loadAPI')
const config             = require('../../../.config/orion.json')
const geraJsonOcorrencia = require('../../../src/metodsDB/OR/geraJsonOcorrencia')
const upd_response       = require('../../metodsDB/OR/upd_response')

const method   = 'POST'
const endpoint = config.URL_OCORRENCIA
const server   =  (config.run=='Test') ? config.TEST_SRV : config.SERVIDOR

let RET = {
    dados: {
      BaixaOcorrenciaResult: {
        Mensagem: 'Sucesso.',
        Protocolo: 'B3B14EB1748226DFE053C24DEC0AA494',
        Sucesso: true
      }
    },
    isErr: false
  }

const enviaOcorrencias = async () => {
    let retorno  = []
    let bodys    = await geraJsonOcorrencia()

    if(!bodys || bodys.length==0) {
        return retorno
    }

    console.log('Envia Ocorrências:')
    console.log('* server:', server)
    console.log('* endpoint:', endpoint)
    
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
            
            let api   = await loadAPI(method,endpoint,server,body)
            ret.dados = api.data 

             console.log('POST:', body)                       //--- TESTES
             console.log('RESPONSE:', api.data)
            
            let id        = body.REFID
            let Mensagem  = ret.dados.BaixaOcorrenciaResult.Mensagem
            let Protocolo = ret.dados.BaixaOcorrenciaResult.Protocolo
            let Sucesso   = ret.dados.BaixaOcorrenciaResult.Sucesso
            
            ret.grv  = await upd_response( { id, Mensagem, Protocolo, Sucesso } )

            retorno.push( ret ) 

        } catch (err) {

            console.log('(enviaOcorrencias) err:', err.message )     //--- TESTES

            ret.success = false
            ret.message = err.message
            ret.dados   = {}
            retorno.push( ret ) 
        }
        let grv = {}    
    }  

    return retorno
}


module.exports = enviaOcorrencias
