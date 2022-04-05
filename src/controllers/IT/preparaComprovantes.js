// 13/09/2021 17:50 - Avisa API - Prepara links dos comprovantes - iTrack

const downloadComprovante = require('../../metodsAPI/IT/downloadComprovante')
const sqlQuery            = require('../../connection/sqlSENIOR')
const sqlExec             = require('../../connection/sqlExSENIOR')

const preparaComprovantes = async () => {
    let retorno = {
        success:false,
        message:'',
        rotine: '(IT) preparaComprovantes.js',
        dados: [],
    }
    async function upd_status(id,links) {
        let flag = ( !links || links=='[]' || links=='[null]' ) ? 0  : 1
        let sJson = flag ? `'${links}'` : 'null'
        let sqlEx = `
            UPDATE SIC.dbo.ITRACK_DANFE 
            SET  FLAG_COMPROVANTE = ${ flag  }
               , JSON_COMPROVANTE = ${ sJson }
               , DT_UPDATE = CURRENT_TIMESTAMP
            WHERE ID = ${id}     
        `
        return await sqlExec(sqlEx)
    }

    let tempo = Math.floor( Math.random() * 07 + 3 ) // Soteia um numero de 3 a 10 minutos
    let lista = 100  
    //  Math.floor( Math.random() * 20 + 5 ) // Soteia um numero de 5 a 25 registros

    let sqlComp = `
        SELECT TOP ${lista} * 
        FROM SIC.dbo.ITRACK_DANFE IT 
        WHERE IDCARGA > 0
        AND FASE_ID = 6 
        AND FLAG_COMPROVANTE = 0
        AND ( IT.DT_UPDATE IS NULL OR DATEDIFF(minute,IT.DT_UPDATE, CURRENT_TIMESTAMP) > ${tempo}) --- depois de X min da ultima tentativa
    `
    try {
        let dadosComp =  await sqlQuery( sqlComp ) 
        let lenArray  = dadosComp.length

        // console.log('preparaComprovantes (dadosComp)',dadosComp,lenArray)   //// teste

        if(!lenArray) {
            retorno.message = dadosComp.Erro ? dadosComp.Erro : 'Sem dados !!!'
            return retorno
        }
        retorno.dados     = dadosComp
        
        let idx = 0

        for await (let itn of dadosComp) {
            let ctrc                     = itn.CTRC
            let download                 = await downloadComprovante(ctrc)

            // console.log('preparaComprovantes (downloadComprovante)',download,ctrc)    /// teste

            let alinks                   = download.data.map(i=>i.url)
            let slinks                   = JSON.stringify(alinks)
            retorno.dados[idx].links     = slinks
            retorno.dados[idx].upd       = await upd_status(itn.ID,slinks)
            idx++
        }

        retorno.success = true
        return retorno

    } catch (err) {
        console.log('preparaComprovantes ERR',err)
        retorno.success = false
        retorno.message = err.message
        return retorno
    }

}

module.exports = preparaComprovantes
