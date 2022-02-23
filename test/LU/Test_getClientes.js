const getClientes = require('../../src/metodsDB/LU/getClientes')

getClientes().then((ret)=>{
   console.log(ret)
})
