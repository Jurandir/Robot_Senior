//-- Versão Inicial ( 27/08/2021 )
//-- By : Jurandir Ferreira

require('dotenv').config()
const moment = require('moment')

moment.locale('pt-br')        

const colors    = require('colors')
const clientes  = require('./config/clientes.json')
const login     = require('./src/metodsAPI/login')
const robot     = require('./src/controllers/robot')

const config  = { 
    versao: process.env.VERSAO,
    time: process.env.TIME_INTERVALO * 1000,          // Intervalo de execução do robô ( TIME_INTERVALO = 10s )
    validade: process.env.TIME_VALIDADE_TOKEN * 1000, // Validade do token na API ( TIME_VALIDADE_TOKEN = 5400s )
    loginURL: process.env.URL_LOGIN, 
    embarqueURL: process.env.URL_EMBARQUE , 
    comprovanteURL: process.env.URL_COMPROVANTE,
    debug: process.env.DEBUG,
    user: process.env.USUARIO,
    pwd: process.env.SENHA
}

const titulo  = ` Robô - ConfirmaFacil - ${config.versao} `.yellow.bgBlue.bold 

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
