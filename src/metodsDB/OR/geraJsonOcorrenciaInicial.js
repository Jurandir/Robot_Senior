// 23/09/2021 16:17 - GERA JSON OCORRENCIAS INICIAIS - ("ORION/CEVA")

const sqlQuery        = require('../../connection/sqlSENIOR')
const dataSetToJson   = require('../../helpers/dataSetToJson')

const fs                        = require('fs')
const path                      = require('path')
const sqlFileName               =  path.join(__dirname, '../../sql/OR/consultas/enviaOcorrenciasIniciais.SQL')
const sqlNovaOcorrenciaJSON     = fs.readFileSync(sqlFileName, "utf8")

const geraJsonOcorrenciaInicial = async () => {
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

module.exports = geraJsonOcorrenciaInicial