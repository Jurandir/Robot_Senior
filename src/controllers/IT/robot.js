// 08/09/2021 11:34 - Versão Sênior - iTrack - By: Jurandir Ferreira

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')


const initNFs               = require('../../metodsDB/IT/initNFs')      
const valida_idCargaPK      = require('./valida_idCargaPK')      
const initTransporte        = require('../../metodsDB/IT/initTransporte')
const registraNF            = require('../../models/IT/registraNF')


// const initTransferencia     = require('../../metodsDB/CF/initTransferencia')
// const initChegada           = require('../../metodsDB/CF/initChegada')
// const initEntregaProgramada = require('../../metodsDB/CF/initEntregaProgramada')
// const initEmRota            = require('../../metodsDB/CF/initEmRota')
// const initEntrega           = require('../../metodsDB/CF/initEntrega')
// const initOcorrencias       = require('../../metodsDB/CF/initOcorrencias')
// const initComprovante       = require('../../metodsDB/CF/initComprovante')
// const encerraProcessos      = require('../../metodsDB/CF/encerraProcessos')
// const transfereNF           = require('../../models/CF/transfereNF')
// const chegadaNF             = require('../../models/CF/chegadaNF')
// const entregaProgramada     = require('../../models/CF/entregaProgramada')
// const rotaEntrega           = require('../../models/CF/rotaEntrega')
// const entregaNF             = require('../../models/CF/entregaNF')
// const ocorrencias           = require('../../models/CF/ocorrencias')
// const comprovante           = require('../../models/CF/comprovante')
// const preparaLinkComprovante = require('../../helpers/preparaLinkComprovante')

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

   await captura_nfs()                   // XXX - INICIA PROCESSO DE MONITORAMENTO (BD CLIENTES ITRACK)
   await valida_idCargaPK(cfg)           // XXX - PESQUISA NA API ITRACK O "IDCARGAPK" OU REGISTRA NOVA CARGA
   await transporte_iniciado()           // 000 - PROCESSO DE TRANSPORTE INICIADO (BD)
   await api_registra_NFs()              // 000 - PROCESSO DE TRANSPORTE INICIADO (API)


   let time_final = process.uptime()
   let time_total = Math.ceil(time_final-time_inicio)

   console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

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
        let retRegistraNF = await registraNF(cfg,cli)
        logEventos(cfg,'(API - REGISTRO NF) - Robô -> API iTrack:',retRegistraNF.message)
        return retRegistraNF
      }
  
  
}

module.exports = robot
