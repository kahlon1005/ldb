-- Driver Release archive form view
CREATE     VIEW [dbo].[v_u_ibod_a_ldb] 
(whse_code, ibod_rid, ibodh_rid, ib_oid, ib_type, ib_lno, sku, pkg,  lot, uc1, uc2, uc3, ib_lno_stt, ord_qty, ord_uom, cmp_qty, hold,  cont, tag, complete, expect_date, dt_mfg, rotation_time, mod_resource,  mod_user, mod_counter, create_stamp, mod_stamp, receipt, dms_rcvr_line_seq,  reference_num, host_order_lno, dedicated_ob_oid, dedicated_ob_lno,  gtin, purch_uom, purch_mult, custom_char_1, custom_char_2, custom_char_3,  custom_char_4, custom_char_5, custom_char_6, custom_char_7, custom_char_8,  custom_char_9, custom_char_10, custom_numeric_1, custom_numeric_2,  custom_numeric_3, custom_numeric_4, custom_numeric_5, custom_numeric_6,  custom_numeric_7, custom_numeric_8, custom_numeric_9, custom_numeric_10, whse_ref) 
AS 
SELECT whse_code, ibod_rid, 0 ibodh_rid, ib_oid, ib_type, ib_lno, sku, pkg, lot,  uc1, uc2, uc3, ib_lno_stt, ord_qty, ord_uom, cmp_qty, hold, cont, tag, complete,  expect_date, dt_mfg, rotation_time, mod_resource, mod_user, mod_counter,  create_stamp, mod_stamp, receipt, dms_rcvr_line_seq, reference_num, host_order_lno,  dedicated_ob_oid, dedicated_ob_lno, gtin, purch_uom, purch_mult, custom_char_1,  custom_char_2, custom_char_3, custom_char_4, custom_char_5, custom_char_6,  custom_char_7, custom_char_8, custom_char_9, custom_char_10, custom_numeric_1,  custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9,  custom_numeric_10, whse_ref 
FROM   ibod_f 
UNION ALL 
SELECT whse_code, ibod_rid, ibodh_rid, ib_oid,  ib_type, ib_lno, sku, pkg, lot, uc1, uc2, uc3, ib_lno_stt, ord_qty, ord_uom,  cmp_qty, hold, cont, tag, complete, expect_date, dt_mfg, rotation_time,  mod_resource, mod_user, mod_counter, create_stamp, mod_stamp, receipt,  dms_rcvr_line_seq, reference_num, host_order_lno, dedicated_ob_oid,  dedicated_ob_lno, gtin, purch_uom, purch_mult, custom_char_1, custom_char_2,  custom_char_3, custom_char_4, custom_char_5, custom_char_6, custom_char_7,  custom_char_8, custom_char_9, custom_char_10, custom_numeric_1,  custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9,  custom_numeric_10, whse_ref 
FROM   ibod_h 
where ib_oid not in (
	select ib_oid 
	from ibod_f 
	where 
		ib_oid = ibod_h.ib_oid and 
		ib_type =ibod_h.ib_type and 
		ib_lno = ibod_h.ib_lno and 
		whse_code = ibod_h.whse_code)
UNION ALL 
SELECT whse_code, ibod_rid, ibodh_rid, ib_oid,  ib_type, ib_lno, sku, pkg, lot, uc1, uc2, uc3, ib_lno_stt, ord_qty, ord_uom,  cmp_qty, hold, cont, tag, complete, expect_date, dt_mfg, rotation_time,  mod_resource, mod_user, mod_counter, create_stamp, mod_stamp, receipt,  dms_rcvr_line_seq, reference_num, host_order_lno, dedicated_ob_oid,  dedicated_ob_lno, gtin, purch_uom, purch_mult, custom_char_1, custom_char_2,  custom_char_3, custom_char_4, custom_char_5, custom_char_6, custom_char_7,  custom_char_8, custom_char_9, custom_char_10, custom_numeric_1,  custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9,  custom_numeric_10, whse_ref 
FROM   ibod_a 
where ib_oid not in (
	select ib_oid 
	from ibod_f 
	where 
		ib_oid = ibod_a.ib_oid and 
		ib_type =ibod_a.ib_type and 
		ib_lno = ibod_a.ib_lno and 
		whse_code = ibod_a.whse_code)

GO
