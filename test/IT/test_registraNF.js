const registraNF = require('../../src/models/IT/registraNF')

async function testa() {

    let ret_json = await registraNF()
    // let str_json = JSON.stringify(ret_json,0,2)
    console.log('ret_json:',ret_json)
    
}
    
testa()