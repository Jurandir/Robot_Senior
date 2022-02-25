// 23/02/2022 11:18 - Renova o token e grava no BD

const moment   = require('moment')
const login    = require('../../metodsAPI/LU/login')
const getToken = require('../../metodsDB/LU/getToken')
const updToken = require('../../metodsDB/LU/updToken')

const renovaCredenciais = async () => {
    let tokens  = []
    let retorno = {
        success: false,
        message: '',
        data: []
    }

    try {
        tokens = await getToken()
        retorno.success = ( tokens.length > 0 )

        for await (let token of tokens) {
            let api = {}
            let upd = {}
            let update = {}

            let credenciais = {
                grant_type: "Password",
                CompanyId:  token.ID,
                username:   token.USUARIO,
                password:   token.SENHA
            }

            api = await login(credenciais)
            retorno.success = retorno.success && api.success

            // let ExpiresIn = new Date(Date.now()+ 1*60*60*1000) // soma 1 hora
            let ExpiresIn = new Date(Date.now() + api.data.ExpiresIn * 1000 ) // soma retorno da API em milesegundos
            let validade  = moment(ExpiresIn).format('YYYY-MM-DD HH:mm:ss')

            upd = {
                ID: token.ID,
                TOKEN: api.data.AccessToken ,
                CREATE: moment().format('YYYY-MM-DD HH:mm:ss'),
                VALIDADE: validade
            }

            update = await updToken(upd)

            retorno.success = retorno.success && update.success

            if(retorno.success) {
                console.log(moment().format(),`- ( TOKEN RENOVADO ) - ID: ${token.ID} - Validade:`,validade)
            } else {
                console.log(moment().format(),`- ( PROBLEMAS AO TOKEN RENOVADO )`,token.ID)
            }

            retorno.data.push({
                tokens: tokens,
                credenciais: credenciais,
                api: api,
                update: update
            })
        }
    } catch (err) {
        retorno.success = false
        retorno.message = err
    }

    return retorno
}

module.exports = renovaCredenciais
