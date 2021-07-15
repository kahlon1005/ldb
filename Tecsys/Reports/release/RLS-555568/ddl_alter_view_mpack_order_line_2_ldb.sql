ALTER VIEW  [dbo].[mpack_order_line_2_ldb]
(mpack_id, mpack_order_seq, whse_code, cont, liquor_cases, liquor_bottles, liquor_weight, non_liquor_pieces, non_liquor_weight,description_list_ldb) as
SELECT mpack_order.mpack_id, mpack_order.mpack_order_seq, q5.whse_code, q5.cont, 
	FLOOR(q5.liquor_cases) liquor_cases,
	FLOOR(q5.liquor_units) liquor_bottles,  
	CAST(IIF(liquor_wgt > 0, sh_f.wgt, 0) as decimal(14,2)) liquor_weight,
	FLOOR(q5.non_liquor_pieces) non_liquor_pieces,	
	CAST(IIF(liquor_wgt > 0, 0, sh_f.wgt)  as decimal(14,2)) non_liquor_weight, 
	description_list_ldb = STUFF(
			(SELECT DISTINCT ', ' + pm_f.sku_desc
			 FROM v_u_iv_f_ldb iv_f
			 INNER JOIN pm_f ON iv_f.whse_code = pm_f.whse_code AND iv_f.sku = pm_f.sku AND iv_f.pkg = pm_f.pkg
			 LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'	
			 WHERE iv_f.ob_oid =  q5.ob_oid
			   AND iv_f.cont = q5.cont
			   AND IIF(p.custom_char_01 IS NOT NULL, 'Y', 'N') = 'Y'
		     FOR XML PATH('')), 1, 1, '') 	
FROM (
	SELECT q4.whse_code, q4.ob_oid, IIF(q4.in_cont = ' ', q4.cont, q4.in_cont) cont, 
		COUNT(distinct IIF(q4.in_cont = ' ', IIF(cn_f.cntype LIKE 'BX%', q4.cont, null), q4.cont)) bottle_case,
		SUM(q4.liquor_cases) liquor_cases, 
		SUM(q4.liquor_units) liquor_units, 
		SUM(q4.liquor_wgt) liquor_wgt, 
		SUM(q4.non_liquor_pieces) non_liquor_pieces, 
		SUM(q4.non_liquor_wgt) non_liquor_wgt 
	FROM (
		SELECT q3.whse_code, q3.ob_oid, q3.cont, q3.in_cont,  
			SUM(q3.liquor_cases) liquor_cases, 
			SUM(q3.liquor_units) liquor_units,
			SUM(q3.liquor_wgt) liquor_wgt, 
			SUM(q3.non_liquor_pieces) non_liquor_pieces, 
			SUM(q3.non_liquor_wgt) non_liquor_wgt 
		FROM (
			SELECT q2.whse_code, q2.ob_oid, q2.sku, q2.sku_desc, q2.pkg, q2.cont, q2.in_cont, q2.cntype,
				FLOOR(q2.liquor_qty/q2.qty1in2) liquor_cases, 
				FLOOR(q2.liquor_qty%q2.qty1in2) + q2.liquor_units liquor_units, 
				(q2.liquor_qty + q2.liquor_units) * q2.wgt1 liquor_wgt, 
				(q2.non_liquor_qty) non_liquor_pieces,
				(q2.non_liquor_qty * q2.wgt1) non_liquor_wgt  
			FROM (
				SELECT q1.whse_code, q1.ob_oid, q1.sku, q1.sku_desc, q1.pkg, q1.qty1in2, q1.wgt1, q1.cont, cn_f.in_cont, cn_f.cntype, 
				IIF(cn_f.cntype LIKE 'BX%', 0, q1.liquor_qty) liquor_qty,
				IIF(cn_f.cntype LIKE 'BX%', q1.liquor_qty, 0) liquor_units,				
				q1.non_liquor_qty 
				FROM ( 
					SELECT q.whse_code, q.ob_oid, q.sku, pm_f.sku_desc, q.pkg, ISNULL(pm_f.custom_numeric_3,1) qty1in2, pm_f.wgt1, q.cont, 
						IIF(p.custom_char_01 IS NULL, qty, 0) liquor_qty, 
						IIF(p.custom_char_01 IS NULL, 0, qty) non_liquor_qty
					FROM (
						SELECT iv_f.whse_code, iv_f.ob_oid, iv_f.sku, iv_f.pkg, iv_f.cont, SUM(iv_f.qty) qty
						FROM v_u_iv_f_ldb iv_f
						WHERE iv_f.ob_oid <> ' '
--AND iv_f.ob_oid = '828526'
						GROUP BY iv_f.whse_code, iv_f.ob_oid, iv_f.sku, iv_f.pkg, iv_f.cont
					) q
					INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = q.pkg
					LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'
				) q1
				INNER JOIN v_u_cn_f_ldb cn_f ON cn_f.whse_code = q1.whse_code AND cn_f.cont = q1.cont
			) q2	
		) q3
		GROUP BY q3.whse_code, q3.ob_oid, q3.cont, q3.in_cont
	) q4
	INNER JOIN v_u_cn_f_ldb cn_f ON cn_f.whse_code = q4.whse_code AND cn_f.cont = q4.cont
	GROUP BY q4.whse_code, q4.ob_oid, IIF(q4.in_cont = ' ', q4.cont, q4.in_cont)
) q5
INNER JOIN v_u_om_f om_f ON om_f.whse_code = q5.whse_code AND om_f.ob_oid = q5.ob_oid
INNER JOIN mpack_order ON mpack_order.whse_code = om_f.whse_code AND mpack_order.om_rid = om_f.om_rid
INNER JOIN v_u_shipunit_f_ldb sh_f ON sh_f.whse_code = q5.whse_code AND sh_f.cont = q5.cont

