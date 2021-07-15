--create ARCHIVE Tables scripts

SELECT * INTO sbx_94x_w_arch.dbo.it_a FROM sbx_94x_w.dbo.it_f
WHERE 1<>1;


--archive Table sctript



DECLARE @archive_date DATETIME = DateAdd(m, -1, GETDATE())

PRINT N'Archive starting as of  - '  
    + RTRIM(CAST(@archive_date AS nvarchar(30)))  
    + N'.';  

-- Stop Auto Commit

SET IMPLICIT_TRANSACTIONS ON;
PRINT N'Turn AUTO COMMIT OFF';


PRINT N'Archive Table it_f';

INSERT INTO [dbo].[it_a]
           ([transact]
           ,[cont]
           ,[to_cont]
           ,[sku]
           ,[pkg]
           ,[from_loc]
           ,[to_loc]
           ,[transact_stt]
           ,[user_name]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[wave]
           ,[ob_oid]
           ,[ob_type]
           ,[ib_oid]
           ,[ib_type]
           ,[ob_lno]
           ,[ib_lno]
           ,[pri]
           ,[tag]
           ,[qty]
           ,[act_qty]
           ,[carrier_service]
           ,[trailer]
           ,[hold]
           ,[affect_damaged]
           ,[old_hold]
           ,[old_affect_damaged]
           ,[dt_recv]
           ,[rotation_time]
           ,[ord_uom]
           ,[rsn_code]
           ,[curr_inv]
           ,[dest_inv]
           ,[lno_cmp]
           ,[list]
           ,[shipment]
           ,[pams]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[station]
           ,[num_crtn]
           ,[fullskid]
           ,[bol]
           ,[manifest]
           ,[probill]
           ,[wgt]
           ,[qty_to_date]
           ,[linehaul_carrier]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[seal]
           ,[carrier_trailer]
           ,[ser]
           ,[receipt]
           ,[supp_num]
           ,[start_time]
           ,[end_time]
           ,[product_exp_date]
           ,[reference_num]
           ,[tms_shipment_id]
           ,[org_code]
           ,[rma_num]
           ,[is_from_host]
           ,[ibret_id]
           ,[return_line_num]
           ,[ret_cust_num]
           ,[goods_rcvd_in_bldg_date]
           ,[whse_ref]
           ,[pack_count]
           ,[confirm_pickup]
           ,[to_cntype]
           ,[serial_reference_num]
           ,[asn_num]
           ,[quarreason_code]
           ,[cycc_oid]
           ,[whse_code]
           ,[create_user]
           ,[dest_tag]
           ,[applied_to_snapshot]
           ,[is_disassociated_from_order]
           ,[freight_charge_amt]
           ,[owner_num]
           ,[freight_payment_terms_type]
           ,[use_by_time])
SELECT 
            [transact]
           ,[cont]
           ,[to_cont]
           ,[sku]
           ,[pkg]
           ,[from_loc]
           ,[to_loc]
           ,[transact_stt]
           ,[user_name]
           ,[lot]
           ,[uc1]
           ,[uc2]
           ,[uc3]
           ,[wave]
           ,[ob_oid]
           ,[ob_type]
           ,[ib_oid]
           ,[ib_type]
           ,[ob_lno]
           ,[ib_lno]
           ,[pri]
           ,[tag]
           ,[qty]
           ,[act_qty]
           ,[carrier_service]
           ,[trailer]
           ,[hold]
           ,[affect_damaged]
           ,[old_hold]
           ,[old_affect_damaged]
           ,[dt_recv]
           ,[rotation_time]
           ,[ord_uom]
           ,[rsn_code]
           ,[curr_inv]
           ,[dest_inv]
           ,[lno_cmp]
           ,[list]
           ,[shipment]
           ,[pams]
           ,[grp1]
           ,[grp2]
           ,[grp3]
           ,[station]
           ,[num_crtn]
           ,[fullskid]
           ,[bol]
           ,[manifest]
           ,[probill]
           ,[wgt]
           ,[qty_to_date]
           ,[linehaul_carrier]
           ,[mod_resource]
           ,[mod_user]
           ,[mod_counter]
           ,[create_stamp]
           ,[mod_stamp]
           ,[seal]
           ,[carrier_trailer]
           ,[ser]
           ,[receipt]
           ,[supp_num]
           ,[start_time]
           ,[end_time]
           ,[product_exp_date]
           ,[reference_num]
           ,[tms_shipment_id]
           ,[org_code]
           ,[rma_num]
           ,[is_from_host]
           ,[ibret_id]
           ,[return_line_num]
           ,[ret_cust_num]
           ,[goods_rcvd_in_bldg_date]
           ,[whse_ref]
           ,[pack_count]
           ,[confirm_pickup]
           ,[to_cntype]
           ,[serial_reference_num]
           ,[asn_num]
           ,[quarreason_code]
           ,[cycc_oid]
           ,[whse_code]
           ,[create_user]
           ,[dest_tag]
           ,[applied_to_snapshot]
           ,[is_disassociated_from_order]
           ,[freight_charge_amt]
           ,[owner_num]
           ,[freight_payment_terms_type]
           ,[use_by_time]
FROM it_f		   
WHERE CAST(create_stamp AS DATE) <= @archive_date
		   
GO



