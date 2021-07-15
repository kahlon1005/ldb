ALTER   VIEW  [dbo].[mpack_order_line_ldb]
(mpack_id, mpack_order_seq, whse_code, cust_oid, cases) AS
SELECT q2.mpack_id, q2.mpack_order_seq, q2.whse_code, q2.cust_oid, FLOOR(q2.liquor_cases) cases 
FROM (
	SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q3.whse_code, q3.cust_oid, SUM(q3.liquor_cases) liquor_cases FROM (
		SELECT q1.whse_code, q1.ob_oid, q1.cust_oid, q1.cont, q1.liquor_cases + q1.bottle_case liquor_cases
		FROM(
			SELECT q.whse_code, q.ob_oid, q.cust_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont) cont,  
			    COUNT(distinct IIF(cn_f.in_cont = ' ', IIF(cn_f.cntype LIKE 'BX%', q.cont, null), q.cont)) bottle_case,
				SUM(IIF(cn_f.cntype LIKE 'BX%', 0, (q.qty/ISNULL(pm_f.custom_numeric_3,1)))) liquor_cases,
				SUM(IIF(cn_f.cntype LIKE 'BX%', q.qty, 0)) liquor_units	
			  FROM (
				SELECT iv_f.whse_code, iv_f.ob_oid, od_f.cust_oid, iv_f.cont, iv_f.sku, iv_f.pkg, SUM(iv_f.qty) qty 
				FROM v_u_od_f od_f
				INNER JOIN v_u_iv_f_ldb iv_f ON iv_f.whse_code = od_f.whse_code AND iv_f.ob_oid = od_f.ob_oid AND iv_f.ob_lno = od_f.ob_lno
--WHERE od_f.ob_oid = '828526'
				GROUP BY iv_f.whse_code, iv_f.ob_oid, od_f.cust_oid, iv_f.cont, iv_f.sku, iv_f.pkg
			) q
			INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = q.pkg
			LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
			INNER JOIN v_u_cn_f_ldb cn_f ON cn_f.whse_code = q.whse_code AND cn_f.cont = q.cont
			WHERE p.custom_char_01 IS NULL
			GROUP BY q.whse_code, q.ob_oid, q.cust_oid, IIF(cn_f.in_cont <> ' ', cn_f.in_cont, q.cont)
			) q1
		)q3
	INNER JOIN v_u_om_f om_f ON om_f.whse_code = q3.whse_code AND om_f.ob_oid = q3.ob_oid
	INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid
	GROUP BY mpack_order.mpack_id, mpack_order.mpack_order_seq, q3.whse_code, q3.cust_oid
)q2
