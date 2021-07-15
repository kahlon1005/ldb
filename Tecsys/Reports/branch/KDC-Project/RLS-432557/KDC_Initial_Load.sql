---
-- Copy All the VDC Item into KDC
---
INSERT INTO [pm_f](
[sku],[pkg],[sku_desc],[def_hold],[store_rule],[cons_age],[cons_lot],[cons_hold],[cons_uc1],[cons_uc2],[cons_uc3],[dedicate_loc],[loc_size],[uom1],[uom2]
,[uom3],[uom4],[qty1in2],[qty2in3],[qty3in4],[load_uom],[lab_uom],[back_uom],[brk_uom],[cmd_uom],[crtn_uom],[prod_class],[wgt1],[wgt2],[wgt3],[wgt4],[hgt1],[hgt2],[hgt3]
,[hgt4],[wid1],[wid2],[wid3],[wid4],[dpth1],[dpth2],[dpth3],[dpth4],[pal_req],[max_stack],[shelf_life],[pkg_desc],[tag_format],[tag_track],[over_pick],[upload],[ches_num]
,[haz_id_code],[haz_stk_desc],[haz_class],[haz_pack_grp],[haz_lab_desc],[haz_plc_req],[cycc_trig_qty],[cycc_trig_uom],[cycc_freq],[load_min_qty],[load_max_qty],[def_rel_put]
,[allow_rec_ret],[entry_tag],[entry_uc1],[entry_uc2],[entry_uc3],[mod_resource],[mod_user],[mod_counter],[create_stamp],[mod_stamp],[inv_class],[tol_item],[tol_rule],[tol_percent],[tariff]
,[tariff_xref],[def_uc1],[def_uc2],[def_uc3],[def_lot],[fifo_win],[req_cntype],[no_cont_uom],[ser_req],[part_status],[upc],[def_exp_date],[exp_lead_time],[stock_type]
,[pick_lab_uom],[sku_desc_2],[owner_num],[pallet_stack_pattern],[gtin1],[gtin2],[gtin3],[gtin4],[custom_char_1],[custom_char_2],[custom_char_3],[custom_char_4],[custom_char_5]
,[custom_char_6],[custom_char_7],[custom_char_8],[custom_char_9],[custom_char_10],[custom_numeric_1],[custom_numeric_2],[custom_numeric_3],[custom_numeric_4],[custom_numeric_5]
,[custom_numeric_6],[custom_numeric_7],[custom_numeric_8],[custom_numeric_9],[custom_numeric_10],[nmfc_number],[nmfc_sub_number],[serial_format_code],[serial_tracking_method]
,[default_serial_input_method],[cons_product_exp_date_method],[freight_class],[is_keep_inference],[epcis_event_generation],[uom5],[uom6],[qty4in5],[qty5in6],[wgt5]
,[wgt6],[hgt5],[hgt6],[wid5],[wid6],[dpth5],[dpth6],[gtin5],[gtin6],[is_allow_ffp_loc],[whse_code],[create_user],[pkg_desc_2],[is_pack_full_load_separate],[is_dscsa]
,[ndc_num],[stduom_code_1],[stduom_code_2],[stduom_code_3],[stduom_code_4],[stduom_code_5],[stduom_code_6],[is_temperature_control],[is_secure],[is_hazmat],[is_lot_entry_required]
,[is_lot_from_expiration_date],[is_apply_fp_fefo],[is_returnable_to_stock],[ancillary_item_info],[is_host_created],[use_by_days],[use_by_hours],[auto_assign_use_by_time]
) 
SELECT [sku],[pkg],[sku_desc],[def_hold],'SRSUPR',[cons_age],[cons_lot],[cons_hold],[cons_uc1],[cons_uc2],[cons_uc3],[dedicate_loc],[loc_size],[uom1]
,[uom2],[uom3],[uom4],[qty1in2],[qty2in3],[qty3in4],[load_uom],[lab_uom],[back_uom],[brk_uom],[cmd_uom],[crtn_uom],[prod_class],[wgt1],[wgt2],[wgt3],[wgt4],[hgt1]
,[hgt2],[hgt3],[hgt4],[wid1],[wid2],[wid3],[wid4],[dpth1],[dpth2],[dpth3],[dpth4],[pal_req],[max_stack],[shelf_life],[pkg_desc],[tag_format],'N',[over_pick]
,[upload],[ches_num],[haz_id_code],[haz_stk_desc],[haz_class],[haz_pack_grp],[haz_lab_desc],[haz_plc_req],[cycc_trig_qty],[cycc_trig_uom],120,[load_min_qty],[load_max_qty]
,'N',[allow_rec_ret],[entry_tag],[entry_uc1],[entry_uc2],[entry_uc3],[mod_resource],'srparame',0,GETDATE(),GETDATE(),[inv_class],[tol_item]
,[tol_rule],[tol_percent],[tariff],[tariff_xref],[def_uc1],[def_uc2],[def_uc3],[def_lot],[fifo_win],[req_cntype],[no_cont_uom],[ser_req],'NEW',[upc],[def_exp_date]
,[exp_lead_time],[stock_type],[pick_lab_uom],[sku_desc_2],[owner_num],[pallet_stack_pattern],[gtin1],[gtin2],[gtin3],[gtin4],[custom_char_1],[custom_char_2],[custom_char_3],[custom_char_4]
,NULL,[custom_char_6],[custom_char_7],[custom_char_8],[custom_char_9],'0',[custom_numeric_1],[custom_numeric_2],[custom_numeric_3],[custom_numeric_4],[custom_numeric_5]
,[custom_numeric_6],[custom_numeric_7],[custom_numeric_8],[custom_numeric_9],[custom_numeric_10],[nmfc_number],[nmfc_sub_number],[serial_format_code],[serial_tracking_method]
,[default_serial_input_method],[cons_product_exp_date_method],[freight_class],[is_keep_inference],[epcis_event_generation],[uom5],[uom6],[qty4in5],[qty5in6],[wgt5],[wgt6]
,[hgt5],[hgt6],[wid5],[wid6],[dpth5],[dpth6],[gtin5],[gtin6],[is_allow_ffp_loc],'KDC','srparame',[pkg_desc_2],[is_pack_full_load_separate],[is_dscsa],[ndc_num]
,[stduom_code_1],[stduom_code_2],[stduom_code_3],[stduom_code_4],[stduom_code_5],[stduom_code_6],[is_temperature_control],[is_secure],[is_hazmat],[is_lot_entry_required],[is_lot_from_expiration_date]
,[is_apply_fp_fefo],[is_returnable_to_stock],[ancillary_item_info],[is_host_created],[use_by_days],[use_by_hours],[auto_assign_use_by_time]

FROM [dbo].[pm_f] WHERE whse_code = 'VDC';


---
-- Update the storage rules to the default storage rules
---
--UPDATE [dbo].[pm_f] SET [store_rule] = 'SRSUPR' WHERE custom_char_2 NOT LIKE '%BO' AND whse_code = 'KDC';
UPDATE [dbo].[pm_f] SET [store_rule] = 'SRNSWP' WHERE custom_char_2 LIKE '%BO' AND whse_code = 'KDC';
UPDATE [dbo].[pm_f] SET [store_rule] = 'SRDELIST' WHERE custom_char_1 = '4.2' AND whse_code = 'KDC';


---
-- Set NSWP items to be ready as they are ready by default 
---
UPDATE [dbo].[pm_f] SET [part_status] = 'RDY' WHERE custom_char_2 LIKE '%BO' AND whse_code = 'KDC';

---
-- Update the Cycle Count Frequency
---
UPDATE [dbo].[pm_f] SET [cycc_freq] = 365 WHERE custom_char_2 LIKE '%BO' AND whse_code = 'KDC';

---
-- Updated the default release put away to Yes for NSWP items 
---
UPDATE [dbo].[pm_f] SET [def_rel_put] = 'Y' WHERE custom_char_2 LIKE '%BO' AND whse_code = 'KDC';

---
-- Copy All the VDC Aliases into KDC
---
INSERT INTO [dbo].[al_f]
([alias_sku],[alias_pkg],[sku],[pkg],[mod_resource],[mod_user],[mod_counter],[create_stamp],[mod_stamp],[alias_desc],[whse_code],[create_user],[uom],[multiplier])
SELECT [alias_sku],[alias_pkg],[sku],[pkg],[mod_resource],'srparame',0,GETDATE(),GETDATE(),[alias_desc],'KDC','srparame',[uom],[multiplier]
FROM [dbo].[al_f] WHERE whse_code = 'VDC';


---
-- Rollback instructions (Delete the KDC item and Aliases)
---
--delete from al_f where whse_code = 'KDC';
--delete from pm_f where whse_code = 'KDC';