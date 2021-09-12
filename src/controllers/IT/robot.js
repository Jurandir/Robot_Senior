// 08/09/2021 11:34 - Versão Sênior - iTrack - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')


const initNFs                = require('../../metodsDB/IT/initNFs')      
const valida_idCargaPK       = require('./valida_idCargaPK')      
const initTransporte         = require('../../metodsDB/IT/initTransporte')
const registraNF             = require('../../models/IT/registraNF')
const initOcorrencias        = require('../../metodsDB/IT/initOcorrencias')
const initTransferencia      = require('../../metodsDB/IT/initTransferencia')
const transfereNF            = require('../../models/IT/transfereNF')
const initChegada            = require('../../metodsDB/IT/initChegada')
const chegadaNF              = require('../../models/IT/chegadaNF')
const initEmRota             = require('../../metodsDB/IT/initEmRota')
const rotaEntrega            = require('../../models/IT/rotaEntrega')
const initEntrega            = require('../../metodsDB/IT/initEntrega')
const entregaNF              = require('../../models/IT/entregaNF')
const initComprovante        = require('../../metodsDB/IT/initComprovante')
const preparaComprovante     = require('../../controllers/IT/preparaComprovantes')
const comprovantes           = require('../../models/IT/comprovantes')
const ocorrencias            = require('../../models/IT/ocorrencias')
const encerraProcessos       = require('../../metodsDB/IT/encerraProcessos')


// const initEntregaProgramada = require('../../metodsDB/IT/initEntregaProgramada')
// const entregaProgramada     = require('../../models/IT/entregaProgramada')

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

                                         /// ENTREGA PROGRAMADA NÃO FEITA ROTINA ESPECIFICA (91)

   await captura_nfs()                   // XXX - INICIA PROCESSO DE MONITORAMENTO (BD CLIENTES ITRACK)
   await valida_idCargaPK(cfg)           // XXX - PESQUISA NA API ITRACK O "IDCARGAPK" OU REGISTRA NOVA CARGA
   await transporte_iniciado()           // 000 - PROCESSO DE TRANSPORTE INICIADO (BD)
   await api_registra_NFs()              // 000 - PROCESSO DE TRANSPORTE INICIADO (API)
   await ocorrencias_manuais()           // XXX - OCORRENCIAS MANUAIS - SÊNIOR (DB)
   await transferencia_entre_filiais()   // 101 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS (BD)
   await api_transferencia_NFs()         // 101 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS (API)
   await chegada_filial_destino()        // 098 - CHEGADA NA CIDADE OU FILIAL DE DESTINO (BD)
   await api_chegada_filial()            // 098 - CHEGADA NA CIDADE OU FILIAL DE DESTINO (API)
   await em_rota_entrega()               // 100 - EM ROTA PARA ENTREGA (BD)
   await api_em_rota_entrega()           // 100 - EM ROTA PARA ENTREGA (API)
   await confirmacao_entrega()           // 001 - ENTREGA REALIZADA NORMALMENTE (BD)
   await api_confirmacao_entrega()       // 001 - ENTREGA REALIZADA NORMALMENTE (API)
   await API_ocorrencias_manuais()       // XXX - OCORRENCIAS MANUAIS (API) 
   await comprovante_entrega_BD()        // 999 - COMPROVANTE DE ENTREGA (BD)
   await comprovante_entrega_FILE()      // 999 - COMPROVANTE DE ENTREGA (FILE - API LOCAL)
   await API_comprovante_entrega()       // 999 - COMPROVANTE DE ENTREGA (API)
   await encerra_processo()              // XXX - ENCERRA PROCESSO DE MONITORAMENTO (BD)


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
        let retInitNFs = await initNFs(cli)
        logEventos(cfg,'(BD - CAPTURA NFs) - Sênior -> iTrack:',retInitNFs) 
        return retInitNFs
   }

   // PROCESSO DE TRANSPORTE INICIADO
    async function transporte_iniciado() {
        let retInitTransporte = await initTransporte()
        logEventos(cfg,'(BD - PROCESSO DE TRANSPORTE INICIADO) - OCORRÊNCIA (000) Itrack:',retInitTransporte)
        return retInitTransporte
    }

    // REGISTRA INICIO NA API
    async function api_registra_NFs() {
        let ret = await registraNF()
        ret.forEach(itn => {
             let log = jsonLOG(itn)
             logEventos(cfg,'(API - REGISTRO NF) - Robô -> API iTrack:',log)
        })
        return 1
     }

    // OCORRENCIAS MANUAIS BD
    async function ocorrencias_manuais() {
          let retInitOcorrencias = await initOcorrencias()
          logEventos(cfg,'(BD - OCORRENCIAS MANUAIS) - retInitOcorrencias:',retInitOcorrencias)
          return { retInitOcorrencias }
     } 

     // DB - (101) - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS
     async function transferencia_entre_filiais() {
          let retInitTransferencia = await initTransferencia()
          logEventos(cfg,'(BD - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS) - iTrack:',retInitTransferencia)
          return 1
     }

     // API - (101) - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS 
     async function api_transferencia_NFs() {
          let ret = await transfereNF()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,'(API - TRANSFERENCIA ENTRE FILIAIS) - iTrack:',log)
          })
          return 1
     }

     // DB - (098) - CHEGADA NA CIDADE OU FILIAL DE DESTINO 
     async function chegada_filial_destino() {
          let retInitChegada = await initChegada()
          logEventos(cfg,'(BD - CHEGADA NA CIDADE OU FILIAL DE DESTINO) - iTrack:',retInitChegada)
          return 1
     }  
     
     // API - (098) - CHEGADA NA CIDADE OU FILIAL DE DESTINO      
     async function api_chegada_filial() {
          let ret = await chegadaNF()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,`(API - CHEGADA NA CIDADE OU FILIAL DE DESTINO) - iTrack:`,log)
          })
          return 1
     }

     // DB - (100) - EM ROTA PARA ENTREGA
     async function em_rota_entrega() {
          let retInitEmRota = await initEmRota()
          logEventos(cfg,'(BD - EM ROTA PARA ENTREGA) - iTrack:',retInitEmRota)
          return 1
     }

     // API - (100) - EM ROTA PARA ENTREGA
     async function api_em_rota_entrega() {
          let ret = await rotaEntrega()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,`(API - EM ROTA DE ENTREGA) - iTrack:`,log)
          })
          return 1
     }   

    // DB - (001) - ENTREGA REALIZADA NORMALMENTE
    async function confirmacao_entrega() {
          let retInitEntrega = await initEntrega()
          logEventos(cfg,'(BD - ENTREGA REALIZADA NORMALMENTE) - iTrack:',retInitEntrega)
          return 1
     }     

     // API - (001) - ENTREGA REALIZADA NORMALMENTE
     async function api_confirmacao_entrega() {
          let ret = await entregaNF()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,`(API - REGISTRO DE ENTREGA) - iTrack:`,log)
          })
          return 1
     }   

     // COMPROVANTE DE ENTREGA
     async function comprovante_entrega_BD() {
          let retInitComprovante = await initComprovante()
          logEventos(cfg,'(BD - COMPROVANTE) - iTrack:',retInitComprovante)
          return 1
     }
 
     // AVISA A API PARA DOWNLOAD DO COMPROVANTE - PREPARA API LOCAL
     async function comprovante_entrega_FILE() {
          let ret = await preparaComprovante(cfg)
          ret.dados.forEach(itn => {
               let log = {
                    success: true,
                    idCargaPK:  itn.IDCARGA,
                    links:  itn.links
               }
               logEventos(cfg,`(FILE - COMPROVANTE - PREPARA API LOCAL) - iTrack:`,log)
          })
          return 1
     }

     // ENVIA LINKS DOS COMPROVANTES DE ENTREGA
     async function API_comprovante_entrega() {
         let ret = await comprovantes()
         ret.forEach(itn => {
          let log = jsonLOG(itn)
          let msg = { success: true, response: log }
          logEventos(cfg,`(API - ENTREGA - ENVIA COMPROVANTE) - iTrack:`,msg)
         })
          return 1
     }

     // API - (XXX) - OCORRENCIAS MANUAIS 
     async function API_ocorrencias_manuais() {
          let ret = await ocorrencias()
          ret.forEach(itn => {
               let log = jsonLOG(itn)
               logEventos(cfg,`(API - OCORRÊNCIAS MANUAIS) - iTrack:`,log)
          })
          return 1
     }   
     
     // ENCERRA PROCESSOS DE MONITORAMENTO
     async function encerra_processo() {
          let retEncerraProcessos = await encerraProcessos()
          logEventos(cfg,'(BD - ENCERRA PROCESSOS) - retEncerraProcessos:',retEncerraProcessos)
          return 1
     }

}

module.exports = robot
