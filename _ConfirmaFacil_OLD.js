//-- Versão Inicial Sênior ( 30/08/2021 )
//-- By : Jurandir Ferreira

require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')        

const colors    = require('colors')
const config    = require('./.config/confirmaFacil.json') 
const clientes  = require('./.config/CF/clientes.json')
const login     = require('./src/metodsAPI/CF/login')
const robot     = require('./src/controllers/CF/robot')

const titulo  = ` Robô - `.yellow.bgBlue.bold+`" ConfirmaFacil "`.white.bgBlue.bold+` - Sênior - ${config.versao} `.yellow.bgBlue.bold 

process.stdout.write('\x1B[2J\x1B[0f')
console.log(titulo)

function setToken (loopToken) {
    loopToken++
    let uptime = Math.ceil(process.uptime()-1)
    setTimeout(setToken, config.validade + config.time, loopToken ) 
    clientes.forEach(item=>{
        login(config).then( ret => {
            if(ret.success) {
                item.login = ret.data
                item.count = parseInt( config.validade / config.time ) -1 // Quantidade de vezes que o robô vai executar usando o token atual
                item.fnTime = setInterval(robot, config.time, item, config, uptime)    
                console.log(moment().format(),`- ( TOKEN RENOVADO ) - ${item.login.resposta.token} - UP Time: ${uptime}s - loop:`,loopToken)

            } else {
                console.log(moment().format(),`- ( ERRO - RENOVAR TOKEN ) - ${item.nome}`,ret)
            }
        })
    })
}

// Run
setToken(0)
