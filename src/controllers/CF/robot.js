// 02/09/2021 09:34 - Versão Sênior - By: Jurandir Ferreira

const moment                = require('moment')
const initNFs               = require('../../metodsDB/CF/initNFs')                 // 30/08/2021 10:03
const initTransporte        = require('../../metodsDB/CF/initTransporte')
const initTransferencia     = require('../../metodsDB/CF/initTransferencia')
const initChegada           = require('../../metodsDB/CF/initChegada')
const initEntregaProgramada = require('../../metodsDB/CF/initEntregaProgramada')
const initEmRota            = require('../../metodsDB/CF/initEmRota')
const initEntrega           = require('../../metodsDB/CF/initEntrega')
const initOcorrencias       = require('../../metodsDB/CF/initOcorrencias')
const initComprovante       = require('../../metodsDB/CF/initComprovante')
const encerraProcessos      = require('../../metodsDB/CF/encerraProcessos')
const registraNF            = require('../../models/CF/registraNF')
const transfereNF           = require('../../models/CF/transfereNF')
const chegadaNF             = require('../../models/CF/chegadaNF')
const entregaProgramada     = require('../../models/CF/entregaProgramada')
const rotaEntrega           = require('../../models/CF/rotaEntrega')
const entregaNF             = require('../../models/CF/entregaNF')
const ocorrencias           = require('../../models/CF/ocorrencias')
const comprovante           = require('../../models/CF/comprovante')
const logEventos            = require('../../helpers/logEventos')

const preparaLinkComprovante = require('../../helpers/preparaLinkComprovante')

const robot = async (cli,cfg,uptime) =>{
   let timeOUT = Math.ceil((process.uptime()-2) - uptime)
   let time_inicio = process.uptime()
   
    // CONTROLE DE EXECUÇÃO
    if( cli.count <=0 ){
         clearInterval(cli.fnTime);
         console.log(moment().format(),`- ( TOKEN VENCIDO  ) - ${cli.login.resposta.token} - Time: ${timeOUT}s - `,cli.nome)
         return 
    } else {
         console.log(moment().format(),'- Robô em Execução:',cli.count,' - ',timeOUT,'s')
    }
    cli.count--

    await captura_nfs()                   // XXX - INICIA PROCESSO DE MONITORAMENTO (BD)
    await transporte_iniciado()           // 000 - PROCESSO DE TRANSPORTE INICIADO (BD)
    await api_registra_NFs()              // 000 - PROCESSO DE TRANSPORTE INICIADO (API)
    await ocorrencias_manuais()           // XXX - OCORRENCIAS MANUAIS (BD) 
    await transferencia_entre_filiais()   // 101 - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS (BD,API)
    await chegada_filial_destino()        // 098 - CHEGADA NA CIDADE OU FILIAL DE DESTINO (BD,API)
    await entrega_programada()            // 091 - ENTREGA PROGRAMADA (BD,API)
    await em_rota_entrega()               // 100 - EM ROTA PARA ENTREGA (BD,API)
    await confirmacao_entrega()           // 001 - ENTREGA REALIZADA NORMALMENTE (BD,API)
    await comprovante_entrega_BD()        // 999 - COMPROVANTE DE ENTREGA (BD)
    await comprovante_entrega_FILE()      // 999 - COMPROVANTE DE ENTREGA (FILE,API LOCAL)
    await API_comprovante_entrega()       // 999 - COMPROVANTE DE ENTREGA (API)
    await API_ocorrencias_manuais()       // XXX - OCORRENCIAS MANUAIS (API)
    await encerra_processo()              // XXX - ENCERRA PROCESSO DE MONITORAMENTO (BD)

    let time_final = process.uptime()
    let time_total = Math.ceil(time_final-time_inicio)
 
    console.log('Fim - Exec - Robô.',time_total,'s')

   // ======================== ROTINAS ===============================

    // CAPTURA NFs 
    async function captura_nfs() {
       let retInitNFs = await initNFs(cli)
       logEventos(cfg,'(BD - CAPTURA NFs) - retInitNFs:',retInitNFs) 
       return retInitNFs
    }

    // PROCESSO DE TRANSPORTE INICIADO
    async function transporte_iniciado() {
      let retInitTransporte = await initTransporte()
      logEventos(cfg,'(BD - PROCESSO DE TRANSPORTE INICIADO) - retInitTransporte:',retInitTransporte)
      return retInitTransporte
    }

    // OCORRENCIAS MANUAIS BD
    async function ocorrencias_manuais() {
       let retInitOcorrencias = await initOcorrencias()
       logEventos(cfg,'(BD - OCORRENCIAS MANUAIS) - retInitOcorrencias:',retInitOcorrencias)

       return { retInitOcorrencias }
    }   

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
    
    // REGISTRA INICIO NA API
    async function api_registra_NFs() {
      let retRegistraNF = await registraNF(cfg,cli)
      logEventos(cfg,'(API - REGISTRO NF) - retRegistraNF:',retRegistraNF.message)
      return retRegistraNF
    }

    // EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS
    async function transferencia_entre_filiais() {
      let retInitTransferencia = await initTransferencia()
      logEventos(cfg,'(BD - EM PROCESSO DE TRANSFERENCIA ENTRE AS FILIAIS) - retInitTransferencia:',retInitTransferencia)

      let retTransfereNF = await transfereNF(cfg,cli)
      logEventos(cfg,'(API - TRANSFERENCIA ENTRE FILIAIS) - retTransfereNF:',retTransfereNF.message)
      return { retInitTransferencia, retTransfereNF }
    }

    // CHEGADA NA CIDADE OU FILIAL DE DESTINO -- ( 098 passou para manual)
    async function chegada_filial_destino() {
      let retInitChegada = await initChegada()
      logEventos(cfg,'(BD - CHEGADA NA CIDADE OU FILIAL DE DESTINO) - retInitChegada:',retInitChegada)

      let retChegadaNF = await chegadaNF(cfg,cli)
      logEventos(cfg,'(API - CHEGADA NA FILIAL) - retChegadaNF:',retChegadaNF.message)
      return { retInitChegada, retChegadaNF }
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
      let retComprovante = await comprovante(cfg,cli)
      logEventos(cfg,'(API - COMPROVANTE) - retComprovante:',retComprovante.message)
      return retComprovante
    }

    // ENCERRA PROCESSOS DE MONITORAMENTO
    async function encerra_processo() {
      let retEncerraProcessos = await encerraProcessos()
      logEventos(cfg,'(BD - ENCERRA PROCESSOS) - retEncerraProcessos:',retEncerraProcessos)
      return retEncerraProcessos
    }
   
   return 
}

module.exports = robot
