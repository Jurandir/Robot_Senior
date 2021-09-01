-- 01/09/2021 10:48 - OCORRENCIAS DIVERSAS - MANUAIS
DECLARE @CONFIRMAFACIL_ID           as INT
DECLARE @OCORRENCIA_DATA            as DATETIME
DECLARE @DATAOCO                    as DATETIME
DECLARE @OCORRENCIA_ID              as INT
DECLARE @OCORRENCIA_NOME            as NVARCHAR(60)
DECLARE @OCORRENCIA_OBS             as NVARCHAR(2000)
DECLARE @RECEBEDOR_NOME             as NVARCHAR(60)
DECLARE @RECEBEDOR_DOC              as NVARCHAR(40)
DECLARE @CdEmpresa                  as INT
DECLARE @NrSeqControle              as BIGINT
DECLARE @CdSequencia                as INT


DECLARE Ocorrencia_Cursor CURSOR FOR 
SELECT TOP 10
    CF.ID                   AS CONFIRMAFACIL_ID
	,CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 
	                         AS OCORRENCIA_DATA
	,ISNULL(DP.ID_CONFIRMAFACIL,OUN.CdOcorrencia)
	                         AS OCORRENCOA_ID
	,OCO.DsHistoricoEntrega  AS OCORRENCIA_NOME
	,OUN.DsComplementoOcorr  AS OCORRENCIA_OBS
    ,OUN.NrDoctoIdentPessoal AS RECEBEDOR_DOC
    ,OUN.DsContato           AS RECEBEDOR_NOME
	,OUN.CdEmpresa           AS CdEmpresa
	,OUN.NrSeqControle       AS NrSeqControle
	,OUN.CdSequencia         AS CdSequencia

FROM softran_termaco.dbo.gtcmoven         OUN                                                  -- Movimento das Ocorrencias
     JOIN softran_termaco.dbo.gtchisen    OCO ON OCO.cdhistoricoentrega = OUN.cdocorrencia     -- Ocorrencias
     JOIN SIC.dbo.CONFIRMAFACIL           CF  ON CF.CdEmpresa = OUN.CdEmpresa AND CF.NrSeqControle = OUN.NrSeqControle 
LEFT JOIN SIC.dbo.CONFIRMAFACILDEPARA     DP  ON DP.ID_SENIOR = OUN.CdOcorrencia               -- DE PARA ( SENIOR -> CONFIRMAFACIL )
LEFT JOIN SIC.dbo.CONFIRMAFACILOCORRENCIA CO  ON CO.CdEmpresa = OUN.CdEmpresa AND CO.NrSeqControle = OUN.NrSeqControle AND CO.CdSequencia  = OUN.CdSequencia 
WHERE (isnull(OCO.InExibehist, 0) = 0 OR OUN.CdOcorrencia=219)               -- 219 = AGUARDANDO AGENDAMENTO/SOLICITADO AGENDA
  AND NOT EXISTS ( SELECT 1 FROM SIC.dbo.CONFIRMAFACILOCORRENCIA CO WHERE CO.CdEmpresa = OUN.CdEmpresa AND CO.NrSeqControle = OUN.NrSeqControle  AND CO.CdSequencia = OUN.CdSequencia )

  AND CF.FASE_ID < 5
ORDER BY 
   CAST(CONCAT(FORMAT(OUN.DtMovimento,'yyyy-MM-dd'),' ', FORMAT(OUN.HRMovimento,'HH:mm:ss')) as datetime) 

;	

OPEN Ocorrencia_Cursor;  

FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @CONFIRMAFACIL_ID, 
         @OCORRENCIA_DATA, 
         @OCORRENCIA_ID, 
         @OCORRENCIA_NOME,
         @OCORRENCIA_OBS,
         @RECEBEDOR_DOC,
         @RECEBEDOR_NOME,
         @CdEmpresa,
         @NrSeqControle,
         @CdSequencia
         ;
          
WHILE @@FETCH_STATUS = 0  
BEGIN      
      BEGIN TRANSACTION;

         INSERT INTO SIC.dbo.CONFIRMAFACILOCORRENCIA ( 
             CONFIRMAFACIL_ID, 
             OCORRENCIA_ID, 
             OCORRENCIA_NOME, 
             OCORRENCIA_DATA,
             OCORRENCIA_OBS,
             RECEBEDOR_DOC,
             RECEBEDOR_NOME,
             CdEmpresa,
             NrSeqControle,
             CdSequencia 
        ) VALUES ( 
            @CONFIRMAFACIL_ID, 
            @OCORRENCIA_ID, 
            @OCORRENCIA_NOME,  
            @OCORRENCIA_DATA,  
            @OCORRENCIA_OBS,
            @RECEBEDOR_DOC,
            @RECEBEDOR_NOME,
            @CdEmpresa,
            @NrSeqControle,
            @CdSequencia 
        )

      -- Print @@ROWCOUNT
      ; 

      COMMIT TRANSACTION
      ;
      
      -- Print @CONFIRMAFACIL_ID ;
      -- Print @OCORRENCIA_ID ;
      -- Print @OCORRENCIA_DATA ;

      FETCH NEXT FROM Ocorrencia_Cursor INTO 
         @CONFIRMAFACIL_ID, 
         @OCORRENCIA_DATA, 
         @OCORRENCIA_ID, 
         @OCORRENCIA_NOME,
         @OCORRENCIA_OBS,
         @RECEBEDOR_DOC,
         @RECEBEDOR_NOME,
         @CdEmpresa,
         @NrSeqControle,
         @CdSequencia
         ;

END
;

CLOSE Ocorrencia_Cursor
;  
DEALLOCATE Ocorrencia_Cursor
;  
