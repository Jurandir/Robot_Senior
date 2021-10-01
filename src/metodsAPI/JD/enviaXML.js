// 01/10/2021 15:48 - ENVIA XML PARA API "JOHN DEERE"

const axios         = require('axios')
const atualizaEnvio = require('../../metodsDB/JD/atualizaEnvio')

const test        = 'https://tpallbeta.2wglobal.com:6443/WWLRestService?Message_Identifier=JD&Message_Type=PARTSTATUS'
const production  = 'https://tpall2.2wglobal.com:6443/WWLRestService?Message_Identifier=JD&Message_Type=PARTSTATUS'


async function enviaXML(itn) {
    let filexml = itn.xml
    let retorno = {success: false, data:'', status:0, statusText:'' }
    let url     = test
    let host    = 'tp'+url.replace(/.*tp(.*):6443.*/, '$1')+':6443'

    let res = await axios.post(url, filexml, 
        { headers: 
        
            {
                'Accept-Encoding': 'gzip,deflate',
                'Content-Type': 'application/xml',
                'Content-Length': '1172',
                'Host': host,
                'Connection': 'Keep-Alive',
                'User-Agent': 'Apache-HttpClient/4.1.1 (java 1.5)'
  
            }
  
        });
  
    let data            = res.data
    
    retorno.success     = (data == 'SUCCESS')
    retorno.success     = retorno.success
    retorno.data        = res.data
    retorno.status      = res.status
    retorno.statusText  = res.statusText
      
    if (retorno.success) {
        await atualizaEnvio(itn)  
    }

    return retorno

  }
  module.exports = enviaXML