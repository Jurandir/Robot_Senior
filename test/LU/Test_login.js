const login = require('../../src/metodsAPI/LU/login')

let credenciais   = {
      CompanyId: 373,
      grant_type: "Password",
      username: "373T3rm4c0API",
      password: "T3rm4c0373"
  }

login(credenciais).then((ret)=>{
   console.log(ret)
})
