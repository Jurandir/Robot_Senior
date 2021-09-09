// 08/09/2021 17:02 - PESQUISA NA API ITRACK O "IDCARGAPK" OU REGISTRA NOVA CARGA

const sqlQuery        = require('../../connection/sqlSENIOR')
const dataSetToJson   = require('../../helpers/dataSetToJson')

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          =  path.join(__dirname, '../../sql/IT/consultas/montaNovaCargaTMS.SQL')
const sqlNovaCargaJSON     = fs.readFileSync(sqlFileName, "utf8")


const geraJsonNovaCarga = async (params) => {
    let { cfg, CdEmpresa, NrSeqControle, danfe } = params
    let sql = eval('`'+sqlNovaCargaJSON+'`');
    
    if(!CdEmpresa)     { return { success: false, message: 'CdEmpresa não informado !!!' }} 
    if(!NrSeqControle) { return { success: false, message: 'NrSeqControle não informado !!!' }} 
    if(!danfe)         { return { success: false, message: 'DANFE não informado !!!' }} 

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

module.exports = geraJsonNovaCarga
