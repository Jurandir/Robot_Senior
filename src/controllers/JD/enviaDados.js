// 01/10/2021 17:44 - ENVIO DE DADOS PARA API - "JOHN DEERE"

const moment      = require('moment')
const sqlQuery    = require('../../connection/sqlSENIOR')
const fs          = require('fs')
const path        = require('path')
const sqlFileName = path.join(__dirname, '../../sql/JD/consultas/LISTA.SQL')
const sqlInit     = fs.readFileSync(sqlFileName, "utf8")

const montaXML = require('../../models/JD/montaXML')
const enviaXML = require('../../metodsAPI/JD/enviaXML')

async function enviaDados(itn) {

    let dados = await sqlQuery(sqlInit)

    if(!Array.isArray(dados)) {
        console.log(moment().format(),'enviaDados.js - enviaDados():',dados)    
        return 0
    }

    for await (let itn of dados) {
        let ret_json = await montaXML(itn)
        console.log(moment().format(),'- Arquivo :',ret_json.fullName) 
        if(ret_json.success){
            let ret = await enviaXML(ret_json)
            console.log('API - JD - Response > ',ret)
        }
    }

}
module.exports = enviaDados    