-- 15/09/2021 14:37 -- ORION OCORRENCIAS DE TRANSPORTE

USE [SIC]

CREATE TABLE ORION_TRANSPORTE (
  ID                INT         NOT NULL  IDENTITY    PRIMARY KEY,
  CNPJ              VARCHAR(14) NOT NULL,
  TRANSPORTE_ID     INT         NOT NULL,
  DESCRICAO         VARCHAR(80) NOT NULL,
  DT_ATUAL          DATETIME DEFAULT CURRENT_TIMESTAMP,
);

CREATE UNIQUE INDEX IDX_ORION_TRANSPORTE_UK ON SIC.dbo.ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID);

INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',01 ,'SEM OCORRENCIA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',02 ,'MERCADORIA RETIDA FISCALIZACAO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',03 ,'MERCADORIA RETIDA ATE 2º ORDEM');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',04 ,'PROBLEMA MECANICO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',05 ,'PROBLEMA NA ESTRADA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',06 ,'GREVE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',07 ,'CONDICOES CLIMATICAS - TEMPO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',08 ,'DOC. RETIDA NA FISCALIZACAO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',09 ,'ROUBO DE CARGA PARCIAL');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',10 ,'ROUBO DE CARGA TOTAL');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',11 ,'AVARIA DE PARTE DA CARGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',12 ,'AVARIA DE CARGA TOTAL');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',13 ,'EXTRAVIO PARCIAL DE CARGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',14 ,'EXTRAVIO TOTAL DA CARGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',15 ,'EXCESSO VEICULO - DESTINATARIO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',16 ,'FALTA DE ESPACO - DESTINATARIO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',17 ,'DESTINATARIO FECHADO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',18 ,'FERIADO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',19 ,'ENDERECO ENTREGA ? LOCALIZADO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',20 ,'CLIENTE SOLICITOU REENTREGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',21 ,'AGENDAMENTO TRACKING');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',22 ,'CORTE DE CARGA EM PISTA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',23 ,'CARGA AGUARDANDO VOO CONEXAO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',24 ,'EXTRAVIO - CARGA LOCALIZADA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',25 ,'AREA DE RISCO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',26 ,'DESTINATARIO AUSENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',27 ,'DEST. DESCONHECIDO NO ENDERECO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',28 ,'DEST. SEM DOCUMENTACAO EXIGIDA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',29 ,'ENDERECO INSUFICIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',30 ,'MERCADORIA DIFERE DO PEDIDO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',31 ,'MERCADORIAS TROCADAS');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',32 ,'OUTRO LOCAL PARA ENTREGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',33 ,'PEDIDO CANCELADO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',34 ,'SUSPEITA DE FRAUDE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',35 ,'DESTINATARIO MUDOU-SE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',36 ,'DEVOLUCAO NAO AUTORIZADA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',37 ,'RECEB COM FRETE PAGO (CLIENTE)');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',38 ,'REDESPACHO NAO INDICADO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',39 ,'TRANSP NAO ATENDE A PRACA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',40 ,'PEDIDO DE COMPRAS EM DUPLICIDA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',41 ,'ENTROU NO LOCAL DE COLETA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',42 ,'SAIU DO LOCAL DE COLETA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',43 ,'ENTROU NO XD DO TRANSPORTADOR');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',44 ,'SAIU DO XD DO TRANSPORTADOR');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',45 ,'INFORMACAO DE ATRASO ENTREGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',46 ,'CHEGADA NO DESTINATARIO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',47 ,'DEVOLUCAO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',48 ,'CANCELAMENTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',49 ,'VEIC RETIDO CLIENTE ANTERIOR');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',50 ,'FALHA DA TRANSPORTADORA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',51 ,'ACIDENTE COM O VEICULO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',52 ,'PROBLEMAS COM O RASTREADOR');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',53 ,'CONFIRMACAO DE AGENDAMENTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',54 ,'SOLICITACAO DE AGENDAMENTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',55 ,'SAIDA DO DESTINATARIO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',56 ,'LIMPEZA DE DADOS');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',57 ,'SOLICITACAO DE REAGENDA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',58 ,'FOLLOW UP');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',59 ,'AGUARDANDO RETORNO OM');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',60 ,'RECEBIMENTO POS CORTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',61 ,'AGUARDANDO RESPOSTA DA TRANSPO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',62 ,'IMPORTACAO DO XML NFE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',63 ,'AGUARDANDO AGENDA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',64 ,'AGENDAMENTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',65 ,'COMPLEMENTO DE DESCARGA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',66 ,'ENTR REAL DO O TT CLIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',67 ,'ENTR REAL DO O TT FORNECE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',69 ,'ESTADIA NO DESTINATARIO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',70 ,'PROBLEMA DE SISTEMA NO CLIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',71 ,'MERCADORIA S/ PRAZO  VALIDADE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',72 ,'FALTA DE MERCAD. ENTREGA CLIEN');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',73 ,'FALTA MERC. ENTREGA FORNECEDOR');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',74 ,'FORA HORARIO CLIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',75 ,'INVERSAO DE SKU');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',76 ,'NAO RECEBEU NAO PROR. TITULO ');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',77 ,'PROD. EM DESAC. C/ PED CLIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',78 ,'PROB. COM A NF, INFOR. INCORR.');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',79 ,'MERC. FORA DO PRAZO DE VALIDAD');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',80 ,'ESTADIA NO CLIENTE');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',81 ,'PROB. DE QUALIDADE DO PRODUTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',83 ,'DESTINATARIO EM BALANCO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',84 ,'QP - QUEBRA DE PROCEDIMENTO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',85 ,'B.O - BOLETIM DE OCORRENCIA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',86 ,'B.A - BOLETIM DE ATRASO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',87 ,'B.I - BOLETIM INFORMATIVO');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',88 ,'CHEGADA NO HUB');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',89 ,'SAIDA DO HUB');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',90 ,'CLIENTE RETIRA');
INSERT INTO ORION_TRANSPORTE(CNPJ,TRANSPORTE_ID,DESCRICAO) VALUES ( '43854116',91 ,'COMPROVANTE ENTREGA RETIDO');
