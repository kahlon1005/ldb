SELECT whse_code, wave, ob_oid, ord_cases, cont_picked, ob_drop_time,waved_time, plan_time, release_date,
        shipped_time,
	repl_start, repl_end,  
	dbo.getDateDiff_ldb(repl_start, repl_end) repl_time,
	pick_start,	pick_end, 
	dbo.getDateDiff_ldb(pick_start, pick_end) pick_time,
	stag_start, stag_end, 
	dbo.getDateDiff_ldb(stag_start, stag_end) stag_time, 
	load_start, load_end, 
	dbo.getDateDiff_ldb(load_start, load_end) load_time, 
	dbo.getDateDiff_ldb(waved_time, shipped_time) wave_time
FROM (
	SELECT om_f.whse_code, om_f.wave, om_f.ob_oid, om_f.create_stamp ob_drop_time, 		
		wv_f.create_stamp waved_time, 
		release_date,
		(SELECT COUNT(distinct cont) FROM shipunit_f WHERE shipunit_f.whse_code = om_f.whse_code AND shipunit_f.wave = om_f.wave) cont_picked,		
		(SELECT q1.whse_code, q1.ob_oid, q1.sku, FLOOR(q1.ord_qty/q1.qty1in2) +  FLOOR(q1.ord_qty%q1.qty1in2) ord_cases
		FROM (
				SELECT od_f.whse_code, od_f.ob_oid, od_f.sku, od_f.pkg, ISNULL(pm_f.custom_numeric_3,1) qty1in2,  SUM(od_f.ord_qty) ord_qty
				FROM od_f
				INNER JOIN pm_f ON pm_f.whse_code = od_f.whse_code AND pm_f.sku = od_f.sku AND pm_f.pkg = REPLACE(od_f.pkg, '*', ' ')
				LEFT JOIN wms_system_properties_ldb p ON p.whse_code = pm_f.whse_code AND p.custom_char_01 = pm_f.custom_char_6 AND p.property_name = 'NON-LIQUOR'		
				WHERE od_f.whse_code = om_f.whse_code AND od_f.ob_oid = om_f.ob_oid 
				GROUP BY od_f.whse_code, od_f.ob_oid, od_f.sku, od_f.pkg, ISNULL(pm_f.custom_numeric_3,1)
			) q1				
		) ord_cases
		(SELECT SUM(liquor_cases_ord + liquor_btls_ord) FROM ob_ord_summ_ldb od_s WHERE od_s.whse_code = om_f.whse_code AND od_s.ob_oid = om_f.ob_oid) ord_cases_2,
		(SELECT MIN(start_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND transact = 'RDY') plan_time,
		(SELECT MIN(start_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND transact = 'REPL') repl_start,
		(SELECT MAX(end_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND transact = 'REPL') repl_end,	
		(SELECT MIN(start_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND it_f.ob_oid = om_f.ob_oid AND transact = 'RPCK' AND to_cont <> '') pick_start,
		(SELECT MAX(end_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND it_f.ob_oid = om_f.ob_oid AND transact = 'RPCK' AND to_cont <> '') pick_end,	
		(SELECT MIN(start_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND it_f.ob_oid = om_f.ob_oid AND transact = 'PACK') stag_start,
		(SELECT MAX(end_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND it_f.ob_oid = om_f.ob_oid AND transact = 'PACK') stag_end,
		(SELECT MIN(start_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND transact = 'LOAD') load_start,
		(SELECT MAX(end_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND  transact = 'LOAD') load_end,
		(SELECT MAX(end_time) FROM it_f WHERE it_f.whse_code = om_f.whse_code AND it_f.wave = om_f.wave AND it_f.ob_oid = om_f.ob_oid AND transact = 'SHIP') shipped_time
	FROM wv_f wv_f
	INNER JOIN om_f ON om_f.whse_code = wv_f.whse_code AND om_f.wave = wv_f.wave		
)q