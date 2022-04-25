const moment                    = require('moment')
const renovaCredenciais         = require('./renovaCredenciais')
const dadosComprovantes         = require('../../metodsDB/LU/listSendComprovantes')
const loadBase64                = require('../../metodsAPI/LU/loadBase64')
const updComprovante            = require('../../metodsDB/LU/updComprovante')
const updEnvio                  = require('../../metodsDB/LU/updEnvio')
const montaJsonPOD              = require('../../models/LU/montaJsonPOD')
const sendPOD                   = require('../../metodsAPI/LU/sendPOD')

const envioPOD = async () => {

    renovaCredenciais().then(() => {

        dadosComprovantes().then(async (list) => {

            for await (let itn of list) {

                let ctrc = itn.CTRC
                let apiLocal = await loadBase64(ctrc)

                console.log(moment().format(), `- COMPROVANTE CTRC: "${ctrc}" - Base64:`, apiLocal.success)

                if ((apiLocal.success) && (apiLocal.data[0].success) ){

                    itn.ImgComprovante = apiLocal.data[0].base64
                    let temp_ext = apiLocal.data[0].file
                    itn.ExtensaoDoc = '.'+`${temp_ext}`.split('.')[1]

                    let body = await montaJsonPOD(itn)

                    let params = { CTRC: ctrc, flag: 1, data: apiLocal.data }

                    updComprovante(params)

                    let credenciais = {
                        CompanyId: itn.CompanyId,
                        BODY: body,
                        TOKEN: itn.TOKEN
                    }

                    let apiLupeOn = await sendPOD(credenciais)

                    if (apiLupeOn.success) {
                        let data = apiLupeOn.data
                        if (data.status == "Failed") {
                            console.log(moment().format(), `- ( FALHA POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`, data)
                            updEnvio({ ID: itn.ID, flag: 0, message: data.data, code: 0, protocolo: 'Failed' })
                        } else if (data.status == "Success") {
                            console.log(moment().format(), `- ( SUCESSO POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`, data)
                            updEnvio({ ID: itn.ID, flag: 1, message: data.data, code: 1, protocolo: 'Success' })
                        } else {
                            console.log(moment().format(), `- ( INDEFINIDO POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`, apiLupeOn)
                            updEnvio({ ID: itn.ID, flag: -1, message: data.data, code: -1, protocolo: 'undefined' })
                        }

                    } else {
                        console.log(moment().format(), `- ( PROBLEMAS POD ) - ID: ${itn.ID} - CHAVE: ${body[0].ChaveNFe} - Response:`, apiLupeOn)
                        updEnvio({ ID: itn.ID, flag: -1, message: data.data, code: 2, protocolo: 'Error' })
                    }
                }
                ///----------------
            }
        })

    })

}

module.exports = envioPOD
