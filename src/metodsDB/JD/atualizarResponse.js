// 04/10/2021 09:40 - ATUALIZA RESPONSE DO ENVIO - "JOHN DEERE"

const sqlExec       = require('../../connection/sqlExSENIOR')
  
const fs             = require('fs')
const path           = require('path')
const fileName       = path.join(__dirname, '../../sql/JD/rotinas/UPDATE_RESPONSE.SQL')
const sqlRegistraMan = fs.readFileSync(fileName, "utf8") 

async function atualizarResponse(itn) {   
  
      let dados   = {}
      let filexml = itn.xml
      let codigo  = itn.id 
      let retorno = JSON.stringify(itn.retorno)       
      let sql = eval('`'+sqlRegistraMan+'`');
      
      try {
          result = await sqlExec(sql)    

          if (result.rowsAffected==-1){
              throw new Error(`DB ERRO - ${result.Erro}`)
          }
                
          return result
    
      } catch (err) {
          dados = { "erro" : err.message, "rotina" : "atualizarResponse", "sql" : sql, rowsAffected: -1 }
          return dados
      } 
  }

  module.exports = atualizarResponse