// 23/09/2021 16:36 - GERA JSON OUTRAS OCORRENCIAS - ("ORION/CEVA")

const sqlQuery        = require('../../connection/sqlSENIOR')
const dataSetToJson   = require('../../helpers/dataSetToJson')

const fs                        = require('fs')
const path                      = require('path')
const sqlFileName               =  path.join(__dirname, '../../sql/OR/consultas/enviaOcorrenciasOutras.SQL')
const sqlNovaOcorrenciaJSON     = fs.readFileSync(sqlFileName, "utf8")

const geraJsonOcorrenciaOutras = async () => {
    let sql = eval('`'+sqlNovaOcorrenciaJSON+'`');
    
    try {
        let ret = await sqlQuery(sql)
        if(ret) {
            let count = ret.length
            if(count) {
            return dataSetToJson(ret)
            }
        } else {
            return []
        }
    } catch (err) {
        console.log('ERRO:',err)
        return []
    }
}

module.exports = geraJsonOcorrenciaOutras