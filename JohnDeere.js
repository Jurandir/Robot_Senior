//-- Versão Inicial Sênior ( 22/09/2021 )
//-- By : Jurandir Ferreira

// 2 Horas = 432000000 ms
// 1 Dia   = 5184000000 ms


require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')      
const colors    = require('colors')
const config    = require('./.config/johnDeere.json') 
// const robot     = require('./src/controllers/JD/robot')

const titulo  = ` Robô - `.yellow.bgBlue.bold+`" John Deere "`.white.bgBlue.bold+` - Sênior - ${config.versao} `.yellow.bgBlue.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

function loopExecRobot (loopToken) {
    loopToken++
    let uptime = Math.ceil(process.uptime())
    let item   = { count: 3, fnTime:null }

    setTimeout(loopExecRobot, config.validade + config.time, loopToken ) 

    item.count = parseInt( config.validade / config.time ) -1 // Quantidade de vezes que o robô vai executar usando o token atual
    item.fnTime = setInterval(robot, config.time, item, config, uptime) 

    console.log(moment().format(),`- ( ROBOT "John Deere" iniciado ) - UP Time: ${uptime}s - loop:`,loopToken)

}

// Executa Robot
loopExecRobot(0)
