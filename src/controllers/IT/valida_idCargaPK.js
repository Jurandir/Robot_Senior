// 08/09/2021 17:02 - PESQUISA NA API ITRACK O "IDCARGAPK" OU REGISTRA NOVA CARGA

const sqlQuery        = require('../../connection/sqlSENIOR')
const get_IdCargaPK   = require('../../metodsAPI/IT/get_IdCargaPK')
const grava_IdCargaPK = require('../../metodsDB/IT/grava_IdCargaPK')
const insertNewCarga  = require('../../metodsAPI/IT/insertNewCarga')

const logEventos      = require('../../helpers/logEventos')

const valida_idCargaPK = async (cfg) => {                                                ////   TESTE (TOP 20)
    let sql = `
    SELECT TOP 20 DF.* ,TK.TOKEN
	,(SELECT TOP 1 1 FROM SIC.dbo.ITRACK_CLIENTE CL 
	  WHERE (CL.RAIZ_CNPJ=SUBSTRING(DF.EMBARCADOR,1,8) 
	     OR CL.RAIZ_CNPJ=SUBSTRING(DF.DESTINATARIO,1,8)
		 AND CL.FLAG_ADDCARGA=1)) FLAG_ADDCARGA
    FROM SIC.dbo.ITRACK_DANFE DF
    JOIN SIC.dbo.ITRACK_TOKEN TK ON TK.CNPJ = DF.TRANSPORTADOR
    WHERE DF.IDCARGA = 0
    `
    try {

        let params
        let grv
        let ret = await sqlQuery(sql)

        for await (let itn of ret) {

            let api = await get_IdCargaPK(itn.CHAVE,itn.TOKEN)

            //console.log('API:',api)

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
                    logEventos(cfg,`Falha na validação : "${itn.CHAVE}", (${itn.CdEmpresa},${itn.NrSeqControle})`,api.data.data)

                    console.log('>>> FLAG_ADDCARGA:',itn.FLAG_ADDCARGA)


                    //================================================ PARA TESTES (INCLUIR CARGA)
                    itn.FLAG_ADDCARGA = 1
                    //============================================================================


                    if(itn.FLAG_ADDCARGA) {
                        params = {
                            idCargaPK     : 0,
                            CdEmpresa     : itn.CdEmpresa, 
                            NrSeqControle : itn.NrSeqControle,
                            danfe         : itn.CHAVE
                        }
                        let nova = await insertNewCarga(params)

                        params.idCargaPK = nova.success ? (nova.data.success ? nova.data.data : 0 ) : 0

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

/*
  {
    ID: 1,
    IDCARGA: 0,
    EMBARCADOR: '01844555001235',
    NUMERO: '0656781',
    SERIE: '1',
    CHAVE: '35210801844555001235550010006567811023404850',
    DT_EMISSAO: 2021-08-24T00:00:00.000Z,
    DT_EMBARQUE: null,
    DT_CHEGADA: null,
    DT_ENTREGA: null,
    DT_PREVISAO: 2021-09-01T00:00:00.000Z,
    DT_PREV_ORIGINAL: 2021-09-01T00:00:00.000Z,
    DT_AGENDAMENTO: null,
    VALOR: 784,
    CTRC: 'SPOE15216',
    CTRC_OLD: null,
    DESTINATARIO: '34939001000118',
    TRANSPORTADOR: '11552312000710',
    FLAG_COMPROVANTE: 0,
    JSON_COMPROVANTE: null,
    DT_ENVIO: null,
    DT_VALIDACAO: null,
    DT_UPDATE: 2021-09-08T14:41:20.540Z,
    CdEmpresa: 2,
    NrSeqControle: '15260',
    FASE_ID: 1,
    TOKEN: '41YIzpld%2B3rFKIwbpy9g%2FFvMKv%2Buaro8badWdwkVonqe9yUjdfBSUutNg36zKyPI9XtWT7mICJQsTFpfiYlo%2FQpoZ0NFbv1lAqAskvbtJlMqF7o1Qfc3UCx%2BRfzG4m%2FH'
  },

*/
