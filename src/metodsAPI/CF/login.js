const loadAPI = require('../../helpers/loadAPI')

const login = async (cfg) => {
    let method   = 'POST'
    let endpoint = ''
    let server   = cfg.loginURL
    if(cfg.run=='Test') {
        server  = 'http://localhost:4999/test/Login' // Endpoint FAKE
     }  
    let params   = { 
        email: cfg.user,
        senha: cfg.pwd,
        idcliente: cfg.id
    }
   
    let ret = await loadAPI(method,endpoint,server,params)

    return ret

}

module.exports = login
