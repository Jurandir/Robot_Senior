const moment            = require('moment')
const renovaCredenciais = require('../../src/controllers/LU/renovaCredenciais')
const dadosComprovantes = require('../../src/metodsDB/LU/listSendComprovantes')
const loadBase64        = require('../../src/metodsAPI/LU/loadBase64')
const updComprovante    = require('../../src/metodsDB/LU/updComprovante')
const updEnvio          = require('../../src/metodsDB/LU/updEnvio')
const montaJsonPOD      = require('../../src/models/LU/montaJsonPOD')  
const sendPOD           = require('../../src/metodsAPI/LU/sendPOD')

renovaCredenciais().then( ()=> {

    dadosComprovantes().then( async (list) => {
 

        for await ( let itn of list) {
    
            let ctrc     = itn.CTRC
            let apiLocal = await loadBase64(ctrc)

            console.log(moment().format(),`- COMPROVANTE CTRC: "${ctrc}" - Base64:`,apiLocal.success)
            
            if(apiLocal.success) {
                itn.ImgComprovante = apiLocal.data[0].base64  
                itn.ExtensaoDoc    = apiLocal.data[0].file.split('.')[1]
                let body           = await montaJsonPOD(itn)
        
                let params = {CTRC:ctrc, flag:1, data: apiLocal.data}
    
                updComprovante(params)
    
                let credenciais = {
                    CompanyId: itn.CompanyId,
                    BODY: body,
                    TOKEN: itn.TOKEN
                }
    
                let apiLupeOn = await sendPOD(credenciais)

                if(apiLupeOn.success) {
                    let data = apiLupeOn.data
                    if(data.status=="Failed") {
                        console.log(moment().format(),`- ( FALHA POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`,data)
                        updEnvio({ID: itn.ID,flag:0,message: data.data, code: 0, protocolo: 'Failed' })
                    } else if(data.status=="Success") {
                        console.log(moment().format(),`- ( SUCESSO POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`,data)
                        updEnvio({ID: itn.ID,flag:1,message: data.data, code: 1, protocolo: 'Success' })
                    } else {
                        console.log(moment().format(),`- ( INDEFINIDO POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`,apiLupeOn)
                        updEnvio({ID: itn.ID,flag:-1,message: data.data, code: -1, protocolo: 'undefined' })
                    }

                } else {
                    console.log(moment().format(),`- ( PROBLEMAS POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`,apiLupeOn)
                    updEnvio({ID: itn.ID,flag:-1,message: data.data, code: 2, protocolo: 'Error' })
                }
            }
            ///----------------
        }
    })

})
