const fs   = require('fs')
const path = require('path')

const saveLogJSON = async ( _EMP, _FILE, _JSON ) => {

//    let fullName = path.join(__dirname,`../../../logs/${_EMP}/${_FILE}`)
    let fullName = path.join(__dirname,`../../logs/${_EMP}/${_FILE}`)
    fs.writeFileSync( fullName , JSON.stringify(_JSON, null, '\t') )

}

module.exports = saveLogJSON
