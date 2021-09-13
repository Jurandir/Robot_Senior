// 11/09/2021 10:09 - TESTE - monta JSON

const fs                   = require('fs')
const path                 = require('path')
const sqlFileName          = path.join(__dirname, '../../src/sql/IT/consultas/entrega_comprovantes.SQL' )
const sql                  = fs.readFileSync(sqlFileName, "utf8")
const sqlQuery             = require('../../src/connection/sqlSENIOR')
const dataSetToJson        = require('../../src/helpers/dataSetToJson')

const teste = async () => { 
    let oco   = await sqlQuery(sql)

    console.log(oco)

    let bodys = dataSetToJson(oco)

    console.log(bodys)
    console.log(bodys[0].content.fotosComprovantes)

}

teste()


