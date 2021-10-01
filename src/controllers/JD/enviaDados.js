// 01/10/2021 17:44 - ENVIO DE DADOS PARA API - "JONH DEERE"

const sqlQuery             = require('../../src/connection/sqlSENIOR')
const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../src/sql/JD/consultas/LISTA.SQL')
const sqlInit              = fs.readFileSync(sqlFileName, "utf8")

const montaXML = require('../../models/JD/montaXML')
const enviaXML = require('../../metodsAPI/JD/enviaXML')

async function enviaDados(itn) {

    let dados = await sqlQuery(sqlInit)

    for await (let itn of dados) {
        let ret_json = await montaXML(itn)
        console.log(moment().format(),'- Arquivo :',ret_json.fullName) 
        if(ret_json.success){
            let ret = await enviaXML(ret_json)
            console.log('Response > ',ret)
        }
    }

}
module.exports = enviaDados    