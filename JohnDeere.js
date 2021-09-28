//-- Versão Inicial Sênior ( 22/09/2021 )
//-- By : Jurandir Ferreira

// 2 Horas = 7200000 ms
// 1 Dia   = 86400000 ms


require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')      
const colors    = require('colors')
const config    = require('./.config/johnDeere.json') 
const robot     = require('./src/controllers/JD/robot')
const lt        = require('long-timeout')
const label     = `"John Deere"`.green.bold

const titulo  = ` Robô - `.white.bgGreen.bold+`" John Deere "`.white.bgGreen.bold+` - Sênior - ${config.versao} `.white.bgGreen.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

async function loopExecRobot (loopToken) {
    loopToken++
    let uptime = Math.ceil(process.uptime())
    let item   = { count: 3, fnTime:null }

    console.log(moment().format(),`- ( ROBOT ${label} iniciado ) - UP Time: ${uptime}s - loop:`,loopToken)
    await robot(item, config, uptime) 
    
    let proxima   = new Date()
    let intervalo = proxima.getMilliseconds() + config.time
    proxima.setMilliseconds(intervalo)

    console.log(moment().format(),`- ${label} - proxima execução: "${ moment(proxima).format('DD/MM/YYYY HH:mm:ss') }"`)
    lt.setTimeout(loopExecRobot, config.time, loopToken ) 

    // process.exit(0)

}

// Executa Robot
loopExecRobot(0)
