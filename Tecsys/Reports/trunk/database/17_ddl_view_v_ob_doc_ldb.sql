CREATE OR ALTER VIEW [dbo].[v_ob_doc_ldb]
AS
SELECT om_f.whse_code, om_f.ob_oid, 
	CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,
	om_f.wave, om_f.shipment, om_f.ob_ord_stt, ca_f.carrier_code,  sh_f.cont, sh_f.packlist, sh_f.bol, sh_f.manifest, sh_f.cont_packlist 
FROM v_u_om_f om_f
INNER JOIN ca_f ON om_f.whse_code = ca_f.whse_code AND ca_f.carrier_service = om_f.carrier_service
LEFT JOIN v_u_shipunit_f_ldb sh_f ON om_f.whse_code = sh_f.whse_code AND om_f.shipment = sh_f.shipment;
GO

