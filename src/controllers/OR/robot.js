// 16/09/2021 10:14 - Versão Sênior - ORION - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')

const initCTe               = require('../../metodsDB/OR/initCTe')
const initOcorrencias       = require('../../metodsDB/OR/initOcorrencias')
const enviaOcorrencias      = require('../../metodsAPI/OR/enviaOcorrencias')

const robot = async (cli,cfg,uptime) =>{
   let timeOUT = Math.ceil((process.uptime()-2) - uptime)
   let time_inicio = process.uptime()

   // CONTROLE DE EXECUÇÃO
   if( cli.count <=0 ){
        clearInterval(cli.fnTime);
        console.log(moment().format(),`- ( Renovando parâmetros ) - Time: ${timeOUT}s - iTrack`)
        return 
   } else {
        console.log(moment().format(),'- Robô em Execução:',cli.count,' - ',timeOUT,'s')
   }
   cli.count--   
   //=======================

   captura_CTe()           // CAPTURA DADOS PARA MONITORAMENTO
   novas_correncias_DB()   // PESQUISA E REGISTRA NOVAS OCORRENCIAS PARA OS CTe´s MONITORADOS
   novas_correncias_API()  // ENVIA AS OCORRENCIAS PARA API ORION


   //=======================

   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

   // json LOG
   function jsonLOG (itn) { 
     return {
       success: itn.success,
       message: `${itn.body.observacao}`,
       REFID: itn.body.REFID || 0,
       api_success: itn.dados.BaixaOcorrenciaResult.Sucesso || false,
       api_message: itn.dados.BaixaOcorrenciaResult.Mensagem || 'API Error',
       upd_success: itn.grv.success || false,
       upd_message: `${itn.grv.message || 'upd Error' }, Affected: ${itn.grv.rowsAffected || -1}`
     }
   }

   // CAPTURA CTe´s 
   async function captura_CTe() {
        let ret = await initCTe()
        logEventos(cfg,'(BD - CAPTURA CTe´s ) - Sênior -> ORION:',ret) 
        return ret
   }

    // PESQUISA NOVAS OCORRENCIAS PARA OS CTe´s MONITORADOS
    async function novas_correncias_DB() {
        let ret = await initOcorrencias()
        logEventos(cfg,'(BD - NOVAS OCORRÊNCIAS REGISTRADAS) - Sênior -> ORION:',ret) 
        return ret
    }

    // ENVIA AS OCORRENCIAS PARA API ORION
    async function novas_correncias_API() {
          let ret = await enviaOcorrencias()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,'(API - ENVIA OCORRÊNCIAS) - Sênior -> ORION:',log) 
          })
     return ret
 }
  
}

module.exports = robot
