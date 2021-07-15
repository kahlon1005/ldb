CREATE OR ALTER VIEW [dbo].[cpack_order_line_ldb]
AS
SELECT cpack.cpack_id, cpack_order.cpack_order_seq, q2.whse_code, q2.ob_oid, om_f.om_rid, q2.cont, q2.line_seq, q2.sku, q2.sku_desc, q2.non_liquor, ISNULL(q2.btl_cont, ' ') btl_cont, CAST(q2.volume as decimal(14,3)) volume, CAST(q2.pack_size as Integer) pack_size, q2.cases, CAST(q2.bottles as Integer) bottles, CAST(q2.non_liquor_pieces as Integer) non_liquor_pieces, ISNULL(q2.cust_oid, ' ') cust_oid  
FROM (
	SELECT q1.whse_code, q1.ob_oid, q1.cont, q1.sku, q1.sku_desc, q1.btl_cont, q1.volume, q1.pack_size, q1.non_liquor, q1.cases, q1.bottles, q1.non_liquor_pieces, q1.cust_oid
		, IIF(q1.btl_cont <> ' ', 3, IIF(q1.non_liquor = 'N', 1, 2)) line_seq	
	FROM (
		SELECT q.whse_code, q.ob_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont) cont, q.sku, pm_f.sku_desc, IIF(cn_f.in_cont <> ' ', cn_f.cont, NULL) btl_cont, pm_f.custom_numeric_5 volume, ISNULL(pm_f.custom_numeric_3,1) pack_size, IIF(p.custom_char_01 IS NULL,'N','Y') non_liquor, q.cust_oid
			, FLOOR(SUM(IIF(cn_f.cntype LIKE 'BX%', 0, q.qty/ISNULL(pm_f.custom_numeric_3,1)))) cases	
			, SUM(IIF(cn_f.cntype LIKE 'BX%', q.qty, 0)) bottles
			, SUM(IIF(p.custom_char_01 IS NOT NULL, q.qty, 0)) non_liquor_pieces			
		  FROM (
			SELECT iv_f.whse_code, iv_f.ob_oid, iv_f.cont, iv_f.sku, iv_f.pkg, od_f.cust_oid, SUM(iv_f.qty) qty 
			FROM v_u_od_f od_f
			INNER JOIN v_u_iv_f_ldb iv_f ON iv_f.whse_code = od_f.whse_code AND iv_f.ob_oid = od_f.ob_oid AND iv_f.ob_lno = od_f.ob_lno
--WHERE iv_f.ob_oid = '814520'-- and od_f.sku = '999862'
			GROUP BY iv_f.whse_code, iv_f.ob_oid, iv_f.cont, iv_f.sku, iv_f.pkg, od_f.cust_oid
		) q
		INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = q.pkg
		LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
		INNER JOIN v_u_cn_f_ldb cn_f ON cn_f.whse_code = q.whse_code AND cn_f.cont = q.cont
		GROUP BY q.whse_code, q.ob_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont), q.sku, pm_f.sku_desc, IIF(cn_f.in_cont <> ' ', cn_f.cont, NULL), pm_f.custom_numeric_5, ISNULL(pm_f.custom_numeric_3,1), IIF(p.custom_char_01 IS NULL,'N','Y'), q.cust_oid
	) q1
) q2
INNER JOIN cpack ON cpack.whse_code = q2.whse_code AND cpack.cont = q2.cont
INNER JOIN v_u_om_f om_f ON om_f.whse_code = q2.whse_code AND om_f.ob_oid = q2.ob_oid
INNER JOIN cpack_order ON cpack_order.whse_code = cpack.whse_code AND cpack_order.cpack_id = cpack.cpack_id AND cpack_order.om_rid = om_f.om_rid 
INNER JOIN v_u_shipunit_f_ldb sh_f ON om_f.whse_code = sh_f.whse_code AND om_f.shipment = sh_f.shipment AND sh_f.cont_packlist = cpack.cont_packing_list
--ORDER BY q2.whse_code, q2.ob_oid, q2.cont, q2.line_seq


GO