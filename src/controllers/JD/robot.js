// 27/09/2021 17:07 - Versão Sênior - "JOHN DEERE" - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')

const initManifesto            = require('../../metodsDB/JD/initManifestos')
const initTransbordo           = require('../../metodsDB/JD/initTransbordo')
const initFilialDestino        = require('../../metodsDB/JD/initFilialDestino')
const initRotaEntrega          = require('../../metodsDB/JD/initRotaEntrega')
const confirmaEntrega          = require('../../metodsDB/JD/confirmaEntrega')
const enviaDados               = require('./enviaDados')

const robot = async (cli,cfg,uptime) =>{
   let timeOUT = Math.ceil((process.uptime()) - uptime)
   let time_inicio = process.uptime()

   console.log(moment().format(),`- Robot - Time: ${timeOUT}s`)

   //=======================

   await captura_MANIFESTO()        // SHIP        - CAPTURA DADOS PARA MONITORAMENTO / INICIA MANIFESTO/TRANSPORTE
   await chegou_CD_Transbordo()     // DELIVERY    - FILIAL DE TRANSBORDO
   await chegou_CD_Destino()        // RECEIVE     - CHECOU NO DESTINO / FILIAL DE ENTREGA / DESCARREGAMENTO
   await rota_ENTREGA()             // SHIP-BR     - SAIU EM ROTA DE ENTREGA
   await confirmacao_ENTREGA()      // DELIVERY-BR - REGISTRO DE ENTREGA CONFIRMADA
   await envia_DADOS()              // SEND        - ENVIA DADOS PARA API "JOHN DEERE"

   //=======================

   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

   // CAPTURA DADOS - MANIFESTO EMITIDO
   async function captura_MANIFESTO() {
        let ret = await initManifesto()
        logEventos(cfg,'(BD - CAPTURA MANIFESTOS ) - Sênior -> "JOHN DEERE":',ret) 
        return ret
   }

   // REGISTRO NA FILIAL DE TRANSBORDO
   async function chegou_CD_Transbordo() {
         let ret = await initTransbordo()
         logEventos(cfg,'(BD - REGISTRO NA FILIAL DE TRANSBORDO ) - Sênior -> "JOHN DEERE":',ret) 
         return ret
   }

   // CHECOU NO DESTINO / FILIAL DE ENTREGA / DESCARREGAMENTO
   async function chegou_CD_Destino() {
      let ret = await initFilialDestino()
      logEventos(cfg,'(BD - CHEGOU NO DESTINO / FILIAL DE ENTREGA / DESCARREGAMENTO ) - Sênior -> "JOHN DEERE":',ret) 
      return ret
   }

   // SAIU EM ROTA DE ENTREGA
   async function rota_ENTREGA() {
      let ret = await initRotaEntrega()
      logEventos(cfg,'(BD - EM ROTA DE ENTREGA ) - Sênior -> "JOHN DEERE":',ret) 
      return ret
   }

   // REGISTRO DE ENTREGA CONFIRMADA
   async function confirmacao_ENTREGA() {
      let ret = await confirmaEntrega()
      logEventos(cfg,'(BD - EM ROTA DE ENTREGA ) - Sênior -> "JOHN DEERE":',ret) 
      return ret
   }

   // ENVIA DADOS PARA API "JOHN DEERE"
   async function envia_DADOS() {
      let ret = await enviaDados()
      return ret
   }
   
}

module.exports = robot
