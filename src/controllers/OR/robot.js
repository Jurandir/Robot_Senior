// 16/09/2021 10:14 - Versão Sênior - ORION - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')

const initCTe                  = require('../../metodsDB/OR/initCTe')
const initOcorrencias          = require('../../metodsDB/OR/initOcorrencias')
const enviaOcorrenciasIniciais = require('../../metodsAPI/OR/enviaOcorrenciasIniciais')
const enviaOcorrenciasOutras   = require('../../metodsAPI/OR/enviaOcorrenciasOutras')
const enviaComprovantes        = require('../../metodsAPI/OR/enviaComprovantes')
const initComprovantes         = require('../../metodsDB/OR/initComprovantes')
const encerraProcessos         = require('../../metodsDB/OR/encerraProcessos')


const robot = async (cli,cfg,uptime) =>{
   let timeOUT = Math.ceil((process.uptime()-2) - uptime)
   let time_inicio = process.uptime()

   // CONTROLE DE EXECUÇÃO
   if( cli.count <=0 ){
        clearInterval(cli.fnTime);
        console.log(moment().format(),`- ( Renovando parâmetros ) - Time: ${timeOUT}s - Orion`)
        return 
   } else {
        console.log(moment().format(),'- Robô em Execução:',cli.count,' - ',timeOUT,'s')
   }
   cli.count--   
   //=======================

   await captura_CTe()                      // CAPTURA DADOS PARA MONITORAMENTO
   await novas_correncias_DB()              // PESQUISA E REGISTRA NOVAS OCORRENCIAS PARA OS CTe´s MONITORADOS
   await envia_ocorrencias_iniciais_API()   // ENVIA AS OCORRENCIAS PARA API ORION - INICIAIS
   await envia_ocorrencias_outras_API()     // ENVIA AS OCORRENCIAS PARA API ORION - OUTRAS
   await prepara_comprovantes_DB()          // PREPARA ESTRUTURA PARA ENVIO DE COMPROVANTES
   await envia_comprovantes_API()           // PESQUISA EXISTENCIA DE COMPROVANTES E ENVIA PARA API
   await encerra_processo()                 // XXX - ENCERRA PROCESSO DE MONITORAMENTO (BD)

   //=======================

   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

   // json LOG
   function jsonLOG (itn,element) { 
        
        if(!itn.dados) {
          itn.dados = {}
        }

        if(!itn.dados[element]) {
          itn.dados[element] = {}
          itn.dados[element].Sucesso = false
          itn.dados[element].Mensagem = `API Error (${element})`
        }
        
     return {
       success: itn.success,
       message: `${itn.body.observacao}`,
       REFID: itn.body.REFID || 0,
       api_success: itn.dados[element].Sucesso || false,              // <- USAR TEMPLATE STRING PARA EVITAR ERRO
       api_message: itn.dados[element].Mensagem || 'API Error',
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
    async function envia_ocorrencias_iniciais_API() {
          let ret = await enviaOcorrenciasIniciais()
          ret.forEach(itn => {
               let log = jsonLOG(itn,'BaixaOcorrenciaResult')
               logEventos(cfg,'(API - ENVIA OCORRÊNCIAS INICIAIS) - Sênior -> ORION:',log) 
          })
          return ret
     }

     // ENVIA AS DEMAIS OCORRENCIAS PARA API ORION
     async function envia_ocorrencias_outras_API() {
          let ret = await enviaOcorrenciasOutras()
          ret.forEach(itn => {
               let log = jsonLOG(itn,'BaixaOcorrenciaResult')
               logEventos(cfg,'(API - ENVIA OCORRÊNCIAS MANUAIS) - Sênior -> ORION:',log) 
          })
          return ret
     }

     // PREPARA ESTRUTURA PARA ENVIO DE COMPROVANTES
     async function prepara_comprovantes_DB() {
          let ret = await initComprovantes()
          logEventos(cfg,'(BD - PREPARA ESTRUTURA PARA ENVIO DE COMPROVANTES) - Sênior -> ORION:',ret) 
          return ret
      }
    
     // PESQUISA EXISTENCIA DE COMPROVANTES E ENVIA PARA API
     async function envia_comprovantes_API() {
          let ret = await enviaComprovantes()
          ret.forEach(itn => {
               let log = jsonLOG(itn,'EvidenciaOcorrenciaResult')
               logEventos(cfg,'(API - PESQUISA EXISTENCIA DE COMPROVANTES - ENVIA P/ API) - Sênior -> ORION:',log) 
          })

          return ret
     }

     // ENCERRA PROCESSOS DE MONITORAMENTO
     async function encerra_processo() {
          let ret = await encerraProcessos()
          logEventos(cfg,'(BD - ENCERRA PROCESSOS) - retEncerraProcessos:',ret)
          return ret
     }

}

module.exports = robot
