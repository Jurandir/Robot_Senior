// By: Jurandir Ferreira
// Em Produção em : 15/06/2021
// ----------------------------
const moment            = require('moment')
const initNFs           = require('../metodsDB/initNFs')
const initTransporte    = require('../metodsDB/initTransporte')
const initTransferencia = require('../metodsDB/initTransferencia')
const initChegada       = require('../metodsDB/initChegada')
const initEmRota        = require('../metodsDB/initEmRota')
const initEntrega       = require('../metodsDB/initEntrega')
const initOcorrencias   = require('../metodsDB/initOcorrencias')
const initComprovante   = require('../metodsDB/initComprovante')
const encerraProcessos  = require('../metodsDB/encerraProcessos')
const registraNF        = require('../models/registraNF')
const transfereNF       = require('../models/transfereNF')
const chegadaNF         = require('../models/chegadaNF')
const rotaEntrega       = require('../models/rotaEntrega')
const entregaNF         = require('../models/entregaNF')
const ocorrencias       = require('../models/ocorrencias')
const comprovante       = require('../models/comprovante')
const logEventos        = require('../helpers/logEventos')

const preparaLinkComprovante = require('../helpers/preparaLinkComprovante')


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

    let retInitNFs = await captura_nfs() 
    await transporte_iniciado()
    
    await api_registra_NFs()
    if(retInitNFs.rowsAffected>0) {
       return 
    }

    await transferencia_entre_filiais()
    await chegada_filial_destino()
    await em_rota_entrega()
    let ret_ocorrencias = await ocorrencias_manuais()

    if(ret_ocorrencias.retInitOcorrencias.rowsAffected>0) {
        return 
    }

    await confirmacao_entrega()
    await comprovante_entrega_BD()
    await comprovante_entrega_FILE()
    await API_comprovante_entrega()
    await encerra_processo()

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

    // EM ROTA PARA ENTREGA
    async function em_rota_entrega() {
      let retInitEmRota = await initEmRota()
      logEventos(cfg,'(BD - EM ROTA PARA ENTREGA) - retInitEmRota:',retInitEmRota)

      let retRotaEntrega = await rotaEntrega(cfg,cli)
      logEventos(cfg,'(API - EM ROTA DE ENTREGA) - retRotaEntrega:',retRotaEntrega)
      return { retInitEmRota, retRotaEntrega }
    }
    
    // OCORRENCIAS MANUAIS
    async function ocorrencias_manuais() {
      let retInitOcorrencias = await initOcorrencias()
       logEventos(cfg,'(BD - OCORRENCIAS MANUAIS) - retInitOcorrencias:',retInitOcorrencias)

       let retOcorrencias = await ocorrencias(cfg,cli)
       logEventos(cfg,'(API - OCORRÊNCIAS MANUAIS) - retOcorrencias:',retOcorrencias)
       return { retInitOcorrencias, retOcorrencias }
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
  
    // AVISA A API PARA DOWNLOAD DO COMPROVANTE
    async function comprovante_entrega_FILE() {
      let retInitPreparaDownload = await preparaLinkComprovante(cfg)
      logEventos(cfg,'(FILE - COMPROVANTE) - retInitPreparaDownload:',retInitPreparaDownload)
      return retInitPreparaDownload
    }

    async function API_comprovante_entrega() {
      let retComprovante = await comprovante(cfg,cli)
      logEventos(cfg,'(API - COMPROVANTE) - retComprovante:',retComprovante.message)
      return retComprovante
    }

    // ENCERRA PROCESSOS
    async function encerra_processo() {
      let retEncerraProcessos = await encerraProcessos()
      logEventos(cfg,'(BD - ENCERRA PROCESSOS) - retEncerraProcessos:',retEncerraProcessos)
      return retEncerraProcessos
    }
   
   return 
}

module.exports = robot
