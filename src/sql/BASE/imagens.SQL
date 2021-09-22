SELECT a.CdEmpresa
    ,      d.DsApelido     AS DsFilial
    ,      a.NrDoctoFiscal
    ,      a.NrSeqControle
    ,      c.CdSequencia
    ,      c.DsArquivo
    ,      c.DsTipoArquivo
    ,      c.DsNomeArquivo
      FROM softran_termaco.dbo.gtcconhe      a                                                                    -- Conhecimento
      LEFT JOIN softran_termaco.dbo.sisempre d ON d.cdempresa = a.cdempresa                                       -- Filial Origem
      LEFT JOIN softran_termaco.dbo.gtcconce b ON b.CdEmpresa = a.CdEmpresa AND b.NrSeqControle = a.NrSeqControle -- CTe Fiscal
      LEFT JOIN softran_termaco.dbo.GTCMVEDG c ON c.CdEmpresa = a.CdEmpresa AND c.NrSeqControle = a.NrSeqControle -- Comprovante de Entrega baixado pelo RMS
WHERE 
   -- CONCAT(d.DsApelido,'E',a.NrDoctoFiscal) IN ('SPOE3423994','SPOE3423995','SPOE3424003','SPOE3424429')
   c.DsArquivo IS NOT NULL
