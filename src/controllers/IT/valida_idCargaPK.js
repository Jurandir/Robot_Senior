// 08/09/2021 17:02 - PESQUISA NA API ITRACK O "IDCARGAPK" OU REGISTRA NOVA CARGA

const sqlQuery        = require('../../connection/sqlSENIOR')
const get_IdCargaPK   = require('../../metodsAPI/IT/get_IdCargaPK')
const grava_IdCargaPK = require('../../metodsDB/IT/grava_IdCargaPK')
const grava_Update    = require('../../metodsDB/IT/grava_Update')
const insertNewCarga  = require('../../metodsAPI/IT/insertNewCarga')

const logEventos      = require('../../helpers/logEventos')

const valida_idCargaPK = async (cfg) => {                                                ////   TESTE (TOP 20)
    let sql = `
    SELECT TOP 100 DF.* ,TK.TOKEN
	,(SELECT TOP 1 1 FROM SIC.dbo.ITRACK_CLIENTE CL 
	  WHERE (CL.RAIZ_CNPJ=SUBSTRING(DF.EMBARCADOR,1,8) 
	     OR CL.RAIZ_CNPJ=SUBSTRING(DF.DESTINATARIO,1,8)
		 AND CL.FLAG_ADDCARGA=1)) FLAG_ADDCARGA
    FROM SIC.dbo.ITRACK_DANFE DF
    JOIN SIC.dbo.ITRACK_TOKEN TK ON TK.CNPJ = DF.TRANSPORTADOR
   WHERE DF.IDCARGA = 0
     AND ( DF.DT_UPDATE    IS NULL OR DATEDIFF(minute,DF.DT_UPDATE   , CURRENT_TIMESTAMP) > 3) ---UPDATE    depois de 3min da ultima tentativa
     AND ( DF.DT_VALIDACAO IS NULL OR DATEDIFF(minute,DF.DT_VALIDACAO, CURRENT_TIMESTAMP) > 3) ---VALIDACAO depois de 3min da ultima tentativa
    `
    try {

        let params
        let grv
        let ret = await sqlQuery(sql)

        /// console.log('RET SQL',ret)       /////////   teste

        for await (let itn of ret) {

            let api = await get_IdCargaPK(itn.CHAVE,itn.TOKEN)

            /// console.log('RET API:',api)     ////// teste

            if(api.success) {
                if(api.data.data.count) {
                    params = {
                        idCargaPK     : api.data.data.list[0].carga.idCargaPk, 
                        CdEmpresa     : itn.CdEmpresa, 
                        NrSeqControle : itn.NrSeqControle,
                        danfe         : itn.CHAVE
                    }
                    grv = await grava_IdCargaPK(params)
                    logEventos(cfg,`Validação : ${params.idCargaPK}, (${params.CdEmpresa},${params.NrSeqControle}) - OK: ${grv.success}`,grv)
                } else {
                    // logEventos(cfg,`Falha na validação : "${itn.CHAVE}", (${itn.CdEmpresa},${itn.NrSeqControle})`,{ achou:'NÃO', success:true })
                    api.data.data.rowsAffected = -1
                    logEventos(cfg,`Falha Validação - ADD: ${itn.FLAG_ADDCARGA ? 'S' : 'N'}, "${itn.CHAVE}", (${itn.CdEmpresa},${itn.NrSeqControle})`,api.data.data)

                    params = {
                        idCargaPK     : 0,
                        CdEmpresa     : itn.CdEmpresa, 
                        NrSeqControle : itn.NrSeqControle,
                        danfe         : itn.CHAVE
                    }
                    
                    grava_Update(params) // Atualiza "DT_UPDATE"

                    //--console.log('DEBUG:',params,grv)
                    
                    if(itn.FLAG_ADDCARGA) {
                        let nova = await insertNewCarga(params)

                        //console.log('para API (insertNewCarga):',params)     ////// teste
                        //console.log('RET API (insertNewCarga):',nova)        ////// teste

                        params.idCargaPK = nova.success ? (nova.data.success ? nova.data.data : 0 ) : 0
                        logEventos(cfg,`Retorno API (InsertCarga) : (${params.CdEmpresa},${params.NrSeqControle}): CODE:${nova.data.code || params.idCargaPK}, MSG:"${nova.data.message || '' }", OK:${nova.data.success}, CALL:`,{success:true})

                        grv = await grava_IdCargaPK(params)
                        logEventos(cfg,`Nova CARGA : ${params.idCargaPK}, (${params.CdEmpresa},${params.NrSeqControle}) - OK: ${grv.success}`,grv)
                    }
                }
            } else {
                logEventos(cfg,`Pesquisa na API: "${itn.CHAVE}", (${itn.CdEmpresa},${itn.NrSeqControle})`,api)
            }
        }
    
    } catch (err) {
        console.log('ERR:',err)
    }
}

module.exports = valida_idCargaPK
