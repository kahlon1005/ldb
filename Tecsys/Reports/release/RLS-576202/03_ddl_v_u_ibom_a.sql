CREATE OR ALTER view [dbo].[v_u_ibom_a] (
	whse_code, ibom_rid, ibomh_rid, ib_oid, ib_type, ib_ord_stt, ord_date, recv_date,  arrival_date, total_wgt, carrier_service, grp1, grp2, grp3, probill, supplier,  supp_num, is_host_maintained, is_host_planned, is_keep_backorder, is_asn_required,  dedicated_ob_oid, dedicated_order_status, dedicated_order_recv_method, supp_gln,  is_trusted, external_reference,  custom_char_1, custom_char_2, custom_char_3, custom_char_4, custom_char_5,  custom_char_6, custom_char_7, custom_char_8, custom_char_9, custom_char_10,  custom_numeric_1, custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9, custom_numeric_10,  mod_resource, mod_user, mod_counter, create_stamp, mod_stamp
) AS 
select whse_code, ibom_rid, 0 ibomh_rid, ib_oid, ib_type, ib_ord_stt, ord_date,  recv_date, arrival_date, total_wgt, carrier_service, grp1, grp2, grp3, probill,  supplier, supp_num, is_host_maintained, is_host_planned, is_keep_backorder, is_asn_required,  dedicated_ob_oid, dedicated_order_status, dedicated_order_recv_method, supp_gln,  is_trusted, external_reference,  custom_char_1, custom_char_2, custom_char_3, custom_char_4, custom_char_5,  custom_char_6, custom_char_7, custom_char_8, custom_char_9, custom_char_10,  custom_numeric_1, custom_numeric_2, custom_numeric_3, custom_numeric_4,  custom_numeric_5, custom_numeric_6, custom_numeric_7, custom_numeric_8,  custom_numeric_9, custom_numeric_10, mod_resource, mod_user, mod_counter,  create_stamp, mod_stamp  
from ibom_f  
UNION all 
select whse_code, ibom_rid,  ibomh_rid, ib_oid, ib_type, ib_ord_stt, ord_date, recv_date, arrival_date,  total_wgt, carrier_service, grp1, grp2, grp3, probill, supplier, supp_num,  is_host_maintained, is_host_planned, is_keep_backorder, is_asn_required,  dedicated_ob_oid, dedicated_order_status, dedicated_order_recv_method, supp_gln,  is_trusted, external_reference,  custom_char_1, custom_char_2, custom_char_3, custom_char_4, custom_char_5,  custom_char_6, custom_char_7, custom_char_8, custom_char_9, custom_char_10,  custom_numeric_1, custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9, custom_numeric_10,  mod_resource, mod_user, mod_counter,  create_stamp, mod_stamp 
from ibom_h where is_final_copy = 1
UNION all 
select whse_code, ibom_rid,  ibomh_rid, ib_oid, ib_type, ib_ord_stt, ord_date, recv_date, arrival_date,  total_wgt, carrier_service, grp1, grp2, grp3, probill, supplier, supp_num,  is_host_maintained, is_host_planned, is_keep_backorder, is_asn_required,  dedicated_ob_oid, dedicated_order_status, dedicated_order_recv_method, supp_gln,  is_trusted, external_reference,  custom_char_1, custom_char_2, custom_char_3, custom_char_4, custom_char_5,  custom_char_6, custom_char_7, custom_char_8, custom_char_9, custom_char_10,  custom_numeric_1, custom_numeric_2, custom_numeric_3, custom_numeric_4, custom_numeric_5,  custom_numeric_6, custom_numeric_7, custom_numeric_8, custom_numeric_9, custom_numeric_10,  mod_resource, mod_user, mod_counter,  create_stamp, mod_stamp 
from ibom_a where is_final_copy = 1
GO


