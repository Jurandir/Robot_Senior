
// 28/04/2022 16:42 - finaliza acompanhamento - Lupe-ON - ("Lupe-ON - V.01")

const sqlExec = require('../../connection/sqlExSENIOR')

const updFechaFase = async () => {
    let sql = `
    UPDATE NF
       SET FASE_ID = 9
    FROM LUPEON_OCORRENCIA OC
    JOIN LUPEON_NFE NF ON NF.ID = OC.LUPEON_ID
    WHERE OC.FLAG_SEND = 1
      AND OC.OCORRENCIA_ID = 999
       AND NF.FASE_ID < 9
    `
 
    try {
        let result = await sqlExec(sql)         
        return result  
    } catch (err) {
        let Erro = {
            success: false,
            message: err.message,
            rowsAffected: -1,
            rotine: 'updFechaFase',
            sql: sql,
            err: err
        }
        return Erro
    } 
}

module.exports = updFechaFase