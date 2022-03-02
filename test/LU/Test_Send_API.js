// const sqlExec       = require('../../connection/sqlExSENIOR')
const sqlQuery      = require('../../src/connection/sqlSENIOR')
const cfg           = require('../../.config/lupeon.json')
const loadAPI       = require('../../src/helpers/loadAPI')

const loadBase64 = async (ctrc) => {
    let method   = 'GET'
    let endpoint = ''
    let server   = cfg.base64URL
    let params   = {
        ctrc: ctrc,
        retTipo: 2
    }
    let ret = await loadAPI(method,endpoint,server,params)
    return ret
}

const sendPOD = async (credenciais) => {
    let method   = 'POST'
    let endpoint = ''
    let token    = credenciais.TOKEN
    let server   = cfg.embarqueURL
    let params   = credenciais.BODY
   
    let ret = await loadAPI(method,endpoint,server,params,0,{ CompanyId: credenciais.CompanyId, Authorization: token  })

    return ret

}

const dadosComprovantes = async () => {
    let sql = `
    SELECT TOP 1 nfe.EMBARCADOR
    ,            cli.NOME AS EMBARCADOR_NOME
    ,            nfe.NUMERO 
    ,            nfe.SERIE 
    ,            nfe.CHAVE 
    ,            nfe.TRANSPORTADOR 
    ,            oc.OCORRENCIA_NOME
    ,            CONCAT(FORMAT( oc.OCORRENCIA_DATA,'yyyy-MM-dd'),' ', FORMAT(oc.OCORRENCIA_DATA,'HH:mm:ss') ) AS OCORRENCIA_DATA
    ,            nfe.CTRC 
	,            tkn.ID AS CompanyId
	,            tkn.TOKEN    
    FROM  SIC..LUPEON_OCORRENCIA oc
    JOIN  SIC..LUPEON_NFE     nfe ON nfe.ID   = oc.LUPEON_ID
    JOIN  SIC..LUPEON_CLIENTE cli ON cli.CNPJ = nfe.EMBARCADOR
    JOIN  SIC..LUPEON_TOKEN   tkn ON tkn.ID   = 373
    WHERE oc.OCORRENCIA_ID = 999
      AND nfe.FASE_ID = 6
    `
    let ret = await sqlQuery(sql)
    return ret    
}

const updComprovante = async ({CTRC,flag,data}) => {

    let jComprovantes = JSON.stringify( data.map(i=>i.url) )

    let sql = `UPDATE SIC..LUPEON_NFE 
                SET FLAG_COMPROVANTE  = ${flag},
                    JSON_COMPROVANTE  = '${jComprovantes}'
                WHERE CTRC = '${CTRC}'`

    console.log('updComprovante:',sql)
    
    // runSQL(sql,'LU updComprovante')

}

const updEnvio = async ({ID,flag,message,code,protocolo}) => {

    let sql = `UPDATE SIC..LUPEON_OCORRENCIA 
                SET FLAG_SEND          = ${flag},
                    DT_SEND            = CURRENT_TIMESTAMP,
                    RESPOSTA_MSG       = '${message}',
                    RESPOSTA_STATUS    = '${code}',
                    RESPOSTA_PROTOCOLO = '${protocolo}'
                WHERE ID = ${ID}
                `
    console.log('updEnvio:',sql)
    
    // runSQL(sql,'LU updEnvio')

}

const runSQL = async (sql,rotine) => {
    try {
        let result = await sqlExec(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: rotine,
            sql: sql,
            err: err
        }
        return Erro
    } 
}

const montaJson = async (itn) => {
    let ret = {
            EmbarcadorCNPJ: itn.EMBARCADOR,
            Embarcador: itn.EMBARCADOR_NOME,
            TransportadoraCNPJ: itn.TRANSPORTADOR,
            Transportadora: "TERMACO",
            NFeNumero: itn.NUMERO,
            SerieNFe: itn.SERIE,
            ChaveNFe: itn.CHAVE,
            StatusAtual: itn.OCORRENCIA_NOME,
            DataOcorrencia: itn.OCORRENCIA_DATA,
            ImgComprovante: itn.ImgComprovante,
            ExtensaoDoc: itn.ExtensaoDoc
    }
    return ret
}

dadosComprovantes().then( async (list) => {

    for await ( let itn of list) {

        let ctrc     = itn.CTRC
        let apiLocal = await loadBase64(ctrc)
        
        if(apiLocal.success) {
            itn.ImgComprovante = apiLocal.data[0].base64              // `${apiLocal.data[0].base64}`.substring(0,80)
            itn.ExtensaoDoc    = apiLocal.data[0].file.split('.')[1]
            let body           = await montaJson(itn)
            console.log(body.ChaveNFe)

            let params = {CTRC:ctrc, flag:1, data: apiLocal.data}

            updComprovante(params)

            let credenciais = {
                CompanyId: itn.CompanyId,
                BODY: body,
                TOKEN: itn.TOKEN
            }

            let apiLupeOn = await sendPOD(credenciais)

            // "status": "Failed"

            // console.log(apiLupeOn.data.response.data)
            console.log(apiLupeOn.data.response)



        }

        console.log('Base64:',apiLocal.success)
    }
})


/*
{
 "status": "Success",
 "Message": "Integração realizada com sucesso."
}
*/