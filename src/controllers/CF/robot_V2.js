// 08/10/2021 11:11 - Versão Sênior - "Robot CF V2" - By: Jurandir Ferreira

// TEST

const moment                = require('moment')
const logEventos            = require('../../helpers/logEventos')
const cfg                   = require('../../../.config/confirmaFacil.json')    

const initNFs               = require('../../metodsDB/CF2/initNFs')                 
const initTransporte        = require('../../metodsDB/CF2/initTransporte')
const initOcorrencias       = require('../../metodsDB/CF2/initOcorrencias')
const registraNF            = require('../../models/CF2/registraNF')
const initTransferencia     = require('../../metodsDB/CF2/initTransferencia')
const transfereNF           = require('../../models/CF2/transfereNF')

const initChegada           = require('../../metodsDB/CF2/initChegada')
const chegadaNF             = require('../../models/CF2/chegadaNF')


//const initEntregaProgramada = require('../../metodsDB/CF2/initEntregaProgramada')
//const initEmRota            = require('../../metodsDB/CF2/initEmRota')
//const initEntrega           = require('../../metodsDB/CF2/initEntrega')
//const initComprovante       = require('../../metodsDB/CF2/initComprovante')
//const encerraProcessos      = require('../../metodsDB/CF2/encerraProcessos')
//const entregaProgramada     = require('../../models/CF2/entregaProgramada')
//const rotaEntrega           = require('../../models/CF2/rotaEntrega')
//const entregaNF             = require('../../models/CF2/entregaNF')
//const ocorrencias           = require('../../models/CF2/ocorrencias')
//const comprovante           = require('../../models/CF2/comprovante')

//const preparaLinkComprovante = require('../../helpers/preparaLinkComprovante')

const robot_V2 = async (loopRobot) =>{
    let time_inicio = process.uptime()
   
//-    await captura_nfs()                   // XXX - INICIA PROCESSO DE MONITORAMENTO (BD)
//-    await transporte_iniciado()           // 000 - PROCESSO DE TRANSPORTE INICIADO (BD)

//-    await api_registra_NFs()              // 000 - PROCESSO DE TRANSPORTE INICIADO (API)

//-    await ocorrencias_manuais()           // XXX - OCORRENCIAS MANUAIS (BD) 

//-    await transferencia_entre_filiais()     // 101 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS (BD)
//-    await api_transferencia_entre_filiais() // 101 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS (API)

//    await chegada_filial_destino()        // 098 - CHEGADA NA CIDADE OU FILIAL DE DESTINO (BD)
    await api_chegada_filial_destino()    // 098 - CHEGADA NA CIDADE OU FILIAL DE DESTINO (API)



    //await entrega_programada()            // 091 - ENTREGA PROGRAMADA (BD,API)
    //await em_rota_entrega()               // 100 - EM ROTA PARA ENTREGA (BD,API)
    //await API_ocorrencias_manuais()       // XXX - OCORRENCIAS MANUAIS (API)
    //await confirmacao_entrega()           // 001 - ENTREGA REALIZADA NORMALMENTE (BD,API)
    //await comprovante_entrega_BD()        // 999 - COMPROVANTE DE ENTREGA (BD)
    //await comprovante_entrega_FILE()      // 999 - COMPROVANTE DE ENTREGA (FILE,API LOCAL)
    //await API_comprovante_entrega()       // 999 - COMPROVANTE DE ENTREGA (API)
    //await encerra_processo()              // XXX - ENCERRA PROCESSO DE MONITORAMENTO (BD)

    let time_final = process.uptime()
    let time_total = Math.ceil(time_final-time_inicio)
 
    console.log(`Fim - Loop: ${loopRobot} - Exec - Robô.`,time_total,'s')

   // ======================== ROTINAS ===============================
    // CAPTURA NFs 
    async function captura_nfs() {
      let ret = await initNFs()
      logEventos(cfg,'(BD - CAPTURA NFs) - (CF - V2):',ret) 
      return 0
   }

    // PROCESSO DE TRANSPORTE INICIADO
    async function transporte_iniciado() {
      let ret = await initTransporte()
      logEventos(cfg,'(BD - PROCESSO DE TRANSPORTE INICIADO) - (CF - V2):',ret)
      return 0
    }

    // OCORRENCIAS MANUAIS BD
    async function ocorrencias_manuais() {
      let ret = await initOcorrencias()
      logEventos(cfg,'(BD - OCORRENCIAS MANUAIS) - (CF - V2):',ret)

      return 0 
   }   

    // REGISTRA INICIO NA API
    async function api_registra_NFs() {
      let ret = await registraNF()
      for await (itn of ret) {
        let log = {
          success : itn.success,
          message : itn.message
        }
         logEventos(cfg,`${itn.raiz} - (API - REGISTRO NF ) - (CF - V2):`,log)
      }   
      return 0
    }

    // BD - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS
    async function transferencia_entre_filiais() {
      let ret = await initTransferencia()
      logEventos(cfg,'(BD - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS) - (CF - V2):',ret)
    }

    // API - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS
    async function api_transferencia_entre_filiais() {
      let ret = await transfereNF()
      for await (itn of ret) {
        let log = {
          success : itn.success,
          message : itn.message
        }
         logEventos(cfg,`${itn.raiz} - (API - TRANSFERENCIA ENTRE FILIAIS ) - (CF - V2):`,log)
      }   
      return 0
    }

    // BD - CHEGADA NA CIDADE OU FILIAL DE DESTINO -- ( 098 passou para manual)
    async function chegada_filial_destino() {
      let ret = await initChegada()
      logEventos(cfg,'(BD - CHEGADA NA CIDADE OU FILIAL DE DESTINO) - (CF - V2):',ret)
      return 0
    }

    // API - CHEGADA NA CIDADE OU FILIAL DE DESTINO -- ( 098 passou para manual)
    async function api_chegada_filial_destino() {
      let ret = await chegadaNF()
      for await (itn of ret) {
        let log = {
          success : itn.success,
          message : itn.message
        }
         logEventos(cfg,`${itn.raiz} - (API - CHEGADA NA FILIAL ) - (CF - V2):`,log)
      }   
      return 0
    }


   /*

    // OCORRENCIAS MANUAIS API
    async function API_ocorrencias_manuais() {
       let retOcorrencias = await ocorrencias(cfg,cli)
       logEventos(cfg,'(API - OCORRÊNCIAS MANUAIS) - retOcorrencias:',retOcorrencias)
       return { retOcorrencias }
    }   

    // ENTREGA PROGRAMADA
    async function entrega_programada() {
      let retInitEntregaProgamada = await initEntregaProgramada()
      logEventos(cfg,'(BD - ENTREGA PROGRAMADA) - retInitEntregaProgamada:',retInitEntregaProgamada)

      let retEntregaProgramada = await entregaProgramada(cfg,cli)
      logEventos(cfg,'(API - ENTREGA PROGRAMADA) - retEntregaProgramada:',retEntregaProgramada)
      return { retInitEntregaProgamada, retEntregaProgramada }
    }

    // EM ROTA PARA ENTREGA
    async function em_rota_entrega() {
      let retInitEmRota = await initEmRota()
      logEventos(cfg,'(BD - EM ROTA PARA ENTREGA) - retInitEmRota:',retInitEmRota)

      let retRotaEntrega = await rotaEntrega(cfg,cli)
      logEventos(cfg,'(API - EM ROTA DE ENTREGA) - retRotaEntrega:',retRotaEntrega)
      return { retInitEmRota, retRotaEntrega }
    }
        
    // ENTREGA REALIZADA NORMALMENTE
    async function confirmacao_entrega() {
      let retInitEntrega = await initEntrega()
      logEventos(cfg,'(BD - ENTREGA REALIZADA NORMALMENTE) - retInitEntrega:',retInitEntrega)

      let retEntregaNF = await entregaNF(cfg,cli)
      logEventos(cfg,'(API - REGISTRO DE ENTREGA) - retEntregaNF:',retEntregaNF.message)
      return { retInitEntrega, retEntregaNF }
    }

    // COMPROVANTE DE ENTREGA
    async function comprovante_entrega_BD() {
      let retInitComprovante = await initComprovante(cfg,cli)
      logEventos(cfg,'(BD - COMPROVANTE) - retInitComprovante:',retInitComprovante)
      return retInitComprovante
    }
  
    // AVISA A API PARA DOWNLOAD DO COMPROVANTE - PREPARA API LOCAL
    async function comprovante_entrega_FILE() {
      let retInitPreparaDownload = await preparaLinkComprovante(cfg)
      logEventos(cfg,'(FILE - COMPROVANTE - PREPARA API LOCAL) - retInitPreparaDownload:',retInitPreparaDownload)
      return retInitPreparaDownload
    }

    // ENVIA LINKS DOS COMPROVANTES DE ENTREGA
    async function API_comprovante_entrega() {
      let ret = await comprovante(cfg,cli)
      logEventos(cfg,'(API - COMPROVANTE) - retComprovante:',ret)
      return ret
    }

    // ENCERRA PROCESSOS DE MONITORAMENTO
    async function encerra_processo() {
      let retEncerraProcessos = await encerraProcessos()
      logEventos(cfg,'(BD - ENCERRA PROCESSOS) - retEncerraProcessos:',retEncerraProcessos)
      return retEncerraProcessos
    }
    */

   
   return 
}

module.exports = robot_V2
