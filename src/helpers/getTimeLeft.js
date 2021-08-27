const getTimeLeft = (timeout) => {
   let uptime = process.uptime() 
   return (Math.ceil((timeout._idleStart + timeout._idleTimeout)/1000 - uptime))
}

module.exports = getTimeLeft