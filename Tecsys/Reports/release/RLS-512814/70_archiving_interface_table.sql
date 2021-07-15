
--1. Stop $U jobs
--2. Execute below scripts in to archive and purge data from interface tables.
--3. If delete are successful do COMMIT or ROLLBACK
--4. Rebuild indexes. 
--5. Start $U jobs


--Script to Archive
-----------------------------------------------

DECLARE @archive_date DATETIME = DateAdd(m, -1, GETDATE())

PRINT N'Archive starting as of  - '  
    + RTRIM(CAST(@archive_date AS nvarchar(30)))  
    + N'.';  

-- Stop Auto Commit

SET IMPLICIT_TRANSACTIONS ON;
PRINT N'Turn AUTO COMMIT OFF';


PRINT N'Archive Table up_ship_archive';

INSERT INTO [dbo].[up_ship_archive]
           ([up_ship_up_rid]
           ,[upl_stt]
           ,[is_extracted]
           ,[interface_batch]
           ,[ob_oid]
           ,[ob_type]
           ,[shipment]
           ,[dt_ship]
           ,[dt_trans]
           ,[is_picked_short]
           ,[carrier_service]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[pams]
           ,[fr_terms]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[invoice_num]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[lock_id]
           ,[whse_code]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[create_user]
           ,[is_sms_sent])
SELECT 
            [up_ship_up_rid]
           ,[upl_stt]
           ,[is_extracted]
           ,[interface_batch]
           ,[ob_oid]
           ,[ob_type]
           ,[shipment]
           ,[dt_ship]
           ,[dt_trans]
           ,[is_picked_short]
           ,[carrier_service]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[pams]
           ,[fr_terms]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[invoice_num]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[lock_id]
           ,[whse_code]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[create_user]
           ,[is_sms_sent]
FROM [up_ship]
WHERE CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT';


PRINT N'Archive Table up_ship_freight_archive';

INSERT INTO [up_ship_freight_archive]
           ([up_ship_id]
           ,[up_ship_freight_seq]
           ,[fr_chg1]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[whse_code])
SELECT  
            [up_ship_id]
           ,[up_ship_freight_seq]
           ,[fr_chg1]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[whse_code]
FROM up_ship_freight WHERE up_ship_id IN (
SELECT up_ship_id FROM up_ship
WHERE CAST(create_stamp AS DATE) <= @archive_date
  AND is_extracted = 1
  AND upl_stt = 'SENT');


PRINT N'Archive Table up_ship_freight_detail_archive';

INSERT INTO [dbo].[up_ship_freight_detail_archive]
           ([up_ship_id]
           ,[up_ship_freight_seq]
           ,[up_ship_freight_detail_seq]
           ,[up_ship_freight_detail_up_rid]
           ,[ob_oid]
           ,[ob_type]
           ,[carrier_code]
           ,[carrier_service]
           ,[probill]
           ,[bol]
           ,[fr_chg1]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[whse_code])
SELECT 
            [up_ship_id]
           ,[up_ship_freight_seq]
           ,[up_ship_freight_detail_seq]
           ,[up_ship_freight_detail_up_rid]
           ,[ob_oid]
           ,[ob_type]
           ,[carrier_code]
           ,[carrier_service]
           ,[probill]
           ,[bol]
           ,[fr_chg1]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[whse_code]
FROM up_ship_freight_detail WHERE up_ship_id IN (
SELECT up_ship_id FROM up_ship
WHERE CAST(create_stamp AS DATE) <= @archive_date
AND is_extracted = 1
AND upl_stt = 'SENT');



PRINT N'Archive Table up_ship_line_archive';

INSERT INTO [dbo].[up_ship_line_archive]
           ([up_ship_id]
           ,[up_ship_line_seq]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[host_order_lno]
           ,[sku]
           ,[pkg]
           ,[host_backordered]
           ,[qty]
           ,[act_qty]
           ,[is_picked_short]
           ,[kit_line_type]
           ,[kit_order_group]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code])
SELECT 
            [up_ship_id]
           ,[up_ship_line_seq]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[host_order_lno]
           ,[sku]
           ,[pkg]
           ,[host_backordered]
           ,[qty]
           ,[act_qty]
           ,[is_picked_short]
           ,[kit_line_type]
           ,[kit_order_group]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code]
FROM up_ship_line WHERE up_ship_id in (
SELECT up_ship_id FROM up_ship
WHERE CAST(create_stamp AS DATE) <= @archive_date
AND is_extracted = 1
AND upl_stt = 'SENT');


PRINT N'Archive Table up_ship_line_detail_archive';

INSERT INTO [dbo].[up_ship_line_detail_archive]
           ([up_ship_id]
           ,[up_ship_line_seq]
           ,[up_ship_line_detail_seq]
           ,[up_ship_line_detail_up_rid]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[tag]
           ,[hold]
           ,[affect_damaged]
           ,[qty]
           ,[act_qty]
           ,[is_picked_short]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[cont]
           ,[outermost_cont]
           ,[tms_tracking_num]
           ,[user_name]
           ,[host_order_lno]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[product_exp_date]
           ,[whse_code]
           ,[bol]
           ,[use_by_time])
SELECT 
            [up_ship_id]
           ,[up_ship_line_seq]
           ,[up_ship_line_detail_seq]
           ,[up_ship_line_detail_up_rid]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[tag]
           ,[hold]
           ,[affect_damaged]
           ,[qty]
           ,[act_qty]
           ,[is_picked_short]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[cont]
           ,[outermost_cont]
           ,[tms_tracking_num]
           ,[user_name]
           ,[host_order_lno]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[product_exp_date]
           ,[whse_code]
           ,[bol]
           ,[use_by_time]
FROM up_ship_line_detail WHERE up_ship_id in (
SELECT up_ship_id FROM up_ship
WHERE CAST(create_stamp AS DATE) <= @archive_date
AND is_extracted = 1
AND upl_stt = 'SENT');


PRINT N'Archive Table up_rcpt_archive';

INSERT INTO [up_rcpt_archive]
           ([up_rcpt_up_rid]
           ,[upl_stt]
           ,[is_extracted]
           ,[interface_batch]
           ,[receipt]
           ,[ib_oid]
           ,[ib_type]
           ,[dt_trans]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[lock_id]
           ,[whse_code]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[create_user])
select 
            [up_rcpt_up_rid]
           ,[upl_stt]
           ,[is_extracted]
           ,[interface_batch]
           ,[receipt]
           ,[ib_oid]
           ,[ib_type]
           ,[dt_trans]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[lock_id]
           ,[whse_code]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[create_user]
FROM up_rcpt
WHERE CAST(create_stamp AS DATE) <= @archive_date
AND is_extracted = 1
AND upl_stt = 'SENT';


PRINT N'Archive Table up_rcpt_line_archive';

INSERT INTO [dbo].[up_rcpt_line_archive]
           ([up_rcpt_id]
           ,[up_rcpt_line_seq]
           ,[receipt]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[host_order_lno]
           ,[sku]
           ,[pkg]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[expect_qty]
           ,[supplier]
           ,[receiver_num]
           ,[dms_rcvr_line_seq]
           ,[asn_num]
           ,[reference_num]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code])
SELECT
            [up_rcpt_id]
           ,[up_rcpt_line_seq]
           ,[receipt]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[host_order_lno]
           ,[sku]
           ,[pkg]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[expect_qty]
           ,[supplier]
           ,[receiver_num]
           ,[dms_rcvr_line_seq]
           ,[asn_num]
           ,[reference_num]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[whse_code]
FROM up_rcpt_line WHERE up_rcpt_id IN (
SELECT up_rcpt_id FROM up_rcpt
WHERE CAST(create_stamp AS DATE) <= @archive_date
  AND is_extracted = 1
  AND upl_stt = 'SENT');


PRINT N'Archive Table up_rcpt_line_detail_archive';

INSERT INTO [up_rcpt_line_detail_archive]
           ([up_rcpt_id]
           ,[up_rcpt_line_seq]
           ,[up_rcpt_line_detail_seq]
           ,[up_rcpt_line_detail_up_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[lot]
           ,[tag]
           ,[hold]
           ,[affect_damaged]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[expect_qty]
           ,[rcvtodate_qty]
           ,[dt_recv]
           ,[dt_trans]
           ,[rotation_time]
           ,[recv_loc]
           ,[container_num]
           ,[user_name]
           ,[host_order_lno]
           ,[gtin]
           ,[product_exp_date]
           ,[whse_code])
select 
            [up_rcpt_id]
           ,[up_rcpt_line_seq]
           ,[up_rcpt_line_detail_seq]
           ,[up_rcpt_line_detail_up_rid]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[lot]
           ,[tag]
           ,[hold]
           ,[affect_damaged]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[expect_qty]
           ,[rcvtodate_qty]
           ,[dt_recv]
           ,[dt_trans]
           ,[rotation_time]
           ,[recv_loc]
           ,[container_num]
           ,[user_name]
           ,[host_order_lno]
           ,[gtin]
           ,[product_exp_date]
           ,[whse_code]
FROM up_rcpt_line_detail WHERE up_rcpt_id in (
SELECT up_rcpt_id FROM up_rcpt
WHERE CAST(create_stamp AS DATE) <= @archive_date
  AND is_extracted = 1
  AND upl_stt = 'SENT');


PRINT N'Archive Table up_f_archive';

INSERT INTO [up_f_archive]
           ([task_code]
           ,[upl_stt]
           ,[rsn_code]
           ,[sku]
           ,[pkg]
           ,[tag]
           ,[hold]
           ,[old_hold]
           ,[affect_damaged]
           ,[old_affect_damaged]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[user_name]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[ord_stt]
           ,[dt_recv]
           ,[dt_ship]
           ,[dt_trans]
           ,[wave]
           ,[total_pcs]
           ,[wgt]
           ,[volume]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[lno_cmp]
           ,[carrier_service]
           ,[trailer]
           ,[probill]
           ,[bol]
           ,[manifest]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[shipment]
           ,[pams]
           ,[fr_terms]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[cont]
           ,[outermost_cont]
           ,[expect_qty]
           ,[rcvtodate_qty]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[air_bill]
           ,[loc]
           ,[recv_loc]
           ,[supplier]
           ,[invoice_num]
           ,[fr_chg1]
           ,[fr_code1]
           ,[ser]
           ,[receipt]
           ,[rotation_time]
           ,[shipunit_wgt]
           ,[receiver_num]
           ,[dms_rcvr_line_seq]
           ,[container_num]
           ,[asn_num]
           ,[tms_tracking_num]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[reference_num]
           ,[carrier_code]
           ,[org_code]
           ,[rma_num]
           ,[is_from_host]
           ,[ibret_id]
           ,[return_line_num]
           ,[ret_cust_num]
           ,[goods_rcvd_in_bldg_date]
           ,[host_order_lno]
           ,[is_picked_short]
           ,[kit_line_type]
           ,[kit_order_group]
           ,[interface_batch]
           ,[is_extracted]
           ,[whse_code]
           ,[host_pack_list_prt]
           ,[gtin]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[product_exp_date]
           ,[create_user]
           ,[asn_vendor_num]
           ,[asn_time]
           ,[ship_time]
           ,[delivery_time]
           ,[freight_payment_terms_type]
           ,[use_by_time])
SELECT 
            [task_code]
           ,[upl_stt]
           ,[rsn_code]
           ,[sku]
           ,[pkg]
           ,[tag]
           ,[hold]
           ,[old_hold]
           ,[affect_damaged]
           ,[old_affect_damaged]
           ,[org_qty]
           ,[qty]
           ,[act_qty]
           ,[user_name]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[ob_oid]
           ,[ob_type]
           ,[ob_lno]
           ,[ord_stt]
           ,[dt_recv]
           ,[dt_ship]
           ,[dt_trans]
           ,[wave]
           ,[total_pcs]
           ,[wgt]
           ,[volume]
           ,[ib_oid]
           ,[ib_type]
           ,[ib_lno]
           ,[lno_cmp]
           ,[carrier_service]
           ,[trailer]
           ,[probill]
           ,[bol]
           ,[manifest]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[shipment]
           ,[pams]
           ,[fr_terms]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[cont]
           ,[outermost_cont]
           ,[expect_qty]
           ,[rcvtodate_qty]
           ,[ship_name]
           ,[ship_addr1]
           ,[ship_addr2]
           ,[ship_city]
           ,[ship_state]
           ,[ship_zip]
           ,[air_bill]
           ,[loc]
           ,[recv_loc]
           ,[supplier]
           ,[invoice_num]
           ,[fr_chg1]
           ,[fr_code1]
           ,[ser]
           ,[receipt]
           ,[rotation_time]
           ,[shipunit_wgt]
           ,[receiver_num]
           ,[dms_rcvr_line_seq]
           ,[container_num]
           ,[asn_num]
           ,[tms_tracking_num]
           ,[tms_freight_charge]
           ,[tms_freight_cost]
           ,[reference_num]
           ,[carrier_code]
           ,[org_code]
           ,[rma_num]
           ,[is_from_host]
           ,[ibret_id]
           ,[return_line_num]
           ,[ret_cust_num]
           ,[goods_rcvd_in_bldg_date]
           ,[host_order_lno]
           ,[is_picked_short]
           ,[kit_line_type]
           ,[kit_order_group]
           ,[interface_batch]
           ,[is_extracted]
           ,[whse_code]
           ,[host_pack_list_prt]
           ,[gtin]
           ,[custom_char_1]
           ,[custom_char_2]
           ,[custom_char_3]
           ,[custom_char_4]
           ,[custom_char_5]
           ,[custom_char_6]
           ,[custom_char_7]
           ,[custom_char_8]
           ,[custom_char_9]
           ,[custom_char_10]
           ,[custom_numeric_1]
           ,[custom_numeric_2]
           ,[custom_numeric_3]
           ,[custom_numeric_4]
           ,[custom_numeric_5]
           ,[custom_numeric_6]
           ,[custom_numeric_7]
           ,[custom_numeric_8]
           ,[custom_numeric_9]
           ,[custom_numeric_10]
           ,[product_exp_date]
           ,[create_user]
           ,[asn_vendor_num]
           ,[asn_time]
           ,[ship_time]
           ,[delivery_time]
           ,[freight_payment_terms_type]
           ,[use_by_time]
FROM up_f
WHERE CAST(create_stamp AS DATE) <= @archive_date
  AND is_extracted = 1
  AND upl_stt = 'SENT';

  
PRINT N'Delete Table up_ship_freight_detail';

delete from up_ship_freight_detail where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_ship_freight';

delete from up_ship_freight where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_ship_line_detail';

delete from up_ship_line_detail where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_ship_line';

delete from up_ship_line where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_ship';

delete from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT';


PRINT N'Delete Table up_rcpt_line_detail';

delete from up_rcpt_line_detail where up_rcpt_id in (
select up_rcpt_id from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_rcpt_line';

delete from up_rcpt_line where up_rcpt_id in (
select up_rcpt_id from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT');

PRINT N'Delete Table up_rcpt';

delete from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT';

PRINT N'Delete Table up_f';

delete from up_f
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = 'SENT';



--COMMIT;  -- when all delete work 

--ROLLBACK;  -- when any delete failed



-------------------

--Rebuild Indexes
-------------------
--up_ship_freight_detail
--up_ship_freight
--up_ship_line_detail
--up_ship_line
--up_ship
--up_rcpt_line_detail
--up_rcpt_line
--up_rcpt
--up_f


