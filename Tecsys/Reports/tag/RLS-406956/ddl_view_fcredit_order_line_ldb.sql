CREATE OR ALTER VIEW [dbo].[fcredit_order_line_ldb]
AS
SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q2.whse_code, q2.ob_oid, q2.sku, q2.sku_desc, 
	IIF(q2.non_liquor IS NULL,'N','Y') non_liquor, 
	CAST(q2.volume as decimal(14,3)) volume, 
	CAST(q2.pack_size as Integer) pack_size, 
	CAST(q2.cases  as Integer) cases, 
	CAST(IIF(q2.non_liquor IS NULL,q2.bottles,0) as Integer) bottles, 
	CAST(q2.non_liquor_pieces as Integer) non_liquor_pieces, 
	ISNULL(q2.cust_oid, ' ') cust_oid  
FROM (
	SELECT q0.whse_code, q0.ob_oid, q0.sku, pm_f.sku_desc, p.custom_char_01 non_liquor,
		pm_f.custom_numeric_5 volume, ISNULL(pm_f.custom_numeric_3,1) pack_size, q0.cust_oid, 
		FLOOR((q0.ord_qty - SUM(ISNULL(qty,0)))/ISNULL(pm_f.custom_numeric_3,1)) cases, 
		FLOOR((q0.ord_qty - SUM(ISNULL(qty,0)))%ISNULL(pm_f.custom_numeric_3,1)) bottles,
		IIF(p.custom_char_01 IS NULL, 0, (q0.ord_qty-SUM(ISNULL(qty,0)))) non_liquor_pieces
	FROM (
			SELECT od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.pkg, od_f.cust_oid, sum(od_f.ord_qty) ord_qty
			FROM v_u_od_f od_f
--WHERE od_f.ob_oid = '1098406'
			GROUP BY od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.pkg, od_f.cust_oid
	) q0
	LEFT JOIN v_u_iv_f_ldb iv_f ON iv_f.whse_code = q0.whse_code AND iv_f.ob_oid = q0.ob_oid AND iv_f.ob_lno = q0.ob_lno AND iv_f.sku = q0.sku AND iv_f.pkg = REPLACE(q0.pkg, '*', ' ')
	INNER JOIN pm_f ON pm_f.whse_code = q0.whse_code AND pm_f.sku = q0.sku AND pm_f.pkg = REPLACE(q0.pkg, '*', ' ')
	LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
	GROUP BY q0.whse_code, q0.ob_oid, q0.sku, pm_f.sku_desc, p.custom_char_01, pm_f.custom_numeric_5, ISNULL(pm_f.custom_numeric_3,1), q0.cust_oid, q0.ord_qty
) q2
INNER JOIN v_u_om_f om_f ON om_f.whse_code = q2.whse_code AND om_f.ob_oid = q2.ob_oid
INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid
WHERE (q2.cases > 0 OR q2.bottles > 0)

GO