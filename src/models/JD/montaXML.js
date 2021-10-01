// 30/09/2021 14:10 - MONTA XML - SÊNIOR - ("JOHN DEERE")

const fs            = require('fs')
const path          = require('path')

const montaXML = async (itn) => {
        let resutado = {
          success:false,
          id: itn.CODEINSERT,
          filename: itn.FILENAME,
          fullName: '',
          xml:''
        }
        let WITSFileName            = itn.FILENAME
        let TimeStamp               = itn.TIMESTAMP
        let ControlNumber           = itn.CONTROLNUMBER
        let InvoiceNumber           = itn.INVOICENUMBER
        let MessageType             = itn.MESSAGETYPE
        let MessageSender           = itn.MESSAGESENDER
        let MessageRecipient        = itn.MESSAGERECIPIENT
        let CommercialInvoiceNumber = itn.COMMERCIALINVOICENUMBER
        let InvoiceNumberDetails    = itn.INVOICENUMBERDETAILS
        let Customer                = itn.CUSTOMER
        let EventType               = itn.EVENTTYPE
        let RailHead                = itn.RAILHEAD
        let ShipDate                = itn.SHIPDATE
        let CarrierType             = itn.CARRIERTYPE
        let CarrierCode             = itn.CARRIERCODE
        let LicensePlateNumber      = itn.LICENSEPLATENUMBER
        let TruckNumber             = itn.TRUCKNUMBER
        let BOLNumber               = itn.BOLNUMBER == '0' ? ''                 : itn.BOLNUMBER
        let ManifestNumber          = itn.MANIFESTNUMBER   ? itn.MANIFESTNUMBER : ''
        let DestinationLoc          = itn.DESTINATIONLOC
        let DestinationETA          = itn.DESTINATIONETA
        let FinalDestETA            = itn.FINALDESTETA
        let Volume                  = itn.VOLUME
        let GrossWt                 = itn.GROSSWT
        let NetWt                   = itn.NETWT
        let Comments                = itn.COMMENTS           || ''
        let ReceiveLoc              = itn.RECEIVELOC         || ''
        let ReceiveDate             = itn.RECEIVEDATE        || ''
        let DeliveryLoc             = itn.DELIVERYLOC        || ''
        let DealerDeliveryDate      = itn.DEALERDELIVERYDATE || ''

        const cabXML = () => 
        `<?xml version="1.0" encoding="UTF-8"?>
        <Message>
        <MessageType>${MessageType}</MessageType>
        <MessageSender>${MessageSender}</MessageSender>
        <MessageRecipient>${MessageRecipient}</MessageRecipient>
        <Transaction>
        <WITSFileName>${WITSFileName}</WITSFileName>
        <TimeStamp>${TimeStamp}</TimeStamp>
        <ControlNumber>${ControlNumber}</ControlNumber>
        <Cargos>
        <CargoDetail>
        <InvoiceHeader>
        <InvoiceNumber>${InvoiceNumber}</InvoiceNumber>
        <CommercialInvoiceNumber>${CommercialInvoiceNumber}</CommercialInvoiceNumber>
        <InvoiceNumberDetails>${InvoiceNumberDetails}</InvoiceNumberDetails>
        <Customer>${Customer}</Customer>
        </InvoiceHeader>
        <Events>
        `
        const eventShip = () =>
        `<Ship>
        <EventType>${EventType}</EventType>
        <RailHead>${RailHead}</RailHead>
        <ShipDate>${ShipDate}</ShipDate>
        <CarrierType>${CarrierType}</CarrierType>
        <CarrierCode>${CarrierCode}</CarrierCode>
        <LicensePlateNumber>${LicensePlateNumber}</LicensePlateNumber>
        <TruckNumber>${TruckNumber}</TruckNumber>
        <BOLNumber>${BOLNumber}</BOLNumber>
        <ManifestNumber>${ManifestNumber}</ManifestNumber>
        <DestinationLoc>${DestinationLoc}</DestinationLoc>
        <DestinationETA>${DestinationETA}</DestinationETA>
        <FinalDestETA>${FinalDestETA}</FinalDestETA>
        <Volume>${Volume}</Volume>
        <GrossWt>${GrossWt}</GrossWt>
        <NetWt>${NetWt}</NetWt>
        <Comments>${Comments}</Comments>
        </Ship>
        `
        const eventDelivery = () =>
        `<Delivery>
        <RailHead>${RailHead}</RailHead>
        <DeliveryLoc>${DeliveryLoc}</DeliveryLoc>
        <DealerDeliveryDate>${DealerDeliveryDate}</DealerDeliveryDate>
        </Delivery>
        `
        const eventReceive = () =>
        `<Receive>
        <EventType>${EventType}</EventType>
        <RailHead>${RailHead}</RailHead>
        <ReceiveLoc>${ReceiveLoc}</ReceiveLoc>
        <ReceiveDate>${ReceiveDate}</ReceiveDate>
        <FinalDestETA>${FinalDestETA}</FinalDestETA>
        </Receive>
        `

        const eventDealer = () =>
        `<Dealer>
        <EventType></EventType>
        <RailHead></RailHead>
        <DealerAssignDate></DealerAssignDate>
        <DealerSAPCode></DealerSAPCode>
        <Address1></Address1>
        <DeliveryCity></DeliveryCity>
        <DeliveryState></DeliveryState>
        <ZipCode></ZipCode>
        <Name></Name>
        <NeighbourhoodName></NeighbourhoodName>
        <CityCode></CityCode>
        <CountryCode></CountryCode>
        <CountryName></CountryName>
        </Dealer>
        `
        const Rodape = () =>
        `</Events>
        </CargoDetail>
        </Cargos>
        </Transaction>
        </Message>
        `
        let xml
        if (EventType == 'SHIP'){ 
                xml = cabXML() + eventShip() + Rodape()
              } else 
        if(EventType == 'RECEIVE'){
                xml = cabXML() + eventReceive() + Rodape()
              } else 
        if(EventType == 'DELIVERY') {
                xml = cabXML() + eventDelivery() + Rodape()
        } else {
                xml = cabXML() + eventDealer() + Rodape()
        }

        let fullName = path.join(__dirname,`../../../logs/JD/${WITSFileName}`) // fullName = `./logs/JD/${WITSFileName}`

        fs.writeFileSync(fullName,xml)
        fs.close

        resutado.success  = true
        resutado.fullName = fullName
        resutado.xml      = xml

        return resutado
}

module.exports = montaXML
