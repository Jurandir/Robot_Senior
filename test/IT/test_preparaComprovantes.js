const preparaComprovantes = require('../../src/controllers/IT/preparaComprovantes')

async function testa() {

    let ret_json = await preparaComprovantes()
    console.log('ret_json:',ret_json)
    console.log('ret_json.links:',ret_json.dados[0].links)
    
}
    
testa()