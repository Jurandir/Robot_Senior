// 01/10/2021 16:08 - ATUALIZA STATUS DO ENVIO - "JONH DEERE"
const sqlExec       = require('../../connection/sqlExSENIOR')
  
const fs             = require('fs')
const path           = require('path')
const fileName       = path.join(__dirname, '../../sql/JD/rotinas/UPDATE_ENVIO.SQL')
const sqlRegistraMan = fs.readFileSync(fileName, "utf8") 

async function atualizaEnvio(itn) {   
  
      let dados   = {}
      let filexml = itn.xml
      let codigo  = itn.id 
      let sql = eval('`'+sqlRegistraMan+'`');
      
      try {
          result = await sqlExec(sql)    

          if (result.rowsAffected==-1){
              throw new Error(`DB ERRO - ${result.Erro}`)
          }
                
          return result
    
      } catch (err) {
          dados = { "erro" : err.message, "rotina" : "atualizaEnvio", "sql" : sql, rowsAffected: -1 }
          return dados
      } 
  }

  module.exports = atualizaEnvio