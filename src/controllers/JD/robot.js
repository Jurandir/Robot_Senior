// 27/09/2021 17:07 - Versão Sênior - "JOHN DEERE" - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')

const initManifesto            = require('../../metodsDB/JD/initManifestos')


const robot = async (cli,cfg,uptime) =>{
   let timeOUT = Math.ceil((process.uptime()) - uptime)
   let time_inicio = process.uptime()

   console.log(moment().format(),`- Robot - Time: ${timeOUT}s`)

   //=======================

   await captura_MANIFESTO()                // CAPTURA DADOS PARA MONITORAMENTO
//   await chegou_CD()                      // 
//   await chegou_CD_Destino()              // 
//   await chegou_CD()                      // 
//   await mapaEntrega()                    // 
//   await entregaFinal()                   // 


   //=======================

   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

   // CAPTURA CTe´s 
   async function captura_MANIFESTO() {
        let ret = await initManifesto()
        logEventos(cfg,'(BD - CAPTURA MANIFESTOS ) - Sênior -> "JONH DEERE":',ret) 
        return ret
   }

}

module.exports = robot
