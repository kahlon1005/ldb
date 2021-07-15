CREATE OR ALTER VIEW [dbo].[ob_ord_summ_ldb]
AS
SELECT 
    q4.whse_code,  q4.ob_oid, q4.ob_ord_stt, q4.bignum, q4.wave, q4.shipment,
	q4.ship_datetime,
	q4.ship_custnum, q4.ship_name, q4.carrier_service, q4.carrier_code,
	q4.cont, q4.cntype, q4.liquor_cases_ord, q4.liquor_cases_pckd, q4.liquor_btls_ord, q4.liquor_btls_pckd, q4.non_liquor_pcs_ord, 
	q4.non_liquor_pcs_pckd, q4.scaled_wgt, 	
	q4.ship_complete,
	q4.loc, 	
	q4.locked_YN, 
	q4.pend_cmd_YN, 		
	q4.suspended_cmd_YN,
	q4.final_loc_YN	
FROM (
SELECT q3.whse_code,  q3.ob_oid, om_f.ob_ord_stt, RIGHT(q3.ob_oid,4) bignum, om_f.wave, om_f.shipment,
	CONVERT(varchar,CONVERT(DATE,om_f.ship_date)) +' '+ ISNULL(om_f.appoint_time, '00:00:00') ship_datetime,
	om_f.ship_custnum, om_f.ship_name, om_f.carrier_service, ca_f.carrier_code,
	ISNULL(q3.cont,'') cont, ISNULL(cn_f.cntype,'') cntype, q3.liquor_cases_ord, q3.liquor_cases_pckd, q3.liquor_btls_ord, q3.liquor_btls_pckd, q3.non_liquor_pcs_ord, q3.non_liquor_pcs_pckd, 0 scaled_wgt, 	
	om_f.ship_complete,
	ISNULL((SELECT TOP 1 cm_f.loc FROM cm_f WHERE cm_f.whse_code = q3.whse_code AND cm_f.to_cont = q3.cont ORDER BY cm_f.cmd_seq ASC), cn_f.loc) loc, 	
	IIF(q3.cont IS NULL, 'N', IIF((SELECT COUNT(1) FROM cm_f WHERE cm_f.whse_code = q3.whse_code AND (cm_f.to_cont = q3.cont OR cm_f.to_cont = replace(q3.cont,'C','SP')) AND cm_f.session_app_id > 0) > 0, 'Y', 'N')) locked_YN, 
	IIF(q3.cont IS NULL, 
		IIF((SELECT COUNT(1) FROM cm_f WHERE cm_f.whse_code = q3.whse_code AND cm_f.ob_oid = q3.ob_oid AND cm_f.to_cont = '' AND cm_f.cont = '') > 0, 'Y', 'N'), 
		IIF((SELECT COUNT(1) FROM cm_f WHERE cm_f.whse_code = q3.whse_code AND (cm_f.to_cont = q3.cont OR cm_f.to_cont = replace(q3.cont,'C','SP'))) > 0, 'Y', 'N')) pend_cmd_YN, 		
	IIF(q3.cont IS NULL, 'N', IIF((SELECT COUNT(1) from cm_f WHERE cm_f.whse_code = q3.whse_code AND (cm_f.to_cont = q3.cont OR cm_f.to_cont = replace(q3.cont,'C','SP')) AND cm_f.cmd_stt = 'SUSP') > 0, 'Y', 'N')) suspended_cmd_YN,
	IIF(q3.cont <> '', IIF((SELECT COUNT(1) FROM cp_h WHERE cp_h.whse_code = q3.whse_code AND cp_h.ob_oid = q3.ob_oid AND cp_h.cont = q3.cont AND cp_h.final_loc = 'Y') > 0, 'Y', 'N'), 'N') final_loc_YN	
FROM (
	SELECT q2.whse_code, q2.ob_oid, q2.cont,  
			SUM(IIF(q2.cont IS NULL, q2.b_liquor_cases_ord, q2.liquor_cases_ord)) liquor_cases_ord, 
			SUM(q2.liquor_cases_pckd) liquor_cases_pckd, 
			SUM(IIF(q2.cont IS NULL, q2.b_liquor_btls_ord, q2.liquor_btls_ord)) liquor_btls_ord, 
			SUM(q2.liquor_btls_pckd) liquor_btls_pckd, 
			SUM(q2.non_liquor_pcs_ord) non_liquor_pcs_ord, 
			SUM(q2.non_liquor_pcs_pckd) non_liquor_pcs_pckd
	FROM (
		SELECT q1.whse_code, q1.ob_oid, IIF(cn_f.in_cont = ' ', q1.cont, cn_f.in_cont) cont, q1.cont f_cont, q1.sku, q1.pkg, q1.ord_qty, q1.qty, q1.qty1in2, q1.non_liquor,ISNULL(cn_f.cntype, '') cntype,
   		    IIF(q1.non_liquor = 'N', FLOOR(q1.ord_qty/q1.qty1in2), 0) b_liquor_cases_ord,			
			IIF(q1.non_liquor = 'N' AND ISNULL(cn_f.cntype,'') NOT LIKE 'BX%', FLOOR(q1.ord_qty/q1.qty1in2), 0) liquor_cases_ord,
			IIF(q1.non_liquor = 'N' AND ISNULL(cn_f.cntype,'') NOT LIKE 'BX%', FLOOR(q1.qty/q1.qty1in2), 0) liquor_cases_pckd,
			IIF(q1.non_liquor = 'N', FLOOR(q1.ord_qty%q1.qty1in2), 0) b_liquor_btls_ord,			
			IIF(q1.non_liquor = 'N' AND ISNULL(cn_f.cntype,'') LIKE 'BX%', FLOOR(q1.ord_qty), 0) liquor_btls_ord,
			IIF(q1.non_liquor = 'N' AND ISNULL(cn_f.cntype,'') LIKE 'BX%', FLOOR(q1.qty), IIF(cn_f.cntype IS NULL, q1.qty%q1.qty1in2, 0)) liquor_btls_pckd,
			IIF(q1.non_liquor = 'Y', FLOOR(q1.ord_qty), 0) non_liquor_pcs_ord,
			IIF(q1.non_liquor = 'Y', FLOOR(q1.qty), 0) non_liquor_pcs_pckd	
		FROM (
			SELECT q.whse_code, q.ob_oid, q.cont, q.sku, q.pkg, q.ord_qty, q.qty, ISNULL(pm_f.custom_numeric_3,1) qty1in2, 
				 IIF(p.custom_char_01 IS NOT NULL, 'Y', 'N') non_liquor
			FROM (
				SELECT od_f.whse_code, od_f.ob_oid, iv_f.cont, od_f.sku, od_f.pkg, IIF(iv_f.cont IS NULL, od_f.ord_qty,SUM(iv_f.qty)) ord_qty,  IIF(iv_f.cont IS NULL, od_f.cmp_qty, IIF(iv_f.mod_id = 'cm_f', 0, SUM(iv_f.qty))) qty 
				FROM od_f
				LEFT JOIN v_u_cm_f_ldb iv_f ON od_f.whse_code = iv_f.whse_code AND od_f.ob_oid = iv_f.ob_oid AND od_f.ob_lno = iv_f.ob_lno AND od_f.sku = iv_f.sku AND REPLACE(od_f.pkg, '*', ' ') = iv_f.pkg		 
				WHERE (ob_lno_stt <> 'RDY' OR (ob_lno_stt = 'RDY' AND od_f.plan_qty > 0))
				GROUP BY od_f.whse_code, od_f.ob_oid, iv_f.cont, od_f.sku, od_f.pkg, iv_f.mod_id, od_f.ord_qty, od_f.cmp_qty
			) q
			INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = REPLACE(q.pkg, '*', ' ')
			LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'				
		) q1
		LEFT JOIN cn_f ON cn_f.whse_code = q1.whse_code AND cn_f.cont = q1.cont	
	) q2	
	GROUP BY q2.whse_code, q2.ob_oid, q2.cont  		
) q3
INNER JOIN om_f ON om_f.whse_code = q3.whse_code AND om_f.ob_oid = q3.ob_oid
INNER JOIN ca_f ON ca_f.carrier_service = om_f.carrier_service
LEFT JOIN cn_f ON cn_f.whse_code = q3.whse_code AND cn_f.cont = q3.cont
) q4
WHERE ((q4.ob_ord_stt <> 'RDY' AND q4.ob_ord_stt <> 'ISHP') OR ((q4.ob_ord_stt = 'RDY' and q4.cont <> '') OR (q4.ob_ord_stt = 'RDY' and q4.pend_cmd_YN = 'Y')))
--AND q4.ob_oid = '1162022';


GO