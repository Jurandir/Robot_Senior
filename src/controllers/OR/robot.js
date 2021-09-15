// 15/09/2021 15:20 - Versão Sênior - ORION - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')

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

   captura_nfs() // CAPTURA DADOS PARA MONITORAMENTO



   //=======================

   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

   // json LOG
   function jsonLOG (itn) { 
        return {
          success: itn.success,
          message: `API: ${itn.data.message ? itn.data.message : 'OK' }, UPD: ${itn.upd.message}`,
          idCargaFk: itn.body.content.idCargaFk,
          api: itn.data.success,
          upd: itn.upd.success
        }
    }

   // CAPTURA NFs 
   async function captura_nfs() {
     //   let ret = await initNFs(cli)
        ret = {
             success: true,
             message: 'Test'
        }
        logEventos(cfg,'(BD - CAPTURA NFs) - Sênior -> ORION:',ret) 
        return ret
   }


}

module.exports = robot
