-- SELECT * FROM softran_termaco.dbo.CCERoman ROM                            -- Romaneio
-- SELECT * FROM softran_termaco.dbo.CCERomIt ITR  WHERE InColetaEntrega = 1 -- itens Romaneio
-- SELECT * FROM softran_termaco.dbo.gtcconhe CON                            -- Conhecimento
-- SELECT * FROM softran_termaco.dbo.GTCFunDp MOT                            -- Funcionario


SELECT 
     '99'        as content_motorista_tipoVeiculo
    ,MOT.DsNome  as content_motorista_nome
    ,ROM.NrPlaca as content_motorista_placaVeiculo
FROM softran_termaco.dbo.CCERomIt ITR
JOIN softran_termaco.dbo.CCERoman ROM ON ROM.CdEmpresa = ITR.CdEmpresa AND ROM.CdRomaneio = ITR.CdRomaneio AND ROM.CdRota = ITR.CdRota
JOIN softran_termaco.dbo.GTCFunDp MOT ON MOT.NrCPF = ROM.NrCPFMotorista
WHERE ITR.InColetaEntrega = 1
  AND ITR.CdEmpresaColetaEntrega = 10
  AND ITR.NrSeqControle = 22
