// 30/09/2021 14:10 - MONTA XML - SÊNIOR - ("JOHN DEERE")


const montaXML = async (itn) => {
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
        let BOLNumber               = itn.BOLNUMBER      ? itn.BOLNUMBER      : ''
        let ManifestNumber          = itn.MANIFESTNUMBER ? itn.MANIFESTNUMBER : ''
        let DestinationLoc          = itn.DESTINATIONLOC
        let DestinationETA          = itn.DESTINATIONETA
        let FinalDestETA            = itn.FINALDESTETA
        let Volume                  = itn.VOLUME
        let GrossWt                 = itn.GROSSWT
        let NetWt                   = itn.NETWT
        let Comments                = itn.COMMENTS      || ''
        let ReceiveLoc              = itn.RECEIVELOC    || ''
        let ReceiveDate             = itn.RECEIVEDATE   || ''
        let DeliveryLoc             = itn.DELIVERYLOC   || ''

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

         let ret
        if (EventType == 'SHIP'){ 
                ret = cabXML() + eventShip() + Rodape()
              } else 
        if(EventType == 'RECEIVE'){
                ret = cabXML() + eventReceive() + Rodape()
              } else 
        if(EventType == 'DELIVERY') {
                ret = cabXML() + eventDelivery() + Rodape()
              } else {
                ret = cabXML() + eventDealer() + Rodape()
        }

        return ret

}

module.exports = montaXML

/*
  {
    FILENAME: 'PARTS_TRUCK_SHIP_601_20210929_104002_3.XML',
    CODEINSERT: 3,
    DATESENDXML: 2021-09-29T10:40:02.497Z,
    MESSAGETYPE: 'INVOICE',
    MESSAGESENDER: 'CARRIER_TERM',
    MESSAGERECIPIENT: 'VISIBILITY',
    WITSFILENAME: '20210929104002',
    TIMESTAMP: '20210929104002',
    CONTROLNUMBER: '000000003',
    INVOICENUMBER: '1585903',
    COMMERCIALINVOICENUMBER: '',
    INVOICENUMBERDETAILS: '',
    CUSTOMER: 'JDP',
    EVENTTYPE: 'SHIP',
    RAILHEAD: '89674782001391',
    SHIPDATE: '20210913000000',
    CARRIERTYPE: 'TRUCK',
    CARRIERCODE: 'TERM',
    LICENSEPLATENUMBER: 'PJI0633',
    TRUCKNUMBER: '',
    BOLNUMBER: '0',
    MANIFESTNUMBER: '0000001',
    DESTINATIONLOC: '3',
    DESTINATIONETA: '20210918073000',
    FINALDESTETA: 'Sep 17 2021 12:00AM',
    VOLUME: '2.0000',
    GROSSWT: '15717.8800',
    NETWT: '',
    COMMENTS: '',
    RECEIVELOC: null,
    RECEIVEDATE: null,
    DEALERASSIGNDATE: null,
    DEALERSAPCODE: null,
    ADDRESS1: null,
    DELIVERYCITY: null,
    DELIVERYSTATE: null,
    ZIPCODE: null,
    NAME: null,
    NEIGHBOURHOODNAME: null,
    CITYCODE: null,
    COUNTRYCODE: null,
    COUNTRYNAME: null,
    DELIVERYLOC: null,
    DEALERDELIVERYDATE: null,
    FILEXML: null,
    SENDXML: '0',
    NrManifesto: 'SPO/AJU-0000001',
    CdEmpresa: 2,
    NrSeqControle: '1174',
    CdRemetente: '89674782001391',
    NrNotaFiscal: '1585903',
    NrSerie: '1',
    CdSequencia: 0
  }
]

*/