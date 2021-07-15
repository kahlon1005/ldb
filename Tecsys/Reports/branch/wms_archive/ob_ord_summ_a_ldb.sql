-- create outbound summary archive view 
CREATE   VIEW [dbo].[ob_ord_summ_a_ldb]
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
	q4.final_loc_YN,
	q4.last_trans_dt
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
		IIF(q3.cont <> '', IIF((SELECT COUNT(1) FROM v_u_cp_h cp_h WHERE cp_h.whse_code = q3.whse_code AND cp_h.ob_oid = q3.ob_oid AND cp_h.cont = q3.cont AND cp_h.final_loc = 'Y') > 0, 'Y', 'N'), 'N') final_loc_YN,
		q3.last_trans_dt
	FROM (
 		SELECT q2.whse_code, q2.ob_oid, q2.cont,  
				SUM(IIF(q2.cont IS NULL, q2.b_liquor_cases_ord, q2.liquor_cases_ord)) liquor_cases_ord, 
				SUM(q2.liquor_cases_pckd) liquor_cases_pckd, 
				SUM(IIF(q2.cont IS NULL, q2.b_liquor_btls_ord, q2.liquor_btls_ord)) liquor_btls_ord, 
				SUM(q2.liquor_btls_pckd) liquor_btls_pckd, 
				SUM(q2.non_liquor_pcs_ord) non_liquor_pcs_ord, 
				SUM(q2.non_liquor_pcs_pckd) non_liquor_pcs_pckd,
				MAX(q2.last_trans_dt) last_trans_dt
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
				,it_last.last_trans_dt
			FROM (
				SELECT q.whse_code, q.ob_oid, q.cont, q.sku, q.pkg, q.ord_qty, q.qty, ISNULL(pm_f.custom_numeric_3,1) qty1in2, 
					 IIF(p.custom_char_01 IS NOT NULL, 'Y', 'N') non_liquor
				FROM (
					SELECT od_f.whse_code, od_f.ob_oid, iv_f.cont, od_f.sku, od_f.pkg, IIF(iv_f.cont IS NULL, od_f.ord_qty,SUM(iv_f.qty)) ord_qty,  IIF(iv_f.cont IS NULL, od_f.cmp_qty, IIF(iv_f.mod_id = 'cm_f', 0, SUM(iv_f.qty))) qty 
					FROM v_u_od_a od_f
					LEFT JOIN v_u_cm_f_ldb iv_f ON od_f.whse_code = iv_f.whse_code AND od_f.ob_oid = iv_f.ob_oid AND od_f.ob_lno = iv_f.ob_lno AND od_f.sku = iv_f.sku AND REPLACE(od_f.pkg, '*', ' ') = iv_f.pkg		 
					WHERE (ob_lno_stt <> 'RDY' OR (ob_lno_stt = 'RDY' AND od_f.plan_qty > 0))
					GROUP BY od_f.whse_code, od_f.ob_oid, iv_f.cont, od_f.sku, od_f.pkg, iv_f.mod_id, od_f.ord_qty, od_f.cmp_qty
				) q
				INNER JOIN pm_f ON pm_f.whse_code = q.whse_code AND pm_f.sku = q.sku AND pm_f.pkg = REPLACE(q.pkg, '*', ' ')
				LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'		
			) q1
			LEFT JOIN v_u_cn_a_ldb cn_f ON cn_f.whse_code = q1.whse_code AND cn_f.cont = q1.cont	
			LEFT JOIN  
			( SELECT it.whse_code, it.ob_oid, it.ob_type, MAX(it.mod_stamp) as last_trans_dt 
				  FROM v_u_it_h it 
				  GROUP BY it.whse_code, it.ob_oid, it.ob_type 
				)it_last ON it_last.whse_code = q1.whse_code AND it_last.ob_oid = q1.ob_oid 
		) q2	
		GROUP BY q2.whse_code, q2.ob_oid, q2.cont 	
	) q3
	INNER JOIN v_u_om_a om_f ON om_f.whse_code = q3.whse_code AND om_f.ob_oid = q3.ob_oid
	INNER JOIN ca_f ON ca_f.whse_code = q3.whse_code AND ca_f.carrier_service = om_f.carrier_service
	LEFT JOIN v_u_cn_a_ldb cn_f ON cn_f.whse_code = q3.whse_code AND cn_f.cont = q3.cont
) q4
WHERE ((q4.ob_ord_stt <> 'RDY' AND q4.ob_ord_stt <> 'ISHP') OR ((q4.ob_ord_stt = 'RDY' and q4.cont <> '') OR (q4.ob_ord_stt = 'RDY' and q4.pend_cmd_YN = 'Y')))
--AND q4.ob_oid = '1162022';


GO

-- create volumetric archive view 
CREATE   VIEW [dbo].[v_ob_volumetric_a_ldb]
AS
SELECT  od_f.whse_code, od_f.ob_oid, SUM(od_f.ord_vol) ord_vol, 
	CEILING(SUM(od_f.ord_vol)/(SELECT (intn_dpth*intn_hgt*intn_wid*3.53147E-5) * cast(cast(max_fill as decimal(18,4)) * 1/100 as decimal(18,2)) max_fill from cnty_f where cnty_f.whse_code = od_f.whse_code AND  cnty_f.cntype = 'RPAL')) pallets 
FROM (
	SELECT od_f.whse_code, od_f.ob_oid, od_f.ob_lno, od_f.sku, od_f.ord_qty, pm_f.custom_numeric_3 pkg_size, pm_f.uom1, 
	od_f.ord_qty * ((IIF(pm_f.uom1 = 'CASE1',(pm_f.dpth1 * pm_f.hgt1 * pm_f.wid1), (pm_f.dpth2 * pm_f.hgt2 * pm_f.wid2)) * 3.53147E-5)/pm_f.custom_numeric_3) ord_vol 
	FROM v_u_od_a od_f 
	INNER JOIN pm_f ON pm_f.whse_code = od_f.whse_code AND pm_f.sku = od_f.sku AND pm_f.pkg = REPLACE(od_f.pkg, '*','')
	--where od_f.ob_oid = '1118705' --AND od_f.sku = '453092'
) od_f
GROUP BY od_f.ob_oid, od_f.whse_code

GO