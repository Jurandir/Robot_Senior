const downloadComprovante = require('../../src/metodsAPI/IT/downloadComprovante')

async function testa() {

    let ret_json = await downloadComprovante('RECE17')
    // let str_json = JSON.stringify(ret_json,0,2)
    console.log('ret_json:',ret_json)
    
}
    
testa()
