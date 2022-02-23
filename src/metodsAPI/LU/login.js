// 23/02/2022 10:23 - Login Lupe-ON

const cfg     = require('../../../.config/lupeon.json')
const loadAPI = require('../../helpers/loadAPI')

const login = async (credenciais) => {
    let method   = 'POST'
    let endpoint = ''
    let server   = cfg.loginURL
    let params   = {
        grant_type: credenciais.grant_type,
        username:   credenciais.username,
        password:   credenciais.password
    }
   
    let ret = await loadAPI(method,endpoint,server,params,0,{ CompanyId: credenciais.CompanyId })

    return ret

}

module.exports = login
