DROP VIEW IF EXISTS [dbo].[v_ob_doc_ldb];
GO

DROP VIEW IF EXISTS [dbo].[v_u_shipunit_f_ldb];
GO

CREATE VIEW [dbo].[v_u_shipunit_f_ldb]
AS
SELECT whse_code, shipunit_rid, loc, cont, wave, shipment, wgt, packlist, bol, manifest, cont_packlist, carrier_service, trailer, carrier_trailer FROM shipunit_f
UNION ALL
SELECT whse_code, shipunit_rid, loc, cont, wave, shipment, wgt, packlist, bol, manifest, cont_packlist, carrier_service, trailer, carrier_trailer FROM shipunit_h;
GO

CREATE VIEW [dbo].[v_ob_doc_ldb]
AS
SELECT om_f.whse_code, om_f.ob_oid, 
	CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,
	om_f.wave, om_f.shipment, om_f.ob_ord_stt, sh_f.cont, sh_f.packlist, sh_f.bol, sh_f.manifest, sh_f.cont_packlist from v_u_om_f om_f
LEFT JOIN v_u_shipunit_f_ldb sh_f ON om_f.whse_code = sh_f.whse_code AND om_f.shipment = sh_f.shipment;
GO
