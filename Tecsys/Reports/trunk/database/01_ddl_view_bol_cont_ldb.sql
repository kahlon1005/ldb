--created new view to join shipunit_f_es (current) and shipunit_h_es (history)
CREATE OR ALTER VIEW [dbo].v_u_shipunit_f_es
       (shipunit_rid, whse_code, scaled_wgt)
AS
SELECT shipunit_rid, whse_code, scaled_wgt FROM  shipunit_f_es
UNION ALL
SELECT shipunit_rid, whse_code, scaled_wgt from shipunit_h_es;

GO

CREATE OR ALTER VIEW [dbo].[bol_cont_ldb]
(cont, whse_code, bol_id, shipunit_rid, scaled_wgt, non_liquor) as
SELECT cont, whse_code, bol_id, shipunit_rid, IIF(liquor_scaled_wgt > 0, liquor_scaled_wgt, non_liquor_scaled_wgt) scaled_wgt, 
	IIF(liquor_scaled_wgt > 0, 'N', 'Y') non_liquor 
FROM (
	SELECT cont, whse_code, bol_id, shipunit_rid, SUM(IIF(non_liquor = 'N', scaled_wgt, 0)) liquor_scaled_wgt, SUM(IIF(non_liquor = 'Y', scaled_wgt, 0)) non_liquor_scaled_wgt 
	FROM (
		SELECT 
			DISTINCT a.cont, b.whse_code, b.bol_id, s.shipunit_rid, s.wgt scaled_wgt, --c.scaled_wgt,
			   CASE WHEN ((SELECT count(1) FROM pm_f
						   WHERE pm_f.whse_code = a.whse_code
							 AND pm_f.sku = a.sku
							 AND pm_f.pkg = a.pkg
							 AND EXISTS (SELECT 1 FROM wms_system_properties_ldb wsp
										 WHERE pm_f.whse_code = wsp.whse_code
										   AND pm_f.custom_char_6 = wsp.custom_char_01
										   AND wsp.property_name = 'NON-LIQUOR')) > 0) THEN 'Y' ELSE 'N' END non_liquor
		FROM bol b
		INNER JOIN v_u_shipunit_f_ldb s ON b.whse_code = s.whse_code AND b.bol = s.bol
		INNER JOIN v_u_shipunit_f_es c ON c.whse_code = s.whse_code AND c.shipunit_rid = s.shipunit_rid  
		INNER JOIN v_u_iv_f_ldb a ON a.whse_code = s.whse_code AND a.cont = s.cont		
		--and  b.bol_id = 104
	) q
	GROUP BY cont, whse_code, bol_id, shipunit_rid
) q1;

GO