---  22/09/2021 16:01 - REPOSITORIO DE DADOS

USE SIC

CREATE TABLE JOHNDEERE_INFO (
	CODEINSERT                      INT          NOT NULL IDENTITY PRIMARY KEY,
	DATESENDXML                     DATETIME     DEFAULT CURRENT_TIMESTAMP,
	MESSAGETYPE                     varchar(10)  DEFAULT 'INVOICE',
	MESSAGESENDER                   varchar(15)  DEFAULT 'CARRIER_TERM',
	MESSAGERECIPIENT                varchar(15)  DEFAULT 'VISIBILITY',
	WITSFILENAME                    varchar(100) DEFAULT FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss'),
	TIMESTAMP                       varchar(15)  DEFAULT FORMAT(CURRENT_TIMESTAMP,'yyyyMMddHHmmss'),
	CONTROLNUMBER                   varchar(9)   ,  --- NUMERO DE CONTROLE = FORMAT( CODEINSERT ,'0000000') 
	INVOICENUMBER                   varchar(9)   ,  --- NOTA FISCAL
	COMMERCIALINVOICENUMBER         varchar(20)  DEFAULT '',
	INVOICENUMBERDETAILS            varchar(20)  DEFAULT '',
	CUSTOMER                        varchar(3)   DEFAULT 'JDP',
	EVENTTYPE                       varchar(20)  DEFAULT 'SHIP',
	RAILHEAD                        varchar(80)  DEFAULT '89674782001391',
	SHIPDATE                        varchar(20)  ,  --- DATA DE EMISSÃO CTRC - yyyyMMddHHmmss
	CARRIERTYPE                     varchar(10)  DEFAULT 'TRUCK',
	CARRIERCODE                     varchar(10)  DEFAULT 'TERM', -- TERMACO
	LICENSEPLATENUMBER              varchar(10)  ,  --- PLACAS DO VEICULO
	TRUCKNUMBER                     varchar(20)  DEFAULT '',
	BOLNUMBER                       varchar(12)  ,  --- NUMERO (BOLETO/FATURA)
	MANIFESTNUMBER                  varchar(12)  ,  --- NUMERO DO MANIFESTO (SPO/AJU-0000001)
	DESTINATIONLOC                  varchar(80)  ,  --- DESTINATARIO
	DESTINATIONETA                  varchar(20)  ,  --- PREVISÃO DE CHEGADA - yyyyMMddHHmmss
	FINALDESTETA                    varchar(20)  ,  --- PREVISÃO DE ENTREGA - yyyyMMddHHmmss
	VOLUME                          varchar(15)  ,  --- VOLUME / PESO CALCULADO
	GROSSWT                         varchar(15)  ,  --- VALOR NOTA FISCAL
	NETWT                           varchar(15)  DEFAULT '',
	COMMENTS                        varchar(4)   DEFAULT '',
	RECEIVELOC                      varchar(80)  ,
	RECEIVEDATE                     varchar(14)  ,   --- REMETENTE
	DEALERASSIGNDATE                varchar(14)  ,
	DEALERSAPCODE                   varchar(14)  ,
	ADDRESS1                        varchar(50)  ,
	DELIVERYCITY                    varchar(50)  ,
	DELIVERYSTATE                   varchar(2)   ,
	ZIPCODE                         varchar(9)   ,
	NAME                            varchar(50)  ,
	NEIGHBOURHOODNAME               varchar(50)  ,
	CITYCODE                        varchar(50)  ,
	COUNTRYCODE                     varchar(2)   ,
	COUNTRYNAME                     varchar(18)  ,
	DELIVERYLOC                     varchar(80)  ,
	DEALERDELIVERYDATE              varchar(14)  ,
	FILEXML                         image        ,
	SENDXML                         varchar(1)   DEFAULT '0',
    NrManifesto                     VARCHAR(20),
    CdEmpresa                       INT,
    NrSeqControle                   BIGINT,
    CdRemetente                     VARCHAR(20),
    NrNotaFiscal	                BIGINT,
    NrSerie                         VARCHAR(10),
	CdSequencia  	                INT DEFAULT 0
) 
;

CREATE INDEX IDX_JOHNDEERE_INFO_CTRC      ON JOHNDEERE_INFO (CdEmpresa,NrSeqControle);
CREATE INDEX IDX_JOHNDEERE_INFO_MANIFESTO ON JOHNDEERE_INFO (NrManifesto);
CREATE INDEX IDX_JOHNDEERE_INFO_NF        ON JOHNDEERE_INFO (CdRemetente,NrNotaFiscal,NrSerie);
