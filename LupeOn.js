//-- Versão Inicial Sênior ( 23/02/2022 09:37 ) - Lupe-ON - V.01
//-- By : Jurandir Ferreira

require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')        

const colors            = require('colors')
const lt                = require('long-timeout')
const config            = require('./.config/lupeon.json')  
const renovaCredenciais = require('./src/controllers/LU/renovaCredenciais')
const robot             = require('./src/controllers/LU/robot')
const label             = `"Lupe-ON - V.01"`.green.bold

const titulo  = ` Robô - `.yellow.bgBlue.bold+`" Lupe-ON - V.01 "`.white.bgBlue.bold+` - Sênior - ${config.versao} `.yellow.bgBlue.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

// Loop renovação dos tokens 
async function renovaToken(loopToken) {
    
    renovaCredenciais()

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

    await robot(loopRobot)    
    lt.setTimeout(runRobot, config.time) 
    return 0
}

async function runInit () {
    // Gera tokens de acesso
    await renovaToken(0)      

    // Run Loop Robot
//    await runRobot()
}

runInit()
