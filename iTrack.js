//-- Versão Inicial Sênior ( 08/09/2021 )
//-- By : Jurandir Ferreira

require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')      
const colors    = require('colors')
const config    = require('./.config/iTrack.json') 
const robot     = require('./src/controllers/IT/robot')


const titulo  = ` Robô - iTrack - Sênior - ${config.versao} `.yellow.bgBlue.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

function loopExecRobot (loopToken) {
    loopToken++
    let uptime = Math.ceil(process.uptime())
    let item   = { count: 3, fnTime:null }

    setTimeout(loopExecRobot, config.validade + config.time, loopToken ) 

    item.count = parseInt( config.validade / config.time ) -1 // Quantidade de vezes que o robô vai executar usando o token atual
    item.fnTime = setInterval(robot, config.time, item, config, uptime) 

    console.log(moment().format(),`- ( ROBOT iTrack iniciado ) - UP Time: ${uptime}s - loop:`,loopToken)

}

// Executa Robot
loopExecRobot(0)
