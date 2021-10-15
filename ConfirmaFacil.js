//-- Versão Inicial Sênior ( 08/10/2021 15:33 ) - Confirma Facil v2 - "Multi Sessão / Multi Empresa"
//-- By : Jurandir Ferreira

require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')        

const colors      = require('colors')
const lt          = require('long-timeout')
const config      = require('./.config/confirmaFacil.json') 
const getClientes = require('./src/metodsDB/CF2/getClientes')
const updToken    = require('./src/metodsDB/CF2/updToken')
const login       = require('./src/metodsAPI/CF/login')
const robot2      = require('./src/controllers/CF/robot_V2')
const label       = `"Confirma Facil v2"`.green.bold

const titulo  = ` Robô - `.yellow.bgBlue.bold+`" ConfirmaFacil V2 "`.white.bgBlue.bold+` - Sênior - ${config.versao} `.yellow.bgBlue.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

// Loop renovação dos token de acesso dos clientes
async function renovaToken(loopToken) {
    let lista = await getClientes()
    for await ( itn of lista ) {
        let params = {
            loginURL: config.loginURL,
            user: itn.EMAIL,
            pwd: itn.SENHA,
            id: itn.ID
        }
        let ret = await login(params)
        if(ret.success){
            itn.TOKEN = ret.data.resposta.token
            let grv = await updToken(itn)
            console.log(moment().format(),`- ( TOKEN RENOVADO "${itn.TOKEN}" - ${grv.message} )`,itn.ID,itn.NOME)
        } else {
            console.log(moment().format(),`- ( PROBLEMAS AO TOKEN RENOVADO )`,itn.ID,itn.NOME,ret) 
        }
    }

    let proxima   = new Date()
    let intervalo = proxima.getMilliseconds() + config.validade
    proxima.setMilliseconds(intervalo)

    console.log(moment().format(),`- ${label} - proxima renovação: "${ moment(proxima).format('DD/MM/YYYY HH:mm:ss') }"`)
    lt.setTimeout(renovaToken, config.validade, loopToken ) 
    return 0
}

// Loop de execução do Robot
let loopRobot = 0
async function runRobot () {
    loopRobot++
    console.log(moment().format(),`- ${label} - Loop: ${loopRobot}`)

    await robot2(loopRobot)    
    lt.setTimeout(runRobot, config.time) 
    return 0
}

async function runInit () {
    // Gera tokens de acesso
    await renovaToken(0)      

    // Run Loop Robot
    await runRobot()
}

runInit()
