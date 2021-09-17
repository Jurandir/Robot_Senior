// 17/09/2021 10:39 - UPDATE RETORNO API - OCORRÊNCIAS - SÊNIOR - ("ORION/CEVA")

const sqlExec       = require('../../connection/sqlExSENIOR')

const upd_response = async (params) => {
    let {id, Mensagem, Protocolo, Sucesso } = params

    if(!id) {
        return { success: false, message: 'id error',  rowsAffected: -1, rotine: 'upd_response' }
    }

    let sql = `
    UPDATE SIC.dbo.ORION_OCORRENCIAS
    SET DT_UPDATE           = CURRENT_TIMESTAMP
      , DT_SEND             = CURRENT_TIMESTAMP
      , RESPOSTA_MSG        = '${Mensagem}'
      , RESPOSTA_PROTOCOLO  = '${Protocolo}'
      , RESPOSTA_STATUS     = ${ Sucesso ? 200 : -1 }
      , FLAG_SEND           = ${ Sucesso ? 1 : 0 }
      , RESPOSTA_REENVIO    = RESPOSTA_REENVIO + 1
    WHERE 
      ID = ${id}
    `
    try {

        let result = await sqlExec(sql)         
        return result
  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'upd_response'
        }
        return Erro
    } 
}

module.exports = upd_response