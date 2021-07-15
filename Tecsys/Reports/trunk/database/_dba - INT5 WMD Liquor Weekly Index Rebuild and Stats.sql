/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.5366)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [msdb]
GO

/****** Object:  Job [_dba - INT5 WMD Liquor Weekly Index Rebuild and Stats]    Script Date: 2/13/2020 9:40:24 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [DBAAdmin]    Script Date: 2/13/2020 9:40:24 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'DBAAdmin' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'DBAAdmin'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'_dba - INT5 WMD Liquor Weekly Index Rebuild and Stats', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=3, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'DBAAdmin', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'WMSSupportTeam', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Archive and Purge WMS Operational Tables]    Script Date: 2/13/2020 9:40:24 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Archive and Purge WMS Operational Tables', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-----------------------------------------------
--Script to Archive/Truncate
-----------------------------------------------
 
DECLARE @archive_date DATETIME = DateAdd(m, -1, GETDATE())
 
PRINT N''Archive starting as of  - '' 
    + RTRIM(CAST(@archive_date AS nvarchar(30))) 
    + N''.''; 


PRINT N''Archive Table up_ship_archive'';

BEGIN TRANSACTION;  
  
BEGIN TRY  

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
and upl_stt = ''SENT'';

PRINT N''Archive Table up_ship_freight_archive'';
 
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
  AND upl_stt = ''SENT'');

PRINT N''Archive Table up_ship_freight_detail_archive'';
 
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
AND upl_stt = ''SENT'');

PRINT N''Archive Table up_ship_line_archive'';
 
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
AND upl_stt = ''SENT'');

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
AND upl_stt = ''SENT'');

PRINT N''Archive Table up_rcpt_archive'';
 
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
AND upl_stt = ''SENT'';

PRINT N''Archive Table up_rcpt_line_archive'';
 
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
  AND upl_stt = ''SENT'');

PRINT N''Archive Table up_rcpt_line_detail_archive'';
 
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
  AND upl_stt = ''SENT'');

PRINT N''Archive Table up_f_archive'';
 
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
  AND upl_stt = ''SENT'';

PRINT N''Delete Table up_ship_freight_detail'';
 
delete from up_ship_freight_detail where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_ship_freight'';
 
delete from up_ship_freight where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_ship_line_detail'';
 
delete from up_ship_line_detail where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_ship_line'';
 
delete from up_ship_line where up_ship_id in (
select up_ship_id from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_ship'';
 
delete from up_ship
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'';
 
PRINT N''Delete Table up_rcpt_line_detail'';
 
delete from up_rcpt_line_detail where up_rcpt_id in (
select up_rcpt_id from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_rcpt_line'';
 
delete from up_rcpt_line where up_rcpt_id in (
select up_rcpt_id from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'');
 
PRINT N''Delete Table up_rcpt'';
 
delete from up_rcpt
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'';
 
PRINT N''Delete Table up_f'';
 
delete from up_f
where CAST(create_stamp AS DATE) <= @archive_date
and is_extracted = 1
and upl_stt = ''SENT'';

END TRY  
BEGIN CATCH  
    DECLARE @ErrorNumber INT;  
	DECLARE @ErrorSeverity INT;  
	DECLARE @ErrorState INT;  
	DECLARE @ErrorProcedure NVARCHAR(4000);  
	DECLARE @ErrorLine NVARCHAR(4000);  
	DECLARE @ErrorMessage NVARCHAR(4000);  
		
	SELECT   	
	    @ErrorNumber = ERROR_NUMBER()
        ,@ErrorSeverity = ERROR_SEVERITY()
        ,@ErrorState = ERROR_STATE()
        ,@ErrorProcedure = ERROR_PROCEDURE()
        ,@ErrorLine = ERROR_LINE()
        ,@ErrorMessage = ERROR_MESSAGE();  
  

    IF @@TRANCOUNT > 0 
	    ROLLBACK TRANSACTION;
	RAISERROR (
					@ErrorNumber
				,@ErrorSeverity
				,@ErrorState
				,@ErrorProcedure
				,@ErrorLine
				,@ErrorMessage  
					);  
	PRINT N''Transaction Failed and was Rolled Back. '';
	--Send email and fail the step
	declare @myprofile varchar(50) = ''dba_DBMail Public Profile''  
	declare @recipient_list varchar(150) = ''ldbdba@bcldb.com''
	declare @mysubject varchar(100) =  @@servername + '': '' + db_name() + '' Purge and Archive job Step 1 failed and was rolled back''
	declare @mybody varchar(1000) = ''Check Step 1 of Weekly Index Rebuild and Stats job for details... ''

	EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = @myprofile,
		@recipients = @recipient_list,
		@body = @mybody,
		@subject = @mysubject
		;
	THROW; -- This will stop further execution and complete step with error''
END CATCH;  
  
IF @@TRANCOUNT > 0  
BEGIN
    PRINT N''Purge successfully Completed'';
    COMMIT TRANSACTION; 
	PRINT N''Transaction was Commited'';
END;
GO  

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
-------------------
 
--Shrink DB log file
-------------------', 
		@database_name=N'int5_94x_w', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Purge WMS Operational Tables]    Script Date: 2/13/2020 9:40:24 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Purge WMS Operational Tables', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @archive_date DATETIME = DateAdd(m, -1, GETDATE())
 
PRINT N''Purge starting as of  - '' 
    + RTRIM(CAST(@archive_date AS nvarchar(30))) 
    + N''.''; 

BEGIN TRANSACTION;  
  
BEGIN TRY  

PRINT N''Purge bottle pick tower MOVE transactions from it_f'';
  
delete from [it_f]
where CAST(create_stamp AS DATE) <= @archive_date
and transact = ''MOVE''
and [user_name] = ''pick_tower'';

PRINT N''Purge task tables'';

 WHILE (SELECT TOP 1 1 FROM md_task WHERE create_stamp <= @archive_date) > 0
    BEGIN
		SELECT @v_task_id = task_id FROM md_task WHERE create_stamp <= @archive_date;
        DELETE FROM md_task_param_join WHERE task_id = @v_task_id;
        DELETE FROM md_task_param WHERE task_id = @v_task_id;
        DELETE FROM md_task_log WHERE task_id = @v_task_id;
		DELETE FROM md_task WHERE task_id = @v_task_id;
    END
END TRY  
BEGIN CATCH  
    DECLARE @ErrorNumber INT;  
	DECLARE @ErrorSeverity INT;  
	DECLARE @ErrorState INT;  
	DECLARE @ErrorProcedure NVARCHAR(4000);  
	DECLARE @ErrorLine NVARCHAR(4000);  
	DECLARE @ErrorMessage NVARCHAR(4000);  
		
	SELECT   	
	    @ErrorNumber = ERROR_NUMBER()
        ,@ErrorSeverity = ERROR_SEVERITY()
        ,@ErrorState = ERROR_STATE()
        ,@ErrorProcedure = ERROR_PROCEDURE()
        ,@ErrorLine = ERROR_LINE()
        ,@ErrorMessage = ERROR_MESSAGE();  

	IF @@TRANCOUNT > 0  
		ROLLBACK TRANSACTION;

	RAISERROR (
					@ErrorNumber
				,@ErrorSeverity
				,@ErrorState
				,@ErrorProcedure
				,@ErrorLine
				,@ErrorMessage  
	        ); 
	--Send email and fail the step
	declare @myprofile varchar(50) = ''dba_DBMail Public Profile''  
	declare @recipient_list varchar(150) = ''elena.khramtsova@bcldb.com''
	declare @mysubject varchar(100) =  @@servername + '': '' + db_name() + '' Purge job Step 2 failed and was rolled back''
	declare @mybody varchar(1000) = ''Check Step 2 of Weekly Index Rebuild and Stats job for details... ''

	EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = @myprofile,
		@recipients = @recipient_list,
		@body = @mybody,
		@subject = @mysubject
		; 
	THROW;
     
	END CATCH;  
  
IF @@TRANCOUNT > 0 
BEGIN 
    PRINT N''Purge successfully Completed'';
    COMMIT TRANSACTION; 
	PRINT N''Transaction was Commited'';
END;
GO  

-------------------
 
--Rebuild Indexes
-------------------
--it_f
-------------------
 
--Shrink DB log file
-------------------', 
		@database_name=N'int5_94x_w', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Rebuild Indexes Cnline and Collect Statistics]    Script Date: 2/13/2020 9:40:24 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Rebuild Indexes Cnline and Collect Statistics', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @dbname nvarchar(max) --From our cursor.
DECLARE @time_limit_seconds int --How long do we run this for?

--Set our variables
SET @dbname = ''ALL_DATABASES''  
SET @time_limit_seconds = 3600  --By default do not run longer than 1 hour.

Select @time_limit_seconds as ''Run Duration in Seconds''


EXECUTE dbo.IndexOptimize
@Databases = @dbname,
@FragmentationLow = NULL,
@FragmentationMedium = ''INDEX_REBUILD_ONLINE'',  --Don''t take any indexes offline
@FragmentationHigh = ''INDEX_REBUILD_ONLINE'',  --Don''t take any indexes offline
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 25,
@TimeLimit = @time_limit_seconds,
@MinNumberOfPages = 1000, --Don''''t bother with tiny tables.
@UpdateStatistics = ''ALL'',  --Update statistics
@OnlyModifiedStatistics = ''Y'', --Only those who have had thier tables modified recently.
@WaitAtLowPriorityMaxDuration = 2, --Wait only 2 minutes for locks before moving on.
@WaitAtLowPriorityAbortAfterWait = ''SELF'', --If we are waiting for a lock abort and keep going.
@DatabasesInParallel = ''Y''  --Run on multiple databases at once.
', 
		@database_name=N'DBAAdmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Run every Sunday at 2 AM', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=32, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190908, 
		@active_end_date=99991231, 
		@active_start_time=131500, 
		@active_end_time=235959, 
		@schedule_uid=N'c65b31c6-a4ec-4720-9cd3-ca52362cdf41'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


