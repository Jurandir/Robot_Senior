// 01/10/2021 16:21 - TESTE DE ENVIO PARA API

const sqlQuery             = require('../../src/connection/sqlSENIOR')
const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../src/sql/JD/consultas/LISTA.SQL')
const sqlInit              = fs.readFileSync(sqlFileName, "utf8")

const montaXML = require('../../src/models/JD/montaXML')
const enviaXML = require('../../src/metodsAPI/JD/enviaXML')

async function testa() {

    let dados = await sqlQuery(sqlInit)

    for await (let itn of dados) {
        let ret_json = await montaXML(itn)
        console.log('>',ret_json.fullName)
        if(ret_json.success){
            let ret = await enviaXML(ret_json)
            console.log('Retorno > ',ret)
        }
    }
}

testa()