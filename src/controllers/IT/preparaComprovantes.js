
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
        let sqlEx = `
            UPDATE SIC.dbo.ITRACK_DANFE 
            SET  FLAG_COMPROVANTE = 1
               , JSON_COMPROVANTE = '${links}'
               , DT_UPDATE = CURRENT_TIMESTAMP
            WHERE ID = ${id}     
        `
        return await sqlExec(sqlEx)
    }

    let sqlComp = `
        SELECT * 
        FROM SIC.dbo.ITRACK_DANFE IT 
        WHERE IDCARGA > 0
        AND FASE_ID = 6 
        AND FLAG_COMPROVANTE = 0
    `
    try {
        let dadosComp =  await sqlQuery( sqlComp ) 
        let lenArray  = dadosComp.length

        if(!lenArray) {
            retorno.message = dadosComp.Erro ? dadosComp.Erro : 'Sem dados !!!'
            return retorno
        }
        retorno.dados     = dadosComp
        
        let idx = 0

        for await (let itn of dadosComp) {
            let ctrc                     = itn.CTRC
            let download                 = await downloadComprovante(ctrc)
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
