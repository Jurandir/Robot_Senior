SELECT  TOP 10 
   n.NrPlaca
   ,*
FROM softran_termaco.dbo.gtcconhe a
JOIN softran_termaco.dbo.GTCManCn m ON m.CdEmpresa = a.CdEmpresa AND m.NrSeqControle = a.NrSeqControle
JOIN softran_termaco.dbo.GTCMan   n ON n.NrManifesto = m.NrManifesto