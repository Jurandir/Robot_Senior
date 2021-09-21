SELECT  TOP 10 
   n.*
FROM softran_termaco.dbo.gtcconhe a
JOIN softran_termaco.dbo.GTCFatIt m ON m.CdEmpresa = a.CdEmpresa AND m.NrSeqControle = a.NrSeqControle
JOIN softran_termaco.dbo.GTCFat   n ON n.CdEmpresa = m.CdEmpresa AND n.CdFatura = m.CdFatura AND m.CdParcela = n.CdParcela

