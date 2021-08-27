const loadAPI = require('../helpers/loadAPI')

const login = async (cfg) => {
    let method   = 'POST'
    let endpoint = ''
    let server   = cfg.loginURL
    let params   = { 
        email: cfg.user,
        senha: cfg.pwd
    }
   
    let ret = await loadAPI(method,endpoint,server,params)

    return ret

}

module.exports = login
