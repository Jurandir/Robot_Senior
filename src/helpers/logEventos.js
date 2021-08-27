const moment            = require('moment')

const logEventos = (cfg,msg,ret) => {
    if(cfg.debug=='ON' || ret.success || ret.rowsAffected==-1 ) {
       if(ret.rowsAffected==-1) {
          console.error(moment().format(),'-',msg,ret)
       } else {
          console.log(moment().format(),'-',msg,ret) 
       }   
    }
 }

module.exports = logEventos