-- 08/09/2021 15:14 - MONTA ESTRUTURA DE INSERT NOVA CARGA NA API (ITRACK) 

SELECT TOP 10
     CONCAT(aa.dsapelido,'E',a.nrdoctofiscal)              AS content_observacao,
     aa.dsapelido                                          AS content_sigla,
	 b.nrnotafiscal                                        AS content_nroNotaFiscal,
	 1                                                     AS content_centroDeCusto_nro,
	 'LOGISTICA'                                           AS content_centroDeCusto_nome,
	 bb.CdChaveAcesso                                      AS content_cte,
	 'E'                                                   AS content_serialNumber,

	 j.DsUF                                                AS content_embarcador_endereco_uf,
	 j.DsLocal                                             AS content_embarcador_endereco_cidade,
	 g.DsEndereco                                          AS content_embarcador_endereco_logradouro,
	 g.DsBairro                                            AS content_embarcador_endereco_bairro,
	 g.DsNumero                                            AS content_embarcador_endereco_nro,
	 g.NrCEP                                               AS content_embarcador_endereco_cep,
	 g.CdInscricao                                         AS content_embarcador_responsavel_cnpj,
	 g.DsEntidade                                          AS content_embarcador_responsavel_nome,

	 k.DsUF                                                AS content_destinatario_endereco_uf,
	 k.DsLocal                                             AS content_destinatario_endereco_cidade,
	 h.DsEndereco                                          AS content_destinatario_endereco_logradouro,
	 h.DsBairro                                            AS content_destinatario_endereco_bairro,
	 h.DsNumero                                            AS content_destinatario_endereco_nro,
	 h.NrCEP                                               AS content_destinatario_endereco_cep,
	 h.DsEntidade                                          AS content_destinatario_nome,
    CASE WHEN SUBSTRING(h.CdInscricao,1,3)='000' THEN SUBSTRING(h.CdInscricao,4,11) ELSE h.CdInscricao END	 -- IDENTIFICA CPF
	                                                       AS content_destinatario_cpfCnpj, 

	 j.DsUF                                                AS content_transportador_endereco_uf,
	 j.DsLocal                                             AS content_transportador_endereco_cidade,
	 aa.DsEndereco                                         AS content_transportador_endereco_logradouro,
	 aa.DsBairro                                           AS content_transportador_endereco_bairro,
	 aa.DsNumero                                           AS content_transportador_endereco_nro,
	 aa.NrCEP                                              AS content_transportador_endereco_cep,
	 aa.NrTelefone                                         AS content_transportador_responsavel_telefone,
	 aa.NrCGCCPF                                           AS content_transportador_responsavel_cnpj,
	 aa.DsEmpresa                                          AS content_transportador_responsavel_nomeFantasia,
	 'TERMACO LOGISTICA'                                   AS content_transportador_responsavel_nome,

	 c.NrChaveAcessoNFe                                    AS content_danfe,
	 FORMAT(c.DtEmissao,'yyyy-MM-ddThh:mm:ss-03')          AS content_dataEmissaoDanfe,

	 j.DsUF                                                AS content_endereco_uf,
	 j.DsLocal                                             AS content_endereco_cidade,
	 g.DsEndereco                                          AS content_endereco_logradouro,
	 g.DsBairro                                            AS content_endereco_bairro,
	 g.DsNumero                                            AS content_endereco_nro,
	 g.NrCEP                                               AS content_endereco_cep,

	 CONCAT(aa.dsapelido,'E',a.nrdoctofiscal)              AS content_xpedido,
	 FORMAT(softran_termaco.dbo.SP_CalculaDtPrevisaoEntregaPercurso(a.DtEmissao, a.CdEmpresaDestino, a.CdPercurso, a.CdTransporte, a.CdRemetente, a.CdDestinatario, a.cdempresa, a.nrseqcontrole),'yyyy-MM-ddThh:mm:ss-03') 
                                                           AS content_dataPrevisao,
	 TOKEN.TOKEN                                           AS token

FROM softran_termaco.dbo.gtcconhe      a                                          -- Conhecimento
LEFT JOIN softran_termaco.dbo.sisempre aa ON aa.cdempresa         = a.cdempresa   -- Filial Origem
LEFT JOIN softran_termaco.dbo.gtcconce bb ON bb.cdempresa         = a.cdempresa	  AND bb.nrseqcontrole = a.nrseqcontrole -- CTe Fiscal
LEFT JOIN softran_termaco.dbo.gtcnfcon b  ON b.cdempresa          = a.cdempresa	  AND b.nrseqcontrole = a.nrseqcontrole  -- Link CTRC x NF
LEFT JOIN softran_termaco.dbo.gtcnf    c  ON c.cdremetente        = b.cdinscricao AND c.nrserie = b.nrserie AND c.nrnotafiscal = b.nrnotafiscal  -- NotaFiscal
LEFT JOIN softran_termaco.dbo.sistdf   f  ON f.cdtpdoctofiscal    = a.cdtpdoctofiscal  -- Tipo Fiscal
LEFT JOIN softran_termaco.dbo.siscli   g  ON g.cdinscricao        = a.cdremetente      -- Clientes Remetente
LEFT JOIN softran_termaco.dbo.siscli   h  ON h.cdinscricao        = a.cddestinatario   -- Clientes Destinatários
LEFT JOIN softran_termaco.dbo.siscli   i  ON i.cdinscricao        = a.cdinscricao      -- Clientes Pagador
LEFT JOIN softran_termaco.dbo.siscep   j  ON j.nrcep              = a.nrcepcoleta      -- CEP Filial Origem
LEFT JOIN softran_termaco.dbo.siscep   k  ON k.nrcep              = a.nrcepentrega     -- CEP Local Entrega
LEFT JOIN softran_termaco.dbo.sisempre l  ON l.cdempresa          = a.cdempresa        -- Filial Origem
LEFT JOIN softran_termaco.dbo.sisempre m  ON m.cdempresa          = a.cdempresadestino -- Filial Destino
LEFT JOIN softran_termaco.dbo.siscep   n  ON n.nrcep              = m.nrcep            -- CEP Filial Destino
LEFT JOIN softran_termaco.dbo.CCEColet o  ON o.CdEmpresa          = a.CdEmpresa  AND o.NrColeta = a.NrColeta  -- Dados Coleta
LEFT JOIN softran_termaco.dbo.GTCSITCG p  ON p.CdSituacaoCarga    = a.CdSituacaoCarga  -- Situação Atual da Carga
     JOIN SIC.dbo.ITRACK_TOKEN     TOKEN  ON TOKEN.CNPJ           = aa.NrCGCCPF
WHERE 1=1
     AND a.CdEmpresa        = ${CdEmpresa}
	 AND a.NrSeqControle    = ${NrSeqControle}
     AND c.NrChaveAcessoNFe = '${danfe}'
  