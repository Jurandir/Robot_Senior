const geraJsonNovaCarga = require('../../src/metodsDB/IT/geraJsonNovaCarga')
const config            = require('../../.config/iTrack.json') 

let params = {
    cfg           : config,
    CdEmpresa     : 2, 
    NrSeqControle : 4221,
    danfe         : '35210689674782001391550010015177721007675588'
}

async function testa() {

let ret_json = await geraJsonNovaCarga(params)
let str_json = JSON.stringify(ret_json,0,2)
console.log('ret_json:',str_json)

}

testa()


