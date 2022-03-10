const fs   = require('fs')
const path = require('path')

const saveLog = async ( _EMP, _FILE, _DATA ) => {

    // let fullName = path.join(__dirname,`../../../logs/${_EMP}/${_FILE}`)
    let fullName = path.join(__dirname,`../../logs/${_EMP}/${_FILE}`)
    fs.writeFileSync( fullName , _DATA )

}

module.exports = saveLog