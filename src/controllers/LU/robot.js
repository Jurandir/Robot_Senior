//-- Robot Sênior ( 25/02/2022 14:36 ) - Lupe-ON - V.01 - By: Jurandir Ferreira

const moment                 = require('moment')
const logEventos             = require('../../helpers/logEventos')
const cfg                    = require('../../../.config/lupeon.json')    
const initNFs                = require('../../metodsDB/LU/initNFs')                 
const initComprovante        = require('../../metodsDB/LU/initComprovante')
const fechaFase              = require('../../metodsDB/LU/updFechaFase')
const envioPOD               = require('./envioPOD')

const robot = async (loopRobot) =>{
    let time_inicio = process.uptime()
  
    await captura_nfs()                     // XXX - INICIA PROCESSO DE MONITORAMENTO (BD)
    await prepara_comprovantes()            // 999 - PREPARA COMPROVANTES (BD)
    await envio_api_POD()                   // API - ENVIA POD
    await fechaFase()                       // Finaliza acompanhamento p/ comprovantes enviados

    let time_final = process.uptime()
    let time_total = Math.ceil(time_final-time_inicio)
 
    console.log(`Fim - Loop: ${loopRobot} - Exec - Robô.`,time_total,'s')

   // ======================== ROTINAS ===============================
    // CAPTURA NFs 
    async function captura_nfs() {
      let ret = await initNFs()
      logEventos(cfg,'(BD - CAPTURA NFs) - (Lupe-ON):',ret) 
      return 0
   }

    // PREPARA COMPROVANTES
    async function prepara_comprovantes() {
      let ret = await initComprovante()
      logEventos(cfg,'(BD - PREPARA COMPROVANTES) - (Lupe-ON):',ret)
      return 0
    }

    // ENVIO API POD
    async function envio_api_POD() {
      let ret = await envioPOD()
      return 0
    }
    

   return 
}

module.exports = robot
