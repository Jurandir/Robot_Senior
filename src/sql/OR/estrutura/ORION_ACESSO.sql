-- 15/09/2021 16:45 -- CREDENCIAIS DA TERMACO - ORION

USE [SIC]

CREATE TABLE ORION_ACESSO (
  ID          INT NOT NULL PRIMARY KEY,
  LOGIN       VARCHAR(80),
  SENHA       VARCHAR(2000),
  DT_UPDATE   DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ORION_ACESSO (ID,LOGIN,SENHA) 
VALUES (1,
'WEBTERMACO',
'plqQS/5gjKlJ49n1IRC2WU7jC06OaajvzghiPoI8nWGrlbvdwxC5JHZBt7ZkVKE+zVwfJmY/b1s0UOkb2T+tDWlnDDsvKptVBMxGO3RM3tTiQHOD0jWEx63VmK9bqJXGT7MG+2dt5RsWsbKZkcjeA546Fy1qo3LzX3TSyVmInQ8=')
